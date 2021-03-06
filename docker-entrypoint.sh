#!/bin/bash

# find every JS file in every dir passed as an argument to container
for i in $*; do
    JSFILES="$JSFILES "$(find "$i" -name "*.js")
done

failed=""

echo "** gjslint **"
for JS in $JSFILES; do
    if ! gjslint --disable "0131,0110" --nojsdoc --max_line_length 160 $JS; then
        failed="`basename $JS` $failed"
    fi
done

echo "** closure compiler **"
tmpjs="/tmp/output.js"
for JS in $JSFILES; do
    if ! java -jar /usr/local/closure/compiler.jar --js "$JS" --js_output_file "$tmpjs" --warning_level DEFAULT --summary_detail_level 3 --language_in ECMASCRIPT5; then
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

