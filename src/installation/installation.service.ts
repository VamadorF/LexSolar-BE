import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class InstallationService {
    constructor(private readonly prismaService: PrismaService) {}

    // Create installation logic here
    async createInstallation(data: any): Promise<any> {
        // Example logic to create an installation record
        const installation = await this.prismaService.installation.create({
            data,
        });
        return installation;
    }
}
