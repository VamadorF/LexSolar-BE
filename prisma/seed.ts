import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  // Create Roles
  const roles = [
    { code: 'admin', label: 'Admin' },
    { code: 'manager', label: 'Manager' },
    { code: 'operator', label: 'Operator' },
    { code: 'viewer', label: 'Viewer' }
  ];

  for (const role of roles) {
    await prisma.user_role_catalog.upsert({
      where: { code: role.code },
      update: {},
      create: role
    });
  }

  // Create Permissions
  const permissions = [
    { code: 'users:create', label: 'Create Users' },
    { code: 'users:read', label: 'Read Users' },
    { code: 'users:update', label: 'Update Users' },
    { code: 'users:delete', label: 'Delete Users' },
    { code: 'roles:create', label: 'Create Roles' },
    { code: 'roles:read', label: 'Read Roles' },
    { code: 'roles:update', label: 'Update Roles' },
    { code: 'roles:delete', label: 'Delete Roles' }
  ];

  for (const permission of permissions) {
    await prisma.permission_catalog.upsert({
      where: { code: permission.code },
      update: {},
      create: permission
    });
  }

  // Associate permissions with roles
  const rolePermissions = {
    'admin': [
      'users:create', 'users:read', 'users:update', 'users:delete',
      'roles:create', 'roles:read', 'roles:update', 'roles:delete'
    ],
    'manager': [
      'users:create', 'users:read', 'users:update',
      'roles:read', 'roles:update'
    ],
    'operator': [
      'users:read',
      'roles:read'
    ],
    'viewer': [
      'users:read',
      'roles:read'
    ]
  };

  for (const [roleCode, permissions] of Object.entries(rolePermissions)) {
    const role = await prisma.user_role_catalog.findUnique({
      where: { code: roleCode }
    });
    if (!role) continue;

    for (const permissionCode of permissions) {
      const permission = await prisma.permission_catalog.findUnique({
        where: { code: permissionCode }
      });
      if (!permission) continue;

      await prisma.role_permission.upsert({
        where: {
          role_id_permission_id: {
            role_id: role.id,
            permission_id: permission.id
          }
        },
        update: {},
        create: {
          role_id: role.id,
          permission_id: permission.id
        }
      });
    }
  }

  // Create company and active status for admin
  const company = await prisma.company.upsert({
    where: { name: 'Default Company' },
    update: {},
    create: { name: 'Default Company' }
  });

  const activeStatus = await prisma.user_status_catalog.upsert({
    where: { code: 'active' },
    update: {},
    create: { code: 'active', label: 'Active' }
  });

  // Create initial admin user
  const adminRole = await prisma.user_role_catalog.findUnique({
    where: { code: 'admin' }
  });

  if (adminRole) {
    const hashedPassword = await bcrypt.hash('admin123', 10);

    const admin = await prisma.system_user.upsert({
      where: { email: 'admin@lexsolar.com' },
      update: {},
      create: {
        name: 'Admin User',
        email: 'admin@lexsolar.com',
        password_hash: hashedPassword,
        role_id: adminRole.id,
        status_id: activeStatus.id,
        company_id: company.id
      }
    });
    console.log('Seeded admin:', admin);
  }

  console.log('Seed completed successfully');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });