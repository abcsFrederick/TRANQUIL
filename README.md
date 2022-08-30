## Background

TRANQUIL or "TRna AbundaNce QUantification pIpeLine" is a Snakemake pipeline which quantifies tRNA using the [mim-tRNAseq](https://github.com/nedialkova-lab/mim-tRNAseq) tool. 

**mim-tRNAseq** is dockerized using [this](https://github.com/CCBR/Dockers/tree/master/misc/mimseq) recipe. The docker is pushed to [dockerhub](https://hub.docker.com/repository/docker/nciccbr/mimseq_v1.4) for general consumption.

> The pipeline is developed with the intention of executing it on [Biowulf](https://hpc.nih.gov/) or [FRCE](https://ncifrederick.cancer.gov/staff/frce/welcome) clusters. Hence, may have some Biowulf/FRCE specific hardcoding.


## Running on FRCE

Pipeline code has been checked out at `/mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL` and is available for all users of FRCE. 

```bash
$ /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/tranquil
#################################################################
#################################################################
Pipeline Dir: 		 /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL
Snakefile: 		 /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/workflow/Snakefile
Git Commit/Tag: 	 678ccfc1f3c0013690c2d09100619b9a5b7259ee
Host: 			 FRCE
#################################################################
#################################################################
Running /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/tranquil ...
TRANQUIL (TRna AbundaNce QUantification pIpeLine)
#################################################################
#################################################################
USAGE:
  bash /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/tranquil -m/--runmode=<RUNMODE> -w/--workdir=<WORKDIR>
Required Arguments:
1.  RUNMODE: [Type: String] Valid options:
    *) init : initialize workdir
    *) run : run with slurm
    *) reset : DELETE workdir dir and re-init it
    *) dryrun : dry run snakemake to generate DAG
    *) unlock : unlock workdir if locked by snakemake
    *) runlocal : run without submitting to sbatch
2.  WORKDIR: [Type: String]: Absolute or relative path to the
             output folder with write permissions.
#################################################################
#################################################################
```
In order to run the pipeline, there are 3 steps:

  1. Initialize: Use the `init` mode to setup the output folder:

```bash
$ /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/tranquil
#################################################################
#################################################################
Pipeline Dir: 		 /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL
Snakefile: 		 /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/workflow/Snakefile
Git Commit/Tag: 	 678ccfc1f3c0013690c2d09100619b9a5b7259ee
Host: 			 FRCE
#################################################################
#################################################################
Running /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/tranquil ...
TRANQUIL (TRna AbundaNce QUantification pIpeLine)
#################################################################
#################################################################
USAGE:
  bash /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/tranquil -m/--runmode=<RUNMODE> -w/--workdir=<WORKDIR>
Required Arguments:
1.  RUNMODE: [Type: String] Valid options:
    *) init : initialize workdir
    *) run : run with slurm
    *) reset : DELETE workdir dir and re-init it
    *) dryrun : dry run snakemake to generate DAG
    *) unlock : unlock workdir if locked by snakemake
    *) runlocal : run without submitting to sbatch
2.  WORKDIR: [Type: String]: Absolute or relative path to the
             output folder with write permissions.
#################################################################
#################################################################
```

  2. Enter Sample Manifest: Now edit the `samples.tsv` and `contrasts.tsv` in the output folder to reflect the names/locations of the sample input files and the desired contrasts.

  `samples.tsv` has the following tab-delimited columns:
   
    - sampleName
    - replicateNumber	
    - path_to_R1_fastq
  
  `contrasts.tsv` has the following tab-delimited columns:

    - group1
    - group2

The group1 w.r.t. group2 contrast is run.
  
  > NOTE: By default the `samples.tsv` and `contrasts.tsv` will be pointing to the test dataset in the `.tests` folder.

  3. Dry-run (and Run): The following command will run the dry-run and generate a `dryrun.log` in the output folder
   
```bash
$ /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/tranquil -w=/scratch/cluster_scratch/$USER/TRANQUIL_test -m=dry
```

Once everything looks ok, the job can be run on the cluster by switching the **mode** from `dry` to `run`, like so:

```bash
$ /mnt/projects/CCBR-Pipelines/pipelines/TRANQUIL/tranquil -w=/scratch/cluster_scratch/$USER/TRANQUIL_test -m=run
```

## Outputs:

- The output folder has a `results` subfolder which has a `fastqs` subfolder with

  - trimmed fastqs prepared for mim-tRNAseq
  - `readstats.txt` tab-delimited file with trimming statistics

- The `results` folder also contains one subfolder for each of the contrasts in the `contrasts.tsv` with the naming convention of "`<group1>_vs<group2>`". This folder has the mim-tRNAseq outputs.



> Please send any comments/suggestions/requests to [Vishal Koparde](https://github.com/kopardev) via [email](mailto:vishal.koparde@nih.gov).