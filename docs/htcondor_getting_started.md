# HTCondor - Getting Started

## Accessing HTCondor

Currently all HTCondor transactions can be done from `six`.
For work that needs to be done outside of the queue
(e.g. software development/debugging, small file operations, etc.),
please use the `six` server or request an interactive session (see [HTCondor - Running Jobs](htcondor_running_jobs.md)).

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

`condor_userprio` shows a limited amount of history by default. If you want to summarize your user and group usage over a longer period, use `condor_userprio -usage -activefrom <month> <day> <year>`.
