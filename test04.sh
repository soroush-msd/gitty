#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi

failed=0

###testing girt-log###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - calling girt-log before init - exit 1
sh girt-log 
test $? -eq 1 || failed=1

sh girt-init

# no commit yet - print nothing and exit 0
sh girt-log
test $? -eq 0 || failed=1

# with arguments - output usage - exit 1
sh girt-log a b
test $? -eq 1 || failed=1

#creating files
seq 1 10 >> a
seq 1 10 >> b
seq 1 10 >> c

# add and commit the files
sh girt-add a b c
sh girt-commit -m "commit-0 with add and commit"

# change the files - add and commit with commit -a 
seq 11 20 >> b
seq 30 40 >> c 
sh girt-commit -a -m "commit-1 with with commit -a"

#nothing to commit 
sh girt-commit -m "commit-2"

#remove a file and add and commit again
rm a 
sh girt-add a 
sh girt-commit -m "removed a"

# show the commit numbers with their messages
echo "#########################"
sh girt-log
test $? -eq 0 || failed=1
echo "#########################"

rm -r .girt
rm b c

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



