/// An easy mvvm solution that includes ways to manage routes, views, viewmodels,
/// and the mvvm architecture
library easy_mvvm;

// router
export 'src/route_transition.dart' show RouteTransition;
export 'src/route_info.dart' show RouteInfo;
export 'src/route_error_template.dart' show RouteErrorTemplate;
export 'src/route_service.dart' show RouteService;
export 'src/custom_page_route_builder.dart' hide CustomPageRouteBuilder;
export 'src/defined_routes.dart' hide DefinedRoutes;

// mvvm
// ignore: deprecated_member_use_from_same_package
export 'src/easy_view_model.dart' show EasyViewModel, ViewModel;
// ignore: deprecated_member_use_from_same_package
export 'src/easy_view.dart' show EasyView, View;
export 'src/locator.dart' show locator;
export 'src/base_view.dart' hide BaseView, BaseViewState;
export 'src/easy_view.dart' hide ViewElement;
export 'src/property_builder.dart' show PropertyBuilder;
export 'src/multi_property_builder.dart' show MultiPropertyBuilder;
