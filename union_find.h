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
/*   union_find.h                                  |__ --==|'-''' '...;       */
/*                                                [  ]  :[|       |---\       */
/*   By: teghjyot <teghjyot@teghjyot.com>         |__| I=[|     .'    '.      */
/*                                                / / ____|     :       '._   */
/*   Created: 2025/09/08 18:04:00 by teghjyot    |-/.____.'      | :      :   */
/*   Updated: 2025/09/08 18:04:02 by teghjyot     /___ /___      '-'._----'   */
/*                                                                            */
/* ************************************************************************** */

#ifndef UNION_FIND_H
# define UNION_FIND_H
# include <stdlib.h>

typedef struct s_union_find
{
	int		size;
	int		*parent;
}	t_union_find;

t_union_find	*uf_create(int size);
int				uf_find(t_union_find *uf, int x);
void			uf_union(t_union_find *uf, int a, int b);

#endif
