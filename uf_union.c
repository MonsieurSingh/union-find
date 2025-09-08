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
/*   uf_union.c                                    |__ --==|'-''' '...;       */
/*                                                [  ]  :[|       |---\       */
/*   By: teghjyot <teghjyot@teghjyot.com>         |__| I=[|     .'    '.      */
/*                                                / / ____|     :       '._   */
/*   Created: 2025/09/08 18:22:41 by teghjyot    |-/.____.'      | :      :   */
/*   Updated: 2025/09/08 18:22:43 by teghjyot     /___ /___      '-'._----'   */
/*                                                                            */
/* ************************************************************************** */

#include "union_find.h"

void	uf_union(t_union_find *uf, int a, int b)
{
	int	root_a;
	int	root_b;

	root_a = uf_find(uf, a);
	root_b = uf_find(uf, b);
	if (root_a == root_b)
		return ;
	if (uf->rank[root_a] < uf->rank[root_b])
		uf->parent[root_a] = root_b;
	else if (uf->rank[root_a] > uf->rank[root_b])
		uf->parent[root_b] = root_a;
	else
	{
		uf->parent[root_b] = root_a;
		uf->rank[root_a]++;
	}
}
