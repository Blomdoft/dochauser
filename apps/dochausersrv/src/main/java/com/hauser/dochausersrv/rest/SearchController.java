package com.hauser.dochausersrv.rest;

import com.hauser.dochausersrv.model.PDFDocument;
import com.hauser.dochausersrv.model.SearchDocRequest;
import com.hauser.dochausersrv.repository.PDFDocumentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class SearchController {

    @Autowired
    private PDFDocumentRepository pdfDocumentRepository;

    @GetMapping("/search")
    public PDFDocument[] searchDocuments(@RequestBody SearchDocRequest request) {

        String queryString = String.join(" ", request.getQueryTerms());
        return pdfDocumentRepository.findDocumentsByText(
                queryString
                ).toArray(new PDFDocument[0]);

    }
}
