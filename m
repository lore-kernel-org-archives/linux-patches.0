Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043572;
	b=2nQqrxBzBl7u4odZ0mjximnrSNM5rpHixyLUPCZiNslZlGgDDo00lM3lup0/FOXdbfB0
	 1yDVDi2Qxc3PYubFlAqxdKq9DMbm5Jkyuv/sY3hHNJyOnPfgiC/IUu8aHdOhHf9qi9jyA
	 P0YTuvoGBwJG143NZpm5FBKvGkXGXEJjopd0N+D5rF2oiqlFtgd+Z+mb1Rc7dpOglq4BK
	 8dJOEmEqsEQBP46TE2Qiw2UM+XpeypbGa+Mn9xZsMXjaeQi6rjszwX2vEU+eVfLobjuwE
	 kYKvtJu/64GWCS14xpXbLKUqUFd0HvBHq2LZj4BtFbloS+t0/QRrSgRYRzRtmeRrPtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MLa0W27kiE37NJMMhnXUTTrsXVUPUIV9cdMq9FpxM0s=;
	b=SbdnjsORIzDCin0yYdjbUEcSV9dIlsZZtX9+Ky5lubielTeGYh+hg3WnSpo8nouTlLNU
	 sj0g2SH52NPcl9duZBoBjGt/HZU7vFWkcZsNrVBtTmqvsNZgnV69dCksU/U0Rcy1OiWyL
	 MC11C7r7aVV8NokOhdmHEjwMnUSSbzJgTQdYKiSrOOmPkdUHuNJbJ85BN1kry2Qm2E3UT
	 zVhvI0A5f/+vPZid6DBwOKmzUa4iT1GW9HGEn8US6JN6BSDO3wW43uSTK3OUs8p7T2Zqj
	 Bmfa7n20t63ia7hI1RPgDRBvTVWvjGpMUrVpc5JQ8xcvB1udCO/O8EHI4GBtZKSqcWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRviCiH1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8541606A320;
	Wed, 18 Nov 2026 23:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRviCiH1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CFF1F000C4;
	Wed, 18 Nov 2026 23:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043571;
	bh=MLa0W27kiE37NJMMhnXUTTrsXVUPUIV9cdMq9FpxM0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRviCiH1OPH/zBJwzL5F0XVoL88UnlQvy8ripb0KNh32KnfTtVoT8Lo7H6ez2y/zQ
	 eakGFzTruXc99nYLFTa+9H/CsmfvHCGoMFmxhhCfoUxBWBTuKgHcVaU+qt1HaHZhwC
	 C9Y+zNKIGNSg5wmI1QniMCgkCWKbv5zSJ7MIE5ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0258/2857] net: stmmac: use dma_addr_t for DMA addresses
Date: Wed, 18 Nov 2026 15:21:32 +0100
Message-ID: <20261118150210.721663114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



