package com.hauser.dochausersrv.model;

public class Thumbnail {

    private String imgdirectory;
    private String imgname;

    public Thumbnail() {}

    public Thumbnail(String imgdirectory, String imgname) {
        this.imgdirectory = imgdirectory;
        this.imgname = imgname;
    }

    public String getImgdirectory() {
        return imgdirectory;
    }

    public void setImgdirectory(String imgdirectory) {
        this.imgdirectory = imgdirectory;
    }

    public String getImgname() {
        return imgname;
    }

    public void setImgname(String imgname) {
        this.imgname = imgname;
    }

}
