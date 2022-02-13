#!/usr/bin/env nextflow

params.inputspectra = 'data/GNPS00002_A3_p.mzML'

_spectra_ch = Channel.fromPath( params.inputspectra )

TOOL_FOLDER = "$baseDir/bin"
params.publishdir = "nf_output"

process convertAll {
    publishDir "$baseDir/nf_output", mode: "copy"
    stageInMode 'copy'

    echo false
    cache true

    container 'chambm/pwiz-skyline-i-agree-to-the-vendor-licenses'

    input:
    file convertable_file from _spectra_ch

    output:
    file "converted/*mzML"

    script:
    """
    echo $convertable_file
    mkdir converted
    wine msconvert --mzML --32 -filter --zlib "peakPicking true" $convertable_file --outfile ${convertable_file}.mzML --outdir converted
    """
}