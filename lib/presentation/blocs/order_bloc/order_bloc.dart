import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:lesson62_final_project_part1/data/models/email_model/email_model.dart';
import 'package:lesson62_final_project_part1/data/repositories/order_repository.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(OrderInitial()) {
    on<SendOrderEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        repository.sendOrderToEmail(emailModel: event.model);
        emit(OrderSuccess());
      } catch (e) {
        if (e is DioException) {
          emit(
            OrderError(errorText: e.response?.data.toString() ?? ''),
          );
        } else {
          emit(
            OrderError(errorText: e.toString()),
          );
        }
      }
    });
  }
}
