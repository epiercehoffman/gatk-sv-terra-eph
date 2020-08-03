version 1.0

import "SelectBatchesAndColumns.wdl" as select

workflow BatchCombinePreMerge {
	input {
		File sample_sets_table_tsv
		Array[String]? batches
		String? docker
	}
	Array[String] columns=["filtered_depth_vcf","filtered_pesr_vcf"]
	

	call select.SelectBatchesAndColumns as SelectBatchesAndColumns {
		input:
			sample_sets_table_tsv=sample_sets_table_tsv,
			columns=columns,
			batches_opt=batches,
			docker=docker
	}

	output {
		Array[File] filtered_depth_vcf=SelectBatchesAndColumns.columns_as_rows[0]
		Array[File] filtered_pesr_vcf=SelectBatchesAndColumns.columns_as_rows[1]
		Array[String]? batches_combined_pre_merge = batches
	}
	
}


