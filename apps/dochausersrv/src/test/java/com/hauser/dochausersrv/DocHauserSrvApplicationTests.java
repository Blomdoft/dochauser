package com.hauser.dochausersrv;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hauser.dochausersrv.model.SearchAggregation;
import com.hauser.dochausersrv.model.SearchMode;
import com.hauser.dochausersrv.model.SearchDocRequest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

@AutoConfigureMockMvc
@SpringBootTest
@ActiveProfiles("dev")
class DocHauserSrvApplicationTests {

	@Autowired
	private MockMvc mockMvc;


	public static String asJsonString(final Object obj) {
		try {
			final ObjectMapper mapper = new ObjectMapper();
			return mapper.writeValueAsString(obj);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	@Test
	void contextLoads() {
	}

	@Test
	void testBasicSearch() throws Exception {

		String[] searchTerms = {"XXXLutz"};
		SearchDocRequest req = new SearchDocRequest(SearchAggregation.AND, SearchMode.EXACT, null, null, searchTerms);

		RequestBuilder requestBuilder = MockMvcRequestBuilders.get(
				"/search")
				.content(asJsonString(req))
				.contentType(MediaType.APPLICATION_JSON)
				.accept(MediaType.APPLICATION_JSON);

		MvcResult result = mockMvc.perform(requestBuilder).andReturn();
		System.out.println(result.getResponse().getContentAsString());
	}

}
