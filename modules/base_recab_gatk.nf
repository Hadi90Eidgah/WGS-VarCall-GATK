// vim: set filetype=groovy:
process BASE_RECAB_GATK {
    tag "Generating recalibration table for Base Quality Score Recalibration (BQSR)"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/${name}/BQSR_model_generated", mode: 'copy'

    input:
    tuple val(name), path(dedup_bam)
    path ref
    path sites

    output:
    path('*.table') , emit: model

    script:
    """
    gatk BaseRecalibrator -I ${dedup_bam} -R ${ref} --known-sites ${sites} -O recal_data.table
    """
}
