#!/bin/dash

# if .girt directory exist already, remove it for testing
if test -d ".girt/"
then
    rm -r ".girt/"
fi

failed=0

###testing girt-add error messages and functionality###
echo ""
echo "<<<<<<<<<<<<<<<START>>>>>>>>>>>>>>>"
echo ""

# error - calling before init - exit 1
sh girt-add
test $? -eq 1 || failed=1

# initialising .girt
sh girt-init
test $? -eq 0 || failed=1

# creating files to add
seq 1 10 >> a
seq 1 10 >> b
seq 1 10 >> c

# error - girt-add needs filenames - output usage - exit 1
sh girt-add
test $? -eq 1 || failed=1

# error - file cannot open - exit 1
sh girt-add d
test $? -eq 1 || failed=1

# error - invalid filenames regardless of whetehr or not they exit - exit 1
touch .e

sh girt-add .e
test $? -eq 1 || failed=1

sh girt-add _f
test $? -eq 1 || failed=1

# add file or files to index regardless of whether they are changed - exit 0
sh girt-add a
test $? -eq 0 || failed=1

sh girt-add b c
test $? -eq 0 || failed=1

sh girt-add a b
test $? -eq 0 || failed=1

# add files to index after they are changed - exit 0
seq 11 20 >> a
seq 20 30 >> b

sh girt-add a b
test $? -eq 0 || failed=1

# check contents of the files in index are same as the one in cwd
for indexed_file in ".girt/index/"*
do
    base_name=$(echo "$indexed_file" | cut -d'/' -f3)
    if diff "$base_name" "$indexed_file" >/dev/null
    then
        echo "$base_name is added correctly"
    else
        echo "ERROR: $base_name is not added correctly" 1>&2
    fi
done


# clean-up
rm -r .girt
rm a b c .e

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

