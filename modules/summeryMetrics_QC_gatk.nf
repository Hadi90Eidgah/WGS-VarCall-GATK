// vim: set filetype=groovy:
process SUMMERY_METRICS {
    tag "Evaluating the overall quality of alignments"
    cpus 4
    memory '12 GB'
    publishDir "${params.outdir}/SummeryMetrics", mode: 'copy'

    input:
    path ref
    path dedup_bqsr_bam

    output:
    path ('*Metrics.txt'), emit:Metrics
    path ('*InsertSize.txt'), emit:InsertSize
    path ('*histogram.pdf'),  emit:histogram

    script:
    """
    gatk CollectAlignmentSummaryMetrics R=${ref} I=${dedup_bqsr_bam} O= ${dedup_bqsr_bam.baseName}_Metrics.txt 
    gatk CollectInsertSizeMetrics INPUT=${dedup_bqsr_bam} OUTPUT= ${dedup_bqsr_bam.baseName}_InsertSize.txt \
    HISTOGRAM_FILE= ${dedup_bqsr_bam.baseName}_InsertSize_histogram.pdf
    """
}
