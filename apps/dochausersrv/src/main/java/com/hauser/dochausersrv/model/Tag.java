package com.hauser.dochausersrv.model;

import java.util.Objects;

public class Tag {
    private String tagname;

    public Tag(String tagname) {
        this.tagname = tagname;
    }
    public Tag() {}

    public String getTagname() {
        return tagname;
    }

    public void setTagname(String tagname) {
        this.tagname = tagname;
    }

    @Override
    public String toString() {
        return "Tag{" +
                "tagname='" + tagname + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Tag tag = (Tag) o;
        return Objects.equals(tagname, tag.tagname);
    }

    @Override
    public int hashCode() {
        return Objects.hash(tagname);
    }
}
