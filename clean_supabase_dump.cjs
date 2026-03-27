const fs = require('fs');

const sql = fs.readFileSync('C:\\Users\\kayky\\Desktop\\fiden-agency-main\\backup_fiden_agency_2026-03-27.sql', 'utf8');

// We split the SQL file by logical statements (or chunks separated by \n\n)
// pg_dump separates objects with double newlines.
const chunks = sql.split(/\n\n+/);

const systemSchemas = [
  'auth', 'storage', 'realtime', 'graphql', 'graphql_public', 
  'pgbouncer', 'vault', 'extensions', 'supabase_migrations'
];

const schemaRegex = new RegExp(`^(CREATE|ALTER|DROP|COMMENT ON|GRANT|REVOKE|CREATE OR REPLACE)\\s+(TABLE|VIEW|MATERIALIZED VIEW|TYPE|FUNCTION|TRIGGER|POLICY|INDEX|SEQUENCE|DEFAULT PRIVILEGES FOR ROLE|EXTENSION)\\s+(IF (NOT )?EXISTS\\s+)?("?(${systemSchemas.join('|')})"?\\.)`, 'i');

const createSchemaRegex = new RegExp(`^(CREATE|ALTER|DROP)\\s+SCHEMA\\s+("?(${systemSchemas.join('|')})"?);`, 'i');
const grantSchemaRegex = new RegExp(`^(GRANT|REVOKE)\\s+.*ON\\s+SCHEMA\\s+("?(${systemSchemas.join('|')})"?).*`, 'i');

let inCopy = false;
const out = [];

for(let chunk of chunks) {
  let lines = chunk.split('\n');
  
  // Strip COPY blocks entirely
  if (lines.some(l => l.startsWith('COPY '))) {
    continue;
  }
  
  // Strip lines starting with \ (psql meta commands)
  lines = lines.filter(l => !l.startsWith('\\'));
  
  let joinedChunk = lines.join('\n').trim();
  if (!joinedChunk) continue;

  // Does this chunk define/alter a system schema object?
  if (schemaRegex.test(joinedChunk) || createSchemaRegex.test(joinedChunk) || grantSchemaRegex.test(joinedChunk)) {
    continue;
  }
  
  // Some pg_dump statements spanning multiple lines might start with SET or other pg_dump metadata
  if (joinedChunk.startsWith('SET ') || joinedChunk.startsWith('SELECT pg_catalog.set_config')) {
    // We allow SET statements because they configure the session
    out.push(joinedChunk);
    continue;
  }

  out.push(joinedChunk);
}

fs.writeFileSync('C:\\Users\\kayky\\Desktop\\fiden-agency-main\\schema_only.sql', out.join('\n\n'));
console.log('Criado com sucesso: schema_only.sql, limpo para o Supabase SQL Editor!');
