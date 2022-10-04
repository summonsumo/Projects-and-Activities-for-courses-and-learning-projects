With vendas_preco As (

-- Join table vendas with preco 

Select v.*, p.preco, p.Preco * v.Unidades As vendas From GA.vendas As v

Left Join ga.PRECO As p
On v.Produto = p.Produto

),

-- Group by vendas by Loja and Ano

vendas_preco_agrupado As (


Select
	a.Loja,
	a.Ano,
	Sum(Cast(a.vendas As Float)) As Vendas

From vendas_preco As a

Group By a.Loja, a.Ano

),

-- Join with table Meta 

vendas_metas As (


Select gp.*, gm.[Meta Valor] From vendas_preco_agrupado As gp

Left Join ga.meta As gm
On gp.Loja = gm.Loja and gp.Ano = gm.Data


),

-- Calculated target on Loja B 

lojaB_ano As (

Select
	
	a.*,
	Concat (Round(a.vendas / a.[Meta Valor] * 100, 2), '%') As 'Atingimento Metas %',
	case When Round(a.vendas / a.[Meta Valor] * 100, 2) >= 100 Then 'SIM'
	Else 'NÃO' End As 'Bateu Meta'

From vendas_metas As a
Where a.Loja = 'B'

) Select * From lojaB_ano 
Order By Ano