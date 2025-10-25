import { Body, Controller, Post } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserSystemDto } from './dto/system-user.dto';

@Controller('user')
export class UserController {
    constructor(private userService: UserService) {}

    @Post()
    async createUser(@Body() createUserDto: CreateUserSystemDto) {
        return this.userService.createUser(createUserDto);
    }
}
