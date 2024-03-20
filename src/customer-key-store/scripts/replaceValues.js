const fs = require('fs');

const filePath = process.argv[2];
const replacements = {
  valueClientId: process.argv[3],
  valueTenantId: process.argv[4],
  valueUrl: process.argv[5],
  valueKeyName: process.argv[6],
  valueGuid: process.argv[7],
  valueEmails: process.argv[8],
  valuePublicPem: process.argv[9],
  valuePrivatePem: process.argv[10]
};

fs.readFile(filePath, 'utf8', (err, data) => {
  if (err) {
    console.error(err);
    return;
  }

  let jsonData = JSON.parse(data);

  // Replace values with environment variables
  for (const key in replacements) {
    if (replacements.hasOwnProperty(key)) {
      jsonData[key] = process.env[key];
    }
  }

  // Write back the modified JSON
  fs.writeFile(filePath, JSON.stringify(jsonData, null, 2), (err) => {
    if (err) {
      console.error(err);
      return;
    }
    console.log('Values replaced successfully!');
  });
});
