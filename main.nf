
include { merge_fq } from './subworkflows/merge_fastq'
include { mapping } from './subworkflows/mapping_amplicon'
include { sam_sort } from './subworkflows/sort_bam'
include { count_matrix } from './subworkflows/countmx_amplicon'
include { clean_countmx } from './subworkflows/countmx_amplicon'
include { mosdepth } from './subworkflows/mosdepth'
include { multiqc } from './subworkflows/multiqc'

workflow { 
    samples=Channel.fromPath(params.csv)
        .splitCsv(header: true)
        .map { row -> 
            tuple(row.sample, row.fasta, row.barcode)
        }
    merge_fq(samples)

    mapping(merge_fq.out)
    sam_sort(mapping.out)

    multi_bam_ch = sam_sort.out
        .map { bam, bai -> 
            def parts = bam.simpleName.split('-')    // splits the file name without its extension to get sample_id and ref name isolated from the file name
            def key = parts[-2..-1].join('-')          // only keep the ref name as key
            tuple(key, bam, bai)                    // create a new tuple with this key 
        }
        .groupTuple(by:0)                       // Group bam files by reference used
    
    count_matrix(multi_bam_ch)
    ctmx=count_matrix.out
        .collect()
    clean_countmx(ctmx)

    mosdepth(sam_sort.out)

    multi_ch = Channel.empty()
        .mix(mosdepth.out)
        .collect()
    multiqc(multi_ch)
}