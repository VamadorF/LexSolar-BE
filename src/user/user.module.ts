import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { PrismaModule } from 'src/prisma/prisma.module';

@Module({
  imports: [PrismaModule],     // <- IMPORTA el módulo que exporta la dependencia
  providers: [UserService],
  controllers: [UserController]
})
export class UserModule {}
