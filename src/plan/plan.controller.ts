import { Body, Controller, Get, Post } from '@nestjs/common';
import { PlanService } from './plan.service';
import { CreatePlanCatalogDto } from './dto/create-plan-catalog.dto';

@Controller('plan')
export class PlanController {
    constructor(private readonly planService: PlanService) {}

    // Obtener planes
    @Get()
    async getAllPlans() {
        return this.planService.getAllPlans();
    }

    // Crear plan
    @Post()
    async createPlan(@Body() createPlanDto: CreatePlanCatalogDto) {
        return this.planService.createPlan(createPlanDto);
    }
}
