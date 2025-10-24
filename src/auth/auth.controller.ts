
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

    @Get('users')
    @UseGuards(JwtAuthGuard, PermissionsGuard)
    @Permission('users:read')
    getUsers(
        @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
        @Query('limit', new DefaultValuePipe(10), ParseIntPipe) limit: number,
    ) {
        return this.authService.getUsers(page, limit);
    }

    @UseGuards(JwtAuthGuard, PermissionsGuard)
    @Patch('users/:id/roles')
    @Permission('roles:update')
    async assignRoles(
        @Param('id') id: string,
        @Body() dto: AssignRolesDto
    ) { 
        return this.authService.assignRoles(id, dto.roleIds);
    }

    @Get('users/:id')
    @UseGuards(JwtAuthGuard, PermissionsGuard)
    @Permission('users:read')
    getById(@Param('id') id: string) {
        return this.authService.findById(id);
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