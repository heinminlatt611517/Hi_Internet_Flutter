class ServiceComplainResponseVO {
  String updateStatus;
  String isRequireUpdate;
  String isForceUpdate;
  String status;
  String errorCode;
  String ticketId;
  String message;

  ServiceComplainResponseVO(
      {this.updateStatus,
        this.isRequireUpdate,
        this.isForceUpdate,
        this.status,
        this.errorCode,
        this.ticketId,
        this.message});

  ServiceComplainResponseVO.fromJson(Map<String, dynamic> json) {
    updateStatus = json['update_status'];
    isRequireUpdate = json['is_require_update'];
    isForceUpdate = json['is_force_update'];
    status = json['status'];
    errorCode = json['error_code'];
    ticketId = json['ticket_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['update_status'] = this.updateStatus;
    data['is_require_update'] = this.isRequireUpdate;
    data['is_force_update'] = this.isForceUpdate;
    data['status'] = this.status;
    data['error_code'] = this.errorCode;
    data['ticket_id'] = this.ticketId;
    data['message'] = this.message;
    return data;
  }
}
