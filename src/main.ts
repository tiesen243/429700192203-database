import { drizzle } from 'drizzle-orm/node-mssql'

const db = drizzle(process.env.DATABASE_URL ?? '')

async function main() {
  await db.$client

  const result = await db.execute(`
CREATE DATABASE qlbh
ON (
  NAME = qlbh_data,
  FILENAME = '/var/opt/mssql/data/qlbh_data.mdf',
  SIZE = 20MB,
  MAXSIZE = 40MB,
  FILEGROWTH = 1MB
)
LOG ON (
  NAME = qlbh_log,
  FILENAME = '/var/opt/mssql/data/qlbh_log.ldf',
  SIZE = 6MB,
  MAXSIZE = 8MB,
  FILEGROWTH = 1MB
);
  `)
  console.log(result)
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(() => {
    process.exit(0)
  })
