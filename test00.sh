#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi

failed=0

###testing girt-init error messages and functionality###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - output usage - init does not accept arguments- exit 1
sh girt-init test00
test $? -eq 1 || failed=1 

sh girt-init 1 2 3
test $? -eq 1 || failed=1

# output message when .girt created for the first time - exit 0
sh girt-init 
test $? -eq 0 || failed=1

# error - .girt already exists - exit 1
sh girt-init  
test $? -eq 1 || echo failed=1

sh girt-init
test $? -eq 1 || echo failed=1

# check the initial directories (index and commit) are created with log.txt 
# when initialising .girt

if test -d ".girt/index"
then
    echo "index created"
else
    echo "ERROR: index not present" 1>&2
fi


if test -d ".girt/commit"
then
    echo "commit created"
else
    echo "ERROR: commit not present" 1>&2 
fi


if test -e ".girt/commit/log.txt"
then
    echo "log.txt created"
else
    echo "ERROR: log.txt not present" 1>&2
fi

# clean-up
rm -r .girt

echo ""
echo "<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>"
echo ""

if test "$failed" -eq 1
then
    echo "***************TEST FAILED***************" 1>&2
    echo ""
    exit 1
else
    echo "***************TEST PASSED***************" 1>&2
    echo ""
    exit 0
fi


