# Package: Bowtie2

**About**: Short-read alignment program.

**Version**: 2.2.9

**Added**: 2016-04-21

**Updated**: 2016-04-21

**Installation directory**: /shares/bioinfo/bin

**Source directory**: /shares/bioinfo/installs/bowtie2-2.2.6

**Link**: [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)

## bowtie2

### Example bowtie2 HTCondor job file

- requests resources (CPUs, RAM, scratch)
- transfers pair1 and pair2 into scratch
- all output file(s) are automatically transferred to working directory at end of job

```     
universe                 = vanilla
getenv                   = true

accounting_group         = $ENV(CONDOR_GROUP)
condor_output            = /path/to/condor/output/dir/

request_cpus             = $(cpu_req)
request_memory           = $(memory_req)
request_disk             = $(disk_req)

notification             = Complete

ID                       = $(Cluster).$(Process)
output                   = $(condor_output)$(run_type).$(ID).out
error                    = $(condor_output)$(run_type).$(ID).err
log                      = $(condor_output)$(run_type).$(ID).log
###################

executable               = /shares/bioinfo/bin/bowtie2
arguments                = -q --threads $(cpu_req) -x /path/to/genome.fa -1 pair1.reads.fastq.qz -2 pair2.reads.fastq.gz -S alignment.sam


transfer_executable      = False
should_transfer_files    = YES
when_to_transfer_output  = ON_EXIT
transfer_input_files     = [full/path/to/pair1.reads.fastq.gz,full/path/to/pair2.reads.fastq.gz]


## Need to edit info here ##
run_type                 = bowtie2
cpu_req                  = [Number of processors]
memory_req               = [RAM request i.e. 1G]
disk_req                 = [scratch disk size request 3G]
############################

queue
```
