package com.hauser.dochausersrv.model;

public enum SearchAggregation {
    AND("AND"), OR("OR");

    private final String text;

    SearchAggregation(final String text) {
        this.text = text;
    }

     @Override
    public String toString() {
        return text;
    }
}

