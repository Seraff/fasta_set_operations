#!/usr/bin/env bash
# Author: Serafim Nenarokov, 2018

set -e

command=$1
left=$2
right=$3

show_help()
{
    echo 'fasta_set_operations.sh - Set operations for fasta files'
    echo
    echo 'Author: Serafim Nenarokov, 2018 <serafim.nenarokov@gmail.com>'
    echo 'Usage: ./fasta_set_operations.sh command left_file.fasta right_file.fasta'
    echo
    echo 'Commands:'
    echo -e '\tsubtract - return sequenses which exist in left file, but do not exist in right file'
    echo -e '\tintersect - return common sequenses of two files'
    echo -e '\tdifference - return not common sequenses of two files'

}

random_name()
{
    od -x /dev/urandom | head -1 | awk '{OFS=""; print $2$3,$4,$5,$6,$7$8$9}'
}

extract_headers()
{
    grep '>' $1 | sed 's/>//'
}

subtract()
{
    tmp_file=$(random_name)
    extract_headers ${right} > ${tmp_file}
    seqkit grep -n -f ${tmp_file} -v "${left}"
    rm ${tmp_file}
}

intersect()
{
    tmp_file=$(random_name)
    extract_headers ${right} > ${tmp_file}
    seqkit grep -n -f ${tmp_file} "${left}"
    rm ${tmp_file}
}

difference()
{
    left_headers=$(random_name)
    extract_headers ${left} > ${left_headers}

    right_headers=$(random_name)
    extract_headers ${right} > ${right_headers}

    result=$(random_name)
    seqkit grep -n -f ${right_headers} -v "${left}" > ${result}
    seqkit grep -n -f ${left_headers} -v "${right}" >> ${result}
    cat ${result}

    rm ${left_headers} ${right_headers} ${result}
}

if ! command -v seqkit > /dev/null; then
  echo "SeqKit is not installed on your system"
  exit 1
fi

case $command in
    intersect)
    intersect
    ;;

    subtract)
    subtract
    ;;

    difference)
    difference
    ;;

    *)
    show_help
    exit 1
esac
