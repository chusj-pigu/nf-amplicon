# Amplicon analysis

This workflow provides mapped bam, count matrix and [multiqc] report from amplicon sequences.

You can run this workflow on the login node with `nextflow run chusj-pigu/nf-amplicon --csv SAMPLESHEET --in_dir INPUT DIRECTORY --ref_dir REFERENCE DIRECTORY` with [Nextflow], [Docker] or [Apptainer], and [R] installed.

To run on Compute Canada Narval, use `-profile drac`. You can also run it on the test data using `-profile test` or `-profile test_drac` for testing on compute canada.

## Input

You must provide at least three inputs for this workflow:

1. A samplesheet CSV file with three columns : first one is the sample ID, second is the subdirectory name containing the reference fasta files (or fasta file name without its extension), and third is the nanopore barcode associated with the sample. Example:

    ``` bash
    sample,fasta,barcode
    sample1,FASTA-1,barcode01
    sample2,FASTA-1,barcode02
    ```

2. Absolute path to where the fastq reads are located. They must be under `barcodeXX` subdirectory.
3. Absolute path to where the reference files are located.

You can also provide an output directory with `--out-dir`.

## Workflow overview

1. Concatenate fastq reads for each barcode in `reads/barcodeXX` and reference fasta files if they are not already concatenated. Each concatenated sample fastq files will be located in `reads` and named according to sample_id. Concatenated reference fastq will be located in `refs` and named according to subdirectory `FASTA` name.
2. Align samples to reference with [minimap2].
3. Convert sam to bam, sort and index with [samtools].
4. Make a tab file per reference containing coverage of each sample with `multiBamSummary` from [deepTools]. Arrange the table to have an excel file with a separated sheet per reference.
5. Make coverage summaries and reports using [mosdepth] and [multiqc].

[Docker]: https://www.docker.com
[Apptainer]: https://apptainer.org
[Nextflow]: https://www.nextflow.io/docs/latest/index.html
[R]: https://www.r-project.org/
[minimap2]: https://lh3.github.io/minimap2/minimap2.html
[samtools]: http://www.htslib.org
[deepTools]: https://deeptools.readthedocs.io/en/latest/
[multiqc]: https://multiqc.info
[mosdepth]: https://github.com/brentp/mosdepth
