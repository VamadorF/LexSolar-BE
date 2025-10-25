import { Body, Controller, Patch, Post, Put, UseGuards } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserSystemDto } from './dto/create-system-user.dto';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { CurrentUser } from 'src/auth/decorators/current-user.decorator';
import { UpdateUserSystemDto } from './dto/update-system-user';
import { IJwtPayload } from 'src/auth/jwt.strategy';

@Controller('user')
export class UserController {
    constructor(private userService: UserService) { }

    @Post()
    async createUser(@Body() createUserDto: CreateUserSystemDto) {
        return this.userService.createUser(createUserDto);
    }

    @Patch('me')
    @UseGuards(JwtAuthGuard)
    async updateMyProfile(
        @CurrentUser() user: IJwtPayload, // userId desde el JWT
        @Body() dto: UpdateUserSystemDto, // PartialType(CreateUserDto)
    ) {
        return this.userService.updateUserSystem(user.id, dto);
    }
}
