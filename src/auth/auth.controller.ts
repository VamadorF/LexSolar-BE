
import { 
    BadRequestException, Body, Controller, Get, HttpCode, NotImplementedException, NotFoundException,
    Param, Patch, Post, Req, UseGuards, DefaultValuePipe, ParseIntPipe, Query 
} from '@nestjs/common';
import { AuthDto } from './dto/auth.dto';
import { CreateUserDto } from './dto/create-user.dto';
import { AssignRolesDto } from './dto/assign-roles.dto';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './jwt-auth.guard';
import { PermissionsGuard } from './guards/permissions.guard';
import { Permission } from './decorators/permission.decorator';


@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Post()
    @HttpCode(200)
    async login(@Body() data: AuthDto): Promise<object> {
        return this.authService.authUserLogin(data);
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