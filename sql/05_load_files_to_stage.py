import os
from snowflake.snowpark import Session
import sys
import logging
from my_globals import spark_conn_params

# Initiate Loggong at INFO level
logging.basicConfig(stream=sys.stdout, level=logging.WARNING, format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%I:%M:%S')

def get_snowpark_session() -> Session:
    return Session.builder.configs(spark_conn_params).create()

def traverse_dir(directory, file_extension) -> list:
    local_file_path = []
    file_list = []
    partition_dir = []
    print(directory)
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(file_extension):
                file_path = os.path.join(root, file)
                file_list.append(file)
                partition_dir.append(root.replace(directory, ''))
                local_file_path.append(file_path)
    return file_list, [ x.replace('\\', '/') for x in partition_dir ], local_file_path

def main():
    # Specify the directory path to traverse
    directory_path = 'data'
    csv_file_name, csv_partition_dir , csv_local_file_path= traverse_dir(directory_path,'.csv')
    parquet_file_name, parquet_partition_dir , parquet_local_file_path= traverse_dir(directory_path,'.parquet')
    json_file_name, json_partition_dir , json_local_file_path= traverse_dir(directory_path,'.json')
    stage_location = '@sales_db.source.int_stage'

    
    csv_index = 0
    for file_element in csv_file_name:
        put_result = ( 
                    get_snowpark_session().file.put( 
                        csv_local_file_path[csv_index], 
                        stage_location+"/"+csv_partition_dir[csv_index], 
                        auto_compress=False, overwrite=True, parallel=10)
                    )
        # put_result(file_element," => ",put_result[0].status)
        logging.warning(put_result)
        # raise Exception('Stop')
        csv_index+=1

    parquet_index = 0
    for file_element in parquet_file_name:

        put_result = ( 
                    get_snowpark_session().file.put( 
                        parquet_local_file_path[parquet_index], 
                        stage_location+"/"+parquet_partition_dir[parquet_index], 
                        auto_compress=False, overwrite=True, parallel=10)
                    )
        #put_result(file_element," => ",put_result[0].status)
        logging.warning(put_result)
        parquet_index+=1
    
    json_index = 0
    for file_element in json_file_name:

        put_result = ( 
                    get_snowpark_session().file.put( 
                        json_local_file_path[json_index], 
                        stage_location+"/"+json_partition_dir[json_index], 
                        auto_compress=False, overwrite=True, parallel=10)
                    )
        #put_result(file_element," => ",put_result[0].status)
        logging.warning(put_result)
        json_index+=1  

if __name__ == '__main__':
    main()