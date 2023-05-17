// vim: set filetype=groovy:
process APPLYBQSR {
    tag "${name}"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/${name}/deduplicated_aligned", mode: 'copy'

    input:
    tuple val(name), path(dedup_bam)
    path ref
    path model

    output:
    tuple val(name), path('*_dedup_bqsr.bam') , emit: dedup_bqsr_bam

    script:
    """
    gatk ApplyBQSR -I ${dedup_bam} -R ${ref} --bqsr-recal-file {$model} -O ${name}_sorted_dedup_bqsr_reads.bam 
    """
}
