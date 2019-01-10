# Package: Interproscan

**About**: Protein sequence analysis & classification.

**Version**: 5.32

**Added**: 2016-03-25

**Updated**: 2019-01-09

**Installation directory**: /bioinfo/bin

**Source directory**: /bioinfo/installs/interproscan-5.32-71.0

**Link**: [InterProScan](https://github.com/ebi-pf-team/interproscan/wiki)

## interproscan

### Interproscan configuration

Interproscan uses a configuration file to set the number of CPUs for a job. The default system configuration file is at
`/bioinfo/installs/interproscan-5.32-71.0/interproscan.properties` and is set to use 8 CPUs. Therefore, a default
interproscan condor job should request 8 CPUs (and 8G of RAM).

To control the number of CPUs used by your job you can create your own configuration file:

```bash
cd ~
mkdir .interproscan-5
cp /bioinfo/installs/interproscan-5.32-71.0/interproscan.properties .interproscan-5/
```

Edit the configuration file with your preferred text editor and change one or both of the following settings:

```
worker.number.of.embedded.workers=1
worker.maxnumber.of.embedded.workers=7
```

In the above example 1 + 7 = 8 CPUs will be used. See the 
[interproscan documentation](https://github.com/ebi-pf-team/interproscan/wiki/ImprovingPerformance#how-to-configure-cpu-usage---example-cases) 
for more details. Generally increasing the `worker.maxnumber.of.embedded.workers` should be sufficient to increase the
number of sequences analyzed in parallel.

### Example interproscan HTCondor job file

```
universe                 = vanilla
getenv                   = true

request_cpus             = 8
request_memory           = 8G

notification             = Complete

ID                       = $(Cluster).$(Process)
output                   = interpro.$(ID).out
error                    = interpro.$(ID).err
log                      = interpro.$(ID).log
###################

executable               = /bioinfo/bin/interproscan
arguments                = -i input.fasta -b output_prefix

############################

queue
```
