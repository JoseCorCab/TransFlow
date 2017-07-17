# Installation

In order to use TransFlow you must:
 *   1. Clone this repository
        `git clone `
 *   2. Install ruby. We recommend to use the RVM manager:  [RVM](https://rvm.io/)
 *   3. Install AutoFlow
        `gem install autoflow`
 *   4. Install html reporting
        `gem install report_html`
 *   5. If you are interested in to use the assembly modules (1, 2, 3), you must install:
	 *  1 Read cleaner SeqTrim Next
	        `gem install seqtrimnext`
	 *  2 Illumina assemblers and related tools (module 1)
        	* [Ray](http://denovoassembler.sourceforge.net/)
	        * [Oases](https://github.com/dzerbino/oases)
        	* [SOAPdenovo Trans](https://sourceforge.net/projects/soapdenovotrans/files/SOAPdenovo-Trans/)
	        * [Minimus2](https://sourceforge.net/projects/amos/files/amos/3.1.0/)
	        * [cd-hit](http://weizhongli-lab.org/cd-hit/)        
	 *  3 454/Roche assemblers (module 2)
	        * [MIRA4](https://sourceforge.net/projects/mira-assembler/)
        	* [Euler-SR](http://cseweb.ucsd.edu/~ppevzner/software.html)
	        * [CAP3](http://seq.cs.iastate.edu/cap3.html)        
	 *  4 Merging/combination assemblers (module 3)
	        * [Ray](http://denovoassembler.sourceforge.net/)        
        	* [Minimus2](https://sourceforge.net/projects/amos/files/amos/3.1.0/)
	        * [cd-hit](http://weizhongli-lab.org/cd-hit/)  
	        * [MIRA4](https://sourceforge.net/projects/mira-assembler/)
 *   6. The reference and validation modules need:
	 *   1. Install Full-Lengther next
        	`gem install full_lengther_next`
	 *   2. Install [BUSCO](http://busco.ezlab.org/) and download the lineage files to BUSCO_DB/ folder
 *   7. Make PATH accesible all the installed software
 *   8. Make PATH accesible the folder scripts

# Usage

## Configuration
There is an editable batch file to perform custom executions (the folder samples has sh files used with the paper data) called launch_TransFlow.sh. You can edit the following variables:
```
 TEMPLATES: modules of TransFlow that will be used.
 reference: folder with the fasta files of the chosen transcriptome references.
 reads: folder with the fastq files that will be mapped against the transcriptome references
 read_454: path to the 454/Roche reads that must be used in the assembly process
 ill_type: describe whether the Illumina reads are paired or single
 read_illumina_pair_1 - read_illumina_pair_2 / singl\_illumina: path to Illumina paired/single files, respectively
 BUSCO_DB: specific lineage for using in the BUSCO analysis
 FLN_DB: database to use in Full-Lengther Next executions
 kmers: k-mers used by the assemblers. Must be specified as "[kmer1;kmer2;kmer3;..;kmerN]" 
 key_organisms: identifiers in the assembly summary table for using as reference transcriptomes. Must be specified as "ref1_ref2_ref3_.._refN" 
 ```
 These variable are preconfigured an you only have to put the files on transcriptome_references and assembly_reads. Then, you have to change the upcase placefolders in launch_TransFlow.sh by your file's names. if you want, you can change this variables to full paths at your convenience.
 When you change the reference files and their respective read files you must edit the reference template (in Templates folder) in order to consign the used fasta file, which ID muts have the reference and which read files must be used in the analysis process.
 The fasta file is specified  in the following way:
 ```
 reference_arab){
        ln -s $reference/Athaliana_167_TAIR10.transcript all_sequences.fasta
        ?
        echo -e "A.thaliana\tref_p\tref_t\tref_k\tref_t" > tracker
}
 ```
**Athaliana_167_TAIR10.transcript** is the fasta file used as reference and **A.thaliana** is the ID that we want when this transcriptome is listed in the results. If you add a new reference, be careful to change the task name  **reference_arab)** to a uniq name as **reference_new_trascriptome)**. To set the read files you must chage this code:
```
FLN_metric_Arab){
    #resources: -s -u 3 -n cal -c 48 -t '7-00:00:00' -m '20gb'
    ln -s reference_arab)/tracker
    ?
    full_lengther_next -s 10.243 -f reference_arab)/all_sequences.fasta -a 's' -z  -g $FLN_DATABASE -c 500 -q 'd' -w [lcpu] -M '$reads/arab_ill_1.fastq,$reads/arab_ill_2.fastq'
```
In this case, yo must change the file names **arab_ill_1.fastq** and **arab_ill_2.fastq** to the paired files that you want to use. 

## Execution
There are two values that can be used with launch_TransFlow.sh. When is executed
` ./launch_TransFlow.sh 1` the whole workflow is launched. If is executed `./launch_TransFlow.sh 2`, a control log is shown and the user can inspect the workflow progress.

## Add new assemblers
# Citation


