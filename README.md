# gitty
A simplified implementation of Git in Shell

Commands implemented are `girt-init`, `girt-add`, `girt-commit`, `girt-log`, `girt-status`, `girt-show`, and `girt-rm`. They match the behaviour of their Git counterparts.

For example:

```$ ./girt-innit```

initialises an empty directory called `.girt` to store the new respositroy.

<br />

After creating a repo, you can add files to the index using:

```$ ./girt-add file.txt ...```

which stores the files inside a `.girt` sub-directory.
