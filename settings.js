// Base by Kevin tech 
// from the maker of Jexploit bot
//256742932677 




const config = require('./start/Core/developer')

const settings = {

  SESSION_ID: process.env.SESSION_ID || config.SESSION_ID || "", 
  ownername: process.env.OWNER_NAME || config.ownername || "Rɪᴅᴢ Cᴏᴅᴇʀ❦", 
  botname: process.env.BOT_NAME || config.botname || "NEMESIS MD", 
  prefa: config.prefa || ['.', '!'], 
  owner: config.owner || ["255611199851"] 
};

module.exports = settings;

const fs = require('fs');
let file = require.resolve(__filename);
fs.watchFile(file, () => {
  fs.unwatchFile(file);
  console.log('\x1b[0;32m' + __filename + ' \x1b[1;32mupdated!\x1b[0m');
  delete require.cache[file];
  require(file);
});