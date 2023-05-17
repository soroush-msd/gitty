#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi

failed=0

###testing girt-commit error messages with functionality and different options###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - calling girt-commit before init - exit 1
sh girt-commit -m "message"
test $? -eq 1 || failed=1

sh girt-init
test $? -eq 0 || failed=1

# error - output correct usage - exit 1
sh girt-commit
test $? -eq 1 || failed=1

sh girt-commit -m -m "message"
test $? -eq 1 || failed=1

# nothgin to commit - exit 0
sh girt-commit -m "message"
test $? -eq 0 || failed=1

# creating files - add them - make the first commit
seq 1 10 >> a
seq 1 10 >> b

sh girt-add a b
test $? -eq 0 || failed=1

# makes commit with message commit-0 - exit 0
sh girt-commit -m "commit-0"
test $? -eq 0 || failed=1


# check the files exist in commit repo and they have the same content as index
for committed_file in ".girt/commit/0/"*
do
    base_name=$(echo "$committed_file" | cut -d'/' -f4)
    if diff ".girt/index/$base_name" "$committed_file" >/dev/null
    then
        echo "$base_name same as repo"
    else
        echo "ERROR: $committed_file not commited properly"
    fi
done

# nothing to commit - exit 0
sh girt-commit -m "commit-1"
test $? -eq 0 || failed=1

# change b
seq 11 20 >> b

# add b to index
sh girt-add b
test $? -eq 0 || failed=1

# new commit as the contents of index are changed
sh girt-commit -m "commit-1"
test $? -eq 0 || failed=1

# check the files exist in commit repo and they have the same content as index
for committed_file in ".girt/commit/1/"*
do
    base_name=$(echo "$committed_file" | cut -d'/' -f4)
    if diff ".girt/index/$base_name" "$committed_file" >/dev/null
    then
        echo "$base_name same as repo"
    else
        echo "ERROR: $committed_file not commited properly"
    fi
done

# clean-up
rm a b 
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
