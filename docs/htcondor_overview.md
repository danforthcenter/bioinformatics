# HTCondor @ Danforth Center User's Guide

This document is a user's guide for using HTCondor on the Danforth
Center Bioinformatics cluster. The guide will be updated as guidelines
are developed, and questions/problems arise.

HTCondor is a workload management system. It handles job batching and
queuing, resource matching, usage accounting, and more. The
documentation is extensive, read more
[here](https://research.cs.wisc.edu/htcondor/).

## Basic infrastructure concepts

* **Central manager server**. This server is the central brain of HTCondor. It is the interface between job scheduling machines and job execution machines. Users do not interact with this server (`basestar` in our case) directly.
* **Scheduler server**. This server submits jobs to the HTCondor system. Multiple servers can run the job scheduling service. Currently the Danforth Center infrastructure runs the scheduler on `six`.
* **Execution server**. These are the servers where jobs are run. Jobs submitted from apollo are analyzed by the central manager (`basestar`) to determine which execution servers can support the job (based on resource requests), whether or not resources are free currently, and what the job priority (rank in the queue) is.
* **Job priority**. HTCondor uses a fair share model to assign jobs a priority. This means jobs are executed in an order that preserves resource allocation shares as much as possible (as opposed to a first-come, first-serve model).
* **Slots**. HTCondor matches jobs to resource "slots." For the Bioinformatics cluster, each server is configured as a single resources slot (all the CPUs and RAM in one slot). Each slot is configured to be partitionable, so a job requesting less than 100% of all the resources in a slot will cause the slot to be divided so that the remaining resources can be matched to another job.
* **Universe**. HTCondor provides different "universes" for executing jobs. Each universe has different properties. For now we will primarily use the vanilla universe, although the parallel universe will probably also be useful.
  * Vanilla: Essentially the same as running any basic program with one or more processors.
  * Java: Java applications have to be run in this special environment.
  * Parallel: The parallel universe runs jobs that use MPI. Our cluster is not configured to run parallel universe jobs because machines need to be dedicated to this job type. You can still run MPI jobs on single server slots through the vanilla universe.
* **Accounting group**. The system usage activity of each user is logged but accounting is done at the group level. This is managed using the `CONDOR_GROUP` environmental variable. If this value is not set for you, please let the Bioinformatics core facility know. If you belong to more than one group, make sure your active group is set to the group you want to log the activity for.
