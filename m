Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831030;
	b=W+fRZv8VfO2Y12qr2ZIZjuarUrJ3V2F4oT51hgQs7ye4f79Xc7KzPclHgNAzK6jGhJBa
	 Xpj3k9wlhggi4ZuzhbssnZdpY6XSyO5/vruzjSR4/JU8fb4P1VBUvtOqkd2bEoNe79cgB
	 REOcXBT/GQZUvil4bU4TuQJISfdqJn2itG3Z9Qe9+YmwH614bZ4eeODIgmxfcSKizeXBm
	 kn23DGHGk58OEBjwZV/Nv25fdMFhg0pjVpoeY7vhyEkEpYKQVB6MGjHFMKKazgGUO9y4U
	 FBU24L9VUznbJCB72w2MyG4hjVM9OPbGvYs1AN8UWLn8fxtOuMzT4nKSs73edmYNfzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ecBl54rkYjVoZECeIJ0MSxo2CGC2tBOSfavjRHldrwc=;
	b=p/r3aLANBVb+O/AAIHkvgeeGOyEzOdKjMcHIirE6lsAWv1JZu47Y+IKp6t24sqIyFNcu
	 Xo6rE2oROBwngpC4xBnTGOV6aGSt68f/mupd41beEo5VQ8KmkWW6y4FKfEpSuIfQpnHtY
	 R9t5xflu59L8t/N2bG5UyHrQVu/gmsi9nL9ldjTmN3sZEN8d4iwRF1+/uVjDMAgumA6Yw
	 XnaO6DuMh9qrAjH+lOusPlhwIABAZF1L0kVBmRsXdlL/jC8YxchM9qLeJUgslBgSCQkz8
	 aakqlKt+vaP1dnfJGPwV5iSM81is1lafehnoUNyE5Qu2XQqkZ9Md6L9XSAVG5G40Wrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xB37EeCU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E3F606A843;
	Wed,  4 Nov 2026 22:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xB37EeCU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2741F000C1;
	Wed,  4 Nov 2026 22:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831029;
	bh=ecBl54rkYjVoZECeIJ0MSxo2CGC2tBOSfavjRHldrwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xB37EeCUrMAcSpYqqYOYOpjkxbDyc3X0K9jrcvo++eVujfTKFhA2oUUrYz7Soa+Gl
	 Jz8zquAL6UjieSwYvteApzyz3wRxuL7naRW2YsQD4X/4LOhOEVQERRqdzjc0zoiKBA
	 jzZ/nbGQyVlZpnS8NwsFwmY6uQVeSizLMKf405cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0428/1005] net: stmmac: use dma_addr_t for DMA addresses
Date: Wed,  4 Nov 2026 16:02:41 -0500
Message-ID: <20261104211056.087858248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@riscstar.com>

[ Upstream commit 0c1f9020d2ada55aed8a2e055903ad9cd5d49dab ]

In jumbo_frm() (implemented in both "chain_mode.c" and "ring_mode.c"),
an unsigned integer local variable is used to hold the value returned
by dma_map_single().  On systems where a dma_addr_t is 64 bits, the
subsequent dma_mapping_error() check of the returned value operates
only on the low 32 bits (whose high bit won't be sign-extended).  In
this case, dma_mapping_error() would return 0 (no error) even if there
were one.

Fix this in both spots by using a dma_addr_t for the local variable.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-devicetree/20260606010122.21A211F00899@smtp.kernel.org/
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20260812163832.271742-2-elder@riscstar.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c | 3 ++-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
index 2515608878235..5b0bab33ce4b6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
@@ -20,9 +20,10 @@ static int jumbo_frm(struct stmmac_tx_queue *tx_q, struct sk_buff *skb,
 	unsigned int nopaged_len = skb_headlen(skb);
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->cur_tx;
-	unsigned int bmax, buf_len, des2;
+	unsigned int bmax, buf_len;
 	unsigned int i = 1, len;
 	struct dma_desc *desc;
+	dma_addr_t des2;
 
 	desc = tx_q->dma_tx + entry;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
index 88a8d22812f5d..1e6541937cb27 100644
--- a/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/ring_mode.c
@@ -20,8 +20,9 @@ static int jumbo_frm(struct stmmac_tx_queue *tx_q, struct sk_buff *skb,
 	unsigned int nopaged_len = skb_headlen(skb);
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->cur_tx;
-	unsigned int bmax, len, des2;
+	unsigned int bmax, len;
 	struct dma_desc *desc;
+	dma_addr_t des2;
 
 	if (priv->extend_desc)
 		desc = (struct dma_desc *)(tx_q->dma_etx + entry);
-- 
2.53.0



