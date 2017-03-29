#HTCondor - Useful commands & troubleshooting

##Getting Help

- The documentation for HTCondor is extensive. Many answers to 
general questions can be easily found by including `HTCondor` 
to your search.
- The Danforth Center Bioinformatics Core has a Slack Channel <https://ddpsc-bioinfo.slack.com/>
	- A (free) account is required to join
	- This is an excellent, in-house resource for asking questions from other scientists doing bioinformatics.

## Basic commands

### View the current status of the Bioinformatics cluster

`condor_status`

In the example output below we can see that there are five servers currently configured to run jobs. Servers that are completely idle appear as one slot. Servers running one or more jobs will show up as divided into multiple slots, one per job and the remaining idle resources.

```
Name               OpSys      Arch   State     Activity LoadAv Mem     ActvtyTime

slot1@aerilon.ddps LINUX      X86_64 Unclaimed Idle      0.000 257769  2+18:30:21
slot1@pallas.ddpsc LINUX      X86_64 Unclaimed Idle      0.000 514276  2+18:46:43
slot1_10@pallas.dd LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:27
slot1_11@pallas.dd LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:27
slot1_1@pallas.ddp LINUX      X86_64 Claimed   Busy     47.330  128  0+02:50:26
slot1_2@pallas.ddp LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:28
slot1_3@pallas.ddp LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:28
slot1_4@pallas.ddp LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:28
slot1_5@pallas.ddp LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:28
slot1_6@pallas.ddp LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:28
slot1_7@pallas.ddp LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:27
slot1_8@pallas.ddp LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:27
slot1_9@pallas.ddp LINUX      X86_64 Claimed   Busy      1.000  128  0+00:10:27
slot1@pegasus.ddps LINUX      X86_64 Unclaimed Idle      1.000 257769  2+18:40:56
slot1@tauron.ddpsc LINUX      X86_64 Unclaimed Idle      1.000 245481  1+19:55:15
slot1_5@tauron.ddp LINUX      X86_64 Claimed   Busy      0.000 12288  1+14:44:40
slot1@thanatos.ddp LINUX      X86_64 Unclaimed Idle      2.000 499558  6+20:46:23
                     Machines Owner Claimed Unclaimed Matched Preempting

        X86_64/LINUX       17     0      12         5       0          0

               Total       17     0      12         5       0          0
```

### Status of the HTCondor queue

`condor_q`

In the example below one job is in the queue and is running. The ST column lists the state of each job: I = Idle, R = Running, X = Removed, > = Transferring input files, < = Transferring output files.

```
-- Schedd: six.ddpsc.org : <10.5.1.63:15151?...
ID      OWNER            SUBMITTED     RUN_TIME ST PRI SIZE CMD
30.0   nfahlgren       3/3  22:43   0+00:00:02 R  0   3.2  samtools view -b -

1 jobs; 0 completed, 0 removed, 0 idle, 1 running, 0 held, 0 suspended
```

`condor_fullstat`

Provides a table of compiled data for jobs currently running from `condor_q` and `condor_status`. Especially useful for monitoring job usage vs requests.

```
   ID  Owner          Host                  CPUs    CPUs (%)    Memory (GB)    Memory (%)    Disk (GB)    Disk (%)  Run Time     Cmd
-----  -------------  ------------------  ------  ----------  -------------  ------------  -----------  ----------  -----------  -------------
39768  clizarraga     pacifica.ddpsc.org       4         0.2            0             0              0         100  28:00:00:41  (interactive)
40655  ebertolini     scorpia.ddpsc.org       40         2.5            2.9           2.9            0         100  19:04:45:43  lncrna.sh
40706  abasaro        tauron.ddpsc.org         1       106             11.9          79.5            0         100  15:19:22:04  varscan
41814  ebertolini     pallas.ddpsc.org        20         0              0             0              0         100  00:05:38:37  (interactive)
41834  abasaro        pacifica.ddpsc.org      10        10              0             0              0         100  00:03:09:26  (interactive)
41853  rparvathaneni  pacifica.ddpsc.org       5        20              0             0              0         100  00:00:06:20  awk.sh
```




### Analyzing jobs that are on Hold or Idle

If upon submitting your job the status listed on `condor_q` is "H" or "I" then your job is not running. There are a number of reasons why this could be and using `condor_q -analyze [jobID]` will give you more details. In the first and third examples, the job was killed (`condor_rm [jobID]`) and the settings adjusted. Some examples include:

* **Missing/error with executable or other input file**
```
[JobID]:  Request is held.
Hold reason: Error from slot1@pallas.ddpsc.org: Failed to execute '/script.pl' with arguments Single_Astral/ Solanum,Olea: (errno=13: 'Permission denied')
```

* **Requested resources currently unavailable** This job was listed as "I" and ended up being the next to run in the queue.
```
[jobID]:  Run analysis summary.  Of 34 machines,
     24 are rejected by your job's requirements
      0 reject your job because of their own requirements
      0 match and are already running your jobs
     10 match but are serving other users
      0 are available to run your job
	No successful match recorded.
	Last failed match: Tue Apr 19 16:28:20 2016
Reason for last match failure: PREEMPTION_REQUIREMENTS == False

The Requirements expression for your job is:
    ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) &&
    ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) &&
    ( TARGET.Cpus >= RequestCpus ) && ( ( TARGET.HasFileTransfer ) ||
      ( TARGET.FileSystemDomain == MY.FileSystemDomain ) )
Suggestions:
    Condition                         Machines Matched    Suggestion
    ---------                         ----------------    ----------
1   ( TARGET.Memory >= 51200 )        15
2   ( TARGET.Cpus >= 10 )             29
3   ( TARGET.Arch == "X86_64" )       34
4   ( TARGET.OpSys == "LINUX" )       34
5   ( TARGET.Disk >= 42 )             34
6   ( ( TARGET.HasFileTransfer ) || ( TARGET.FileSystemDomain == "ddpsc.org" ) )
                                      34
```

* **Requested resources totally unavailable** This job was in "H" due to lack of resources; Condor offered a suggestion so that the job would run
```
[jobID]:  Run analysis summary.  Of 27 machines,
     27 are rejected by your job's requirements
      0 reject your job because of their own requirements
      0 match and are already running your jobs
      0 match but are serving other users
      0 are available to run your job
	No successful match recorded.
	Last failed match: Wed Apr 20 11:29:19 2016
Reason for last match failure: no match found
WARNING:  Be advised:
   No resources matched request's constraints

The Requirements expression for your job is:
    ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) &&
    ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) &&
    ( TARGET.Cpus >= RequestCpus ) && ( TARGET.HasFileTransfer )
Suggestions:
    Condition                         Machines Matched    **Suggestion**
    ---------                         ----------------    ----------
1   ( TARGET.Memory >= 102400 )       0                   **MODIFY TO 54884**
2   ( TARGET.Cpus >= 20 )             5
3   ( TARGET.Arch == "X86_64" )       27
4   ( TARGET.OpSys == "LINUX" )       27
5   ( TARGET.Disk >= 400000 )         27
6   ( TARGET.HasFileTransfer )        27
```


### HTCondor system usage by group/user

`condor_userprio`

In the example below, user nfahlgren from group jcarrington has used 0.02 CPU hours of computing time.

```
Last Priority Update:  3/3  23:00
Group                     Config     Use    Effective   Priority   Res   Total Usage  Time Since Requested
  User Name                Quota   Surplus   Priority    Factor   In Use (wghted-hrs) Last Usage Resources
------------------------ --------- ------- ------------ --------- ------ ------------ ---------- ----------
group_jcarrington             0.30 ByQuota                1000.00      0         0.02      <now>          1
  nfahlgren@ddpsc.org                            500.24   1000.00      0         0.02      <now>
------------------------ --------- ------- ------------ --------- ------ ------------ ---------- ----------
Number of users: 1                 ByQuota                             0         0.02    1+00:00
```

`condor_userprio` shows a limited amount of history by default. 
If you want to summarize your user and group usage over a longer 
period, use `condor_userprio -usage -activefrom <month> <day> <year>`.


## Optimizing resource usage and job performance

Understanding the needs and usage of system resources by a program 
will allow you to optimize your job requests. CPU usage 
is a good example: many programs have a `--threads` or `--CPU` option, but the
actual usage can vary, resulting in over-request by the user and higher
costs. Meanwhile, under-requesting scratch disk or RAM relative to the job's usage can
result in a server becoming overloaded and jobs being killed by the system.

To evaluate the requirements of a job, particularly a job that will be run repeatedly,
a good approach is to run one instance of the job and monitor the resource usage. For
scratch disk and RAM usage, the log file produced by HTCondor gives the information you need. 
At the end of the log file, once the job is complete, you will find the following:

```
	(1) Normal termination (return value 0)
		Usr 0 00:44:19, Sys 0 00:04:07  -  Run Remote Usage
		Usr 0 00:00:00, Sys 0 00:00:00  -  Run Local Usage
		Usr 0 00:44:19, Sys 0 00:04:07  -  Total Remote Usage
		Usr 0 00:00:00, Sys 0 00:00:00  -  Total Local Usage
	3943671552  -  Run Bytes Sent By Job
	639678720  -  Run Bytes Received By Job
	3943671552  -  Total Bytes Sent By Job
	639678720  -  Total Bytes Received By Job
	Partitionable Resources :    Usage  Request Allocated
	   Cpus                 :                 8         8
	   Disk (KB)            :  4475941 10485760  10716960
	   Memory (MB)          :      166      500       500
```

In this example, the job finished with a return value `0` (Normal termination).  
`8 CPUs` were requested (and "used")  
`10 GB of Scratch Disk` were requested and `4.3 GB` were used  
`500 MB of RAM` were requested and `166 MB` were used

- If this job was part of a set, one might want to maximize the number of jobs 
that could simultaneously run. Thus some possible modifications to the job file could be: 
request less Scratch Disk (6GB) and request less RAM (250MB). It's still a good idea to
include a buffer since not all of the jobs will have identical usage.

**CPU Usage**

The log file only reports the number of CPUs requested as this is the usage as far
as the system is concerned - these CPUs get checked out for your request and are thus
unavailable to other users. To determine CPU usage, a within-system tool is `condor_fullstat`
which will report on the actual CPU usage of a program. This could be run frequently over
the course of a job's run, with the user monitoring the actual percentage of CPUs used.

For example:

```
   ID  Owner       Host                  CPUs    CPUs (%)    Memory (GB)    Memory (%)    Disk (GB)    Disk (%)  Run Time     Cmd
-----  ----------  ------------------  ------  ----------  -------------  ------------  -----------  ----------  -----------  ---------
40655  xxxxxxxxxx  scorpia.ddpsc.org       40       2.5            2.9           2.9              0         100  19:21:28:54  job.sh
```

- `Job_40655` has requested 40 CPUs, and has been running for >19 days. 
However, a repeated look at `condor_fullstat` determines that the job only
used 40 CPUs for an early step, and has since been only using 2.5% (or 1 CPU)
for the majority of the job. Thus, if this program were re-run, it may be worth
modifying the CPU request, or modifying the program itself.

- Another approach is searching the internet - many common bioinformatic programs
have papers, blog posts, etc, that report the CPU usage efficiency. `bwa` is a good
example where requests with 8 CPUs do not have 2x improved performance over 4 CPUs.
	- Therefore, if you have i.e. 50 bwa jobs to run, the fastest way to get them done would
	be to request 4-8 CPUs each. This means that more jobs can run simultaneously,
	even if they take a bit longer each, resulting in the batch of jobs being done sooner for 
	you to continue your analyses.
	- [Intel White Paper for GATK Pipeline](http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/deploying-gatk-best-practices-paper.pdf)