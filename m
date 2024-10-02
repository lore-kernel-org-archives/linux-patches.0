Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445791D0429;
	Wed,  2 Oct 2024 13:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875492; cv=none; b=UzVwbRUJ8S33B/Qiz6FZK1VSlj8ntOMfq1zXjv5A+3sj34yjA+N1VXVfLiCwY5Uc+o5iXCJd6aXKPyTR8A1RdJwzxIUOwPNTal7VCHX4t9xhQpMyhNuCtVmEmixrUatQfRopJfqNGK1jdNMMLMVCFGVhBQwY9zrqVN2tF3LkOzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875492; c=relaxed/simple;
	bh=wAoQRA7EU0Wd+gKFNlQrPKDz6tJYgc9/4Wv4abbrx34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXatztqOzmpBNqbDvDPhSO3ppCkaZ+LJsnFp4y20P/76a21X9xX8bHO3wBolz9n2h6dXG2jpTnUJszYB4Nw0TF/crdASUQW6IodS/f3HaHF3w7hRFLpKcebhOhWtXTViEuPvsrZZIIKP/2T6dai2JWZDCP5a6ENc/mkmqzrz8N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZUtE7wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZUtE7wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81927C4CEC5;
	Wed,  2 Oct 2024 13:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875491;
	bh=wAoQRA7EU0Wd+gKFNlQrPKDz6tJYgc9/4Wv4abbrx34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZUtE7waXgDNq7fRSDGO5rrvJfE3LZglrtjVABHcxsqBVFPHxGS3dNdtO/sdSWhmR
	 f9yJr0orAtDHtJJp05Jtg6ufoEq7aX7o2lKElogipiyikMz6FxWhobKj8HymZs1RBc
	 DL78Q0ECqBND0MdxeaEt4+YB5NbAmS6SuMOrLq0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 087/695] wifi: mt76: connac: fix checksum offload fields of connac3 RXD
Date: Wed,  2 Oct 2024 14:51:25 +0200
Message-ID: <20241002125825.953464310@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit a04b920fbc707deb699292cdae47006e8ea57d87 ]

Fix incorrect RXD offset and bitfield related to RX checksum offload.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: 4e9011fcdfc4 ("wifi: mt76: connac: move connac3 definitions in mt76_connac3_mac.h")
Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Link: https://patch.msgid.link/20240816095040.2574-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c       | 5 ++---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c       | 4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
index 353e660698409..ef003d1620a5b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
@@ -28,8 +28,6 @@ enum {
 #define MT_RXD0_MESH			BIT(18)
 #define MT_RXD0_MHCP			BIT(19)
 #define MT_RXD0_NORMAL_ETH_TYPE_OFS	GENMASK(22, 16)
-#define MT_RXD0_NORMAL_IP_SUM		BIT(23)
-#define MT_RXD0_NORMAL_UDP_TCP_SUM	BIT(24)
 
 #define MT_RXD0_SW_PKT_TYPE_MASK	GENMASK(31, 16)
 #define MT_RXD0_SW_PKT_TYPE_MAP		0x380F
@@ -80,6 +78,8 @@ enum {
 #define MT_RXD3_NORMAL_BEACON_UC	BIT(21)
 #define MT_RXD3_NORMAL_CO_ANT		BIT(22)
 #define MT_RXD3_NORMAL_FCS_ERR		BIT(24)
+#define MT_RXD3_NORMAL_IP_SUM		BIT(26)
+#define MT_RXD3_NORMAL_UDP_TCP_SUM	BIT(27)
 #define MT_RXD3_NORMAL_VLAN2ETH		BIT(31)
 
 /* RXD DW4 */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index cf36750cf7092..634c42bbf23f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -352,7 +352,7 @@ mt7925_mac_fill_rx_rate(struct mt792x_dev *dev,
 static int
 mt7925_mac_fill_rx(struct mt792x_dev *dev, struct sk_buff *skb)
 {
-	u32 csum_mask = MT_RXD0_NORMAL_IP_SUM | MT_RXD0_NORMAL_UDP_TCP_SUM;
+	u32 csum_mask = MT_RXD3_NORMAL_IP_SUM | MT_RXD3_NORMAL_UDP_TCP_SUM;
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	bool hdr_trans, unicast, insert_ccmp_hdr = false;
 	u8 chfreq, qos_ctl = 0, remove_pad, amsdu_info;
@@ -362,7 +362,6 @@ mt7925_mac_fill_rx(struct mt792x_dev *dev, struct sk_buff *skb)
 	struct mt792x_phy *phy = &dev->phy;
 	struct ieee80211_supported_band *sband;
 	u32 csum_status = *(u32 *)skb->cb;
-	u32 rxd0 = le32_to_cpu(rxd[0]);
 	u32 rxd1 = le32_to_cpu(rxd[1]);
 	u32 rxd2 = le32_to_cpu(rxd[2]);
 	u32 rxd3 = le32_to_cpu(rxd[3]);
@@ -420,7 +419,7 @@ mt7925_mac_fill_rx(struct mt792x_dev *dev, struct sk_buff *skb)
 	if (!sband->channels)
 		return -EINVAL;
 
-	if (mt76_is_mmio(&dev->mt76) && (rxd0 & csum_mask) == csum_mask &&
+	if (mt76_is_mmio(&dev->mt76) && (rxd3 & csum_mask) == csum_mask &&
 	    !(csum_status & (BIT(0) | BIT(2) | BIT(3))))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index bc7111a71f98c..fd5fe96c32e3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -435,7 +435,7 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 	u32 rxd2 = le32_to_cpu(rxd[2]);
 	u32 rxd3 = le32_to_cpu(rxd[3]);
 	u32 rxd4 = le32_to_cpu(rxd[4]);
-	u32 csum_mask = MT_RXD0_NORMAL_IP_SUM | MT_RXD0_NORMAL_UDP_TCP_SUM;
+	u32 csum_mask = MT_RXD3_NORMAL_IP_SUM | MT_RXD3_NORMAL_UDP_TCP_SUM;
 	u32 csum_status = *(u32 *)skb->cb;
 	u32 mesh_mask = MT_RXD0_MESH | MT_RXD0_MHCP;
 	bool is_mesh = (rxd0 & mesh_mask) == mesh_mask;
@@ -497,7 +497,7 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 	if (!sband->channels)
 		return -EINVAL;
 
-	if ((rxd0 & csum_mask) == csum_mask &&
+	if ((rxd3 & csum_mask) == csum_mask &&
 	    !(csum_status & (BIT(0) | BIT(2) | BIT(3))))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-- 
2.43.0



