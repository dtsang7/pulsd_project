
require 'pg'

begin
	conn = PG.connect(dbname: 'postgres')
	conn.exec("CREATE DATABASE testdb;")
rescue PG::Error => e
    puts e.message 
ensure
    conn.close if conn
end