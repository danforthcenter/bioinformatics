#!/usr/bin/env nextflow

// Command-line arguments
params.images = './*.jpg'
params.outdir = './dirt_output'
params.threshold = 1.0
params.marker = 0.0
params.excised = 1
params.crown = 1
params.segmentation = 1
params.stem = 0
params.plot = 0
params.outfmt = 0
params.traits = '/opt/DIRT/traits.csv'
params.help = false

log.info("Bioinformatics DIRT workflow")
log.info("--images          Input images. Has to be in the form of './*.jpg'. Must be in quotes (default: './*.jpg')")
log.info("--outdir          Output directory (default: ./dirt_output)")
log.info("--threshold       Multiplier for the automatically determined mask threshold. 1.0 works fine and is default. If flashlight is used, the 0.6 is a good choice (default: 1.0)")
log.info("--marker          Marker diameter. A simple decimal e.g. 25.4. If 0.0 is used, then the output will have pixels as unit (default: 0.0)")
log.info("--excised         Excised root analysis is on, 0 - excised root analysis is off (default: 1)")
log.info("--crown           Crown root analysis is on, 0 - crown root analysis is off (default: 1)")
log.info("--segmentation    Segmentation is on, 0 - segmentation is off (default: 1)")
log.info("--stem            Stem reconstruction is on, 0 - stem reconstruction is off (default: 0)")
log.info("--plot            Plotting data is on, 0 - plotting data is not stored (default: 0)")
log.info("--outfmt          Output format. The full trait set is put into one excel file containing empty cells for traits that were not computed, 0 - only computed files are written to the output file (default: 0)")
log.info("--traits          Full path to .csv file containing the traits to be computed (default: ${params.traits})")
log.info("--help            Print this menu and exit.")
if (params.help) exit 1

// The --images parameter is used to find input images
input_files = Channel.fromPath(params.images)

// Create the output directory
outdir = file(params.outdir)
outdir.mkdirs()

process dirt {
    validExitStatus = 0,1,2,143

    input:
    each image from input_files

    script:
    name = file(image).name
    output_dir = params.outdir + "/" + name
    dir = file(output_dir)
    dir.mkdirs()
    "/shares/bioinfo/bin/dirt $image 1 ${params.threshold} ${params.excised} ${params.crown} ${params.segmentation} ${params.marker} ${params.stem} ${params.plot} ${params.outfmt} ${output_dir} ${params.traits}"
}
