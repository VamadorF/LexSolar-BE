import { IsString, IsNotEmpty, IsArray } from 'class-validator';

export class UpdateUserRolesDto {
    @IsArray()
    @IsString({ each: true })
    @IsNotEmpty({ each: true })
    role_ids: string[];
}