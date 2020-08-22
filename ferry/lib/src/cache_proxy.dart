import 'package:ferry_cache/ferry_cache.dart';

import './operation_request.dart';
import './fragment_request.dart';

/// Provides an interface for interacting with the [Cache] from within
/// [UpdateCacheHandler]s, including fully typed reads and writes for
/// operations and fragments.
class CacheProxy {
  final Cache _cache;
  final bool _optimistic;
  final String _requestId;

  CacheProxy(
    Cache cache,
    bool optimistic,
    String requestId,
  )   : _cache = cache,
        _optimistic = optimistic,
        _requestId = requestId;

  TData readQuery<TData, TVars>(
    OperationRequest<TData, TVars> request, {
    bool optimistic,
  }) {
    final json = _cache.readQuery(
      request.execRequest,
      optimistic: optimistic ?? _optimistic,
    );
    return json == null ? null : request.parseData(json);
  }

  TData readFragment<TData, TVars>(
    FragmentRequest<TData, TVars> request, {
    bool optimistic,
  }) {
    final json = _cache.readFragment(
      document: request.document,
      idFields: request.idFields,
      fragmentName: request.fragmentName,
      // TODO: don't cast to dynamic
      variables: (request.vars as dynamic)?.toJson(),
      optimistic: optimistic ?? _optimistic,
    );
    return json == null ? null : request.parseData(json);
  }

  void writeQuery<TData, TVars>(
    OperationRequest<TData, TVars> request,
    TData data,
  ) =>
      _cache.writeQuery(
        request.execRequest,
        // TODO: don't cast to dynamic
        (data as dynamic)?.toJson(),
        optimistic: _optimistic,
        requestId: _requestId,
      );

  void writeFragment<TData, TVars>(
    FragmentRequest<TData, TVars> request,
    TData data,
  ) =>
      _cache.writeFragment(
        document: request.document,
        idFields: request.idFields,
        data: (data as dynamic)?.toJson(),
        fragmentName: request.fragmentName,
        // TODO: don't cast to dynamic
        variables: (request.vars as dynamic)?.toJson(),
        optimistic: _optimistic,
        requestId: _requestId,
      );
}