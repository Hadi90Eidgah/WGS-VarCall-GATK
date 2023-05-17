// vim: set filetype=groovy:
process BWA_INDEX {
    cpus 3
    memory '8 GB'
    publishDir "${params.refrences}", mode: 'copy'

    input:
    path ref

    output:
    path('hg38.fa*') , emit: index
    script:
    """
    echo 'Refrence Indexing by BWA is underway'
    bwa index ${ref}
    """
}
