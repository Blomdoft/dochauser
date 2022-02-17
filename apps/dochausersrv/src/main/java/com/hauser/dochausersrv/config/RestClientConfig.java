package com.hauser.dochausersrv.config;

import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.elasticsearch.client.ClientConfiguration;
import org.springframework.data.elasticsearch.client.RestClients;
import org.springframework.data.elasticsearch.config.AbstractElasticsearchConfiguration;

@Configuration
public class RestClientConfig extends AbstractElasticsearchConfiguration {

    @Value( "${elasticsearch.url}" )
    private String elasticSearchUrl;

    @Override
    @Bean
    public RestHighLevelClient elasticsearchClient() {

        System.out.println("Connecting ElasticSearch Client to: " + elasticSearchUrl);

        final ClientConfiguration clientConfiguration = ClientConfiguration.builder()
                .connectedTo(elasticSearchUrl)
                .build();

        return RestClients.create(clientConfiguration).rest();
    }

}
