#!/usr/bin/env nextflow

// Enable DSL2
nextflow.enable.dsl = 2
/*
  ----------------------------------------------------------------------------
                       Main Nextflow script:
*/

log.info """\
    WHOLE GENOME SEQUENCING
    The pipeline is designed for WGS Variant Calling with GATK
    ================================================================
    Genome assembly: ${params.genome}
    reads          : ${params.input}
    outdir         : ${params.outdir}
    """
    .stripIndent()

params.ref = params.genomes[ params.genome ]?.ref
params.sites     = params.genomes[ params.genome ]?.sites
params.sites_tbi = params.genomes[ params.genome ]?.sites_tbi
params.refrences = params.genomes[ params.genome ]?.refrences
params.fasta_index =params.genomes[ params.genome ]?.fasta_index
params.dict      =params.genomes[ params.genome ]?.dict


include { FASTQC } from './modules/fastqc'
include { BWA_INDEX } from './modules/bwa_index'
include { BWA_ALIGNER } from './modules/bwa_aligner'
include { DEDUP_GATK } from './modules/dedup_gatk'
include { BASE_RECAB_GATK } from './modules/base_recab_gatk'
include { APPLYBQSR } from './modules/applyBQSR_gatk'
include { SUMMERY_METRICS } from './modules/summeryMetrics_QC_gatk'
include { HAPLOTYPECALLER } from './modules/Variant_Call_gatk'

workflow{
    //ch_samplesheet = file(params.input, checkIfExists: true)
    reads = Channel
        .fromPath(params.input)  //CSV header: name,fastq[,fastq2],strandness
        .splitCsv(header: true)
        .tap { ch_samplesheet } //
        .map { sample ->
             [ sample.name, file(sample.fastq), file(sample.fastq2) ]
         }
        .groupTuple()


    //store samplesheet metadata in a hash table
    samplesheet = [:]
    ch_samplesheet.subscribe { sample ->
        samplesheet.put(
            sample.name,
            [
                'name': sample.name,
                'strandness': sample.strandness
            ]
        )
    }

ref = file(params.ref)
known_sites = file(params.sites)
sites_tbi   = file(params.sites_tbi)
fasta_index = file(params.fasta_index)
dict =  file(params.dict)

FASTQC(reads)
BWA_INDEX(ref)
BWA_ALIGNER (ref,BWA_INDEX.out.index,reads)
DEDUP_GATK(BWA_ALIGNER.out.ppair_aligned)
BASE_RECAB_GATK(DEDUP_GATK.out.dedup_bam,ref,fasta_index,dict,known_sites,sites_tbi)
APPLYBQSR(DEDUP_GATK.out.dedup_bam,ref,BASE_RECAB_GATK.out.model,fasta_index,dict)
SUMMERY_METRICS(ref,APPLYBQSR.out.dedup_bqsr_bam)
HAPLOTYPECALLER(ref,APPLYBQSR.out.dedup_bqsr_bam,fasta_index,dict)
}
