#!/usr/bin/env bash

if [[ $# -lt 2 ]]; then
    echo "usage: $0 swiftc DIR"
    exit 1
fi

bin=$1
seed_dir=$2

function test_driver() {
    $bin $f &> $f.drive
    rc=$?
    if [[ $rc -gt 128 ]] && [[ $rc -lt 250 ]]; then
        echo "+++ (driver) Crash"
    elif [[ $? -lt 128 ]] ; then
        echo "+++ (drive) abnormal"
    else
        echo "--- (drive) captured"
    fi
}


for f in $seed_dir/*.swift; do
    echo -e "\n\n====== $f"
    $bin -dump-ast $f &> $f.tc
    tc_rc=$?
    if [[ $tc_rc -gt 128 ]] && [[ $tc_rc -lt 250 ]]; then
        rg -a -l -i "Assertion " $f
        if [[ $? == 0 ]]; then
            echo "--- (dump-ast) Assertion Failre"
        fi
    else
        $bin -emit-bc $f -o /dev/null 2> $f.bc
        bc_rc=$?
        if [[ $bc_rc -gt 128 ]] && [[ $bc_rc -lt 250 ]]; then
            rg -a -l -i "Assertion " $f
            if [[ $? == 0 ]]; then
                echo "--- (emit-bc) Assertion Failre"
            fi
        fi
    fi
done
