# Link Hub — Arte Mineira Móveis

O arquivo `index.html` é um fragmento pronto para o widget **HTML personalizado** do WordPress. Ele contém HTML e CSS no mesmo bloco, sem JavaScript ou bibliotecas de ícones.

## Publicação no WordPress

1. Copie todo o conteúdo do `index.html` para um widget **HTML personalizado**.
2. No template da página, desative título, cabeçalho e rodapé do tema e use um layout de largura total, se o tema oferecer essas opções.

As URLs definitivas da logo, do fundo e da assinatura SAIPH na Biblioteca de Mídia já estão configuradas no código.

O CSS usa exclusivamente o prefixo `am-` e fica contido em `.am-linkhub`, reduzindo conflitos com estilos do tema. A faixa usa `100vw` para sair do container padrão do WordPress e ocupar toda a viewport.

O único reset global é aplicado a `html` e `body`: remove margens e paddings do tema e oculta visualmente a barra de rolagem, sem impedir a navegação por rolagem.

## SEO da página

Configure no WordPress ou no plugin de SEO:

- **Título:** Arte Mineira Móveis | Links Oficiais
- **Descrição:** Acesse os canais oficiais da Arte Mineira Móveis, conheça nossos móveis em madeira de demolição e fale diretamente com nossa equipe.
- **Canonical sugerida:** `https://www.artemineiramoveis.com.br/links/`
- **Open Graph:** use o mesmo título e descrição; adicione uma imagem institucional de compartilhamento em 1200 × 630 px quando estiver disponível.
- **Favicon:** em **Aparência > Personalizar > Identidade do site**, defina a logo/ícone oficial como “Ícone do site”. O WordPress gera automaticamente os tamanhos necessários.

O título, canonical e as tags Open Graph pertencem ao `<head>` da página e, por isso, devem ser configurados pelo WordPress/plugin de SEO, não dentro do widget HTML.

## Links configurados

- Site oficial
- WhatsApp oficial: `(37) 99921-9111`
- Solicitação de orçamento por WhatsApp
- Grupo de Ofertas
- Grupo de Artesanato (URL recebida foi normalizada)
- Instagram
- TikTok
- Google Maps
