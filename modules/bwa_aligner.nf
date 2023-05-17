// vim: set filetype=groovy:
process BWA_ALIGNER {
    tag "${name}"
    cpus 3
    memory '9 GB'
    publishDir "${params.outdir}/${name}/ALIGNED_bwa", mode: 'copy'


    input:
    path ref
    path index
    tuple val(name), path(read1), path(read2)


    output:
    path "*.sam",emit: ppair_aligned

    script:
    """
    bwa mem -t 3 -R "@RG\\tID:${name}\\tPL:ILLUMINA\\tSM:${name}" ${ref} ${read1} ${read2} > ${name}_paired.sam
    """
}
