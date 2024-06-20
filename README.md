# Amplicon analysis

This workflow provides mapped bam, count matrix and multiqc report from amplicon sequences.

You can run this workflow on the login node with `nextflow run /project/ctb-noncodo/Platform/templates/nextflow/nf-amplicon --csv SAMPLESHEET --in_dir INPUT DIRECTORY` with nextflow, apptainer and r modules loaded.

## Input

You must provide at least two inputs for this workflow:

    1. A samplesheet CSV file with three columns : first one is the sample ID, second is the path to the directory containing reference files or path to the reference file, and third is the nanopore barcode associated with the sample. Example:

    ``` bash
    sample,fasta,barcode
    sample1,FASTA-1,barcode01
    sample2,FASTA-1,barcode02
    ```

    2. Directory where the fastq reads are located. They must be under `barcodeXX` subdirectory.

You can also provide an output directory with `--out-dir`.

## Workflow overview

    1. Concatenate fastq reads for each barcode in `reads/barcodeXX` and reference fasta files if they are not already concatenated. Each concatenated sample fastq files will be located in `reads` and named according to sample_id. Concatenated reference fastq will be located in `refs` and named according to subdirectory `FASTA` name.
    2. Align samples to reference with minimap2.
    3. Convert sam to bam, sort and index.
    4. Make a tab file per reference containing coverage of each sample with `multiBamSummary` from deeptools. Arrange the table to have an excel file with a separated sheet per reference.
    5. Make coverage summaries and reports using mosdepth and multiqc. 
