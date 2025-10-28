import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreatePlanCatalogDto } from './dto/create-plan-catalog.dto';
import { plainToInstance } from 'class-transformer';
import { validateOrReject } from 'class-validator';

@Injectable()
export class PlanService {
    constructor(private readonly prismaService: PrismaService) {}

    // Obtener todos los planes
    async getAllPlans() {
        return this.prismaService.plan_catalog.findMany();
    }

    // Crear plan
    async createPlan(data: CreatePlanCatalogDto) {
        // Verificasión de la data
        if (
            !data ||
            !data.code ||
            !data.label ||
            data.monthly_allowance === undefined
        ) {
            throw new Error('Datos incompletos para crear el plan.');
        }

        // Verificación del DTO
        const dtoInstance = plainToInstance(CreatePlanCatalogDto, data, {
            excludeExtraneousValues: true, // descarta props no declaradas en el DTO
            enableImplicitConversion: true, // convierte tipos (por ejemplo string->number)
        });

        // Validar (usando class-validator)
        try {
            await validateOrReject(dtoInstance);
        } catch (errors) {
            throw new BadRequestException(errors);
        }

        // Revisar si el código del plan ya existe
        const existingPlan = await this.prismaService.plan_catalog.findUnique({
            where: { code: dtoInstance.code },
        });
        
        if (existingPlan) {
            throw new BadRequestException('El código del plan ya existe.');
        }

        // Crear el plan en la base de datos
        return this.prismaService.plan_catalog.create({
            data: {
                code: dtoInstance.code,
                label: dtoInstance.label,
                monthly_allowance: dtoInstance.monthly_allowance,
            },
        });
    }
}
