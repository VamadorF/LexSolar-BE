import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import { RoleModule } from './role/role.module';
import { PrismaModule } from './prisma/prisma.module';
import { UserModule } from './user/user.module';
import { InstallationModule } from './installation/installation.module';
import { ComponentController } from './component/component.controller';
import { ComponentModule } from './component/component.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true, // Makes the configuration available globally
    }),
    ThrottlerModule.forRoot({
      throttlers:[
        {
          ttl: 60, // Time to live in seconds
          limit: 10, // Maximum number of requests allowed in the ttl period
        },
      ],
    }),
    AuthModule,
    RoleModule,
    PrismaModule,
    UserModule,
    InstallationModule,
    ComponentModule,
  ],
  controllers: [AppController, ComponentController],
  providers: [AppService],
})
export class AppModule {}
