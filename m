Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057618;
	b=B+7FYiaQG2Ax91Sa2/aqHCePfga1ZJjwCbwjtPWVaZRaqz8SZxawY/PELV9EtKqc0DmC
	 KZ5f5+QwfTVBIJlgCv/+ijP07hg5FZnovCENEG7hOogw/qobbAG207/2tsB/8Sjg+11D/
	 uszEiwqUZJOADDSek03l2ZEj73mwpE8GKaUkqI6HVawA6hX8e2Z1gSWrDBVo8Z7YU0Asf
	 HZjms2hkMXYGnM3NP7+eGo/nPmByHy76v5S2AGhlBuCFfEwV6w8jua6AiTsakyOUTS4U9
	 4MdFbdaLZGmzzbxre0f/W+u+jZqkVKgyoguw9z6O7EIshSQsu3zXDxY+WnBjx+qbbrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SxkTl4QdPZ9h/pOM83QQjBwAV7jAxcudCP7i7Jy5L/g=;
	b=cyJIBWGfFymtcA7uKKBi6NahkNxSUJdBDBpIfvCVweZwv6Qx7AtgvPMc37zFIUK5hldr
	 JWy4blRShilH7LVlT0zGJGqtaQp2RW0pQCw/7YyBdKGWam/8rL5SsGM3xgGJPmCcKdV7f
	 SIuAJJNB2JNHM3TpKBqEDr+/Eob02jvAn0X7aouFBMuPgUbp0gLLeDVrORETcLiBAVOOR
	 A+fmOrl0uF0TAbDvfqNQ2QEY2sw9xSxwW1L6JdeEeie2VFMjRMgjTTf9hcE/IXBiS/EQ1
	 VjJS4TnELyeOfyB1LJ+5vuQvX8LZQ9EMQhJ95iANgaCLQ21OCuBpazoiAUOH04n6qwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H0RV0X/v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF4E606A33F;
	Thu, 19 Nov 2026 03:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H0RV0X/v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B731F000C4;
	Thu, 19 Nov 2026 03:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057618;
	bh=SxkTl4QdPZ9h/pOM83QQjBwAV7jAxcudCP7i7Jy5L/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0RV0X/v4Jst/DM57NDXqBtmQfHHC33d8lSS6MajCQSyw+3Y78oK+FrZGaOXh472L
	 1jYv87VYXKvr7HsmvLhq9yPNkyZcJIybSz0jfXTZEmr8L9Poby3oHjhmbg2CaS8L9c
	 59JV8cjhgxhGV58tRADJMAoZaSY/xsrDJDbaQdpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0177/1848] net: stmmac: use dma_addr_t for DMA addresses
Date: Wed, 18 Nov 2026 15:36:55 +0100
Message-ID: <20261118145918.934466164@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ba24be6e863e1..1bb3c5fa37177 100644
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
index 275b638bbc0f4..f673db338d810 100644
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



