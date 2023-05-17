// vim: set filetype=groovy:
process FASTQC {
    tag "${name}"
    cpus 2
    memory '4 GB'
    publishDir "${params.outdir}/${name}/fastqc", mode: 'copy'

    input:
    tuple val(name), path(read1), path(read2)

    output:
    tuple val(name), path("*_fastqc.{zip,html}"), emit: fastqc_out

    script:
    """
    fastqc -q ${read1} ${read2}
    """
}
