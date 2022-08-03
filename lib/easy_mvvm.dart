/// An easy total mvvm solution that includes ways to manage routes,
/// drawer, and the mvvm architecture
library easy_mvvm;

// router
export 'src/route_transition.dart' show RouteTransition;
export 'src/route_info.dart' show RouteInfo;
export 'src/route_error_template.dart' show RouteErrorTemplate;
export 'src/route_service.dart' show RouteService;
export 'src/custom_page_route_builder.dart' hide CustomPageRouteBuilder;
export 'src/defined_routes.dart' hide DefinedRoutes;

// mvvm
export 'src/view_model.dart' show ViewModel;
export 'src/view.dart' show View;
export 'src/locator.dart' show locator;
export 'src/base_view.dart' hide BaseView;
