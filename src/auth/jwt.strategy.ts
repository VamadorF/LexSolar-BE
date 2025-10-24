import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';

export interface IJwtPayload {
    id: string;
    email: string;
    name: string;
    roles: string[];
    permissions: string[];
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
    constructor(
        configService: ConfigService,
        private prisma: PrismaService
    ) {
        const secret = configService.get<string>('JWT_SECRET');
        if (!secret) {
            throw new Error('JWT_SECRET is not defined in environment variables');
        }

        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            ignoreExpiration: false,
            secretOrKey: secret,
        });
    }

    async validate(payload: IJwtPayload) {
        // Fetch fresh role and permissions from database
        const user = await this.prisma.system_user.findUnique({
            where: { id: payload.id },
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
            throw new UnauthorizedException('User no longer exists');
        }

        const permissions = user.role.role_permissions.map(rp => rp.permission.code);

        return {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role.code,
            permissions
        };
    }
}