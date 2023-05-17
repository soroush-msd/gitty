#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi

failed=0

###testing girt-commit further with different options###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - calling girt-commit -a before init - exit 1
sh girt-commit -a -m "message"
test $? -eq 1 || failed=1

sh girt-init
test $? -eq 0 || failed=1

# error - output correct usage - exit 1
sh girt-commit -a
test $? -eq 1 || failed=1

# wrong order
sh girt-commit -m -a "message"
test $? -eq 1 || failed=1

# too many arguments
sh girt-commit -a -m -m "message"
test $? -eq 1 || failed=1

# wrong arguments
sh girt-commit -a -a "message"
test $? -eq 1 || failed=1

# nothgin to commit - exit 0
sh girt-commit -a -m "message"
test $? -eq 0 || failed=1

# creating files - add them - make the first commit
seq 1 10 >> a
seq 1 10 >> b

# no tracked files - nothing to commit
sh girt-commit -a -m "commit-0"
test $? -eq 0 || failed=1

sh girt-add a b 

# files are being tracked - make first commit
sh girt-commit -a -m "commit-0"
test $? -eq 0 || failed=1

# cfiles changed but tracked - add and commit with commit -a - make second commit
seq 1 3 >> a 
seq 1 3 >> b 

sh girt-commit -a -m "commit-1"
test $? -eq 0 || failed=1

# make a new file but untracked - nothing to commit
seq 40 60 >> c
sh girt-commit -a -m "commit-2"
test $? -eq 0 || failed=1


rm -r .girt
rm a b c


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




