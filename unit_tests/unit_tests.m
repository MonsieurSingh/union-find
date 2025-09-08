//
//  unit_tests.m
//  unit_tests
//
//  Created by Teghjyot Singh on 8/9/2025.
//

#import <XCTest/XCTest.h>
#import "../union_find.h"

@interface unit_tests : XCTestCase

@property (nonatomic) t_union_find *uf;
@property (nonatomic) int random_size;

@end

@implementation unit_tests

- (void)setUp
{
	[super setUp];
	self.random_size = arc4random_uniform(96) + 5;
	self.uf = uf_create(self.random_size);
}

- (void)tearDown
{
	uf_destroy(self.uf);
	[super tearDown];
}

- (void)test_initialisation
{
	XCTAssertEqual(self.uf->size, self.random_size, "Invalid size");
	XCTAssertEqual(self.uf->parent[0], 0,
				   "Incorrectly linked parent");
	XCTAssertEqual(self.uf->parent[self.random_size - 1], self.random_size - 1,
				   "Incorrectly linked parent");
}

- (void)test_find
{

}

- (void)testPerformanceExample
{

    [self measureBlock:^ {
		
		}
	];
}

@end
