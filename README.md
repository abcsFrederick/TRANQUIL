TRANQUIL or "TRna AbundaNce QUantification pIpeLine" is a Snakemake pipeline which quantifies tRNA using the [mim-tRNAseq](https://github.com/nedialkova-lab/mim-tRNAseq) tool. 

**mim-tRNAseq** is dockerized using [this](https://github.com/CCBR/Dockers/tree/master/misc/mimseq) recipe. The docker is pushed to [dockerhub](https://hub.docker.com/repository/docker/nciccbr/mimseq_v1.4) for general consumption.

> The pipeline is developed with the intention of executing it on [Biowulf](https://hpc.nih.gov/) or [FRCE](https://ncifrederick.cancer.gov/staff/frce/welcome) clusters. Hence, may have some Biowulf/FRCE specific hardcoding.

> Please send any comments/suggestions/requests to [Vishal Koparde](https://github.com/kopardev) via [email](mailto:vishal.koparde@nih.gov).