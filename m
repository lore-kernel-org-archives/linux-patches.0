Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACFA1D0BB3;
	Wed,  2 Oct 2024 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877433; cv=none; b=UOK8OCtmODkT9ftiStjLYwjT2NOVIWZk+OVxLWqu6pjw46yKAdpTDwRGmfGOASdIYfHbV40CzIQ6Ob8+rdr13/dTCgCFNityeV97NNHFQOe0pTz9xfO1HFARll9sSWEeCdnIPOl7oMB8ytbDACRAwQoNHNrrTk6+bVYM5mX6X7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877433; c=relaxed/simple;
	bh=XjM5juI43K49LJkD9od3d2j8rIDQYruOM74wyf3tJME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjNRyivtLZQ4rHfAKxDA7HUbW0JfC/d1Gis7bPkLwP5LCvcRkjVuIaeaPvsFdPJKlDRY3+juq6CWs6fjIfOLp26TKFCL3Wfdn4DYEaMZ1QE9tHUjNG5NwiXvixtoQVmg6c+KtfLCo7MKcqYl07nMlXY45wre75Y0sPHWPyjsjWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScmbR/Gw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScmbR/Gw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98086C4CEF6;
	Wed,  2 Oct 2024 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877433;
	bh=XjM5juI43K49LJkD9od3d2j8rIDQYruOM74wyf3tJME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScmbR/GwYEtBU3z1cui9ERAQlUikgvnorHJBUSCnR2mP0aKzOJfCVurX/6HI9YpUI
	 lHTyligijpEtLKZkx7xaaaFGYENRrolbzXlxxoNT6fNGY4i49+PcEUylNdQQVcFVkV
	 67A5Pj76VzUwn8XYEXp/HYKWRnpuLA9ZrBoBDW+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 077/634] wifi: mt76: connac: fix checksum offload fields of connac3 RXD
Date: Wed,  2 Oct 2024 14:52:57 +0200
Message-ID: <20241002125814.148295871@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c2460ef4993db..e9d2d0f22a586 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -350,7 +350,7 @@ mt7925_mac_fill_rx_rate(struct mt792x_dev *dev,
 static int
 mt7925_mac_fill_rx(struct mt792x_dev *dev, struct sk_buff *skb)
 {
-	u32 csum_mask = MT_RXD0_NORMAL_IP_SUM | MT_RXD0_NORMAL_UDP_TCP_SUM;
+	u32 csum_mask = MT_RXD3_NORMAL_IP_SUM | MT_RXD3_NORMAL_UDP_TCP_SUM;
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	bool hdr_trans, unicast, insert_ccmp_hdr = false;
 	u8 chfreq, qos_ctl = 0, remove_pad, amsdu_info;
@@ -360,7 +360,6 @@ mt7925_mac_fill_rx(struct mt792x_dev *dev, struct sk_buff *skb)
 	struct mt792x_phy *phy = &dev->phy;
 	struct ieee80211_supported_band *sband;
 	u32 csum_status = *(u32 *)skb->cb;
-	u32 rxd0 = le32_to_cpu(rxd[0]);
 	u32 rxd1 = le32_to_cpu(rxd[1]);
 	u32 rxd2 = le32_to_cpu(rxd[2]);
 	u32 rxd3 = le32_to_cpu(rxd[3]);
@@ -418,7 +417,7 @@ mt7925_mac_fill_rx(struct mt792x_dev *dev, struct sk_buff *skb)
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



