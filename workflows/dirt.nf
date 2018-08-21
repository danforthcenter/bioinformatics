#!/usr/bin/env nextflow

// Command-line arguments
params.images = ''
params.tmpdir = ''
params.outdir = ''
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
log.info("--images          Input images. Has to be in the form of '/home/username/*.jpg'. Must be in quotes. Required")
log.info("--tmpdir          DIRT working directory (fully-qualified path, must not exist). Required")
log.info("--outdir          Collated output directory (fully-qualified path). Required")
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
input_files = Channel.fromPath(params.images).ifEmpty{
    // Exit if no images are found
    println("Error: no input files found in ${params.images}!")
    exit 1
}

// Create the working directory
tmpdir = file(params.tmpdir)
if (tmpdir.exists()) {
    println("Error: the output directory ${params.tmpdir} already exists!")
    exit 1
}
tmpdir.mkdirs()

// Create the output directory
outdir = file(params.outdir)
// It is okay if this directory already exists
outdir.mkdirs()
// Create the AllCrowns output directory
crown_dir = params.outdir + "/AllCrowns"
crowns = file(crown_dir)
if (params.crown == 1) {
    crowns.mkdirs()
}
// Create the AllExcised output directory
lateral_dir = params.outdir + "/AllExcised"
lateral = file(lateral_dir)
if (params.excised == 1) {
    lateral.mkdirs()
}
// Create the AllSkeletons output directory
skel_dir = params.outdir + "/AllSkeletons"
skel = file(skel_dir)
if (params.stem == 1) {
    skel.mkdirs()
}

// Process: DIRT - runs DIRT in a singularity container
process dirt {
    afterScript """
    #!/bin/bash
    
    # Copy the Crown images if they exist
    if [ -d ${crown_dir} ]; then
        for d in ${params.tmpdir}/* ; do
            for i in `find \$d/1/Crown -maxdepth 1 -name *.png` ; do
                cp \${i} ${crown_dir}
            done
        done
    fi

    # Copy the Lateral images if they exist
    if [ -d ${lateral_dir} ]; then
        for d in ${params.tmpdir}/* ; do
            for i in `find \$d/1/Lateral -maxdepth 1 -name *.png` ; do
                cp \${i} ${lateral_dir}
            done
        done
    fi

    # Copy the Skeleton images if they exist
    if [ -d ${skel_dir} ]; then
        for d in ${params.tmpdir}/* ; do
            for i in `find \$d/1/Crown/Skeleton -maxdepth 1 -name *.png` ; do
                cp \${i} ${skel_dir}
            done
        done
    fi

    # Concatenate all the trait outputs
    awk 'FNR==1 && NR!=1 {while (/^Image/) getline;} 1 {print}' ${params.tmpdir}/*/1/output.csv >> ${params.outdir}/outputAll.csv
    """

    input:
    each image from input_files

    script:
    name = file(image).name
    output_dir = params.tmpdir + "/" + name
    dir = file(output_dir)
    dir.mkdirs()
    "/shares/bioinfo/bin/dirt $image 1 ${params.threshold} ${params.excised} ${params.crown} ${params.segmentation} ${params.marker} ${params.stem} ${params.plot} ${params.outfmt} ${output_dir} ${params.traits}"
}
