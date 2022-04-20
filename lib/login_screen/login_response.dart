class LoginVO {
  String status;
  String errorCode;
  String message;
  String userId;
  String phone;
  String paymentChannel;
  String token;

  LoginVO(
      {this.status,
        this.errorCode,
        this.message,
        this.userId,
        this.phone,
        this.paymentChannel,
        this.token});

  LoginVO.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['error_code'];
    message = json['message'];
    userId = json['user_id'];
    phone = json['phone'];
    paymentChannel = json['payment_channel'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error_code'] = this.errorCode;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['phone'] = this.phone;
    data['payment_channel'] = this.paymentChannel;
    data['token'] = this.token;
    return data;
  }
}

