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

params.ref_fasta = params.genomes[ params.genome ]?.ref_fasta
params.sites     = params.genomes[ params.genome ]?.sites
params.refrences = params.genomes[ params.genome ]?.refrences

include { FASTQC } from './modules/fastqc'
include { BWA_INDEX } from './modules/bwa_index'
include { BWA_ALIGNER } from './modules/bwa_aligner'
include { DEDUP_GATK } from './modules/dedup_gatk'
include { BASE_RECAB_GATK } from './modules/base_recab_gatk'

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

ref = file(params.ref_fasta)
known_sites = file(params.sites)
refrences = file(params.refrences)

FASTQC(reads)
BWA_INDEX(ref)
BWA_ALIGNER (ref,BWA_INDEX.out.index,reads)
DEDUP_GATK(BWA_ALIGNER.out.ppair_aligned)
//BASE_RECAB_GATK()
}
