import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { IJwtPayload } from '../jwt.strategy';

export const CurrentUser = createParamDecorator(
  (data: IJwtPayload, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.user; // <- aquí viene el payload decodificado del JWT
  },
);