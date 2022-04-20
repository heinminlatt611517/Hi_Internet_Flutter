class AccountResponse {
  String updateStatus;
  String isRequireUpdate;
  String isForceUpdate;
  String status;
  String errorCode;
  AccountVO data;

  AccountResponse(
      {this.updateStatus,
        this.isRequireUpdate,
        this.isForceUpdate,
        this.status,
        this.errorCode,
        this.data});

  AccountResponse.fromJson(Map<String, dynamic> json) {
    updateStatus = json['update_status'];
    isRequireUpdate = json['is_require_update'];
    isForceUpdate = json['is_force_update'];
    status = json['status'];
    errorCode = json['error_code'];
    data = json['list'] != null ? new AccountVO.fromJson(json['list']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['update_status'] = this.updateStatus;
    data['is_require_update'] = this.isRequireUpdate;
    data['is_force_update'] = this.isForceUpdate;
    data['status'] = this.status;
    data['error_code'] = this.errorCode;
    if (this.data != null) {
      data['list'] = this.data.toJson();
    }
    return data;
  }
}

class AccountVO {
  String userId;
  String name;
  String plan;
  String activateDate;
  String accountStatus;
  String service;
  String mobileNo;
  String address;
  String createdDate;
  String modifiedDate;

  AccountVO(
      {this.userId,
        this.name,
        this.plan,
        this.activateDate,
        this.accountStatus,
        this.service,
        this.mobileNo,
        this.address,
        this.createdDate,
        this.modifiedDate});

  AccountVO.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    plan = json['plan'];
    activateDate = json['activate_date'];
    accountStatus = json['account_status'];
    service = json['service'];
    mobileNo = json['mobile_no'];
    address = json['address'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['plan'] = this.plan;
    data['activate_date'] = this.activateDate;
    data['account_status'] = this.accountStatus;
    data['service'] = this.service;
    data['mobile_no'] = this.mobileNo;
    data['address'] = this.address;
    data['created_date'] = this.createdDate;
    data['modified_date'] = this.modifiedDate;
    return data;
  }
}

