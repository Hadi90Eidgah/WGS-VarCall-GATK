// vim: set filetype=groovy:
process HAPLOTYPECALLER {
    tag "Variant discovery analysis HaplotypeCaller"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/_VariantCalling_", mode: 'copy'

    input:
    path ref
    path dedup_bqsr_bam
    path fasta_index
    path dict


    output:
    path ('*.vcf'), emit:raw_variants

    script:
    """
    gatk HaplotypeCaller -R ${ref} -I ${dedup_bqsr_bam} -O raw_variants.vcf
    """
}
