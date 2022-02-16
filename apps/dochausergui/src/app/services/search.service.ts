import {Injectable} from "@angular/core";
import {DocumentService} from "./document.service";

@Injectable({providedIn: 'root'})
export class SearchService {

  documentService : DocumentService;

  constructor(documentService : DocumentService) {
    this.documentService = documentService;
  }

  searchDocuments(searchQuery : string, from : string, to : string, aggregation : string, mode : string) {

  }

}
