# Link Hub — Toraflex Colchões

Página de links da Toraflex Colchões, hospedada como arquivos estáticos (sem WordPress, sem build). Todo o conteúdo visível — links, redes sociais, textos, logo e imagem de fundo — vem de um banco Supabase e é editado pelo painel `admin.html`, sem precisar mexer em código.

## Arquivos

- `index.html` — página pública. Busca links, redes sociais e conteúdo do site no Supabase e renderiza tudo dinamicamente; se alguma busca falhar, usa valores de emergência (`TF_FALLBACK_LINKS`, `TF_FALLBACK_SOCIAL`, `TF_FALLBACK_CONTENT`) embutidos no próprio arquivo, para a página nunca ficar quebrada.
- `admin.html` — painel administrativo com 4 abas: **Links**, **Redes sociais**, **Conteúdo do site** e **Senha**. Não é indexado por buscadores (`meta robots noindex`), mas não depende disso para segurança: sem login válido, nenhuma escrita é aceita.
- `assets/supabase-config.js` — URL do projeto Supabase e chave pública (`anon`/`publishable`). É seguro essa chave ser pública; a proteção de escrita vem das políticas de RLS do banco.
- `supabase-schema.sql` — script único que cria todas as tabelas (`links`, `site_content`, `social_links`), o bucket de imagens `site-media`, as políticas de RLS e já popula tudo com os dados da Toraflex.

## Identidade visual

Cores da marca Toraflex (extraídas de [toraflex.com.br](https://toraflex.com.br/)):

- **Azul** `#2a3082` — cor principal (textos, cabeçalho, ícones, cartão de destaque, fundo).
- **Vermelho** `#dc2626` — acento (botão de destaque em largura total, selo "brilho" e ações de exclusão no painel).
- **Branco** `#ffffff` — superfícies e cartões.

Fonte: **Manrope** (mantida do projeto original). O fundo usa um gradiente azul da marca (sem imagem), mas continua substituível por uma imagem enviada no painel.

## Como editar o site pelo painel

1. Acesse `admin.html` (ex.: `https://bio.toraflex.com.br/admin.html`).
2. Faça login com o e-mail e senha do administrador (criado no Supabase, em Authentication → Users).
3. **Aba Links** — botões da grade principal: **+ Novo link**, **Editar**/**Excluir** em cada item, setas **↑/↓** para reordenar. Cada link tem ícone, nome, descrição opcional, URL e destaque (nenhum / vermelho em largura total / brilho vermelho).
4. **Aba Redes sociais** — ícones do rodapé ("Siga a Toraflex"): mesmo fluxo de adicionar/editar/excluir/reordenar.
5. **Aba Conteúdo do site** — um formulário para tudo que é único na página: logo (upload), imagem de fundo (upload), texto acima do título, subtítulo, texto de apresentação, títulos das seções e textos do cartão de destaque.
6. **Aba Senha** — troca a senha do administrador logado.
7. As mudanças aparecem no site assim que a página é recarregada — não é preciso reenviar nenhum arquivo.

## Banco de dados (Supabase)

- **`links`**: `title`, `description` (opcional), `url`, `icon_key`, `highlight` (`none` | `primary` | `glow`), `badge_text` (opcional), `position`.
- **`social_links`**: `icon_key`, `label` (usado como `aria-label`), `url`, `position`.
- **`site_content`**: linha única (`id = 1`) com `logo_url`, `logo_alt`, `background_url`, `eyebrow_text`, `brand_subtitle`, `brand_copy`, `links_section_label`, `feature_kicker`, `feature_title`, `feature_text`, `feature_cta_label`, `feature_cta_url`, `social_label`, `highlight_primary_label`, `highlight_glow_label`.
- **Storage `site-media`**: bucket público onde ficam a logo e a imagem de fundo enviadas pelo painel.

Em todas as tabelas: leitura pública (`anon`), escrita restrita a usuários `authenticated`. Não existe cadastro público — o único usuário admin é criado manualmente no painel do Supabase.

## Configurar um novo projeto Supabase (Toraflex)

1. Crie um projeto novo em [supabase.com](https://supabase.com) na conta da Toraflex.
2. Em **SQL Editor → New query**, cole e rode `supabase-schema.sql` inteiro.
3. Em **Authentication → Users → Add user**, crie o usuário administrador (e-mail + senha).
4. Em **Project Settings → API**, copie a **Project URL** e a chave **anon public** e preencha `assets/supabase-config.js`.

## Ícones disponíveis

Os ícones são SVGs embutidos (sem biblioteca externa), definidos em `<defs>` tanto em `index.html` quanto em `admin.html`. Chaves disponíveis: `whatsapp`, `globe`, `ruler`, `tag`, `sparkles`, `instagram`, `pin`, `tiktok`, `phone`, `email`, `facebook`, `youtube`, `cart`, `star`, `heart`, `calendar`, `message`, `pinterest`, `linkedin`, `x`, `telegram`, `threads`.

Para adicionar um ícone novo: crie um `<symbol id="tf-icon-SUACHAVE">` em ambos os arquivos e inclua a chave na lista `TF_ICONS` dentro de `admin.html`.

## SEO e compartilhamento

Título, descrição, favicon e imagem de Open Graph (para WhatsApp/redes sociais) já estão configurados no `<head>` de `index.html`. Ajuste o domínio das URLs de Open Graph (`https://bio.toraflex.com.br/`) caso a página seja publicada em outro endereço.

## Publicação

Envie `index.html`, `admin.html`, `supabase-schema.sql` (opcional, é só referência) e a pasta `assets/` inteira para a raiz da hospedagem.
