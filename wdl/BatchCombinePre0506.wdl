version 1.0

import "SelectBatchesAndColumns.wdl" as select

workflow BatchCombinePre0506 {
	input {
		File sample_sets_table_tsv
		Array[String]? batches
		String? docker
	}
	Array[String] columns=["trained_genotype_depth_depth_sepcutoff","regenotyped_depth_vcfs", "merged_bincov", "merged_PE","median_cov","ped_file_postOutlierExclusion", "genotyped_pesr_vcf", "sr_background_fail","sr_bothside_pass","cutoffs"]

	scatter (column in columns) {
		call select.SelectBatchesAndColumns as SelectBatchesAndColumns {
			input:
				sample_sets_table_tsv=sample_sets_table_tsv,
				column=column,
				batches_opt=batches,
				docker=docker
		}
	}
	

	output {
		Array[String]? batches_combined_pre_0506 = batches
		Array[File] trained_genotype_depth_depth_sepcutoff=SelectBatchesAndColumns.column_as_row[0]
		Array[File] regenotyped_depth_vcfs=SelectBatchesAndColumns.column_as_row[1]
		Array[File] merged_bincov=SelectBatchesAndColumns.column_as_row[2]
		Array[File] merged_PE=SelectBatchesAndColumns.column_as_row[3]
		Array[File] median_cov=SelectBatchesAndColumns.column_as_row[4]
		Array[File] ped_file_postOutlierExclusion=SelectBatchesAndColumns.column_as_row[5]
		Array[File] genotyped_pesr_vcf=SelectBatchesAndColumns.column_as_row[6]
		Array[File] sr_background_fail=SelectBatchesAndColumns.column_as_row[7]
		Array[File] sr_bothside_pass=SelectBatchesAndColumns.column_as_row[8]
		Array[File] cutoffs=SelectBatchesAndColumns.column_as_row[9]
	}
	
}
