# contains(string, substring)
#
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

#
# look under two dirs: ./seeker and ./mcp
#
for i in seeker mcp; do
    for state in Succeed Failed; do
        echo $i $state `grep $state $i/regression/REP.LOG | wc -l`
    done
done
# Dive in for: i=mcp state=Failed
count=0
for line in `grep $state $i/regression/REP.LOG`; do
    _dir=$i/regression/$line
    if [ -d $_dir ]; then
        dir=$_dir
        (( count++ ))
        echo $count: $line
        lib=`grep flatten.exe $dir/run | cut -d " " -f 6`
        flag=1
        for dir in $dir seeker/regression/$line; do
            echo RUN $count $dir/run
            msg="> pushd $dir/output"
            flag2=1
            # TODO: grep Helix.exe and cnhxrun to get more cell names.. add to set..
            for cell in `grep cnhxcc $dir/run | cut -d " " -f 6 | cut -d . -f 1`; do
                (( flag++ ))
                if [ $flag -eq 2 ]; then
                    grep -q InputLocation $dir/output/$cell.hxnet
                    if [ $? -ne 0 ]; then
                        ls $dir/output/$cell.hxcs
                    else
                        for line in `grep -A 2 InputLocation $dir/output/$cell.hxnet`; do
                            contains $line OADesign
                            if [ $? -ne 1 ]; then
                                #echo "hxcs in: $line"
                                regexp="OADesign\((\w+/\w+/\w+)\)"
                                [[ $line =~ $regexp ]]
                                path=${BASH_REMATCH[1]}
                                if [ -f $dir/output/libs/$path/constraint.hxcs ]; then
                                    ls $dir/output/libs/$path/constraint.hxcs
                                else
                                    ls $dir/output/$path/constraint.hxcs
                                fi
                            fi
                        done
                    fi
                fi
                if [ $flag2 -eq 1 ]; then
                    echo $msg
                    (( flag2++ ))
                fi
                echo "> pyros -ld $lib/$cell &"
            done
            echo "> popd"
        done
    fi
done
# get lib and cell for the last test:
if [ 0 == 1 ]; then
    cell=`grep cnhxcc $dir/run | cut -d " " -f 6 | cut -d . -f 1`
    lib=`grep flatten.exe $dir/run | cut -d " " -f 6`
    echo "pushd $dir/output"
    echo "pyros -ld $lib/$cell &"
fi

