/* ************************************************************************** */
/*                                                                            */
/*                           .                      .                   ·     */
/*        .    __ _o|                        .                ·               */
/*            |  /__|===--        .                                  ·        */
/*     *      [__|______~~--._                      .                         */
/*      .    |\  `---.__:====]-----...,,_____                *          ·     */
/*           |[>-----|_______<----------_____;::===--             .==.        */
/*           |/_____.....-----'''~~~~~~~                         ()''()-.     */
/*      +               ·                           .---.         ;--; /      */
/*                                                .'_:___". _..'.  __'.       */
/*   unit_tests.m                                  |__ --==|'-''' '...;       */
/*                                                [  ]  :[|       |---\       */
/*   By: teghjyot <teghjyot@teghjyot.com>         |__| I=[|     .'    '.      */
/*                                                / / ____|     :       '._   */
/*   Created: 2025/09/08 21:23:07 by teghjyot    |-/.____.'      | :      :   */
/*   Updated: 2025/09/08 21:23:08 by teghjyot     /___ /___      '-'._----'   */
/*                                                                            */
/* ************************************************************************** */

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
	for (int i = 0; i < self.random_size; i++)
	{
		XCTAssertEqual(uf_find(self.uf, i), i,
					   "Find operation failed");
	}
	XCTAssertEqual(uf_find(self.uf, self.random_size), -1,
				   "Find operation failed for out of bounds");
}

- (void)test_union
{
	int a;
	int b;
	if (self.random_size < 2)
		return;
	a = arc4random_uniform(self.random_size);
	b = arc4random_uniform(self.random_size);
	while (a == b)
		b = arc4random_uniform(self.random_size);
	uf_union(self.uf, a, b);
	XCTAssertEqual(uf_find(self.uf, a), uf_find(self.uf, b),
				   "Union operation failed");
	XCTAssertEqual(uf_find(self.uf, self.random_size), -1,
				   "Union operation failed for out of bounds");
}

- (void)test_performance_find
{
	[self measureBlock:^ {
		for (int i = 0; i < 1000; i++) {
			int a = arc4random_uniform(self.random_size);
			uf_find(self.uf, a);
		}
	}];
}

- (void)test_performance_union
{
	[self measureBlock:^ {
		for (int i = 0; i < 1000; i++) {
			int a = arc4random_uniform(self.random_size);
			int b = arc4random_uniform(self.random_size);
			uf_union(self.uf, a, b);
		}
	}];
}

@end
