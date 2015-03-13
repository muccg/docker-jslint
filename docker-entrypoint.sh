#!/bin/bash

echo "HOME is ${HOME}"
echo "WHOAMI is `whoami`"

# find every JS file in every dir passed as an argument to container
for i in $*; do
    for i in $i/*.js; do
        JSFILES="$JSFILES $i"
    done
done

echo "Linting: $JSFILES"

failed=""

echo "** gjslint **"
for JS in $JSFILES; do
    if ! gjslint --disable 0131 --nojsdoc --max_line_length 160 $JS; then
        failed="`basename $JS` $failed"
    fi
done

echo "** closure compiler **"
tmpjs="/tmp/output.js"
for JS in $JSFILES; do
    if ! java -jar /usr/local/closure/compiler.jar --js "$JS" --js_output_file "$tmpjs" --warning_level DEFAULT --summary_detail_level 3; then
        failed="`basename $JS` $failed"
    fi
done
rm -f "$tmpjs"

if [ x"$failed" != "x" ]; then
    echo
    echo "lint failed, files failing are:"
    echo "  $failed"
    exit 1
fi

