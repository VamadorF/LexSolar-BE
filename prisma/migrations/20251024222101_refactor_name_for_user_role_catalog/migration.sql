/*
  Warnings:

  - You are about to drop the `user_role_catalog` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "public"."role_permission" DROP CONSTRAINT "role_permission_role_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."system_user" DROP CONSTRAINT "system_user_role_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."user_role_history" DROP CONSTRAINT "user_role_history_new_role_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."user_role_history" DROP CONSTRAINT "user_role_history_old_role_id_fkey";

-- DropTable
DROP TABLE "public"."user_role_catalog";

-- CreateTable
CREATE TABLE "user_role" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "user_role_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_role_code_key" ON "user_role"("code");

-- AddForeignKey
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "user_role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_user" ADD CONSTRAINT "system_user_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "user_role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role_history" ADD CONSTRAINT "user_role_history_old_role_id_fkey" FOREIGN KEY ("old_role_id") REFERENCES "user_role"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role_history" ADD CONSTRAINT "user_role_history_new_role_id_fkey" FOREIGN KEY ("new_role_id") REFERENCES "user_role"("id") ON DELETE SET NULL ON UPDATE CASCADE;
