# Package: Variation Graph

**About**: Tools for working with variation graphs.

**Version**: Latest

**Docker Image**: erictdawson/vg_d

**Link**: [VG](https://github.com/vgteam/vg)

## vg

### Example vg HTCondor job file

- runs vg via the docker universe

```
################################
# Example vg docker universe Job
################################

log                     = $(Cluster).$(Process).condor.vg.log
error                   = $(Cluster).$(Process).condor.vg.error
request_cpus            = 1
request_memory          = 1G

# Use the docker universe and specify the docker image (from Docker Hub by default)
universe                = docker
docker_image            = erictdawson/vg_d

# The executable is inside the container
executable              = vg
arguments               = construct -r refseq.fa -v sample.vcf

# We need to transfer files to use Docker
should_transfer_files   = YES
when_to_transfer_output = ON_EXIT
transfer_input_files    = refseq.fa,sample.vcf
output                  = output.vg

queue
```
