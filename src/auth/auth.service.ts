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

    async authUserLogin(data: AuthDto): Promise<object> {
        const { email, password } = data;

        const user = await this.prisma.system_user.findUnique({
            where: { email },
            include: { role: true },
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

        return {
            code: 200,
            access_token: this.jwtService.sign({
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
                
            }),
            user: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
            }
        };
    }
}