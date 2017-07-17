# /usr/bin/env bash

current_dir=`pwd`
OUTPUT_WORKFLOW=$current_dir"/workflow_plant_references"

mkdir $current_dir


TEMPLATES="../Templates/transcriptome_reference_Illumina_SIX_plants.txt,../Templates/transcriptome_validation_454_single_Illumina_ONLY_BUSCO.txt"
vars=`echo "
\\$ill_type=paired,
\\$kmers=[25;35],
\\$key_organisms='',
\\$FLN_DATABASE=plants,
\\$reference=$current_dir/../transcriptome_references/fasta_files,
\\$reads=$current_dir/../transcriptome_references/read_files,
\\$BUSCO_db_path=$current_dir/../BUSCO_DB/embryophyta_odb9,
\\$report_template=$current_dir/../Templates/assembly_report.erb
" | tr -d [:space:]`

if [ $1 == '1' ]; then
	AutoFlow -w $TEMPLATES  -o $OUTPUT_WORKFLOW -c 1 -t 160:00:00 -V $vars -s
fi

if [ $1 == '2' ]; then
	flow_logger -e $OUTPUT_WORKFLOW -r all $2
fi
