import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  async onModuleInit() {
    //eslint-disable-next-line @typescript-eslint/no-unsafe-call
    await this.$connect(); // 👈 esto debería funcionar sin error
  }

  async onModuleDestroy() {
    //eslint-disable-next-line @typescript-eslint/no-unsafe-call
    await this.$disconnect();
  }
}