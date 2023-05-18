// vim: set filetype=groovy:
process BASE_RECAB_GATK {
    tag "Generating recalibration table for Base Quality Score Recalibration (BQSR)"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/${name}/BQSR_model_generated", mode: 'copy'

    input:
    path(dedup_bam)
    path ref
    path fasta_index
    path dict
    path sites
    path sites_tbi

    output:
    path('*.table') , emit: model

    script:
    """
    gatk BaseRecalibrator -I ${dedup_bam} -R ${ref} --known-sites ${sites} -O ${dedup_bam.baseName}_recal_data.table
    """
}
