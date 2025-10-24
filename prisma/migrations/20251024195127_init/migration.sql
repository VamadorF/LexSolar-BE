-- CreateTable
CREATE TABLE "permission_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "permission_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permission" (
    "id" SERIAL NOT NULL,
    "role_id" INTEGER NOT NULL,
    "permission_id" INTEGER NOT NULL,

    CONSTRAINT "role_permission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_role_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "user_role_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_status_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "user_status_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "company" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "system_user" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "phone" TEXT,
    "role_id" INTEGER NOT NULL,
    "status_id" INTEGER NOT NULL,
    "company_id" UUID NOT NULL,
    "last_login" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "system_user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_role_history" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "old_role_id" INTEGER,
    "new_role_id" INTEGER,
    "changed_by" UUID,
    "reason" TEXT,
    "changed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_role_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_status_history" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "old_status_id" INTEGER,
    "new_status_id" INTEGER,
    "changed_by" UUID,
    "reason" TEXT,
    "changed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_status_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "address" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "street" TEXT,
    "city" TEXT,
    "state" TEXT,
    "commune" TEXT,
    "country" TEXT,
    "postal_code" TEXT,

    CONSTRAINT "address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "installation_type_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "installation_type_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "installation_status_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "installation_status_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "installation" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT,
    "client_id" UUID NOT NULL,
    "installer_id" UUID,
    "type_id" INTEGER,
    "status_id" INTEGER,
    "address_id" UUID,
    "start_date" TIMESTAMP(3),
    "end_date" TIMESTAMP(3),
    "estimated_power_w" DECIMAL(18,2),
    "components_count" INTEGER NOT NULL DEFAULT 0,
    "progress" DECIMAL(5,2),
    "image_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "installation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "component_type_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "component_type_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "component_status_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "component_status_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "component" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "serial_number" TEXT NOT NULL,
    "type_id" INTEGER NOT NULL,
    "brand" TEXT,
    "model" TEXT,
    "status_id" INTEGER NOT NULL,
    "location" TEXT,
    "installation_id" UUID,
    "installation_date" TIMESTAMP(3),
    "warranty_expiry" TIMESTAMP(3),
    "power_w" DECIMAL(18,2),
    "efficiency_pct" DECIMAL(5,2),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "component_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "component_quality_history" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "component_id" UUID NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "state" TEXT NOT NULL,
    "quality_color" TEXT NOT NULL,
    "notes" TEXT,

    CONSTRAINT "component_quality_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rma_movement" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "removed_component_id" UUID,
    "new_component_id" UUID,
    "reason" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "evidence_url" TEXT,

    CONSTRAINT "rma_movement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "certificate_status_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "certificate_status_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "certificate" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "installation_id" UUID,
    "certificate_number" TEXT NOT NULL,
    "client_id" UUID,
    "installer_id" UUID,
    "issue_date" TIMESTAMP(3) NOT NULL,
    "expiry_date" TIMESTAMP(3),
    "status_id" INTEGER NOT NULL,
    "location" TEXT,
    "components_count" INTEGER,
    "total_power_w" DECIMAL(18,2),
    "file_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "certificate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "report_type_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "report_type_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "report_status_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "report_status_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "priority_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "priority_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evidence_file" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "url" TEXT NOT NULL,
    "mime_type" TEXT,
    "uploaded_by" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "evidence_file_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "security_report" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "type_id" INTEGER NOT NULL,
    "component_id" UUID,
    "component_serial" TEXT,
    "component_type_id" INTEGER,
    "status_id" INTEGER NOT NULL,
    "priority_id" INTEGER NOT NULL,
    "reported_by" UUID,
    "report_date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "location" TEXT,
    "description" TEXT,
    "resolution" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "security_report_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "security_report_evidence" (
    "report_id" UUID NOT NULL,
    "evidence_id" UUID NOT NULL,

    CONSTRAINT "security_report_evidence_pkey" PRIMARY KEY ("report_id","evidence_id")
);

-- CreateTable
CREATE TABLE "capture_assignment" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "capturer_id" UUID NOT NULL,
    "installation_id" UUID NOT NULL,
    "address_id" UUID,
    "client_id" UUID,
    "date" TIMESTAMP(3),
    "status" TEXT,
    "progress" DECIMAL(5,2),
    "components_total" INTEGER,
    "components_captured" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "capture_assignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "component_capture" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "capturer_id" UUID NOT NULL,
    "component_id" UUID,
    "serial" TEXT NOT NULL,
    "type_id" INTEGER,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" TEXT,
    "location" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "component_capture_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_type_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,

    CONSTRAINT "notification_type_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "type_id" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "priority_id" INTEGER,
    "related_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "system_settings" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "company_id" UUID,
    "company_name" TEXT,
    "company_email" TEXT,
    "company_phone" TEXT,
    "company_website" TEXT,
    "company_address" TEXT,
    "two_factor_auth" BOOLEAN NOT NULL DEFAULT false,
    "session_expiration" TEXT,
    "audit_logging" BOOLEAN NOT NULL DEFAULT true,
    "alerts_robo" BOOLEAN NOT NULL DEFAULT true,
    "weekly_reports" BOOLEAN NOT NULL DEFAULT false,
    "maintenance_notifications" BOOLEAN NOT NULL DEFAULT true,
    "api_key_current" TEXT,
    "database_connection_status" TEXT,
    "last_backup_at" TIMESTAMP(3),
    "version" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "system_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "api_key_history" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "company_id" UUID,
    "api_key" TEXT NOT NULL,
    "created_by" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revoked_at" TIMESTAMP(3),

    CONSTRAINT "api_key_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_log" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "actor_id" UUID,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entity_id" TEXT,
    "diff" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "backup_run" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finished_at" TIMESTAMP(3),
    "status" TEXT,
    "location_url" TEXT,
    "notes" TEXT,

    CONSTRAINT "backup_run_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plan_catalog" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "monthly_allowance" INTEGER NOT NULL,

    CONSTRAINT "plan_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "company_plan" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "company_id" UUID NOT NULL,
    "plan_id" INTEGER NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "bags_used" INTEGER NOT NULL DEFAULT 0,
    "bags_available" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "company_plan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_company_stats" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "company_id" UUID NOT NULL,
    "stat_date" TIMESTAMP(3) NOT NULL,
    "active_projects" INTEGER NOT NULL DEFAULT 0,
    "components_today" INTEGER NOT NULL DEFAULT 0,
    "components_month" INTEGER NOT NULL DEFAULT 0,
    "error_rate" DECIMAL(5,2) NOT NULL DEFAULT 0,
    "open_reports" INTEGER NOT NULL DEFAULT 0,
    "bags_used" INTEGER NOT NULL DEFAULT 0,
    "bags_available" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "daily_company_stats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "system_stats_monthly" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "month" TIMESTAMP(3) NOT NULL,
    "total_installations" INTEGER,
    "total_components" INTEGER,
    "active_companies" INTEGER,
    "pending_reports" INTEGER,
    "monthly_growth" DECIMAL(7,3),
    "system_health" DECIMAL(5,2),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "system_stats_monthly_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "client_alert" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "client_id" UUID NOT NULL,
    "type" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "client_alert_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "internal_user" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "company_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "internal_user_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "permission_catalog_code_key" ON "permission_catalog"("code");

-- CreateIndex
CREATE INDEX "role_permission_role_id_idx" ON "role_permission"("role_id");

-- CreateIndex
CREATE INDEX "role_permission_permission_id_idx" ON "role_permission"("permission_id");

-- CreateIndex
CREATE UNIQUE INDEX "role_permission_role_id_permission_id_key" ON "role_permission"("role_id", "permission_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_role_catalog_code_key" ON "user_role_catalog"("code");

-- CreateIndex
CREATE UNIQUE INDEX "user_status_catalog_code_key" ON "user_status_catalog"("code");

-- CreateIndex
CREATE UNIQUE INDEX "company_name_key" ON "company"("name");

-- CreateIndex
CREATE INDEX "company_name_idx" ON "company"("name");

-- CreateIndex
CREATE UNIQUE INDEX "system_user_email_key" ON "system_user"("email");

-- CreateIndex
CREATE INDEX "system_user_company_id_idx" ON "system_user"("company_id");

-- CreateIndex
CREATE INDEX "system_user_role_id_idx" ON "system_user"("role_id");

-- CreateIndex
CREATE INDEX "system_user_status_id_idx" ON "system_user"("status_id");

-- CreateIndex
CREATE INDEX "system_user_email_idx" ON "system_user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "installation_type_catalog_code_key" ON "installation_type_catalog"("code");

-- CreateIndex
CREATE UNIQUE INDEX "installation_status_catalog_code_key" ON "installation_status_catalog"("code");

-- CreateIndex
CREATE INDEX "installation_client_id_idx" ON "installation"("client_id");

-- CreateIndex
CREATE INDEX "installation_installer_id_idx" ON "installation"("installer_id");

-- CreateIndex
CREATE INDEX "installation_status_id_idx" ON "installation"("status_id");

-- CreateIndex
CREATE INDEX "installation_type_id_idx" ON "installation"("type_id");

-- CreateIndex
CREATE UNIQUE INDEX "component_type_catalog_code_key" ON "component_type_catalog"("code");

-- CreateIndex
CREATE UNIQUE INDEX "component_status_catalog_code_key" ON "component_status_catalog"("code");

-- CreateIndex
CREATE UNIQUE INDEX "component_serial_number_key" ON "component"("serial_number");

-- CreateIndex
CREATE INDEX "component_type_id_idx" ON "component"("type_id");

-- CreateIndex
CREATE INDEX "component_status_id_idx" ON "component"("status_id");

-- CreateIndex
CREATE INDEX "component_installation_id_idx" ON "component"("installation_id");

-- CreateIndex
CREATE INDEX "component_serial_number_idx" ON "component"("serial_number");

-- CreateIndex
CREATE INDEX "component_quality_history_component_id_date_idx" ON "component_quality_history"("component_id", "date" DESC);

-- CreateIndex
CREATE INDEX "rma_movement_removed_component_id_idx" ON "rma_movement"("removed_component_id");

-- CreateIndex
CREATE INDEX "rma_movement_new_component_id_idx" ON "rma_movement"("new_component_id");

-- CreateIndex
CREATE UNIQUE INDEX "certificate_status_catalog_code_key" ON "certificate_status_catalog"("code");

-- CreateIndex
CREATE UNIQUE INDEX "certificate_certificate_number_key" ON "certificate"("certificate_number");

-- CreateIndex
CREATE INDEX "certificate_client_id_idx" ON "certificate"("client_id");

-- CreateIndex
CREATE INDEX "certificate_installer_id_idx" ON "certificate"("installer_id");

-- CreateIndex
CREATE INDEX "certificate_status_id_idx" ON "certificate"("status_id");

-- CreateIndex
CREATE UNIQUE INDEX "report_type_catalog_code_key" ON "report_type_catalog"("code");

-- CreateIndex
CREATE UNIQUE INDEX "report_status_catalog_code_key" ON "report_status_catalog"("code");

-- CreateIndex
CREATE UNIQUE INDEX "priority_catalog_code_key" ON "priority_catalog"("code");

-- CreateIndex
CREATE INDEX "security_report_status_id_idx" ON "security_report"("status_id");

-- CreateIndex
CREATE INDEX "security_report_priority_id_idx" ON "security_report"("priority_id");

-- CreateIndex
CREATE INDEX "security_report_component_serial_idx" ON "security_report"("component_serial");

-- CreateIndex
CREATE INDEX "security_report_report_date_idx" ON "security_report"("report_date" DESC);

-- CreateIndex
CREATE INDEX "capture_assignment_capturer_id_date_idx" ON "capture_assignment"("capturer_id", "date");

-- CreateIndex
CREATE INDEX "component_capture_capturer_id_timestamp_idx" ON "component_capture"("capturer_id", "timestamp" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "notification_type_catalog_code_key" ON "notification_type_catalog"("code");

-- CreateIndex
CREATE INDEX "notification_user_id_is_read_idx" ON "notification"("user_id", "is_read");

-- CreateIndex
CREATE INDEX "notification_timestamp_idx" ON "notification"("timestamp" DESC);

-- CreateIndex
CREATE INDEX "system_settings_company_id_idx" ON "system_settings"("company_id");

-- CreateIndex
CREATE INDEX "api_key_history_company_id_created_at_idx" ON "api_key_history"("company_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "audit_log_actor_id_created_at_idx" ON "audit_log"("actor_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "audit_log_entity_created_at_idx" ON "audit_log"("entity", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "plan_catalog_code_key" ON "plan_catalog"("code");

-- CreateIndex
CREATE INDEX "company_plan_company_id_expires_at_idx" ON "company_plan"("company_id", "expires_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "company_plan_company_id_plan_id_started_at_key" ON "company_plan"("company_id", "plan_id", "started_at");

-- CreateIndex
CREATE INDEX "daily_company_stats_company_id_stat_date_idx" ON "daily_company_stats"("company_id", "stat_date" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "daily_company_stats_company_id_stat_date_key" ON "daily_company_stats"("company_id", "stat_date");

-- CreateIndex
CREATE INDEX "system_stats_monthly_month_idx" ON "system_stats_monthly"("month" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "system_stats_monthly_month_key" ON "system_stats_monthly"("month");

-- CreateIndex
CREATE INDEX "client_alert_client_id_date_idx" ON "client_alert"("client_id", "date" DESC);

-- CreateIndex
CREATE INDEX "internal_user_company_id_idx" ON "internal_user"("company_id");

-- AddForeignKey
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "user_role_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_permission_id_fkey" FOREIGN KEY ("permission_id") REFERENCES "permission_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_user" ADD CONSTRAINT "system_user_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "user_role_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_user" ADD CONSTRAINT "system_user_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "user_status_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_user" ADD CONSTRAINT "system_user_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role_history" ADD CONSTRAINT "user_role_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "system_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role_history" ADD CONSTRAINT "user_role_history_old_role_id_fkey" FOREIGN KEY ("old_role_id") REFERENCES "user_role_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role_history" ADD CONSTRAINT "user_role_history_new_role_id_fkey" FOREIGN KEY ("new_role_id") REFERENCES "user_role_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role_history" ADD CONSTRAINT "user_role_history_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_status_history" ADD CONSTRAINT "user_status_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "system_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_status_history" ADD CONSTRAINT "user_status_history_old_status_id_fkey" FOREIGN KEY ("old_status_id") REFERENCES "user_status_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_status_history" ADD CONSTRAINT "user_status_history_new_status_id_fkey" FOREIGN KEY ("new_status_id") REFERENCES "user_status_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_status_history" ADD CONSTRAINT "user_status_history_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "installation" ADD CONSTRAINT "installation_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "system_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "installation" ADD CONSTRAINT "installation_installer_id_fkey" FOREIGN KEY ("installer_id") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "installation" ADD CONSTRAINT "installation_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "installation_type_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "installation" ADD CONSTRAINT "installation_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "installation_status_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "installation" ADD CONSTRAINT "installation_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "component" ADD CONSTRAINT "component_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "component_type_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "component" ADD CONSTRAINT "component_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "component_status_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "component" ADD CONSTRAINT "component_installation_id_fkey" FOREIGN KEY ("installation_id") REFERENCES "installation"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "component_quality_history" ADD CONSTRAINT "component_quality_history_component_id_fkey" FOREIGN KEY ("component_id") REFERENCES "component"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rma_movement" ADD CONSTRAINT "rma_movement_removed_component_id_fkey" FOREIGN KEY ("removed_component_id") REFERENCES "component"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rma_movement" ADD CONSTRAINT "rma_movement_new_component_id_fkey" FOREIGN KEY ("new_component_id") REFERENCES "component"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificate" ADD CONSTRAINT "certificate_installation_id_fkey" FOREIGN KEY ("installation_id") REFERENCES "installation"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificate" ADD CONSTRAINT "certificate_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificate" ADD CONSTRAINT "certificate_installer_id_fkey" FOREIGN KEY ("installer_id") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificate" ADD CONSTRAINT "certificate_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "certificate_status_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "evidence_file" ADD CONSTRAINT "evidence_file_uploaded_by_fkey" FOREIGN KEY ("uploaded_by") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_report" ADD CONSTRAINT "security_report_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "report_type_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_report" ADD CONSTRAINT "security_report_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "report_status_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_report" ADD CONSTRAINT "security_report_priority_id_fkey" FOREIGN KEY ("priority_id") REFERENCES "priority_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_report" ADD CONSTRAINT "security_report_component_id_fkey" FOREIGN KEY ("component_id") REFERENCES "component"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_report" ADD CONSTRAINT "security_report_component_type_id_fkey" FOREIGN KEY ("component_type_id") REFERENCES "component_type_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_report" ADD CONSTRAINT "security_report_reported_by_fkey" FOREIGN KEY ("reported_by") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_report_evidence" ADD CONSTRAINT "security_report_evidence_report_id_fkey" FOREIGN KEY ("report_id") REFERENCES "security_report"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_report_evidence" ADD CONSTRAINT "security_report_evidence_evidence_id_fkey" FOREIGN KEY ("evidence_id") REFERENCES "evidence_file"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "capture_assignment" ADD CONSTRAINT "capture_assignment_capturer_id_fkey" FOREIGN KEY ("capturer_id") REFERENCES "system_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "capture_assignment" ADD CONSTRAINT "capture_assignment_installation_id_fkey" FOREIGN KEY ("installation_id") REFERENCES "installation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "capture_assignment" ADD CONSTRAINT "capture_assignment_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "address"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "capture_assignment" ADD CONSTRAINT "capture_assignment_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "component_capture" ADD CONSTRAINT "component_capture_capturer_id_fkey" FOREIGN KEY ("capturer_id") REFERENCES "system_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "component_capture" ADD CONSTRAINT "component_capture_component_id_fkey" FOREIGN KEY ("component_id") REFERENCES "component"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "component_capture" ADD CONSTRAINT "component_capture_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "component_type_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification" ADD CONSTRAINT "notification_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "system_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification" ADD CONSTRAINT "notification_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "notification_type_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification" ADD CONSTRAINT "notification_priority_id_fkey" FOREIGN KEY ("priority_id") REFERENCES "priority_catalog"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "system_settings" ADD CONSTRAINT "system_settings_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "api_key_history" ADD CONSTRAINT "api_key_history_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "api_key_history" ADD CONSTRAINT "api_key_history_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_log" ADD CONSTRAINT "audit_log_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "system_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "company_plan" ADD CONSTRAINT "company_plan_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "company_plan" ADD CONSTRAINT "company_plan_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "plan_catalog"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_company_stats" ADD CONSTRAINT "daily_company_stats_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "client_alert" ADD CONSTRAINT "client_alert_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "system_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "internal_user" ADD CONSTRAINT "internal_user_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
