class PaymentListsResponse {
  String updateStatus;
  String isRequireUpdate;
  String isForceUpdate;
  String status;
  String errorCode;
  List<PaymentVO> list;

  PaymentListsResponse(
      {this.updateStatus,
        this.isRequireUpdate,
        this.isForceUpdate,
        this.status,
        this.errorCode,
        this.list});

  PaymentListsResponse.fromJson(Map<String, dynamic> json) {
    updateStatus = json['update_status'];
    isRequireUpdate = json['is_require_update'];
    isForceUpdate = json['is_force_update'];
    status = json['status'];
    errorCode = json['error_code'];
    if (json['list'] != null) {
      list = new List<PaymentVO>();
      json['list'].forEach((v) {
        list.add(new PaymentVO.fromJson(v));
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

class PaymentVO {
  String paidStatus;
  DueDate dueDate;
  DueDate paidDate;
  String paidUrl;
  String invoiceId;
  String amount;
  String startDate;
  String endDate;
  String creationDate;
  String modifiedDate;

  PaymentVO(
      {this.paidStatus,
        this.dueDate,
        this.paidDate,
        this.paidUrl,
        this.invoiceId,
        this.amount,
        this.startDate,
        this.endDate,
        this.creationDate,
        this.modifiedDate});

  PaymentVO.fromJson(Map<String, dynamic> json) {
    paidStatus = json['paid_status'];
    dueDate = json['due_date'] != null
        ? new DueDate.fromJson(json['due_date'])
        : null;
    paidDate = json['paid_date'] != null
        ? new DueDate.fromJson(json['paid_date'])
        : null;
    paidUrl = json['paid_url'];
    invoiceId = json['invoice_id'];
    amount = json['amount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    creationDate = json['creation_date'];
    modifiedDate = json['modified_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paid_status'] = this.paidStatus;
    if (this.dueDate != null) {
      data['due_date'] = this.dueDate.toJson();
    }
    if (this.paidDate != null) {
      data['paid_date'] = this.paidDate.toJson();
    }
    data['paid_url'] = this.paidUrl;
    data['invoice_id'] = this.invoiceId;
    data['amount'] = this.amount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['creation_date'] = this.creationDate;
    data['modified_date'] = this.modifiedDate;
    return data;
  }
}

class DueDate {
  String day;
  String monthYear;

  DueDate({this.day, this.monthYear});

  DueDate.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    monthYear = json['month_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['month_year'] = this.monthYear;
    return data;
  }
}

