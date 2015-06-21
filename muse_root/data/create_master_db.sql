/*
##############################################################
##
## Name         :   create_master_db.sql
## Author       :   Bradley Atkins
## Description  :   Create the master database for MUSE master.
##                  DB is used to record the state of MUSE at runtime.
## Date         :   11/08/2013
## Args         :   
## Status       :   Reviewed    [n]
##                  Tested      [n]
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

    ============== TIMER TABLES ==============

    Create the TIMER table for tracking all timers used during run. 
    Timeout causes MUSE to call the named function if set or set the action flag */

CREATE TABLE timer
(
    timer_id INTEGER PRIMARY KEY,
    is_set INTEGER NOT NULL DEFAULT 1,              -- Active when 0
    time INTEGER NOT NULL,                          -- Trigger time 
    action CHAR,                                    -- Action flag to set on timeout
    action_state CHAR DEFAULT 'ACT',                -- Action state to set for action flag. ACT or SKIP
    payload CHAR                                    -- Optional payload for action
);

/*  Create the ALARM table for tracking all alarms used during run. 
    Alarms implicitely call m_fail so failure level and msg are all that's required */
CREATE TABLE alarm
(
    alarm_id INTEGER PRIMARY KEY,
    is_set INTEGER DEFAULT 1,                       -- Active when 0
    time INTEGER NOT NULL,                          -- Trigger time 
    alarm_failure_level INTEGER DEFAULT 1,          -- Failure level for call to m_fail
    alarm_failure_msg CHAR NOT NULL                 -- Failure msg to log for failure
);



/* ============== STATE MACHINE TABLES ================= */

/* MASTER State table. Used to persist (Resilience) and 
    track (runtime operation) state. */
CREATE TABLE state
(
    state_id INTEGER PRIMARY KEY,
    status INTEGER DEFAULT 1,                       -- True or False
    state_txt CHAR NOT NULL,                        -- Textual representation e.g. SLAVES_RUNNING
    note CHAR,                                      -- Comment explaining what this field is for
    change CHAR
);

/*  Master state machine flags such as PROCESS_NORMAL_SHUTDOWN etc.
    Used as primary control mechanism in state machine */
CREATE TABLE state_machine
(
    state_machine_id INTEGER PRIMARY KEY,
    flag CHAR,                                      -- The textual flag. e.g. PROCESS_NORMAL_SHUTDOWN
    action CHAR DEFAULT 'SKIP',                     -- SKIP or ACT
    payload CHAR,                                   -- Any payload sent via msg for action
    note CHAR,                                      -- Comment explaining what this field is for
    grp char DEFAULT 'BENIGN',                      -- DESTRUCTIVE / BENIGN
    locked char DEFAULT 'N',                        -- Locked against change
    msg_id INTEGER                                  -- Optional msg ID for originating msg
);



/* ============== JOB AND SUITE CONTROL  ================== */

/* Exec Control Table amalgamates suites and jobs */
CREATE TABLE exec
(
    id INTEGER PRIMARY KEY,
    parent_id INTEGER DEFAULT 0,                    -- ID of parent suite
    exec_type CHAR,                                 -- Plugin or Suite
    line_no INTEGER DEFAULT 0,                      -- Line no in containing suite
    path CHAR,                                      -- Location in file system
    name CHAR,                                      -- m_* or ms_*
    group_id INTEGER DEFAULT 0,                     -- If a memeber of a BG group
    bg INTEGER DEFAULT 1,                           -- True if a background job
    wait INTEGER DEFAULT 1,                         -- True if we need to wait for completion of BG group
    start_time INTEGER,                             -- Epoch seconds
    finish_time INTEGER,                            -- Epoch seconds
    host CHAR,                                      -- Host to run on if type is plugin
    exec_line INTEGER DEFAULT 0,                    -- Line to execute if type is suite
    exec_order INTEGER DEFAULT 0,                   -- Order that plugins are executed
    member_count INTEGER DEFAULT 0,                 -- Number of members if type is suite
    state INTEGER DEFAULT 2                         -- 0 - running 1 - complete 2 - not run Default
);

CREATE TABLE thread_exec
(
    thread_exec_id INTEGER PRIMARY KEY,
    exec_id INTEGER NOT NULL                        -- Points to exec record of suite being executed as thread
);

/* ================ MESSAGING TABLES ==================== */


/* MSG table for master or slave. */
CREATE TABLE msgs
(
    msgs_id INTEGER PRIMARY KEY,
    sender_id INTEGER NOT NULL,                     -- msgs_id from sender msg table. 0 if outbound
    rx_time CHAR,                                   -- Time received. NULL if outbound
    tx_time CHAR NOT NULL,                          -- Time stamp from inbound message
    thread_id INTEGER NOT NULL,                     -- MSG thread this msg belongs to
    priority INTEGER DEFAULT 3,                     -- 1 - High, 2 - Medium, 3 - Low
    sender CHAR NOT NULL,                           -- hostname
    recipient CHAR NOT NULL,                        -- hostname, short name or if a broadcast - names, type or list
    action_flag CHAR NOT NULL,                      -- Corresponds to Action for SM
    payload CHAR NOT NULL,                          -- Any metadata required by the action
    direction CHAR NOT NULL,                        -- INBOUND or OUTBOUND
    status CHAR DEFAULT 'NEW',                      -- NEW, PROCESSED, TIMEOUT ...
    session_id CHAR NOT NULL,                       -- Each msg is tagged with current session_id
    ack INTEGER DEFAULT 1                           -- 0 - True, 1 - false if ACK received
);

CREATE TABLE ack_ctl
(
    ack_ctl_id INTEGER PRIMARY KEY,
    msgs_id INTEGER NOT NULL,                       -- ID of the msg needing ack
    sent INTEGER                                    -- Epoch seconds ack was sent
);

/* ============= COMMS CONTROL ================= */

/* Tables holds association between slave hosts and their pipes in master DB
   In slave DB, just holds master with pipe name for slave. */
CREATE TABLE rxer
(
    listener_id INTEGER PRIMARY KEY,
    fqn CHAR NOT NULL,                              -- Path to rx
    status CHAR DEFAULT 'PENDING',                  -- PENDING / LISTENING / FATAL ERROR
    msg_count INTEGER DEFAULT 0,                    -- Number of msgs read through pipe
    pid integer DEFAULT 0,                          -- PID for listener in case we need to kill
    change CHAR 
);

CREATE TABLE txer
(
    txer_id INTEGER PRIMARY KEY,
    status CHAR DEFAULT 'PENDING',                  -- PENDING / READY TO SEND / FATAL ERROR
    msg_count INTEGER DEFAULT 0,                    -- Number of msgs transmitted
    pid INTEGER DEFAULT 0,                          -- PID of the transmitter
    ctl_file CHAR                                   -- Control file for forced shutdown
);

CREATE TABLE slave_register
(
    slave_register_id INTEGER PRIMARY KEY,
    slave CHAR NOT NULL,                            -- Host name of slave
    control CHAR DEFAULT 'pending',                 -- Slave's control directory
    in_buffer CHAR DEFAULT 'pending',               -- The path to the slave's msg in buffer
    cnxn CHAR NOT NULL,                             -- The path to the connection
    is_registered CHAR DEFAULT 'NO',                -- YES or NO for is registered or not
    is_dump_loaded CHAR DEFAULT 'NO'                -- YES or NO for is registered or not
);

/* ================== HOSTS BEARING MUSE ==================== */

/* MUSE Hosts entries */
CREATE TABLE muse_hosts
(
    muse_hosts_id INTEGER PRIMARY KEY,
    cluster_fqdn CHAR NOT NULL,                     -- Fully Qualified Domain name of cluster
    sname CHAR NOT NULL,                            -- Short name for server
    server_fqdn CHAR NOT NULL,                      -- Fully Qualified Server Name
    server_type CHAR NOT NULL,                      -- Acronym denoting server type
    os CHAR NOT NULL,                               -- Operating System 
    ip CHAR NOT NULL,                               -- IP address/es of server/s. CSV
    muse CHAR DEFAULT 'Y',                          -- If host has MUSE installed
    cluster_type CHAR DEFAULT 'QA'                  -- Cluster type - QA DEV PRODUCTION
);



/* ================== RUNTIME VARIABLES ==================== */

/* Two tables. One holds global variables that can be fetched by any slave using
        the messging infrastructure. e.g. Send msg to master requesting value. The other table 
        holds variables local to each slave. These are for the use of plugins. Each table allows
        MUSE to persist variables across pugins and servers as required. */

CREATE TABLE global_variables
(
    global_variables_id INTEGER PRIMARY KEY,
    name CHAR NOT NULL,                             -- The varaible's name
    payload CHAR                                    -- The variable's value
);

CREATE TABLE local_variables
(
    local_variables_id INTEGER PRIMARY KEY,
    name CHAR NOT NULL,                             -- The varaible's name
    payload CHAR                                    -- The variable's value
);


/* ================== MAPPING TABLES  ==================== */
/* ===================== FILES  ========================== */
CREATE TABLE project_mappings
(
    mappings_id INTEGER PRIMARY KEY,
    project_name,                                   -- Name of the project these files belong to
    path CHAR NOT NULL                              -- Paths in the MUSE core file set
);

CREATE TABLE dev_mappings
(
    mappings_id INTEGER PRIMARY KEY,
    path CHAR NOT NULL                              -- Paths in the MUSE development directory and below
);

/* =================== Variables ======================== */
CREATE TABLE var_scope
(
    var_scope_id INTEGER PRIMARY KEY,
    name CHAR NOT NULL,                             -- Name of the variable
    value CHAR NOT NULL                             -- Value of the variable
);

CREATE TABLE var_map
(
    var_scope_id INTEGER NOT NULL,                  -- Link to variable in var scope table
    exec_id INTEGER NOT NULL                        -- Link to job or suite in exec table
);

/* =================== Functions ======================== */
CREATE TABLE core_function_mappings
(
    func_mappings_id INTEGER PRIMARY KEY,
    name CHAR NOT NULL,                             -- Name of the function
    file CHAR NOT NULL,                             -- Path to a file containing this variable
    type CHAR DEFAULT 'DEPENDENCY'                  -- DEFINITION or DEPENDENCY
);

/* ======================= Files ======================== */
CREATE TABLE core_file_mappings
(
    mappings_id INTEGER PRIMARY KEY,
    path CHAR NOT NULL                              -- Paths in the MUSE core file set
);

/* ========================Projects ===================== */
CREATE TABLE projects
(
    projects_id INTEGER PRIMARY KEY,
    name CHAR NOT NULL                              -- Project Name
);

/* ======================= Metadata ===================== */
CREATE TABLE metadata
(
    metadata_id INTEGER PRIMARY KEY,
    session_id CHAR,                                -- Session  Id for this run
    run_id CHAR,                                    -- Used for many paths
    user_tag CHAR,                                  -- Used for path to control and results dirs
    system_tag CHAR                                 -- Used for path to control and results dirs
);

