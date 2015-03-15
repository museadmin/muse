-- Start up
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','VERIFY_CONNECTIVITY','Talk to the cnxn manager');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','VERIFY_READY_TO_EXECUTE','Check we are in a state to execute');

-- Persistent actions
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_CTL_FILE','Someone might force quit by echoing "stop" into ctl file');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_TIMERS','See if any timer has expired');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_TIMER_Q','Process the timer Q because m_get_timer_q found running timers');

INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PARSE_PLUGIN_HEADER','Parse the header of a plugin');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PREPROCESS_INCLUDES','Include any includes in a plugin header');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','SEND_RESULTS_TO_MASTER','Send the tarred results to the master. ');

INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CREATE_CONNECTION_DETAILS_MSG','Set up our communication to the master');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CHECK_ACK_RECEIVED','Check to see if an ACK has been received for a specific message id');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_FOR_ACK_TX','Check if any ACKs required for tx');

INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_MSGS','See if any msgs have arrived');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_MSG_Q','We have received at least one msg to process');

INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_FOR_DUMP','See if a sql dump is available');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_DUMP','We have received a sql dump');

-- Exec
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','EXECUTE_PLUGIN','Execute a plugin for the master');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_FOR_COMPLETED_JOBS','Check the job records and see if any have completed');


-- Inactive Actions
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','ACK','This is never actioned but here for consistent logic');

-- Shutdown actions
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','STOP_MUSE','Stop launching jobs and wait for all running jobs to complete');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','SHUTDOWN_MUSE','Send shutdown message to all runnning slaves and wait for onfirmation msgs');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','HANDLE_NON_FATAL_ERROR','Handle a fail level of 1');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','HANDLE_FATAL_ERROR','Handle a fail level of 2');
