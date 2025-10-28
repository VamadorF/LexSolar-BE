import { IsString, IsNumber, IsNotEmpty } from 'class-validator';
import { Expose } from 'class-transformer';

export class SetPlanDto {
    @IsString()
    @IsNotEmpty()
    @Expose()
    code: string;

    @IsString()
    @IsNotEmpty()
    @Expose()
    label: string;

    @IsNumber()
    @IsNotEmpty()
    @Expose()
    monthly_allowance: number;
}
