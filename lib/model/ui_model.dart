class UIModel<T> {
  final OperationState state;
  final T? data;
  final Object? error;

  UIModel(this.state, this.data, this.error);

  factory UIModel.success(T data) {
    return UIModel(OperationState.ok, data, null);
  }

  factory UIModel.loading() {
    return UIModel(OperationState.loading, null, null);
  }

  factory UIModel.error(Object? error, {T? data}) {
    return UIModel(OperationState.error, data, error);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UIModel &&
              runtimeType == other.runtimeType &&
              state == other.state &&
              data == other.data &&
              error == other.error;

  @override
  int get hashCode => state.hashCode ^ data.hashCode ^ error.hashCode;

  UIModel<V> transform<V>([V mappingFunction(T? data)?]) {
    if (state == OperationState.loading) {
      return UIModel.loading();
    } else if (state == OperationState.error) {
      return UIModel.error(error);
    } else if (mappingFunction != null) {
      return UIModel.success(mappingFunction(data));
    }
    return UIModel.loading();
  }

  @override
  String toString() {
    return "UIModel(state: $state, data: $data; error: $error)";
  }
}

enum OperationState { loading, error, ok }

class UIError extends Error {}
