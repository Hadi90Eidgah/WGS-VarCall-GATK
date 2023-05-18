// vim: set filetype=groovy:
process DEDUP_GATK {
    tag "Identifying and marking duplicate reads"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/${name}/deduplicated_aligned", mode: 'copy'

    input:
    path(aligned_sam)

    output:
    path('*_dedup.bam') , emit: dedup_bam
    path('*bai') , emit: bai
    path('*sbi') , emit: sbi

    script:
    """
    gatk MarkDuplicatesSpark -I ${aligned_sam} -O ${aligned_sam.baseName}_dedup.bam --conf 'spark.executor.cores=4'
    """
}

