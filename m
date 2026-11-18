Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032634;
	b=TTWhtvtuRhesTToLXTlIPldEJrMu7gFbh0+nTMPFMMnzpVXDWT1PA6evT7x/LsuFXSWr
	 FcSKEzhvbEbDZoELicGPCw5AyqZbnmVFOQWar1HJelyuK3CWo/DtFnCqOCWmzkkVWmy5M
	 XYC/wZOk190PaxTTJja6ICQCtFCf2F6gk+1jl2qd+35stsQ5qcxIz61v2v5qZsfF1Rhmk
	 o4PNo+t9v0+MGGxxZAEYGocSXqWMl5a91rrmj1zmd54+LFrtcs6U6HCfq2L4yrmFIFjNS
	 uOClMOt6r90nUanTTtkhod8B+72314OeBZsu9ey4YD/tqHwTiYECUPV5AxbqJY3n/2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dcpPganWuU7v/o6Yz8b7hco/rEwF2Hrv8D0FbU4z54E=;
	b=oonhng/j8hvtp4e2nYFDo5RKzOnoPkwTLF6z8FJMIhfN1A+cULb2xKOFO1rZTCImYOBy
	 I+aASz3trDC9i4YluaLg8oCzggZyAE9r4JbuNwkuUqyAla84tvPTLS+biPTpxoAsE9I6N
	 7JHokmWQmRfZnZI5HFglcf1BsN9i25jlzy32HcSRZnBGudByePAx1S7CoH+G8B/aSu+aH
	 Cn57n0LLHNdFV8pT+VIXCdst98H96UevDgffs7tK87d91KLKMz/J8IP1bS01P4RuHw5to
	 J8rmZqo3iPX3qKm5AscfH5RHofQSLO8UCi7ALA+9S5eW/Vtjoj/plGVCf1Tvfe0ojzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru6whWjl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16BD606A32A;
	Wed, 18 Nov 2026 20:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru6whWjl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125AE1F000C4;
	Wed, 18 Nov 2026 20:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032634;
	bh=dcpPganWuU7v/o6Yz8b7hco/rEwF2Hrv8D0FbU4z54E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ru6whWjlOkUe/lOOxs86XBFrO+VhyD3nSVVQ4amQWM6qbq3jxv/k/bjH+9k5sh8yF
	 eN19Nk+0vXNGlE8IRSiOYWjWFQQZcKlY260L/Y0Bz4rNx1H2GBE9BHXaoSmNzQoiN3
	 ToyZ5KZ/sc98vuYeSrf1SvG15qdTr2KNYVsbIb1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1464/1756] net: stmmac: Drop useless code related to ethtool rx-copybreak
Date: Wed, 18 Nov 2026 15:59:51 +0100
Message-ID: <20261118150107.334305415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Furong Xu <0x1207@gmail.com>

[ Upstream commit 5c98e89d96ecbf0e4ed38a20c46727c0ed2c112b ]

After commit 2af6106ae949 ("net: stmmac: Introducing support for Page
Pool"), the driver always copies frames to get a better performance,
zero-copy for RX frames is no more, then these code turned to be
useless and users of ethtool may get confused about the unhandled
rx-copybreak parameter.

This patch mostly reverts
commit 22ad38381547 ("stmmac: do not perform zero-copy for rx frames")

Signed-off-by: Furong Xu <0x1207@gmail.com>
Link: https://patch.msgid.link/20241218083407.390509-1-0x1207@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9dd534187819 ("net: stmmac: Track the TX DMA threshold per queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 -
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 39 -------------------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  5 ---
 3 files changed, 46 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 0e85170f6191d..041f43008ce8b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -125,7 +125,6 @@ struct stmmac_rx_queue {
 	unsigned int cur_rx;
 	unsigned int dirty_rx;
 	unsigned int buf_alloc_num;
-	u32 rx_zeroc_thresh;
 	dma_addr_t dma_rx_phy;
 	u32 rx_tail_addr;
 	unsigned int state_saved;
@@ -273,7 +272,6 @@ struct stmmac_priv {
 	int sph_cap;
 	u32 sarc_type;
 
-	unsigned int rx_copybreak;
 	u32 rx_riwt[MTL_MAX_TX_QUEUES];
 	int hwts_rx_en;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index ca8712a573ea0..5d94de4670557 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -1225,43 +1225,6 @@ static int stmmac_get_ts_info(struct net_device *dev,
 		return ethtool_op_get_ts_info(dev, info);
 }
 
-static int stmmac_get_tunable(struct net_device *dev,
-			      const struct ethtool_tunable *tuna, void *data)
-{
-	struct stmmac_priv *priv = netdev_priv(dev);
-	int ret = 0;
-
-	switch (tuna->id) {
-	case ETHTOOL_RX_COPYBREAK:
-		*(u32 *)data = priv->rx_copybreak;
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-static int stmmac_set_tunable(struct net_device *dev,
-			      const struct ethtool_tunable *tuna,
-			      const void *data)
-{
-	struct stmmac_priv *priv = netdev_priv(dev);
-	int ret = 0;
-
-	switch (tuna->id) {
-	case ETHTOOL_RX_COPYBREAK:
-		priv->rx_copybreak = *(u32 *)data;
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
 static int stmmac_get_mm(struct net_device *ndev,
 			 struct ethtool_mm_state *state)
 {
@@ -1388,8 +1351,6 @@ static const struct ethtool_ops stmmac_ethtool_ops = {
 	.set_per_queue_coalesce = stmmac_set_per_queue_coalesce,
 	.get_channels = stmmac_get_channels,
 	.set_channels = stmmac_set_channels,
-	.get_tunable = stmmac_get_tunable,
-	.set_tunable = stmmac_set_tunable,
 	.get_link_ksettings = stmmac_ethtool_get_link_ksettings,
 	.set_link_ksettings = stmmac_ethtool_set_link_ksettings,
 	.get_mm = stmmac_get_mm,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a05a6ebb15433..ddaf43cdfc339 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -76,7 +76,6 @@ module_param(phyaddr, int, 0444);
 MODULE_PARM_DESC(phyaddr, "Physical device address");
 
 #define STMMAC_TX_THRESH(x)	((x)->dma_conf.dma_tx_size / 4)
-#define STMMAC_RX_THRESH(x)	((x)->dma_conf.dma_rx_size / 4)
 
 /* Limit to make sure XDP TX and slow path can coexist */
 #define STMMAC_XSK_TX_BUDGET_MAX	256
@@ -107,8 +106,6 @@ static int buf_sz = DEFAULT_BUFSIZE;
 module_param(buf_sz, int, 0644);
 MODULE_PARM_DESC(buf_sz, "DMA buffer size");
 
-#define	STMMAC_RX_COPYBREAK	256
-
 static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 				      NETIF_MSG_LINK | NETIF_MSG_IFUP |
 				      NETIF_MSG_IFDOWN | NETIF_MSG_TIMER);
@@ -3929,8 +3926,6 @@ static int __stmmac_open(struct net_device *dev,
 		}
 	}
 
-	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
-
 	buf_sz = dma_conf->dma_buf_sz;
 	for (int i = 0; i < MTL_MAX_TX_QUEUES; i++)
 		if (priv->dma_conf.tx_queue[i].tbs & STMMAC_TBS_EN)
-- 
2.53.0



