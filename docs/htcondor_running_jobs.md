# HTCondor - Running Jobs

## Submitting jobs to HTCondor

Instead of typing your command into the command line, you need to write
a job description file to submit the job to HTCondor. The basic job
description file is fairly simple. Imagine you want to run a simple job
that will use a single CPU, your job description file would look
something like this:

```
####################
#
# Example Vanilla Universe Job
# Simple HTCondor submit description file
#
####################

universe         = vanilla
getenv           = true
executable       = /shares/bioinfo/bin/samtools
arguments        = view -b -o alignment.bam alignment.sam
log              = sam2bam.log
output           = sam2bam.out
error            = sam2bam.error

##  Do not edit  ##
accounting_group = $ENV(CONDOR_GROUP)
###################

queue
```

Universe sets which universe to execute your job in, default is vanilla.
Executable is the full path to the program you want to run. Getenv
(true/false) sets whether or not HTCondor should import your shell
environment settings into the job before submitting to the queue.
Alternatively, you can customize the shell environment on a per job
basis by setting getenv to false and using the environment configuration
option instead. Arguments are all the remaining options you would
normally put on the command line after the executable. Log, output and
error are the names (if desired) of an HTCondor log file and the job
standard output and error. Accounting group is a code to keep track of
your cluster usage based on your group (lab) membership. Queue is a
keyword for HTCondor that tells it to submit the code above to the
queue. This example job will request the default slot size (1 CPU, 4 MB
RAM, 3 KB disk space).

To submit your job to the queue:

`condor_submit jobfile`

If you need to submit a job that uses multiple CPUs or other significant
resources, add these requests to the job description file. In the
example below, the job file requests 30 CPUs in addition to the default
memory and disk request sizes.

```
####################
#
# Example Vanilla Universe Job
# Multi-CPU HTCondor submit description file
#
####################

universe         = vanilla
getenv           = true
executable       = /shares/bioinfo/bin/bowtie2
arguments        = -f --no-unal --threads 30 -x reference.fasta -U reads.fasta -S alignment.sam
log              = bowtie2.alignment.log
output           = bowtie2.alignment.out
error            = bowtie2.alignment.error
request_cpus     = 30

##  Do not edit  ##
accounting_group = $ENV(CONDOR_GROUP)
###################

queue
```

Besides the job information, the only difference here is that we have
requested a 30 CPU slot for this job. Note that it is important the the
request_cpus value matches any CPU request options in the submitted job.
After the job starts and the HTCondor monitoring system refreshes we can
now see this activity with `condor_status`:

```
Name               OpSys      Arch   State     Activity LoadAv Mem     ActvtyTime

slot1@aerilon.ddps LINUX      X86_64 Unclaimed Idle      0.000 257641  0+00:19:50
slot1_1@aerilon.dd LINUX      X86_64 Claimed   Busy     25.830  128  0+00:03:47
slot1@pegasus.ddps LINUX      X86_64 Unclaimed Idle      0.000 257769  0+00:14:55
                     Machines Owner Claimed Unclaimed Matched Preempting

        X86_64/LINUX        3     0       1         2       0          0

               Total        3     0       1         2       0          0
```

Note that a partition, slot1_1 was split from slot1 (aerilon) and that
the load average (~26) is approximately equal to the 30 CPUs we
requested. This job took ~11 minutes (wall time) and checked out 30
CPUs, so 11 * 30 / 60 = 5.5 CPU hours. Viewed with
`condor_userprio -usage`:

```
Last Priority Update:  3/3  23:36
Group                     Res   Total Usage       Usage             Last
  User Name              In Use (wghted-hrs)    Start Time       Usage Time
------------------------ ------ ------------ ---------------- ----------------
group_jcarrington             0         5.53  3/03/2016 23:00  3/03/2016 23:26
  nfahlgren@ddpsc.org         0         5.53  3/03/2016 23:00  3/03/2016 23:26
------------------------ ------ ------------ ---------------- ----------------
Number of users: 1            0         5.53                   3/02/2016 23:37
```

To view a history of jobs you have submitted use
`condor_history <username>`.

## Other job configuration options

* `notification = <Always | Complete | Error | Never>`
  * Default = Never
* `notify_user =  <email-address>`
  * Default = `<username>@danforthcenter.org`
* `request_memory = <quantity><units>`
  * Quantity is the numeric amount of memory your job will maximally use
  * Units can optionally be appended to quantity. The default units are M/MB (megabytes). Other units are K/KB (kilobytes), G/GB (gigabytes), or T/TB (terabytes). Example: `request_memory = 1G`
* `request_disk   = <quantity><units>`
  * The same syntax as request_memory
  * The Danforth Center system uses an NFS shared filesystem, so requesting disk may not generally be necessary. Requesting disk is recommended if you are configuring jobs to use scratch space (see below).

## Interactive jobs

In general, most jobs should be submitted using job files, but in cases
where an interactive session is needed (for testing for example), shell
sessions can be requested from the HTCondor queue. Interactive sessions
are similar to logging into a server with ssh except that they will
automatically log out after 2 hours of inactivity and once disconnected
will terminate any running jobs, including `screen` and `tmux` sessions.

```
condor_submit -interactive accounting_group=$CONDOR_GROUP getenv=true request_cpus=1 request_memory=1G
```

The CPU and memory (RAM) can be adjusted accordingly. Furthermore, any
additional HTCondor job parameters can be supplied to the command.

## Job control

If you need to remove a job from the queue, find the job ID with condor_q:

```
-- Schedd: six.ddpsc.org : <10.5.1.63:15151?...
ID      OWNER            SUBMITTED     RUN_TIME ST PRI SIZE CMD
30.0   nfahlgren       3/3  22:43   0+00:00:02 R  0   3.2  samtools view -b -

1 jobs; 0 completed, 0 removed, 0 idle, 1 running, 0 held, 0 suspended
```

Then remove the job:

`condor_rm 30`

This will remove all jobs under the ID 30, including jobs submitted from
the same job file (e.g. 30.0, 30.1, etc.). If you need to remove a
specific job, use the float value instead.

Or remove all jobs associated with your username:

`condor_rm <username>`

## Running a condor job that uses the scratch space

This can be useful for IO-constrained jobs or jobs that behave poorly on
NFS (e.g. HISAT2). Because the Danforth Center system uses NFS, transfer
of files is not done by default. To active the transfer of input files,
output files, or both, additional job file configuration is needed:

```
####################
#
# Example Vanilla Universe Job :: Using SCRATCH space
# ** Executable is NOT copied over **
# Multi-CPU HTCondor submit description file
#
####################

universe         = vanilla
getenv           = true
executable       = /shares/bioinfo/bin/hisat2
arguments        = -q -x genome.fa -U singleEnd.fastq -S output.sam --rna-strandness R -p 20
log              = hisat2.groupID.log
output           = hisat2.groupID.out
error            = hisat2.groupID.error
request_cpus     = 20
transfer_executable = False
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
transfer_input_files = <path to singleEnd.fastq if not in current dir>
# HTCondor will copy any input files listed here (comma-separated)
# HTCondor will transfer all output files since none are listed specifically

##  Do not edit  ##
accounting_group = $ENV(CONDOR_GROUP)
###################

queue
```

## Running multiple jobs with a single job file

The example below will run four cufflinks jobs, substituting the value
of `group` in every time `queue` is called.

```
####################
#
# Example Vanilla Universe Job :: 
# This launches multiple jobs, using the 'group' variable info to find 
# and create the required files [this example would queue up 4 jobs]
# Multi-CPU HTCondor submit description file
#
####################

universe         = vanilla
getenv           = true
executable       = /shares/bioinfo/bin/cufflinks
arguments        = -o output/$(group) --GTF-guide file.gtf -p 15 --library-type fr-firststrand -u -L $(group) $(group)_RNAseq.bam
log              = $(group).cufflinks.log
output           = $(group).cufflinks.out
error            = $(group).cufflinks.error
request_cpus     = 15

##  Do not edit  ##
accounting_group = $ENV(CONDOR_GROUP)
###################

group = controls_1
queue 1

group = controls_2
queue 1

group = controls_3
queue 1

group = controls_4
queue 1
```

## Submitting jobs to the java universe

If you are running a java application you must specify `universe = java`
instead of `universe = vanilla` in your job file. Additionally, java
universe jobs have a special configuration setting
`jar_files = <path to jar file>/name.jar`. You must also keep the
`executable = <path to executable>` option set, because it is required,
but it is not used by java universe jobs. 
