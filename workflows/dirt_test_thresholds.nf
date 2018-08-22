#!/usr/bin/env nextflow

// Command-line arguments
params.images = ''
params.outdir = ''
params.thresholds = '1,5,10,15,20'
params.help = false

log.info("Bioinformatics DIRT threshold-testing workflow")
log.info("--images          Input images. Has to be in the form of '/home/username/*.jpg'. Must be in quotes. Required")
log.info("--outdir          Collated output directory (fully-qualified path). Required")
log.info("--thresholds      A comma-separated list of threshold multipliers to test (default: 1,5,10,15,20)")
log.info("--help            Print this menu and exit.")
if (params.help) exit 1

// The --images parameter is used to find input images
input_files = Channel.fromPath(params.images).ifEmpty{
    // Exit if no images are found
    println("Error: no input files found in ${params.images}!")
    exit 1
}

// Create the output directory
outdir = file(params.outdir)
// It is okay if this directory already exists
outdir.mkdirs()

// Process: dirt_threshold_tester
process dirt_threshold_tester {
    publishDir $params.outdir
    input:
    file image from input_files

    output:
    file *.png

    script:
    """
    python thresholdTester.py
    """
}
