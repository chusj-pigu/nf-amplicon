process count_matrix {
    label "deeptools"
    publishDir "${params.out_dir}/reports", mode : "copy"

    input:
    tuple val(fasta), path(bam), path(bai)

    output:
    tuple path("${fasta}_readCounts.npz"), path("${fasta}_readCounts.tab")

    script:
    """
    multiBamSummary bins --binSize 50 -b $bam --minMappingQuality 30 -out ${fasta}_readCounts.npz --outRawCounts ${fasta}_readCounts.tab
    """
}

process clean_countmx {
    publishDir "${params.out_dir}/reports", mode : "copy"

    input:
    path tab

    output:
    path "readCounts_summary.xlsx"

    script:
    """
    Rscript ${projectDir}/subworkflows/countmx_amplicon/clean_countmx.R
    """
}