class ServiceIssueResponse {
  String updateStatus;
  String isRequireUpdate;
  String isForceUpdate;
  String status;
  String errorCode;
  List<CategoryVO> list;

  ServiceIssueResponse(
      {this.updateStatus,
        this.isRequireUpdate,
        this.isForceUpdate,
        this.status,
        this.errorCode,
        this.list});

  ServiceIssueResponse.fromJson(Map<String, dynamic> json) {
    updateStatus = json['update_status'];
    isRequireUpdate = json['is_require_update'];
    isForceUpdate = json['is_force_update'];
    status = json['status'];
    errorCode = json['error_code'];
    if (json['list'] != null) {
      list = new List<CategoryVO>();
      json['list'].forEach((v) {
        list.add(new CategoryVO.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['update_status'] = this.updateStatus;
    data['is_require_update'] = this.isRequireUpdate;
    data['is_force_update'] = this.isForceUpdate;
    data['status'] = this.status;
    data['error_code'] = this.errorCode;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryVO {
  int id;
  String name;

  CategoryVO({this.id, this.name});

  CategoryVO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

