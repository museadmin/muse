
INSERT INTO state (status, state_txt, note) VALUES (1,'TASKS_IN_Q','Tasks in the q waiting to be launched');
INSERT INTO state (status, state_txt, note) VALUES (1,'MUSE_READY_TO_RUN',' True if all conditions for running met');
INSERT INTO state (status, state_txt, note) VALUES (1,'SLAVES_REGISTERED','All slaves are registered');
INSERT INTO state (status, state_txt, note) VALUES (1,'DUMP_DISPATCHED','Table dump has been sent to slaves');
INSERT INTO state (status, state_txt, note) VALUES (1,'DUMP_NOT_REQUIRED','Table dump was not required as no vars to propagate');
INSERT INTO state (status, state_txt, note) VALUES (1,'SLAVES_LOADED_DUMP','All slaves have loaded the var control tables');

INSERT INTO state (status, state_txt, note) VALUES (1,'ERRORS_OCCURRED','Either a fatal error or a non fatal error occurred during the run');
INSERT INTO state (status, state_txt, note) VALUES (1,'FATAL_ERROR_RECEIVED',' Slave tells us we need to exit after completing running tasks');
INSERT INTO state (status, state_txt, note) VALUES (1,'FATAL_TIME_OUT',' A fatal timeout so shutdown required');
INSERT INTO state (status, state_txt, note) VALUES (1,'NON_FATAL_TIME_OUT',' A time out occoured that wasnt fatal');
INSERT INTO state (status, state_txt, note) VALUES (1,'NON_FATAL_ERROR_RECEIVED',' Slave sent a failure msg');
INSERT INTO state (status, state_txt, note) VALUES (1,'SHUTDOWN_MSGS_SENT','All slaves have been sent the shutdown msg');

INSERT INTO state (status, state_txt, note) VALUES (1,'MASTER_SCREEN_DISPLAYED',' Current screen is master screen');
INSERT INTO state (status, state_txt, note) VALUES (1,'MASTER_SCREEN_CURRENT',' Master screen is up to date');

INSERT INTO state (status, state_txt, note) VALUES (1,'TIMER_SET',' At least one timer set');
INSERT INTO state (status, state_txt, note) VALUES (1,'ALARM_SET',' At least one alarm set');

INSERT INTO state (status, state_txt, note) VALUES (1,'TX_OK','TX status');
INSERT INTO state (status, state_txt, note) VALUES (1,'RX_OK','RX status');
INSERT INTO state (status, state_txt, note) VALUES (1,'CNXN_MGR_RUNNING','Connection manager reported running');
INSERT INTO state (status, state_txt, note) VALUES (1,'CNXNS_OPEN','All connections have state of open');

INSERT INTO state (status, state_txt, note) VALUES (1,'COMMS_OK','All comms states are good');
