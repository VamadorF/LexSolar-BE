import { IsString, IsNumber, IsNotEmpty } from 'class-validator';
import { Expose } from 'class-transformer';

export class SetPlanDto {
    @IsString()
    @IsNotEmpty()
    @Expose()
    name: string;
}
