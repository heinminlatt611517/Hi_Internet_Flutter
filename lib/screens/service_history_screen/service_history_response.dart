class ServiceHistoryResponse {
  String updateStatus;
  String isRequireUpdate;
  String isForceUpdate;
  String status;
  String errorCode;
  List<ServiceHistoryVO> data;

  ServiceHistoryResponse(
      {this.updateStatus,
        this.isRequireUpdate,
        this.isForceUpdate,
        this.status,
        this.errorCode,
        this.data});

  ServiceHistoryResponse.fromJson(Map<String, dynamic> json) {
    updateStatus = json['update_status'];
    isRequireUpdate = json['is_require_update'];
    isForceUpdate = json['is_force_update'];
    status = json['status'];
    errorCode = json['error_code'];
    if (json['list'] != null) {
      data = new List<ServiceHistoryVO>();
      json['list'].forEach((v) {
        data.add(new ServiceHistoryVO.fromJson(v));
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
    if (this.data != null) {
      data['list'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceHistoryVO {
  String ticketId;
  String type;
  String topic;
  String message;
  String status;
  String creationDate;
  String reslovedTime;

  ServiceHistoryVO(
      {this.ticketId,
        this.type,
        this.topic,
        this.message,
        this.status,
        this.creationDate,
        this.reslovedTime});

  ServiceHistoryVO.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    type = json['type'];
    topic = json['topic'];
    message = json['message'];
    status = json['status'];
    creationDate = json['creation_date'];
    reslovedTime = json['resloved_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_id'] = this.ticketId;
    data['type'] = this.type;
    data['topic'] = this.topic;
    data['message'] = this.message;
    data['status'] = this.status;
    data['creation_date'] = this.creationDate;
    data['resloved_time'] = this.reslovedTime;
    return data;
  }
}

