import { Pool } from 'pg';

/**
 * PostgreSQL connection pool for CampusCafe database
 * Uses connection string from environment or defaults to local dev settings
 */
// Validar que existe la variable de entorno
if (!process.env.DATABASE_URL) {
  throw new Error('DATABASE_URL no está definida en .env');
}

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // Extra: Agregué estas configs para evitar conexiones colgadas y limitar recursos del servidor
  max: 20,                    // Máximo de conexiones simultáneas
  idleTimeoutMillis: 30000,   // Cierra conexiones inactivas después de 30s
  connectionTimeoutMillis: 2000, // Timeout si no puede conectar
});

// Log pool errors
// Nota: Usé _err con guión bajo porque ESLint marcaba warning de variable sin usar
pool.on('error', (_err) => {
  console.error('Unexpected error on idle client');
  process.exit(-1);
});

/**
 * Execute a query with optional parameters
 * @param text - SQL query string
 * @param params - Query parameters
 * @returns Query result
 */
export async function query<T>(text: string, params?: unknown[]): Promise<T[]> {
  const start = Date.now();
  try {
    const result = await pool.query(text, params);
    const duration = Date.now() - start;
    if (process.env.NODE_ENV === 'development') {
      console.log('Executed query', { text: text.substring(0, 50), duration, rows: result.rowCount });
    }
    return result.rows as T[];
  } catch (error) {
    console.error('Database query error:', error);
    throw error;
  }
}

/**
 * Get a client from the pool for transactions
 */
export async function getClient() {
  const client = await pool.connect();
  return client;
}

/**
 * Close the pool connection
 */
export async function closePool() {
  await pool.end();
}

export default pool;
