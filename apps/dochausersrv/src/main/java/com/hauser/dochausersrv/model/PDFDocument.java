package com.hauser.dochausersrv.model;

import java.util.List;
import java.util.Objects;

public class PDFDocument {
    private String id;
    private String name;
    private String directory;
    private String text;
    private String timestamp;
    private String origin;
    private List<Thumbnail> thumbnails;
    private List<Tag> tags;

    public PDFDocument() {
    }

    public PDFDocument(String id, String name, String directory, String text, String timestamp, String origin, List<Thumbnail> thumbnails, List<Tag> tags) {
        this.id = id;
        this.name = name;
        this.directory = directory;
        this.text = text;
        this.timestamp = timestamp;
        this.origin = origin;
        this.thumbnails = thumbnails;
        this.tags = tags;
    }

    @Override
    public String toString() {
        return "PDFDocument{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", directory='" + directory + '\'' +
                ", text='" + text + '\'' +
                ", timestamp='" + timestamp + '\'' +
                ", origin='" + origin + '\'' +
                ", thumbnails=" + thumbnails +
                ", tags=" + tags +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PDFDocument that = (PDFDocument) o;
        return Objects.equals(id, that.id) && Objects.equals(name, that.name) && Objects.equals(directory, that.directory) && Objects.equals(text, that.text) && Objects.equals(timestamp, that.timestamp) && Objects.equals(origin, that.origin) && Objects.equals(thumbnails, that.thumbnails) && Objects.equals(tags, that.tags);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name, directory, text, timestamp, origin, thumbnails, tags);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDirectory() {
        return directory;
    }

    public void setDirectory(String directory) {
        this.directory = directory;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public List<Thumbnail> getThumbnails() {
        return thumbnails;
    }

    public void setThumbnails(List<Thumbnail> thumbnails) {
        this.thumbnails = thumbnails;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }
}

