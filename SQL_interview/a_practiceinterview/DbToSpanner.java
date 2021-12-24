package com.springml.demo;

import com.google.api.services.bigquery.model.TableReference;
import com.google.cloud.spanner.Mutation;
import org.apache.beam.sdk.Pipeline;
import org.apache.beam.sdk.coders.BigEndianIntegerCoder;
import org.apache.beam.sdk.coders.KvCoder;
import org.apache.beam.sdk.coders.ListCoder;
import org.apache.beam.sdk.coders.StringUtf8Coder;
import org.apache.beam.sdk.io.gcp.bigquery.BigQueryIO;
import org.apache.beam.sdk.io.gcp.spanner.SpannerIO;
import org.apache.beam.sdk.options.PipelineOptionsFactory;
import org.apache.beam.sdk.transforms.DoFn;
import org.apache.beam.sdk.transforms.MapElements;
import org.apache.beam.sdk.transforms.ParDo;
import org.apache.beam.sdk.values.KV;
import org.apache.beam.sdk.values.PCollection;
import org.apache.beam.sdk.values.TypeDescriptor;
import org.apache.beam.sdk.io.jdbc.JdbcIO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.apache.beam.sdk.transforms.MapElements;
import org.apache.beam.sdk.values.TypeDescriptor;
import org.apache.beam.sdk.io.gcp.spanner.SpannerIO;
import  com.google.cloud.spanner.Value;
import java.util.Date;


public class DbToSpanner {
    public static void main(String[] args) {
        DbToSpannerOptions options = PipelineOptionsFactory
                .fromArgs(args)
                .withValidation()
                .as(DbToSpannerOptions.class);

        run(options);
    }

    private static void run(DbToSpannerOptions options) {

        Pipeline pipeline = Pipeline.create(options);

        /*
         * Steps:
         *  1) Read from the text source.
         *  2) Write each text record to Pub/Sub
         */
        PCollection<List<String>> rows= pipeline.apply("Read From Db",JdbcIO.<List<String>>read()
                .withDataSourceConfiguration(JdbcIO.DataSourceConfiguration.create(
                        "com.mysql.jdbc.Driver", "jdbc:mysql://8.tcp.ngrok.io:12887/demo_database")
                        .withUsername("root")
                        .withPassword("password"))
                .withQuery("select * from demo_table")
                .withCoder(ListCoder.of(StringUtf8Coder.of()))
                .withRowMapper(new JdbcIO.RowMapper<List<String>>() {
                    public List<String> mapRow(ResultSet resultSet) throws Exception {
                        List<String> addRow = new ArrayList<String>();
                        for(int i=1; i<= resultSet.getMetaData().getColumnCount(); i++ )
                        {
                            addRow.add(i-1, String.valueOf(resultSet.getObject(i)));
                        }
                        return addRow;
                    }
                })
        );

        PCollection<DbData> dbDataRows = rows.apply("Convert to DB Rows",MapElements.into(TypeDescriptor.of(DbData.class)).via(DbData::fromDbString));

        PCollection<Mutation> mutations = dbDataRows.apply(
                "Create Mutations", ParDo.of(new DoFn<DbData, Mutation>() {
                    @ProcessElement
                    public void processElement(ProcessContext c) {
                        DbData dbData = c.element();
                        c.output(Mutation.newInsertOrUpdateBuilder("demo_table")
                                .set("Store_id").to(dbData.getStore_id())
                                .set("Store_location").to(dbData.getStore_location())
                                .set("Product_id").to(dbData.getProduct_id())
                                .set("Product_category").to(dbData.getProduct_category())
                                .set("number_of_pieces_sold").to(dbData.getNumber_of_pieces_sold())
                                .set("buy_rate").to(dbData.getBuy_rate())
                                .set("sell_price").to(dbData.getSell_price())
                                .set("unix_timestamp").to(Value.COMMIT_TIMESTAMP)
                                .build());
                    }
                })
        );
        // Write mutations.
        mutations.apply(
                "Insert to Spanner", SpannerIO.write().withInstanceId(options.getSpannerInstanceName()).withDatabaseId(options.getSpannerDatabaseName()));

        pipeline.run();
    }
}
