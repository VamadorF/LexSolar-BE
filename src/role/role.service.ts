import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateRoleDto } from './dto/create-role.dto';
import { plainToInstance } from 'class-transformer';
import { validateOrReject } from 'class-validator';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class RoleService {
  constructor(private readonly prismaService: PrismaService) {} // index [0]

    async createRole(data: CreateRoleDto) {

        // 0 verificar los datos
        if (!data) {
            throw new BadRequestException('Data is required to create a role');
        }

        // 1 Transformar objeto plano en instancia del DTO
        const dtoInstance = plainToInstance(CreateRoleDto, data, {
            excludeExtraneousValues: true, // descarta props no declaradas en el DTO
            enableImplicitConversion: true, // convierte tipos (por ejemplo string->number)
        });

        // 2 Validar (usando class-validator)
        try {
            await validateOrReject(dtoInstance);
        } catch (errors) {
            throw new BadRequestException(errors);
        }

        const existingRole = await this.prismaService.user_role.findFirst({
            where: {
                OR: [
                    { code: dtoInstance.code },
                    { label: dtoInstance.label },
                ],
            },
        });

        if (existingRole) {
            throw new BadRequestException('Role with the same code or label already exists');
        }

        return this.prismaService.user_role.create({
            data,
        });
    }

    async deleteRole(id: number) {
        if (!id) {
            throw new BadRequestException('Role ID is required to delete a role');
        }

        return this.prismaService.user_role.delete({
            where: { id },
        });
    }

    async getRoles() {
        return this.prismaService.user_role.findMany();
    }

    async getRoleById(id: number) {
        if (!id) {
            throw new BadRequestException('Role ID is required to get a role');
        }

        return this.prismaService.user_role.findUnique({
            where: { id },
        });
    }

    async getRoleByCode(code: string) {
        if (!code) {
            throw new BadRequestException('Role code is required to get a role');
        }

        return this.prismaService.user_role.findUnique({
            where: { code },
        });
    }

    async getRoleByLabel(label: string) {
        if (!label) {
            throw new BadRequestException('Role label is required to get a role');
        }

        return this.prismaService.user_role.findFirst({
            where: { label },
        });
    }
}
