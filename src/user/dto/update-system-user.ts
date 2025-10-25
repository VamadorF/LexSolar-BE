import { IsOptional, IsString, IsEmail, IsNumber, IsNotEmpty } from 'class-validator';
import { Expose } from 'class-transformer';

export class UpdateUserSystemDto {
  @IsString()
  @IsNotEmpty()
  @Expose()
  name: string;

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

  @IsNumber()
  @IsNotEmpty()
  @Expose()
  status_id: number;

  @IsNumber()
  @IsNotEmpty()
  @Expose()
  company_id: string;
}
