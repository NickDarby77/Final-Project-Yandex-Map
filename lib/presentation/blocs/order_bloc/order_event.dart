part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class SendOrderEvent extends OrderEvent {
  final EmailModel model;

  SendOrderEvent({required this.model});
}
