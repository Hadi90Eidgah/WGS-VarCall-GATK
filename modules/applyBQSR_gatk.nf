// vim: set filetype=groovy:
process APPLYBQSR {
    tag "Applies the adjustments calculated by the Base Quality Score Recalibration (BQSR)"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/applied_BQSR", mode: 'copy'

    input:
    path(dedup_bam)
    path ref
    path model
    path fasta_index
    path dict

    output:
    path('*.bam') , emit: dedup_bqsr_bam

    script:
    """
    gatk ApplyBQSR -I ${dedup_bam} -R ${ref} --bqsr-recal-file ${model} -O ${dedup_bam.baseName}_sorted_bqsr_reads.bam 
    """
}
