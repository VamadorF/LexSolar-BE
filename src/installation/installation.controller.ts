import { Body, Controller, Delete, Get, Param, Post, Put } from '@nestjs/common';
import { InstallationService } from './installation.service';
import { CreateInstallationTypeDto } from './dto/create-installation-type.dto';
import { UpdateInstallationTypeDto } from './dto/update-installation-type';

@Controller('installation')
export class InstallationController {
    constructor(private readonly installationService: InstallationService) {}

    @Get()
    async getInstallationTypes() {
        return this.installationService.getInstallationTypes();
    }

    @Post('type')
    async createInstallationType(@Body() data: CreateInstallationTypeDto) {
        return this.installationService.createInstallation(data);
    }

    @Put('type/:id')
    async updateInstallationType(@Param('id') id: number, @Body() data: UpdateInstallationTypeDto) {
        return this.installationService.updateInstallationType(id, data);
    }
}
