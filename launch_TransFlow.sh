# /usr/bin/env bash

current_dir=`pwd`
OUTPUT_WORKFLOW=$current_dir"/workflow"

mkdir $current_dir

TEMPLATES="Templates/transcriptome_assembly_Illumina.txt,Templates/transcriptome_reference_Illumina_plants.txt,Templates/transcriptome_validation_454_single_Illumina.txt"
vars=`echo "
\\$ill_type=paired/single,
\\$kmers=[K1;K2],
\\$key_organisms=ID1_ID2,
\\$FLN_DATABASE=GROUP,
\\$single_illumina=$current_dir/assembly_reads/FILE,
\\$read_illumina_pair_1=$current_dir/assembly_reads/FILE_1,
\\$read_illumina_pair_2=$current_dir/assembly_reads/FILE_2,
\\$read_454=$current_dir/assembly_reads/FILE_454,
\\$reference=$current_dir/transcriptome_references/fasta_files,
\\$reads=$current_dir/transcriptome_references/read_files,
\\$BUSCO_db_path=$current_dir/BUSCO_DB/LINEAGE,
\\$report_template=$current_dir/Templates/assembly_report.erb
" | tr -d [:space:]`

if [ $1 == '1' ]; then
	AutoFlow -w $TEMPLATES  -o $OUTPUT_WORKFLOW -c 1 -t 1:00:00 -s -V $vars
fi

if [ $1 == '2' ]; then
	flow_logger -e $OUTPUT_WORKFLOW -r all
fi

if [ $1 == 'r' ]; then
        echo "Relaunching failed jobs"
        flow_logger -e $OUTPUT_WORKFLOW -w -l
fi

