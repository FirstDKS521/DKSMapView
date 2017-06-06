//
//  RootViewController.m
//  DKSMapView
//
//  Created by aDu on 2017/3/30.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "RootViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface RootViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    //如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow; //追踪用户定位
    _mapView.showsUserLocation = YES; //是否显示定位图片
    [self setCircleView];
    
    [self.view addSubview:_mapView];
    
    //添加点击回到当前位置的按钮
    UIButton *btn = [self makeGPSButtonView];
    btn.center = CGPointMake(CGRectGetMidX(btn.bounds) + 10,
                             self.view.bounds.size.height -  CGRectGetMidY(btn.bounds) - 20);
    [self.view addSubview:btn];
    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
}

#pragma mark - 设置圆点儿
- (void)setCircleView
{
    MAUserLocationRepresentation *location = [[MAUserLocationRepresentation alloc] init];
    //是否显示精度圈
//    location.showsAccuracyRing = YES;
//    //是否显示蓝点儿方向
//    location.showsHeadingIndicator = YES;
//    //调整精度圈填充颜色
//    location.fillColor = [UIColor redColor];
//    //调整精度圈边线颜色
//    location.strokeColor = [UIColor greenColor];
//    //调整精度圈边线宽度
//    location.lineWidth = 2;
//    //调整定位蓝点的背景颜色
//    location.locationDotBgColor = [UIColor greenColor];
//    //调整定位蓝点的颜色
//    location.locationDotFillColor = [UIColor redColor];//定位点蓝色圆点颜色，不设置默认蓝色
    //调整定位蓝点的图标
    location.image = [UIImage imageNamed:@"icon_location"]; //定位图标, 与蓝色原点互斥
    [self.mapView updateUserLocationRepresentation:location];
}

#pragma mark - 大头针、点标记
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
    //经纬度
    point.coordinate = CLLocationCoordinate2DMake(30.25999707, 120.01742052);
    point.title = @"19-706室";
    point.subtitle = @"杭州闪易科技有限公司";
    
    MAPointAnnotation *point1 = [[MAPointAnnotation alloc] init];
    //经纬度
    point1.coordinate = CLLocationCoordinate2DMake(30.29949707, 120.01742052);
    point1.title = @"19-706室";
    point1.subtitle = @"杭州闪易科技有限公司";
    
    MAPointAnnotation *point2 = [[MAPointAnnotation alloc] init];
    //经纬度
    point2.coordinate = CLLocationCoordinate2DMake(30.27949707, 120.05742052);
    point2.title = @"19-706室";
    point2.subtitle = @"杭州闪易科技有限公司";
    
    MAPointAnnotation *point3 = [[MAPointAnnotation alloc] init];
    //经纬度
    point3.coordinate = CLLocationCoordinate2DMake(30.27949707, 120.01142052);
    point3.title = @"19-706室";
    point3.subtitle = @"杭州闪易科技有限公司";
    
    NSArray *pointAry = @[point, point1, point2, point3];
    
    [self.mapView addAnnotations:pointAry];
    
    //设置出来时地图的中心点
    [self.mapView showAnnotations:pointAry edgePadding:UIEdgeInsetsMake(0, 20, 80, 60) animated:YES];
}

#pragma mark - 设置标注样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointIndentifier = @"pointIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointIndentifier];
        }
        annotationView.canShowCallout = YES; //设置气泡可以弹起
        annotationView.animatesDrop = YES; //是否有下落动画
        annotationView.draggable = YES; //是否可以拖动
        annotationView.pinColor = MAPinAnnotationColorRed; //大头针颜色
        
//        annotationView.image = [UIImage imageNamed:@"greenPin"]; //大头针图片
//        annotationView.centerOffset = CGPointMake(0, -10);
        
        return annotationView;
    }
    return nil;
}

#pragma mark - 添加点击回到当前位置的按钮
- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (void)gpsAction:(UIButton *)btn {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [btn setSelected:YES];
    }
}

@end
