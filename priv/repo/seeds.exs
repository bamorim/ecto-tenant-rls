alias Tenant.Repo
alias Tenant.Catalog.{Category, Product}

roupas1 = Repo.insert!(%Category{name: "Roupas", tenant_id: 1})
roupas2 = Repo.insert!(%Category{name: "Roupas", tenant_id: 2})
eletronicos1 = Repo.insert!(%Category{name: "Eletrônicos", tenant_id: 1})

for name <- ["TV", "Computador", "Celular"] do
  Repo.insert!(%Product{name: name, tenant_id: 1, category: eletronicos1})
end

for category <- [roupas1, roupas2], name <- ["Calça", "Tênis", "Camisa", "Chapéu"] do
  Repo.insert!(%Product{name: name, tenant_id: category.tenant_id, category: category})
end
