# Link Hub — Arte Mineira Móveis

Página de links da Arte Mineira Móveis, hospedada como arquivos estáticos (sem WordPress, sem build). Todo o conteúdo visível — links, redes sociais, textos, logo e imagem de fundo — vem de um banco Supabase e é editado pelo painel `admin.html`, sem precisar mexer em código.

## Arquivos

- `index.html` — página pública. Busca links, redes sociais e conteúdo do site no Supabase e renderiza tudo dinamicamente; se alguma busca falhar, usa valores de emergência (`AM_FALLBACK_LINKS`, `AM_FALLBACK_SOCIAL`, `AM_FALLBACK_CONTENT`) embutidos no próprio arquivo, para a página nunca ficar quebrada.
- `admin.html` — painel administrativo com 3 abas: **Links**, **Redes sociais** e **Conteúdo do site**. Não é indexado por buscadores (`meta robots noindex`), mas não depende disso para segurança: sem login válido, nenhuma escrita é aceita.
- `assets/supabase-config.js` — URL do projeto Supabase e chave pública (`anon`/`publishable`). É seguro essa chave ser pública; a proteção de escrita vem das políticas de RLS do banco.
- `supabase-schema.sql` — script original: tabela `links`, RLS e dados iniciais.
- `supabase-schema-2.sql` — incremento: tabelas `site_content` e `social_links`, bucket de armazenamento `site-media` para upload de imagens. Ambos os scripts já foram aplicados no banco em uso; ficam aqui como referência.

## Como editar o site pelo painel

1. Acesse `admin.html` (ex.: `https://bio.artemineiramoveis.com.br/admin.html`).
2. Faça login com o e-mail e senha do administrador (criado no Supabase, em Authentication → Users).
3. **Aba Links** — botões da grade principal: **+ Novo link**, **Editar**/**Excluir** em cada item, setas **↑/↓** para reordenar. Cada link tem ícone, nome, descrição opcional, URL e destaque (nenhum / verde em largura total / brilho dourado).
4. **Aba Redes sociais** — ícones do rodapé ("Siga a Arte Mineira"): mesmo fluxo de adicionar/editar/excluir/reordenar, com ícone, nome e link.
5. **Aba Conteúdo do site** — um formulário só, para tudo que é único na página: logo (upload de arquivo), imagem de fundo (upload de arquivo), texto acima do título, subtítulo, texto de apresentação, título da seção de links, textos do cartão de destaque ("Artesanalmente mineiro") e título da seção de redes sociais.
6. As mudanças aparecem no site assim que a página é recarregada — não é preciso reenviar nenhum arquivo.

## Banco de dados (Supabase)

- **`links`**: `title`, `description` (opcional), `url`, `icon_key`, `highlight` (`none` | `primary` | `glow`), `position`.
- **`social_links`**: `icon_key`, `label` (usado como `aria-label`), `url`, `position`.
- **`site_content`**: linha única (`id = 1`) com `logo_url`, `logo_alt`, `background_url`, `eyebrow_text`, `brand_subtitle`, `brand_copy`, `links_section_label`, `feature_kicker`, `feature_title`, `feature_text`, `feature_cta_label`, `feature_cta_url`, `social_label`.
- **Storage `site-media`**: bucket público onde ficam a logo e a imagem de fundo enviadas pelo painel.

Em todas as tabelas: leitura pública (`anon`), escrita restrita a usuários `authenticated`. Não existe cadastro público — o único usuário admin é criado manualmente no painel do Supabase.

## Ícones disponíveis

Os ícones são SVGs embutidos (sem biblioteca externa), definidos em `<defs>` tanto em `index.html` quanto em `admin.html`. Chaves disponíveis: `whatsapp`, `globe`, `ruler`, `tag`, `sparkles`, `instagram`, `pin`, `tiktok`, `phone`, `email`, `facebook`, `youtube`, `cart`, `star`, `heart`, `calendar`, `message`, `pinterest`, `linkedin`, `x`, `telegram`, `threads`.

Para adicionar um ícone novo: crie um `<symbol id="am-icon-SUACHAVE">` em ambos os arquivos e inclua a chave na lista `AM_ICONS` dentro de `admin.html`.

## SEO e compartilhamento

Título, descrição, favicon e imagem de Open Graph (para WhatsApp/redes sociais) já estão configurados no `<head>` de `index.html` — não dependem de plugin ou painel externo.

## Publicação

Envie `index.html`, `admin.html`, os `.sql` (opcional, são só referência) e a pasta `assets/` inteira para a raiz da hospedagem.
