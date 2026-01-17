import { defineConfig } from 'drizzle-kit'

export default defineConfig({
  dialect: 'mssql',
  dbCredentials: {
    url: `Server=127.0.0.1,1433;User Id=sa;Password=${process.env.SA_PASSWORD};TrustServerCertificate=True;`,
  },
  schema: './src/schema.ts',
  casing: 'snake_case',
  strict: true,
})
