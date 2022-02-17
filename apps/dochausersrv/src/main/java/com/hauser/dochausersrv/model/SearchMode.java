package com.hauser.dochausersrv.model;

public enum SearchMode {
    EXACT("EXACT"), FUZZY("FUZZY");

    private final String text;

    SearchMode(final String text) {
        this.text = text;
    }

     @Override
    public String toString() {
        return text;
    }
}

