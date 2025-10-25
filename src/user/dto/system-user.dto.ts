import { IsOptional, IsString, IsEmail, IsNumber, IsNotEmpty } from 'class-validator';
import { Expose } from 'class-transformer';

export class CreateUserSystemDto {
  @IsString()
  @IsNotEmpty()
  @Expose()
  name: string;

  @IsString()
  @IsEmail()
  @IsNotEmpty()
  @Expose()
  email: string;

  @IsString()
  @IsNotEmpty()
  @Expose()
  password: string;

  @IsString()
  @IsNotEmpty()
  @Expose()
  phone: string;

  @IsNumber()
  @IsNotEmpty()
  @Expose()
  role_id: number;
}
