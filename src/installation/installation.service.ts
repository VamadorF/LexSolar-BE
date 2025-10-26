import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateInstallationTypeDto } from './dto/create-installation-type.dto';
import { plainToInstance } from 'class-transformer';
import { validateOrReject } from 'class-validator';
import { UpdateInstallationTypeDto } from './dto/update-installation-type';

@Injectable()
export class InstallationService {
    constructor(private readonly prismaService: PrismaService) { }

    // Proceso de creación de un nuevo tipo de instalación
    async createInstallation(data: CreateInstallationTypeDto): Promise<any> {

        // 0 verificar los datos
        if (!data) {
            throw new Error('Data is required to create an installation');
        }

        // 1 Transformar objeto plano en instancia del DTO
        const dtoInstance = plainToInstance(CreateInstallationTypeDto, data, {
            excludeExtraneousValues: true, // descarta props no declaradas en el DTO
            enableImplicitConversion: true, // convierte tipos (por ejemplo string->number)
        });

        // 2 Validar (usando class-validator)
        try {
            await validateOrReject(dtoInstance);
        } catch (errors) {
            throw new BadRequestException(errors);
        }

        const existingInstallationCatalog = await this.prismaService.installation_type_catalog.findFirst({
            where: {
                OR: [
                    { code: dtoInstance.code },
                    { label: dtoInstance.label },
                ],
            },
        });

        if (existingInstallationCatalog) {
            throw new BadRequestException('Role with the same code or label already exists');
        }

        return this.prismaService.installation_type_catalog.create({
            data,
        });
    }

    async updateInstallationType(id: number, data: UpdateInstallationTypeDto): Promise<any> {

        // 0 verificar los datos
        if (!data) {
            throw new Error('Data is required to create an installation');
        }

        // 1 Transformar objeto plano en instancia del DTO
        const dtoInstance = plainToInstance(UpdateInstallationTypeDto, data, {
            excludeExtraneousValues: true, // descarta props no declaradas en el DTO
            enableImplicitConversion: true, // convierte tipos (por ejemplo string->number)
        });

        // 2 Validar (usando class-validator)
        try {
            await validateOrReject(dtoInstance);
        } catch (errors) {
            throw new BadRequestException(errors);
        }

        const existingInstallationCatalog = await this.prismaService.installation_type_catalog.findFirst({
            where: {
                OR: [
                    { code: dtoInstance.code },
                    { label: dtoInstance.label },
                ],
            },
        });

        if (existingInstallationCatalog) {
            throw new BadRequestException('Role with the same code or label already exists');
        }

        return this.prismaService.installation_type_catalog.update({
            where: { id },
            data,
        });
    }

    // proceso de obtencion de todos los tipos de instalaciones
    async getInstallationTypes() {
        return this.prismaService.installation_type_catalog.findMany();
    }

    // proceso de eliminacion de un tipo de instalacion por id
    async deleteInstallationType(id: number) {
        if (!id) {
            throw new BadRequestException('Installation Type ID is required to delete an installation type');
        }

        return this.prismaService.installation_type_catalog.delete({
            where: { id },
        });
    }

}
