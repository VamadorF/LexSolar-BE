// ...existing imports...
import { Injectable, UnauthorizedException, BadRequestException, NotFoundException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { AuthDto } from './dto/auth.dto';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserRolesDto } from './dto/update-user-roles.dto';
import { PrismaService } from '../prisma/prisma.service';


@Injectable()
export class AuthService {
    constructor(
        private prisma: PrismaService,
        private jwtService: JwtService,
    ) {}

    async findById(id: string) {
        const user = await this.prisma.system_user.findUnique({
            where: { id },
            include: { role: { include: { role_permissions: { include: { permission: true } } } } },
        });
        if (!user) throw new NotFoundException('User not found');
        return {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role.code,
            permissions: user.role.role_permissions.map(rp => rp.permission.code),
        };
    }


    async assignRoles(userId: string, roleIds: number[]) {
        // Actualiza rol
        await this.prisma.system_user.update({
            where: { id: userId },
            data: { role_id: roleIds[0] },
        });

        // Recarga con permisos
        const user = await this.prisma.system_user.findUnique({
            where: { id: userId },
            include: {
                role: {
                    include: { role_permissions: { include: { permission: true } } },
                },
            },
        });
        if (!user) throw new BadRequestException('User not found');

        return {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role.code,
            permissions: user.role.role_permissions.map(rp => rp.permission.code),
        };
    }

    async getUsers(page: number, limit: number) {
        const skip = (page - 1) * limit;
        const [items, total] = await Promise.all([
            this.prisma.system_user.findMany({
                skip,
                take: limit,
                include: {
                    role: { include: { role_permissions: { include: { permission: true } } } },
                },
            }),
            this.prisma.system_user.count(),
        ]);

        const users = items.map(u => ({
            id: u.id,
            name: u.name,
            email: u.email,
            role: u.role.code,
            permissions: u.role.role_permissions.map(rp => rp.permission.code),
        }));

        return { items: users, total };
    }

    async createUser(data: { email: string; password: string; name?: string }) {
        // 1. Hashear contraseña
        const password_hash = await bcrypt.hash(data.password, 10);

        // 2. Encontrar rol Viewer por defecto
        const viewerRole = await this.prisma.user_role_catalog.findUnique({
            where: { code: 'viewer' },
        });
        if (!viewerRole) throw new Error('Default Viewer role not found');

        // 3. Encontrar compañía por defecto
        const defaultCompany = await this.prisma.company.findFirst();
        if (!defaultCompany) throw new Error('Default company not found');

        // 4. Crear usuario con campos completos
        const user = await this.prisma.system_user.create({
            data: {
                name: data.name ?? data.email,      // si no hay nombre, uso el email
                email: data.email,
                password_hash,
                role_id: viewerRole.id,              // rol Viewer
                status_id: 1,                        // estado “active” seed-id = 1
                company_id: defaultCompany.id,       // compañía creada en seed
            },
            include: {
                role: {
                    include: {
                        role_permissions: {
                            include: { permission: true }
                        }
                    }
                }
            }
        });

        // 5. Eliminar el hash antes de devolver
        delete (user as any).password_hash;
        return {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role.code,
            permissions: user.role.role_permissions.map(rp => rp.permission.code),
        };
    }

    async updateUserRoles(userId: string, data: { roleIds: number[] }): Promise<object> {
        const user = await this.prisma.system_user.findUnique({
            where: { id: userId },
            include: {
                role: true
            }
        });

        if (!user) {
            throw new BadRequestException('User not found');
        }

        // Update user role
        const updatedUser = await this.prisma.system_user.update({
            where: { id: userId },
            data: {
                role_id: data.roleIds[0]
            },
            include: {
                role: {
                    include: {
                        role_permissions: {
                            include: {
                                permission: true
                            }
                        }
                    }
                }
            }
        });

        const permissions = updatedUser.role.role_permissions.map(rp => rp.permission.code);

        return {
            code: 200,
            user: {
                id: updatedUser.id,
                name: updatedUser.name,
                email: updatedUser.email,
                role: updatedUser.role.code,
                permissions
            }
        };
    }

    async authUserLogin(data: AuthDto): Promise<object> {
        const { email, password } = data;

        const user = await this.prisma.system_user.findUnique({
            where: { email },
            include: {
                role: {
                    include: {
                        role_permissions: {
                            include: {
                                permission: true
                            }
                        }
                    }
                }
            }
        });

        if (!user) {
            throw new UnauthorizedException('Invalid credentials');
        }

        const isPasswordValid = await bcrypt.compare(password, user.password_hash);

        if (!isPasswordValid) {
            throw new UnauthorizedException('Invalid credentials');
        }

        // Update last login
        await this.prisma.system_user.update({
            where: { id: user.id },
            data: { last_login: new Date() }
        });

        const permissions = user.role.role_permissions.map(rp => rp.permission.code);

        return {
            code: 200,
            access_token: this.jwtService.sign({
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role.code,
                permissions
            }),
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role.code,
                permissions
            }
        };
    }
}