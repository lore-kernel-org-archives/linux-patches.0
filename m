Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA8C2F363F;
	Wed, 20 May 2026 17:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299438; cv=none; b=Hztxn//AUTica51nMoKUYgtEfbfdJxgtBcpUOlIq20k8NaaA9kkN+MpnaqqnUYru35FzKQc/I1/8zBeBzdsKKMPftEAe04IwwXTWKjOTSbGYfvO7628lcI58M6GBz4vypYBhiMCpVcM66O+llH3ja4Cv1YdVABXEGM/b7rYDPoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299438; c=relaxed/simple;
	bh=W0uvDuCx81D2HqWHaRSQPZFAoGOnv7DGgmNT4gHsbbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nG/B2GclPdY5zY1cNkJ5Y1bypXBQ1ydcyw0/Ca03etfJiiwt1prWNFsA8w5h/roKSQJDftSXJRE53hI5H9pRmOMHxAaTl8F6r07Zr02dXi5TPx7tfy+atjHhO0AgbYoOi4QtuIovzwEtvoWUyZyu3AIryfcUQtRJh0SK9pBjvQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocb43PnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocb43PnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13E21F000E9;
	Wed, 20 May 2026 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299437;
	bh=SGpYBBGjEq5lifxPnIQGBmy8m3cX2hwvdM9NRkWiYEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocb43PnSld4VnlDcVqD/F90+ubFFsKkEdTb1seBmB36RUEa6eOR87ovGg0+x7bPG1
	 YuYs+KepS5IJxdh9U3jdpL0iUj+A2eb/30rvxqw7R33cWE3+NucOMyhmxq6jl/Xy6w
	 AMm02QuSnrZh7WqrIA3E41tc3DiNEeE1GeeHaPqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengping Zhang <aquapinn@qq.com>,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 772/957] net: airoha: fix typo in function name
Date: Wed, 20 May 2026 18:20:55 +0200
Message-ID: <20260520162151.304568404@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengping Zhang <aquapinn@qq.com>

[ Upstream commit aebf15e8eb09b01e99f043e9f5d423798aac9d32 ]

Corrected the typo in the function name from
 `airhoa_is_lan_gdm_port` to `airoha_is_lan_gdm_port`. This change ensures
 consistency in the API naming convention.

Signed-off-by: Zhengping Zhang <aquapinn@qq.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/tencent_E4FD5D6BC0131E617D848896F5F9FCED6E0A@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e070aac63b42 ("net: airoha: Do not wake all netdev TX queues in airoha_qdma_wake_netdev_txqs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 drivers/net/ethernet/airoha/airoha_eth.h | 2 +-
 drivers/net/ethernet/airoha/airoha_ppe.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index fd612cc339e13..9691b4134285f 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -76,7 +76,7 @@ static void airoha_set_macaddr(struct airoha_gdm_port *port, const u8 *addr)
 	struct airoha_eth *eth = port->qdma->eth;
 	u32 val, reg;
 
-	reg = airhoa_is_lan_gdm_port(port) ? REG_FE_LAN_MAC_H
+	reg = airoha_is_lan_gdm_port(port) ? REG_FE_LAN_MAC_H
 					   : REG_FE_WAN_MAC_H;
 	val = (addr[0] << 16) | (addr[1] << 8) | addr[2];
 	airoha_fe_wr(eth, reg, val);
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 28dfa35a3abed..abd996492cb7f 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -627,7 +627,7 @@ u32 airoha_rmw(void __iomem *base, u32 offset, u32 mask, u32 val);
 #define airoha_qdma_clear(qdma, offset, val)			\
 	airoha_rmw((qdma)->regs, (offset), (val), 0)
 
-static inline bool airhoa_is_lan_gdm_port(struct airoha_gdm_port *port)
+static inline bool airoha_is_lan_gdm_port(struct airoha_gdm_port *port)
 {
 	/* GDM1 port on EN7581 SoC is connected to the lan dsa switch.
 	 * GDM{2,3,4} can be used as wan port connected to an external
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 6cd5febce6b59..005128717a45c 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -331,7 +331,7 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 			/* For downlink traffic consume SRAM memory for hw
 			 * forwarding descriptors queue.
 			 */
-			if (airhoa_is_lan_gdm_port(port))
+			if (airoha_is_lan_gdm_port(port))
 				val |= AIROHA_FOE_IB2_FAST_PATH;
 			if (dsa_port >= 0)
 				val |= FIELD_PREP(AIROHA_FOE_IB2_NBQ,
-- 
2.53.0



