master.db: create_master_db.sql master_actions.sql master_states.sql create_slave_db.sql slave_actions.sql slave_states.sql
	rm -f master.db
	/usr/bin/sqlite3 master.db < create_master_db.sql
	/usr/bin/sqlite3 master.db < master_actions.sql
	/usr/bin/sqlite3 master.db < master_states.sql

	rm -f slave.db
	/usr/bin/sqlite3 slave.db < create_slave_db.sql
	/usr/bin/sqlite3 slave.db < slave_actions.sql
	/usr/bin/sqlite3 slave.db < slave_states.sql
