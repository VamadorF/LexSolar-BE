import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateUserSystemDto } from './dto/create-system-user.dto';
import { plainToInstance } from 'class-transformer';
import { validateOrReject } from 'class-validator';

import * as bcrypt from 'bcrypt';
import { UpdateUserSystemDto } from './dto/update-system-user';


@Injectable()
export class UserService {
    constructor(private prismaService: PrismaService) { }

    async createUser(data: CreateUserSystemDto) {
        if (!data) {
            throw new Error('Data is required to create a user');
        }

        // 1 Transformar objeto plano en instancia del DTO
        const dtoInstance = plainToInstance(CreateUserSystemDto, data, {
            excludeExtraneousValues: true, // descarta props no declaradas en el DTO
            enableImplicitConversion: true, // convierte tipos (por ejemplo string->number)
        });

        // 2 Validar (usando class-validator)
        try {
            await validateOrReject(dtoInstance);
        } catch (errors) {
            throw new BadRequestException(errors);
        }

        // 3 check for existing user with same email
        const existingUser = await this.prismaService.system_user.findUnique({
            where: { email: dtoInstance.email },
        });

        if (existingUser) {
            throw new BadRequestException('User with the same email already exists');
        }

        // 4 Hash password
        const password_hash = await bcrypt.hash(data.password, 10);

        // 4 Crear el usuario
        return this.prismaService.system_user.create({
            data: {
                name: dtoInstance.name,
                email: dtoInstance.email,
                password_hash: password_hash,
                phone: dtoInstance.phone,
                role_id: dtoInstance.role_id,
            },
        });
    }

    async updateUserSystem(id: string, data: Partial<UpdateUserSystemDto>) {
        // 0 Validaciones iniciales
        if (!id) {
            throw new Error('User ID is required to update a user');
        }

        if (!data) {
            throw new Error('Data is required to update a user');
        }

        // 1 Transformar objeto plano en instancia del DTO
        const dtoInstance = plainToInstance(UpdateUserSystemDto, data, {
            excludeExtraneousValues: true, // descarta props no declaradas en el DTO
            enableImplicitConversion: true, // convierte tipos (por ejemplo string->number)
        });

        // 2 Validar (usando class-validator)
        try {
            await validateOrReject(dtoInstance);
        } catch (errors) {
            throw new BadRequestException(errors);
        }

        // 3 Actualizar el usuario
        return this.prismaService.system_user.update({
            where: { id },
            data: {
                name: dtoInstance.name,
                phone: dtoInstance.phone,
                role_id: dtoInstance.role_id,
                status_id: dtoInstance.status_id,
                company_id: dtoInstance.company_id,
            },
        });
    }

    async deleteUserSystem(id: string) {
        // 0 Validaciones iniciales
        if (!id) {
            throw new Error('User ID is required to delete a user');
        }

        // 1 Eliminar el usuario
        return this.prismaService.system_user.delete({
            where: { id },
        });
    }   
}
