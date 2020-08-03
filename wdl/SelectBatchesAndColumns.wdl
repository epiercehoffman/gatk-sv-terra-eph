version 1.0

task SelectBatchesAndColumns {
	input {
		File sample_sets_table_tsv
		Array[String]? batches_opt
		Array[String] columns
		String? docker
	}
	
	Boolean select_batches=defined(batches_opt)
	Array[String] batches=select_first([batches_opt, ["all"]])

	String docker_set = select_first([docker, "ubuntu:18.04"])

	runtime {
		docker: docker_set
	}

	command <<<
		set -euo pipefail
		1>&2 echo "Selecting columns from sample sets table"
		FILE=~{sample_sets_table_tsv}
		COLNUMS_COMMAS=""
		COMMA=""

		# get column numbers of specified columns and create comma-separated string for cut
		for COL in '~{sep="' '" columns}'; do
			1>&2 echo "Column: $COL"
			colnum=$(head -1 $FILE | awk -v RS='\t' -v field="$COL" '$0~field{print NR; exit}')
			COLNUMS_COMMAS+="${COMMA}${colnum}"
			COMMA=","
		done
		1>&2 echo "Column numbers=$COLNUMS_COMMAS"

		# if batches specified, select rows containing given batches in 1st column then select specified columns
		# otherwise, select specified columns from all rows
		for BATCH in '~{sep="' '" batches}'; do
			1>&2 echo "Batch: $BATCH"
			~{if select_batches then "1>&2 echo 'Selecting batches from sample sets table'; awk -v FS='\t' -v bat=$BATCH '$1 == bat' $FILE | cut -f $COLNUMS_COMMAS" else "cut -f $COLNUMS_COMMAS $FILE"} \
				>> selected.tsv
		done
		
	>>>

	output {
		# return transposed tsv such that each row is all the files for a given column of the sample set table
		Array[Array[File]] columns_as_rows = transpose(read_tsv("selected.tsv"))
	}
}
