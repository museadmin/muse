#! /bin/bash
##############################################################
##
## Name         :   m_fail
## Author       :   Bradley Atkins
## Description  :   Error Handler
## Date         :   06/08/2015
## Args         :   1 - Error Level
##                  2 - Err MSG
## Status       :   Reviewed    [n]
##                  Tested      [n]
##                  Released    [n]
##                  Disabled    [n]
##############################################################
m_fail()
{
    echo "${1}"
}
##############################################################
##
## Name         :   m_get_file_data
## Author       :   Bradley Atkins
## Description  :   Clean the output of the find | ls command
##                  Cut out the time stamps etc just leaving
##                  perms owner grp size and path. First two params
##                  are optional. Complexity arises from requirement to 
##                  handle files and dirs with escape sequences and spaces
##                  in the names.
## Date         :   19/09/2012
## Args         :   1 - -s Optional Sort by file or directory name
##                  2 - -d Optional find of directories (Defaults to files)
##                  3 - -min Optional min depth for find
##                  4 - -max Optional max depth for find
##                  5 - Top level directory for find
## Status       :   Reviewed    [n]
##                  Tested      [n]
##                  Released    [n]
##############################################################
m_get_file_data()
{
    [[ $# > 7 ]] && m_fail 1 "Error: Usage args (${FUNCNAME})"  

    local SORT="cat" OPT="-l" TYPE="f" MIN_D= MAX_D= 

    while [[ $# > 1 ]]
    do
        case ${1} in
            -s) SORT="sort -k5";;
            -d) TYPE="d";OPT="-ld";;
            -min)
                shift 
                [[ ${1} =~ ^[[:digit:]]+$ ]] || 
                    m_fail 1 "Error: Min depth param (${FUNCNAME})" 
                MIN_D="-mindepth ${1}"
                ;;
            -max)
                shift 
                [[ ${1} =~ ^[[:digit:]]+$ ]] || 
                    m_fail 1 "Error: Max depth param (${FUNCNAME})"
                MAX_D="-maxdepth ${1}"
                ;;
            *) m_fail 1 "Error: Unrecognised option (${1}) (${FUNCNAME})";;
        esac
        shift
    done

    [[ -d "${1}" ]] || m_fail 1 "Error: Not a directory (${1}) (${FUNCNAME})" 

    awk '{
        lo=""
        for (i = 1; i <= NF; i++){
            if (i <= 5)
                if (i != 2)
                    lo = lo" "$i

            if ($i ~ /\//){
                sub(/ */, " ", $0)          
                printf lo" "$0"\n"
                next
            }
            $i = ""
        }
    }' <(find "${1}" ${MIN_D} ${MAX_D} -type ${TYPE} | sed 's#\\#\\\\#g' | xargs -i ls ${OPT} "{}") | ${SORT}
}
