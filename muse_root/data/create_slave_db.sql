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
##                  Released    [n]
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
    is_set INTEGER DEFAULT 1,                       -- Active
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
    payload CHAR,                                   -- Any payload for action passed in msg
    grp char DEFAULT 'BENIGN',                      -- DESTRUCTIVE / BENIGN
    locked char DEFAULT 'N',                        -- Locked against change
    note CHAR,                                      -- Comment explaining what this field is for
    msg_id INTEGER                                  -- Optional msg ID for originating msg
);



/* ============== JOB CONTROL TABLE ================== */


/*  Job control table. Controls the running of a plugin. */
CREATE TABLE job
(
    job_id INTEGER PRIMARY KEY,
    name CHAR,                                      -- Unqualified file name
    fqn CHAR NOT NULL,                              -- FQN to plugin
    pid INTEGER,                                    -- PID of plugin
    start_time  CHAR,                               -- Record start time. 
    finish_time CHAR,                               -- Record finish time.
    master_exec_id INTEGER,                         -- id of record in exec table on master
    ctl CHAR,                                       -- Path to control file if defined in M_CTL_FILE (Daemon)
    stop CHAR DEFAULT 'stop',                       -- Control word > control file
    restart CHAR DEFAULT 'restart',                 -- Control word > control file
    startup CHAR DEFAULT 'start',                   -- Control word > control file
    originating_msg_id INTEGER DEFAULT 0,           -- The msg id of the EXECUTE_PLUGIN msg
    report CHAR                                     -- FQN of report
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
    fqn CHAR NOT NULL,                              -- Path to listener
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

/* ======================= Metadata ===================== */
CREATE TABLE metadata
(
    metadata_id INTEGER PRIMARY KEY,
    session_id CHAR,                                -- Session  Id for this run
    run_id CHAR,                                    -- Used for many paths
    user_tag CHAR,                                  -- Used for path to control and results dirs
    system_tag CHAR                                 -- Used for path to control and results dirs
);
