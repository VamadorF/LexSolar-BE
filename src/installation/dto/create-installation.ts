import { IsString, IsNotEmpty, Length, Matches } from 'class-validator';
import { Expose, Transform } from 'class-transformer';

export class CreateInstallationDto {
    @Expose()
    @IsString()
    @IsNotEmpty()
    @Transform(({ value }) => value?.trim())
    @Length(2, 60)
    label: string;

    @Expose()
    @IsString()
    @IsNotEmpty()
    @Transform(({ value }) => value?.trim()?.toUpperCase())
    @Matches(/^[A-Z0-9_]+$/, { message: 'code debe ser MAYÚSCULAS, números o _' })
    @Length(2, 40)
    code: string;
}
