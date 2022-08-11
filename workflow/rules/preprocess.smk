rule trim:
    input:
        infq = join(WORKDIR,"fastqs","{replicate}.R1.fastq.gz")
    output:
        outfq = join(RESULTSDIR,"fastqs","{replicate}.trim.R1.fastq.gz")
    envmodules:
        TOOLS["cutadapt"]["version"]
    container: 
        TOOLS["cutadapt"]["docker"]    
    threads: getthreads("trim")
    params: 
        memg = getmemg("trim"),
        memG = getmemG("trim"),
        workdir = WORKDIR,
        repname = "{replicate}",
        illumina_sequencing_adapter = config["illumina_sequencing_adapter"],
        linker = config["linker"],
        minlen = config["minlen"],
        n5trim = config["n5trim"],
        nextseq_trim_q = config["nextseq_trim_q"],
        read_stats_script = join(SCRIPTSDIR,"_cutadapt_log_get_read_stats.sh")
    shell:"""
set -e -x -o pipefail
# set tmpdir
if [ -w "/lscratch/${{SLURM_JOB_ID}}" ];then 
    # if running on BIOWULF
    tmpdir="/lscratch/${{SLURM_JOB_ID}}"
    cleanup=0
elif [ -w "/scratch/cluster_scratch/${{USER}}" ];then
    # if running on FRCE
    tmp="/scratch/cluster_scratch/${{USER}}"
    tmpdir=$(mktemp -d -p $tmp)
    cleanup=1
else
    # Catchall for "other" HPCs
    tmpdir=$(mktemp -d -p /dev/shm)
    cleanup=1
fi

outdir=$(dirname {output.outfq})
cd $tmpdir
echo "{params.repname} : Trimming illumina sequencing adapter"
cutadapt -j {threads} \\
    -b {params.illumina_sequencing_adapter} -m {params.minlen} \\
    -o {params.repname}.trim_seq_adapter.fastq.gz \\
    {input.infq} | tee ${{outdir}}/{params.repname}.log1
echo "{params.repname} : Trimming linker"
cutadapt -j {threads} \\
    -b {params.linker} -m {params.minlen} \\
    -o {params.repname}.trim_seq_adapter.trim_linker.fastq.gz \\
    {params.repname}.trim_seq_adapter.fastq.gz | tee ${{outdir}}/{params.repname}.log2
echo "{params.repname} : 5-prime Trimming"
cutadapt -j {threads} \\
    -u {params.n5trim} -m {params.minlen} \\
    -o {params.repname}.trim_seq_adapter.trim_linker.trim_5prime.fastq.gz \\
    {params.repname}.trim_seq_adapter.trim_linker.fastq.gz | tee ${{outdir}}/{params.repname}.log3
echo "{params.repname} : NextSeq Trimming"
cutadapt -j {threads} \\
    --nextseq-trim={params.nextseq_trim_q} -m {params.minlen} \\
    -o {output.outfq} \\
    {params.repname}.trim_seq_adapter.trim_linker.trim_5prime.fastq.gz | tee ${{outdir}}/{params.repname}.log4

echo -ne "{params.repname}" > ${{outdir}}/{params.repname}.stats
for i in `seq 1 4`;do
    stats=$(bash {params.read_stats_script} ${{outdir}}/{params.repname}.log${{i}})
    echo -ne " $stats" >> ${{outdir}}/{params.repname}.stats
done
echo -ne "\n" >> ${{outdir}}/{params.repname}.stats

# cleanup tmpdir
if [ "$cleanup" == "1" ];then
    cd {params.workdir}
    rm -rf $tmpdir
fi
"""