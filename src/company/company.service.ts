import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class CompanyService {
    constructor(private prismaService: PrismaService) {}

    // Crear una nueva compañía
    async createCompanyByNewUser(name: string, creatorId: string) {

        // Valudar datos
        if (!name || !creatorId) {
            throw new Error('Name and Creator ID are required to create a company');
        }

        const newCompany = await this.prismaService.company.create({
            data: {
                name: name,
            },
        });
        return newCompany;
    }
}
