Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061025;
	b=OBx22DEjTuDnTCVRHAK0LCWU6uyQjPzXzVPBsXrwGoVywPzjsXA5GBAb3euxK8i8PrUT
	 ID+0HvEXP0Z2pKMBti0DXnbNwWbrHUvgjlbdtBfOvP2B5M4M1VlgwAUijjpuaEnYzzWpC
	 621IPsGyHsEITudexVv2zVljxWHLRIOatQDqX5vi8YzKQfnWmiQ3D/8Ngcj5m2wm0GJxj
	 x7O/cl+NYJxTTINHSsj3IZyfsEgfKFIMdKTD83GOzC7r4xBDaXppxFyf4+NnF7suSx0bJ
	 akvlg6sCYM9ufMJZgVMj8RhHkNLuPN9IjwkotQuoYtUjkyAbFP5bHEE9dk+wBgU8pkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hxroqzSDZ8iDSnL3uzAmo8tLSDZpBU3R8TzYGmnFQWc=;
	b=L5toCnlEgnFSQ5XqR7VNZN9JFZiQQHKvc2V7mLDfXTBRag4x9VE87qvjl2L+doXUzg7Y
	 7I7KigaB1KYBDNVmaMkBR1YFjHRfQgkJePyf5Rn8P1DB5LjlKlUg0G5NsAv/QxVFvBK3i
	 PMammPK5YAatZdQ9p4qm9R/pymI3F1EpgtSD1srFznsPLgnSnIQY8eOuTHLWqJgw5VUDV
	 yhbc609suFOI6oRPoNtlxZWnrY1utd4q6EpfpG8juN8FK/EE0tIMYsuRCuctcJnSstGBx
	 Jr71KinaFhkGO7hAfs2xuqHPofL5FrZJL6xJdA+YsXDPfXkp+gCcI33NWSkWmXCMi5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGIfkTjX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67DB606EEA8;
	Sat,  7 Nov 2026 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NGIfkTjX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADA41F0089F;
	Sat,  7 Nov 2026 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061024;
	bh=hxroqzSDZ8iDSnL3uzAmo8tLSDZpBU3R8TzYGmnFQWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGIfkTjXEQNjk7VYn8gHJPRNDwPiX6jsiITogCPirVAQMvBhXklAnJrCPr4TGqIbB
	 29gPe2usuAMeFfoK/W3cFCg7utg58VnSe5ajgBt5R7qE6+d8F+HxXWfRchU+0x4d6I
	 IMSCcVWBMFDCfMebc9lho50TkB0jtuc5Qssa2IW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0361/1536] net: stmmac: use dma_addr_t for DMA addresses
Date: Sat,  7 Nov 2026 08:39:37 -0500
Message-ID: <20261107135007.796406029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



