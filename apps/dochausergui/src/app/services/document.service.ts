import {Injectable} from "@angular/core";
import {PDFDocument} from "../model/document.model";

@Injectable({providedIn: 'root'})
export class DocumentService {
  private searchResult: PDFDocument[] = [];
  private archiveRoot : string = "";

  constructor() {
  }

  setNewSearchResults(searchResult : PDFDocument[]) {
    this.searchResult = searchResult
  }

  getSearchResults() {
    return this.searchResult;
  }

}
