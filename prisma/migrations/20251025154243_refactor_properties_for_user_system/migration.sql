-- DropForeignKey
ALTER TABLE "public"."system_user" DROP CONSTRAINT "system_user_company_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."system_user" DROP CONSTRAINT "system_user_status_id_fkey";

-- AlterTable
ALTER TABLE "system_user" ALTER COLUMN "status_id" DROP NOT NULL,
ALTER COLUMN "company_id" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "system_user" ADD CONSTRAINT "system_user_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "user_status_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_user" ADD CONSTRAINT "system_user_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE SET NULL ON UPDATE CASCADE;
