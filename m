Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051466;
	b=SF300LU1pLy6p1xCJVeJrLBwYOoojtptTZnQCZOSrLe8uy5jmEye83GQ7bz1w0NVf7sR
	 pJilHUVYlrOWVuyvh7XJHkcyoQuI5NZ1vQqeO2A4G8W81uKV22x+vu3SdCXpBs7Dc8Eg0
	 Mj52qYpoHgGFZ3BUa4usqpkQoBCj6iIOZksAwdTtb24Xt5/Y9V9WEY7xySKDNRROZFdAc
	 Tvd5IMW+5/0BPvLIRm+f2Y/n2DsAHvOgScuB3RJtZGN3vEO+uD0Ed1uTTf36JFGb0Y68F
	 DMR1nRZAFw+Y22Mmu+NtYnA0vTiOxStZlK7W4330xwb08oarHYMrTKdtiqeIzISFK+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IKfwgbnm/o1qBMHXhhAQ1FHhRxuWOx8ymHMv7fOX8s0=;
	b=MhdP3sDXbDn4X+1lx+bHXp6rIwTPMRJCr7Dq4K8rtGyzjKN5XIzHWJ7CP0kUSJlPQ8fV
	 9/CnCMoRU+203kfCUgLRMBp1QJcbGo6VxYeSX3EEXvOZWrSP4TVKWMecAVsi2ZSP9SRaL
	 C5YHExyrWy8ToFyEES0AoNDSQcQUy2LfrmjFO+4x2NKlVbU5ZBuOunJ4ieEQm4Mryvu4x
	 dCiis24Y+i7dkgIRHbidbC8FK251LZo7CZelR2c732pat2eVzIJXSFNxzMm524bnh+nhA
	 F1r21xgZsNOH9cnZ97IrFi7sgyBsrWjNWVRASV7/7gHg3ktK0tTzcardcmCK652Mh8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQPLQWM2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AE0606A32F;
	Thu, 19 Nov 2026 01:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQPLQWM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7B21F000C8;
	Thu, 19 Nov 2026 01:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051466;
	bh=IKfwgbnm/o1qBMHXhhAQ1FHhRxuWOx8ymHMv7fOX8s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQPLQWM2vB37oClLq8xqdlv875Mv1vp7MCdrEEt1a86PJPHQ575FF24NUZBrQogzK
	 lRokrEBuW4ZIIjaihMFyq5uxzRGaPlerBPVRGdpXAu2nI6WLkX0PJs7IoZpCfIwFJM
	 mbpUFnbFwgvt8oJjxDL60GRSEkp97G0zJrgpNHP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0219/2214] net: stmmac: use dma_addr_t for DMA addresses
Date: Wed, 18 Nov 2026 15:31:35 +0100
Message-ID: <20261118150018.924174100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



