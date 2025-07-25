fx_version 'cerulean'

games {"gta5", "rdr3"}

author "Project Error"
version '1.0.0'

lua54 'yes'

ui_page 'web/build/index.html'

client_script "client/**/*"

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua'
}

server_scripts {
  "server/**/*",
  '@oxmysql/lib/MySQL.lua'
}
  
files {
  'web/build/index.html',
  'web/build/**/*'
}
