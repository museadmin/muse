/*
##############################################################
##
## Name		    :	master_actions.sql
## Author	    :	Bradley Atkins
## Description	:	Main actions table for state machine
## Date		    :	21/06/2015
## Status	    :	Reviewed 	[n]
##			        Tested 		[n]
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, version 2 only.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  
## USA
##
##############################################################
*/

-- Start up
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CONFIRM_MUSE_STATUS','Check if all core components are still running');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','VERIFY_SLAVES_REGISTERED','Check if all of the slaves have registered');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CONFIRM_MUSE_READY_TO_RUN','Write yes or no to state file if we are able to run');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','INITIALISE_COMMS','Launch the connection manager and confirm its status');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CONFIRM_COMMS_OK','Confirm cnxns and tx and rx initialised ok');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','LAUNCH_SLAVES','Launch the slaves concenred with this run');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CREATE_TX','Launch the message handler (outbound)');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CREATE_RX','Launch the message handler (inbound)');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','SEND_TABLE_DUMP','Send the table dump for var control to each slave');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','REGISTER_DUMP_LOADED','Register that a slave has loaded the var tables dump');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CONFIRM_ALL_DUMPS_LOADED','Confirm that all slaves in register show dump loaded');

-- Persistent actions
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_CTL_FILE_FOR_STOP','Someone might force quit by echoing "stop" into ctl file');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_CTL_FILE_FOR_SHUTDOWN','Someone might force quit by echoing "shutdown" into ctl file');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_TIMERS','See if any timer has expired');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_TIMER_Q','Process the timer Q because m_get_timer_q found running timers');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','PROCESS_EXECUTION_THREADS','Process each of any execution threads');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_MSGS','See if any msgs have arrived');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_COMMS','See if cnxn manager has reported a problem');

-- Messaging
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CHECK_FOR_ACK_TX','See if any ACKs need sending');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_MSG_Q','We have received at least one msg to process');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_ERROR_MSG','Process a non fatal error');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_FATAL_ERROR_MSG','Process a fatal error msg');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CHECK_ACK_RECEIVED','Check to see if an ACK has been received for a specific message id');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','ACK','This is never actioned but here for consistent logic');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_NEW_REPORT','Parse the report and summarise');
INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_FOR_NEW_REPORTS','Move any newly arrived reports to pending');

-- Resilience
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','HANDLE_LOST_CONNECTION','Deal with a connectivity issue involving a slave');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','HANDLE_LOST_NETWORK','Cnxn mgr reports all cnxns down');


-- Master specific
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','REGISTER_SLAVE','A slave has sent a registration request as part of init sequence');

INSERT INTO state_machine (action, flag, note) VALUES ('ACT','CHECK_RUN_COMPLETE','Check if all tasks have completed');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','REGISTER_PLUGIN_COMPLETE','A slave has reported that a plugin has completed');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_RESULTS','Process a set of results received from a slave');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','GET_USER_INPUT','Wait for user response before continuing or stopping');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','HOLD_TASK','Hold waiting for user input');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','ENABLE_HELD_TASK','User said to continue');


INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','UPDATE_RUN_SCREEN_HEAD','Add a change of state to the run time screen file. e.g. COMPLETE FAIL etc');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','UPDATE_RUN_SCREEN_BODY','Add a change of state to the run time screen file. e.g. COMPLETE FAIL etc');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','UPDATE_RUN_SCREEN_FOOT','Add a change of state to the run time screen file. e.g. COMPLETE FAIL etc');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','REFRESH_RUN_SCREEN','Clear screen and cat updated screen file');

INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','DISPLAY_MSG','Slave sent a request to display a msg file. (Typically manual input)');

-- Shutdown
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_FORCED_SHUTDOWN','Someone wrote a stop msg to the ctl file - master or slave');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_NORMAL_SHUTDOWN','Reached the end of the run');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CONFIRM_MUSE_READY_TO_SHUTDOWN','Confirm all garbage collection etc. performed');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','SHUTDOWN_MUSE','Send shutdown msg to each slave and wait for completion msgs');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','STOP_MUSE','Send shutdown msg to each slave and then immediate shutdown of master');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','SLAVES_FAILED_TO_SHUTDOWN','Slave/s did not exit within timeout for shutdown');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','CONFIRM_ALL_SLAVES_EXITED','Confirm all slaves have acknowledged shutdown msg');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_FATAL_ERROR_MSG','Process a fatal error thrown by a plugin');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','PROCESS_NON_FATAL_ERROR_MSG','Process a non-fatal error thrown by a plugin');

INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','HANDLE_NON_FATAL_ERROR','Handle a fail level of 1');
INSERT INTO state_machine (action, flag, note) VALUES ('SKIP','HANDLE_FATAL_ERROR','Handle a fail level of 2');
