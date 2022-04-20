class HomeDataResponse {
  String updateStatus;
  bool isRequireUpdate;
  bool isForceUpdate;
  String status;
  String hotlinePhone;
  String errorCode;
  HomeDataVO list;

  HomeDataResponse(
      {this.updateStatus,
        this.isRequireUpdate,
        this.isForceUpdate,
        this.status,
        this.hotlinePhone,
        this.errorCode,
        this.list});

  HomeDataResponse.fromJson(Map<String, dynamic> json) {
    updateStatus = json['update_status'];
    isRequireUpdate = json['is_require_update'];
    isForceUpdate = json['is_force_update'];
    status = json['status'];
    hotlinePhone = json['hotline_phone'];
    errorCode = json['error_code'];
    list = json['list'] != null ? new HomeDataVO.fromJson(json['list']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['update_status'] = this.updateStatus;
    data['is_require_update'] = this.isRequireUpdate;
    data['is_force_update'] = this.isForceUpdate;
    data['status'] = this.status;
    data['hotline_phone'] = this.hotlinePhone;
    data['error_code'] = this.errorCode;
    if (this.list != null) {
      data['list'] = this.list.toJson();
    }
    return data;
  }
}

class HomeDataVO {
  List<UpImagesVO> upImages;
  List<MiddleImagesVO> middleImages;
  List<DownImagesVO> downImages;

  HomeDataVO({this.upImages, this.middleImages, this.downImages});

  HomeDataVO.fromJson(Map<String, dynamic> json) {
    if (json['up_images'] != null) {
      upImages = new List<UpImagesVO>();
      json['up_images'].forEach((v) {
        upImages.add(new UpImagesVO.fromJson(v));
      });
    }
    if (json['middle_images'] != null) {
      middleImages = new List<MiddleImagesVO>();
      json['middle_images'].forEach((v) {
        middleImages.add(new MiddleImagesVO.fromJson(v));
      });
    }
    if (json['down_images'] != null) {
      downImages = new List<DownImagesVO>();
      json['down_images'].forEach((v) {
        downImages.add(new DownImagesVO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upImages != null) {
      data['up_images'] = this.upImages.map((v) => v.toJson()).toList();
    }
    if (this.middleImages != null) {
      data['middle_images'] = this.middleImages.map((v) => v.toJson()).toList();
    }
    if (this.downImages != null) {
      data['down_images'] = this.downImages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpImagesVO {
  String slideId;
  String name;
  String type;
  String image;
  String imageMm;
  String link;
  String creationDate;
  String modifiedDate;

  UpImagesVO(
      {this.slideId,
        this.name,
        this.type,
        this.image,
        this.imageMm,
        this.link,
        this.creationDate,
        this.modifiedDate});

  UpImagesVO.fromJson(Map<String, dynamic> json) {
    slideId = json['slide_id'];
    name = json['name'];
    type = json['type'];
    image = json['image'];
    imageMm = json['image_mm'];
    link = json['link'];
    creationDate = json['creation_date'];
    modifiedDate = json['modified_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slide_id'] = this.slideId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['image'] = this.image;
    data['image_mm'] = this.imageMm;
    data['link'] = this.link;
    data['creation_date'] = this.creationDate;
    data['modified_date'] = this.modifiedDate;
    return data;
  }
}

class MiddleImagesVO {
  String videoUrl;
  String slideId;
  String name;
  String type;
  String image;
  String imageMm;
  String link;
  String creationDate;
  String modifiedDate;
  String backgroundColor;
  String title;
  String titleMm;
  String description;
  String descriptionMm;
  String imageV1;
  String imageV1Mm;

  MiddleImagesVO(
      {this.videoUrl,
        this.slideId,
        this.name,
        this.type,
        this.image,
        this.imageMm,
        this.link,
        this.creationDate,
        this.modifiedDate,
        this.backgroundColor,
        this.title,
        this.titleMm,
        this.description,
        this.descriptionMm,
        this.imageV1,
        this.imageV1Mm});

  MiddleImagesVO.fromJson(Map<String, dynamic> json) {
    videoUrl = json['video_url'];
    slideId = json['slide_id'];
    name = json['name'];
    type = json['type'];
    image = json['image'];
    imageMm = json['image_mm'];
    link = json['link'];
    creationDate = json['creation_date'];
    modifiedDate = json['modified_date'];
    backgroundColor = json['background_color'];
    title = json['title'];
    titleMm = json['title_mm'];
    description = json['description'];
    descriptionMm = json['description_mm'];
    imageV1 = json['image_v1'];
    imageV1Mm = json['image_v1_mm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_url'] = this.videoUrl;
    data['slide_id'] = this.slideId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['image'] = this.image;
    data['image_mm'] = this.imageMm;
    data['link'] = this.link;
    data['creation_date'] = this.creationDate;
    data['modified_date'] = this.modifiedDate;
    data['background_color'] = this.backgroundColor;
    data['title'] = this.title;
    data['title_mm'] = this.titleMm;
    data['description'] = this.description;
    data['description_mm'] = this.descriptionMm;
    data['image_v1'] = this.imageV1;
    data['image_v1_mm'] = this.imageV1Mm;
    return data;
  }
}

class DownImagesVO {
  String slideId;
  String name;
  String type;
  String image;
  String imageMm;
  String link;
  String creationDate;
  String modifiedDate;
  String backgroundColor;
  String title;
  String titleMm;
  String titleTextColor;
  String description;
  String descriptionMm;
  String descriptionTextColor;
  String imageV1;
  String imageV1Mm;

  DownImagesVO(
      {this.slideId,
        this.name,
        this.type,
        this.image,
        this.imageMm,
        this.link,
        this.creationDate,
        this.modifiedDate,
        this.backgroundColor,
        this.title,
        this.titleMm,
        this.titleTextColor,
        this.description,
        this.descriptionMm,
        this.descriptionTextColor,
        this.imageV1,
        this.imageV1Mm});

  DownImagesVO.fromJson(Map<String, dynamic> json) {
    slideId = json['slide_id'];
    name = json['name'];
    type = json['type'];
    image = json['image'];
    imageMm = json['image_mm'];
    link = json['link'];
    creationDate = json['creation_date'];
    modifiedDate = json['modified_date'];
    backgroundColor = json['background_color'];
    title = json['title'];
    titleMm = json['title_mm'];
    titleTextColor = json['title_text_color'];
    description = json['description'];
    descriptionMm = json['description_mm'];
    descriptionTextColor = json['description_text_color'];
    imageV1 = json['image_v1'];
    imageV1Mm = json['image_v1_mm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slide_id'] = this.slideId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['image'] = this.image;
    data['image_mm'] = this.imageMm;
    data['link'] = this.link;
    data['creation_date'] = this.creationDate;
    data['modified_date'] = this.modifiedDate;
    data['background_color'] = this.backgroundColor;
    data['title'] = this.title;
    data['title_mm'] = this.titleMm;
    data['title_text_color'] = this.titleTextColor;
    data['description'] = this.description;
    data['description_mm'] = this.descriptionMm;
    data['description_text_color'] = this.descriptionTextColor;
    data['image_v1'] = this.imageV1;
    data['image_v1_mm'] = this.imageV1Mm;
    return data;
  }
}
