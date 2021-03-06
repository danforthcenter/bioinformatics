# Package: SRA-Tools

**About**: Short Read Archive data retrieval and format conversion tools.

**Version**: 2.8.2-5

**Added**: 2016-01-19

**Updated**: 2018-01-08

**Installation directory**: /bioinfo/bin

**Source directory**: /bioinfo/installs/ncbi/sra-tools

**Link**: [SRA-Tools](http://ncbi.github.io/sra-tools/)

## fastq-dump

### Example fastq-dump HTCondor job file

- requests resources (CPUs, RAM, scratch)
- downloads .sra file from the SRA and writes .fastq.gz outputs to scratch (faster than writing to NFS)
- all output file(s) are automatically transferred to working directory at end of job

```     
###############################################################################################
## Housekeeping
###############################################################################################

universe                 = vanilla
getenv                   = true

request_cpus             = $(cpu_req)
request_memory           = $(memory_req)
request_disk             = $(disk_req)

notification             = Complete

condor_output            = /path/to/condor/output/dir

ID                       = $(Cluster).$(Process)
output                   = $(condor_output)/$(run_type).$(ID).out
error                    = $(condor_output)/$(run_type).$(ID).err
log                      = $(condor_output)/$(run_type).$(ID).log



###############################################################################################
## Executable & arguments
###############################################################################################

executable               = /bioinfo/bin/fastq-dump
arguments                = -I --split-files --gzip $(SRA_record)

transfer_executable      = False
should_transfer_files    = YES
when_to_transfer_output  = ON_EXIT



###############################################################################################
## Need to edit info here: Variables
###############################################################################################
run_type                 = fastqdump
SRA_record               = [SRA record ID i.e. SRR390728]
cpu_req                  = [Number of processors i.e. 1]
memory_req               = [RAM request i.e. 1G]
disk_req                 = [scratch disk size request 3G]


queue
```
