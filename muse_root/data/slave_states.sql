/*
##############################################################
##
## Name		    :	slave_states.sql
## Author	    :	Bradley Atkins
## Description	:	Table for tracking state of slave machine
## Date		    :	21/06/2015
## Args		    :	
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
INSERT INTO state (status, state_txt, note) VALUES (1,'SLAVE_READY_TO_EXECUTE','Set when everything initialised');
INSERT INTO state (status, state_txt, note) VALUES (1,'ALARM_SET',' At least one alarm set');
INSERT INTO state (status, state_txt, note) VALUES (1,'TIMER_SET',' At least one timer set');
INSERT INTO state (status, state_txt, note) VALUES (1,'CONNECTIONS_OPEN',' Cnxn Manager reports all open');
INSERT INTO state (status, state_txt, note) VALUES (1,'FATAL_ERROR_RECEIVED',' Slave tells us we need to exit after completing running tasks');
INSERT INTO state (status, state_txt, note) VALUES (1,'ERRORS_OCCURRED','Either a fatal error or a non fatal error occurred during the run');
INSERT INTO state (status, state_txt, note) VALUES (1,'FATAL_TIME_OUT',' A fatal timeout so shutdown required');
INSERT INTO state (status, state_txt, note) VALUES (1,'NON_FATAL_TIME_OUT',' A time out occoured that wasnt fatal');
INSERT INTO state (status, state_txt, note) VALUES (1,'TASKS_IN_Q',' All task complete or not');
INSERT INTO state (status, state_txt, note) VALUES (1,'WAITING_FOR_USER_INPUT',' Waiting for the user so paused');

-- Slave only
INSERT INTO state (status, state_txt, note) VALUES (1,'INITIALISATION_MSG_WRITTEN','The COMMS initialisation msg has been written to db');
INSERT INTO state (status, state_txt, note) VALUES (1,'INITIALISATION_MSG_FAILED','Writing the comms initialisation msg to db failed');


INSERT INTO state (status, state_txt, note) VALUES (1,'INITIALISING_COMMS','Still booting up');
INSERT INTO state (status, state_txt, note) VALUES (1,'DUMP_LOADED','SQL dump from master has been loaded');

