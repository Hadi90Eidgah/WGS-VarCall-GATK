// vim: set filetype=groovy:
process DEDUP_GATK {
    tag "${name}"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/${name}/deduplicated_aligned", mode: 'copy'

    input:
    tuple val(name), path(aligned_sam)

    output:
    tuple val(name), path('*_dedup.bam') , emit: dedup_bam

    script:
    """
    gatk MarkDuplicateSpark -I ${sam} -O ${name}_dedup.bam --conf 'spark.executor.cores=4'
    """
}

