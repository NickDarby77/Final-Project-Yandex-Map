import 'package:dio/dio.dart';
import 'package:lesson62_final_project_part1/core/consts/app_consts.dart';
import 'package:lesson62_final_project_part1/data/models/email_model/email_model.dart';

class OrderRepository {
  final Dio dio;
  OrderRepository({required this.dio});

  Future<void> sendOrderToEmail({required EmailModel emailModel}) async {
    await dio.post(
      'https://api.emailjs.com/api/v1.0/email/send',
      data: {
        "service_id": AppConsts.serviceId,
        "template_id": AppConsts.templateId,
        "user_id": AppConsts.userId,
        "accessToken": AppConsts.accessToken,
        "template_params": emailModel.toJson(),
      },
    );
  }
}
