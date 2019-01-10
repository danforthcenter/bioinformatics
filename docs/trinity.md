# Package: Trinity

**About**: De novo transcriptome assembly.

**Version**: 2.1.1

**Added**: 2015-10-28

**Updated**: 2015-10-28

**Installation directory**: /bioinfo/installs/trinity

**Source directory**: /bioinfo/installs/trinity

**Link**: [Trinity](https://github.com/trinityrnaseq/trinityrnaseq/wiki)

## trinity

### Example Trinity HTCondor job file

* requests resources (CPUs, RAM, scratch)
* transfers pair1 and pair2 into scratch
* creates a trinity-working-directory (in scratch)
* only the final Trinity.fasta output file is transferred back to the original directory

```
universe                 = vanilla
getenv                   = true

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

executable               = /bioinfo/installs/trinity/Trinity
arguments                = --seqType fq --CPU $(cpu_req) --max_memory $(memory_req) --output $(output_name)/ --SS_lib_type RF --left left.fastq.gz --right right.fastq.gz


transfer_executable      = False
should_transfer_files    = YES
transfer_input_files     = /full/path/to/left.fastq.gz,/full/path/to/right.fastq.gz

when_to_transfer_output  = ON_EXIT
transfer_output_files    = $(output_name)/Trinity.fasta

## Need to edit info here ##
run_type                 = Trinity
output_name              = trinity_$(sampleID)
sampleID                 = [sample ID]

cpu_req                  = [Number of processors]
memory_req               = [RAM request i.e. 20G]
disk_req                 = [scratch disk size request 3G]
############################

queue
```
