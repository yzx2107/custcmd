#!/bin/sh

#16-Sep-2018
#script used to customize the cp/mv shell command to support run with test/do mode.
#version 0.1
#author Bill Yang

#usage
this_file_name=custcmd.sh
cust_cmd_list="cust_cp|cust_mv"
usage="usage: 1. to run with test mode: . ${this_file_name} test && [${cust_cmd_list}] file_from file_to \
2. to run with do mode: . ${this_file_name} do && [${cust_cmd_list}] file_from file_to"

#ts
current_ts=$(date +%Y%m%d%H%M%S)

#log_file
log_file=./test_log_${current_ts}.log

#commong funtions here
#custom echo
log_test(){
    local msg
    msg="[$(date +%Y%m%d%H%M%S) test]:$*"
    echo $msg
    echo $msg >> $log_file
}

#log error
log_error(){
    local msg
    msg="[$(date +%Y%m%d%H%M%S) error]:$*"
    echo $msg
    echo $msg >> $log_file
}

#log warn
log_warn(){
    local msg
    msg="[$(date +%Y%m%d%H%M%S) warn]:$*"
    echo $msg
    echo $msg >> $log_file
}

#log info
log_info(){
    local msg
    msg="[$(date +%Y%m%d%H%M%S) info]:$*"
    echo $msg
    echo $msg >> $log_file
}

#show the diff info for 2 files
my_diff(){
    #args check
    if [ $# -ne 2 ] ; then
        log_error "expected 2 args: file1 file2"
    fi
    local file_to
    local file_from
    file_to=$1
    file_from=$2
 
    log_info "ls -l $file_to $file_from"
    ls -l $file_to $file_from
    ls -l $file_to $file_from >> $log_file 2>&1

    log_info "diff $file_to $file_from"
    diff $file_to $file_from
    diff $file_to $file_from >> $log_file 2>&1
}

#custom the cmd (cp/mv) with run mode support
my_cmd(){
    #args check
    if [ $# -ne 3 ] ; then
        echo "expected 3 args: cmd file_from file_to"
        exit 1
    fi

    local cmd
    local file_from
    local file_to
    cmd="$1"
    file_from="$2"
    file_to="$3"

    log_info "<---"
    log_info "checking [${cmd} ${file_from} ${file_to}]"

    #check file status
    #file_from
    if [ ! -f $file_from ] ; then
        log_error "[${file_from}] not existed"
        #exit 1
    fi
    #file_to
    if [ -f $file_to ] ; then
        log_warn "[${file_to}] existed will be override with [${file_from}]"
    fi

    if [ "test" == "$run_mode" ] ; then
        my_diff $file_to $file_from
        log_test "checked [${cmd} ${file_from} ${file_to}]"
    else
        log_info "before $cmd $file_from $file_to"
        my_diff $file_to $file_from

        log_info "$cmd $file_from $file_to"
        $cmd $file_from $file_to

        log_info "after $cmd $file_from $file_to"
        my_diff $file_to $file_from
    fi

    #log some empty lines
    log_info "--->"
    log_info ""
}

#custom the mv method with run mode support
cust_mv(){
    #args check 
    if [ $# -ne 2 ] ; then
        echo "expected 2 args: file_from file_to"
        exit 1
    fi
    my_cmd mv $@
}

#custom the cp method with run mode support
cust_cp(){ 
    #args check 
    if [ $# -ne 2 ] ; then
        echo "expected 2 args: file_from file_to"
        exit 1
    fi
    my_cmd cp $@
    
}

#print usage
print_usage(){
    log_info $usage
    log_info "run_mode=$run_mode"
    log_info ""
}

#program main entry here
#run mode
if [ $# -eq 1 ] ; then
    if [ "test" == "$1" ] ; then
        run_mode=test
    elif [ "do" == "$1" ] ; then
        run_mode=do
    else
        log_error "expected 1 args: (run_mode[test|do])"
        print_usage
        exit 1
    fi
else
    log_error "expected 1 args: (run_mode[test|do])"
    print_usage	
    exit 1
fi

log_info "loaded [${this_file_name}] with mode: [${run_mode}]" 
