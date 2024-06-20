process mapping {
    publishDir "${params.out_dir}/alignments", mode : "copy"
    label "minimap"

    input:
    tuple path(sample), path(ref)

    output:
    path "${sample.simpleName}-${ref.simpleName}.sam"

    script:
    """
    minimap2 -t $params.threads -ax map-ont $ref $sample > "${sample.simpleName}-${ref.simpleName}.sam"
    """
}