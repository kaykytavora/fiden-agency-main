const fs = require('fs');
const lines = fs.readFileSync('C:\\Users\\kayky\\Desktop\\fiden-agency-main\\backup_fiden_agency_2026-03-27.sql', 'utf8').split('\n');
let inCopy = false;
const out = [];
for(let line of lines) {
  if(line.startsWith('COPY ')) { inCopy = true; continue; }
  if(inCopy && line === '\\.') { inCopy = false; continue; }
  if(!inCopy) out.push(line);
}
fs.writeFileSync('C:\\Users\\kayky\\Desktop\\fiden-agency-main\\schema_only.sql', out.join('\n'));
console.log('Done extracting schema.');
