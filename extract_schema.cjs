const fs = require('fs');
const contents = fs.readFileSync('C:\\Users\\kayky\\Desktop\\fiden-agency-main\\backup_fiden_agency_2026-03-27.sql', 'utf8');
const lines = contents.split('\n');
let inCopy = false;
const out = [];

for(let line of lines) {
  if (line.startsWith('COPY ')) {
    inCopy = true;
    continue;
  }
  if (inCopy && line.trim() === '\\.') {
    inCopy = false;
    // adding a newline for separation after copy block completes conceptually, though we remove the data
    out.push('');
    continue;
  }
  if (!inCopy && line.startsWith('\\')) {
    continue;
  }
  if (!inCopy) {
    out.push(line);
  }
}

fs.writeFileSync('C:\\Users\\kayky\\Desktop\\fiden-agency-main\\schema_only.sql', out.join('\n'));
console.log('Criado com sucesso: schema_only.sql');
