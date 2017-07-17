# /usr/bin/env bash

current_dir=`pwd`
OUTPUT_WORKFLOW=$current_dir"/workflow_olive"

mkdir $current_dir

TEMPLATES="../Templates/transcriptome_assembly_Illumina.txt,../Templates/transcriptome_assembly_454_single.txt,../Templates/transcriptome_mix_assembly_454_single_Illumina.txt,../Templates/transcriptome_reference_Illumina_plants.txt,../Templates/transcriptome_validation_454_single_Illumina.txt"
vars=`echo "
\\$ill_type=paired,
\\$kmers=[25;35],
\\$key_organisms=P.trichocarpa_A.thaliana,
\\$FLN_DATABASE=plants,
\\$single_illumina=$current_dir/../assembly_reads/FILE,
\\$read_illumina_pair_1=$current_dir/../assembly_reads/pollen_picual_1.fastq.gz,
\\$read_illumina_pair_2=$current_dir/../assembly_reads/pollen_picual_2.fastq.gz,
\\$read_454=$current_dir/../assembly_reads/RL1_polen_maduro_raw.fastq,
\\$reference=$current_dir/../transcriptome_references/fasta_files,
\\$reads=$current_dir/../transcriptome_references/read_files,
\\$BUSCO_db_path=$current_dir/../BUSCO_DB/embryophyta_odb9,
\\$report_template=$current_dir/../Templates/assembly_report.erb
" | tr -d [:space:]`

if [ $1 == '1' ]; then
	AutoFlow -w $TEMPLATES  -o $OUTPUT_WORKFLOW -c 1 -t 160:00:00 -V $vars
fi

if [ $1 == '2' ]; then
	flow_logger -e $OUTPUT_WORKFLOW -r all $2
fi
