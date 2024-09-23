
include { merge_amplicon } from './modules/ingress'
include { mapping_amplicon } from './modules/minimap'
include { sam_sort } from './modules/samtools'
include { multiBamSummary } from './modules/deeptools'
include { clean_countmx } from './modules/rscripts'
include { mosdepth } from './modules/mosdepth'
include { multiqc } from './modules/multiqc'

workflow { 
    samples=Channel.fromPath(params.csv)
        .splitCsv(header: true)
        .map { row -> 
            tuple(row.sample, row.fasta, row.barcode)
        }
    merge_amplicon(samples)

    mapping_amplicon(merge_amplicon.out)
    sam_sort(mapping_amplicon.out)

    multi_bam_ch = sam_sort.out
        .map { bam, bai -> 
            def parts = bam.simpleName.split('-')    // splits the file name without its extension to get sample_id and ref name isolated from the file name
            def key = parts[-2..-1].join('-')          // only keep the ref name as key
            tuple(key, bam, bai)                    // create a new tuple with this key 
        }
        .groupTuple(by:0)                       // Group bam files by reference used
    
    multiBamSummary(multi_bam_ch)
    ctmx=multiBamSummary.out
        .collect()
    clean_countmx(ctmx)

    mosdepth(sam_sort.out)

    multi_ch = Channel.empty()
        .mix(mosdepth.out)
        .collect()
    multiqc(multi_ch)
}