# DIRT workflows

Credit to Molly Wohl for all the DIRT commands/custom code!

The [NextFlow](https://www.nextflow.io/) workflows here are built to run
[DIRT](https://github.com/Computational-Plant-Science/DIRT) on the Danforth Center Bioinformatics
[HTCondor](https://research.cs.wisc.edu/htcondor/) cluster, although they could be used elsewhere with a
little tweaking.

## Prerequisites

If you are using the Danforth Center cluster then there is nothing you need to do because we have already set up
everything you need. If you are using a different system you will need:

* [NextFlow](https://www.nextflow.io/)
* [Singularity](https://www.sylabs.io/)
* A clone or download of this GitHub repository

If you are trying to use this on a different system you will need to modify the `nextflow.config` file to use the job
[execution system](https://www.nextflow.io/docs/latest/executor.html) of your choosing. The scripts `dirt` and
`dirt_threshold` are shell wrappers for running `singularity` commands. As is they need to be in your `PATH` and they
need to be updated with the locations of the `singularity` images on your system, or converted to pull the containers
from [Singularity Hub](https://singularity-hub.org/).

## Running the workflows

### Running DIRT on a set of images

The main DIRT program is run using the `dirt.nf` workflow. From your job scheduler server (`six` in our case) run:

```bash
nextflow run danforthcenter/bioinformatics/workflows/dirt.nf \
--images '/home/username/images/*.jpg' \
--tmpdir /home/username/dirt_outputs --outdir /home/username/collated_results
```

Some notes here:
* If you use a glob (e.g. *.jpg) to specify multiple images you have to enclose the path in quotes so
that the glob is passed to nextflow to interpret instead of being interpreted by your shell.
* Because DIRT is run inside a `singularity` container it is best to use fully-qualified paths for the three
arguments shown above.
* images, tmpdir, and outdir are the three required parameters. Each image will be processed in parallel. tmpdir
will be the location of the standard DIRT outputs. outdir will collect and aggregate the overall outputs (tmpdir
could be deleted after the run if desired).

The full list of options the workflow supports are:

```
Bioinformatics DIRT workflow
--images          Input images. Has to be in the form of '/home/username/*.jpg'. Must be in quotes. Required
--tmpdir          DIRT working directory (fully-qualified path, must not exist). Required
--outdir          Collated output directory (fully-qualified path). Required
--threshold       Multiplier for the automatically determined mask threshold. 1.0 works fine and is default. If
                  flashlight is used, the 0.6 is a good choice (default: 1.0)
--marker          Marker diameter. A simple decimal e.g. 25.4. If 0.0 is used, then the output will have pixels as
                  unit (default: 0.0)
--excised         Excised root analysis is on, 0 - excised root analysis is off (default: 1)
--crown           Crown root analysis is on, 0 - crown root analysis is off (default: 1)
--segmentation    Segmentation is on, 0 - segmentation is off (default: 1)
--stem            Stem reconstruction is on, 0 - stem reconstruction is off (default: 0)
--plot            Plotting data is on, 0 - plotting data is not stored (default: 0)
--outfmt          Output format. The full trait set is put into one excel file containing empty cells for traits that
                  were not computed, 0 - only computed files are written to the output file (default: 0)
--traits          Full path to .csv file containing the traits to be computed (default: /opt/DIRT/traits.csv)
--help            Print this menu and exit.
```

### Finding an optimal threshold value on a subset of images

This accessory program uses the DIRT thresholding feature to try a range of threshold multiplier values.
The workflow is run using the `dirt_test_thresholds.nf` workflow. From your job scheduler server (`six` in our case)
run:

```bash
nextflow run danforthcenter/bioinformatics/workflows/dirt_test_thresholds.nf \
--images '/home/username/images/*.jpg' \
--outdir /home/username/threshold_test \
--thresholds 1,5,10,15,20
```

Some notes here:
* If you use a glob (e.g. *.jpg) to specify multiple images you have to enclose the path in quotes so
that the glob is passed to nextflow to interpret instead of being interpreted by your shell.
* Because DIRT is run inside a `singularity` container it is best to use fully-qualified paths for the arguments
shown above.
* images and outdir are the two required parameters. Each image will be processed in parallel. outdir will collect and
aggregate the overall outputs.

The full list of options the workflow supports are:

```
Bioinformatics DIRT threshold-testing workflow
--images          Input images. Has to be in the form of '/home/username/*.jpg'. Must be in quotes. Required
--outdir          Collated output directory (fully-qualified path). Required
--thresholds      A comma-separated list of threshold multipliers to test (default: 1,5,10,15,20)
--help            Print this menu and exit.
```
