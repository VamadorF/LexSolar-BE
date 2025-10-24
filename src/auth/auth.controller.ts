import {
    BadRequestException,
    Body,
    Controller,
    Get,
    HttpCode,
    NotImplementedException,
    Param,
    Patch,
    Post,
    Req,
    UseGuards,
} from '@nestjs/common';
import { AuthDto } from './dto/auth.dto';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserRolesDto } from './dto/update-user-roles.dto';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './jwt-auth.guard';
import { PermissionsGuard } from './guards/permissions.guard';
import { Permission } from './decorators/permission.decorator';

@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Post('login')
    @HttpCode(200)
    async login(@Body() data: AuthDto): Promise<object> {
        return this.authService.authUserLogin(data);
    }

    @UseGuards(JwtAuthGuard, PermissionsGuard)
    @Post('users')
    @Permission('users:create')
    async createUser(@Body() data: CreateUserDto): Promise<object> {
        return this.authService.createUser(data);
    }

    @UseGuards(JwtAuthGuard, PermissionsGuard)
    @Patch('users/:id/roles')
    @Permission('roles:update')
    async updateUserRoles(
        @Param('id') id: string,
        @Body() data: UpdateUserRolesDto
    ): Promise<object> {
        return this.authService.updateUserRoles(id, data);
    }

    @UseGuards(JwtAuthGuard)
    @Get('me')
    async getProfile(@Req() req) {
        return {
            code: 200,
            user: req.user
        };
    }
}