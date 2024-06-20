process merge_fq {
    label "cat"
    publishDir "${params.out_dir}/reads", mode : "copy"

    input:
    tuple val(sample), path(fasta), val(barcode)

    output:
    tuple path("${sample}.fq.gz"), path("${fasta.baseName}.fq.gz")

    script:
    """
    cat ${params.in_dir}/${barcode}/* > "${sample}.fq.gz"
    if [ ! -f ${fasta} ]; then
        cat ${fasta}/* > ${fasta.baseName}.fq.gz
    else
        mv ${fasta} ${fasta.baseName}.fq.gz
    fi
    """
}