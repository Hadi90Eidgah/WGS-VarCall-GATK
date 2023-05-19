// vim: set filetype=groovy:
process SELECT_VARIANTS {
    tag "Extracting variants from  VCF"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/__SNPs_and_INDELS__", mode: 'copy'

    input:
    path ref
    path raw_variants
    path fasta_index
    path dict


    output:
    path ('*SNPs.vcf'),   emit:SNPs
    path ('*INDELs.vcf'), emit:INDELs  

    script:
    """
    gatk SelectVariants -R ${ref} -V ${raw_variants} --select-type SNP -O raw_SNPs.vcf
    gatk SelectVariants -R ${ref} -V ${raw_variants} --select-type INDEL -O raw_INDELs.vcf
    """
}
