Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034247;
	b=5FN/0BU7SlQCnWjQLKOkR5k33Bu5so/m1d+1UOTTqywlRud8tr4ODY1iXN9kCYkhIGOw
	 y1SRquHi5VSVyBuTh6w6ft0Wkl6MBlC492v1YCMUUq0tPeSc9SAXxw6oGEk1fRyWpkBFB
	 nvN60e7CIZgcLuuNU3yNiS248k1/WUPSpgURn/AsvLOjQvVdpDrqLReppD27vl0zjMnMB
	 SJnLdEOPDdyhS/Y8cZOTM8Wy5JnFpFGcB2lXqGfzPZ4Cwryirumo4KekJFj2UiEMpgaC/
	 RdL5F1i+YJawq84IGHkzRobjpIqtaR/hncAeftqQu65hhWXtygscq68b6KxETTv2BpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kh+wGehtMaXMGjVRJcQIhkYw5RT/CJKB7yRTl2vwRQ8=;
	b=Cxwm/c9qzwNxdCeq4bIQjFZ71wkSp12ciQS/F4ZM/J5bscvnM3mqB0Odn6J5+Xc+2sTS
	 uizCk98RiDqqEw0LGgfDQDGHFOLe02ZSu2yvQJXBQwt1Tn6+HcZWFxtCjZ0LB22Vm6suw
	 W7YnQMlbFYICACv2z/wcLY2ZFi5T4r06YxhxpVdrnSM+lOCqMCkG8wbfWYpOmIBsVcbVC
	 0mK1aOV/eF9g1qNZK3bJrLDSP/CLAQz+DSSB+KzHUVqEiT0Me/7XiazxvQVIqYdQXjyHw
	 QwtnuOBClyBtCi0z4xM6PM+DHecjMNOtXhdT7ItW+zfYZsG5JlyeyWOabrb15ZZ7kmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w32CqO6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BFF606A332;
	Wed, 18 Nov 2026 20:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w32CqO6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30481F000C4;
	Wed, 18 Nov 2026 20:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034247;
	bh=kh+wGehtMaXMGjVRJcQIhkYw5RT/CJKB7yRTl2vwRQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w32CqO6gMfkBfHY4S84hrlJhBXRvKN38RYRkmVFXYT5NqRWwDxpHzCOcLhhfmKXZ2
	 94AwnzTR7HHtiPE/2e9DLlipD+XFvqWfUbM13vOMUUsKnUH618oEkdWeA4EZWifki1
	 MWuJZdL9HJgoZw6Ng7fYI23L+Idw7bJCaaroGzfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0303/3318] net: stmmac: use dma_addr_t for DMA addresses
Date: Wed, 18 Nov 2026 15:15:25 +0100
Message-ID: <20261118150324.831163679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



