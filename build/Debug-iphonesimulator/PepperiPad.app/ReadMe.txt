
CPTLayerAnnotation.H

@property (nonatomic, readwrite, assign) CPTLayer *anchorLayer;
@property (nonatomic, readwrite, assign) CPTRectAnchor rectAnchor;
was giving me this error
Property of "weak" attribute must be of type object.
Changed to following
@property (nonatomic, readwrite, weak) CPTLayer *anchorLayer;
@property (nonatomic, readwrite, weak) CPTRectAnchor rectAnchor;