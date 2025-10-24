import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { AuthDto } from './dto/auth.dto';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserRolesDto } from './dto/update-user-roles.dto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AuthService {
    constructor(
        private jwtService: JwtService,
        private prisma: PrismaService,
    ) { }

    async createUser(data: CreateUserDto): Promise<object> {
        const existingUser = await this.prisma.system_user.findUnique({
            where: { email: data.email }
        });

        if (existingUser) {
            throw new BadRequestException('Email already registered');
        }

        const hashedPassword = await bcrypt.hash(data.password, 10);

        const user = await this.prisma.system_user.create({
            data: {
                name: data.name,
                email: data.email,
                password_hash: hashedPassword,
                role_id: parseInt(data.role_id),
                company_id: data.company_id,
                status_id: 1 // Active status
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

        const permissions = user.role.role_permissions.map(rp => rp.permission.code);

        return {
            code: 201,
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role.code,
                permissions
            }
        };
    }

    async updateUserRoles(userId: string, data: UpdateUserRolesDto): Promise<object> {
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
                role_id: parseInt(data.role_ids[0]) // For now, we'll just use the first role
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