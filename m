Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025829;
	b=13wDTyzSCnE2DGqx9dBsFiO3ygMHQMdcKrfq+qPz3xFR5kVMLK/dk5mG56I/1ABkKu49
	 haZv9FYx8vTIHHT8jocGdga6HaZ9cWbnw/uFiYZ2hi5mTCkVHZj4IyNDMawrgQ9gpsRiu
	 kYnUqIVQRfTnZSn6zhR6Uy+Mq/Lp9t+js+1UYtcxZgE/OtuhedYOEp7WAXXuofgwSS9j7
	 SqC8VkCAgrCek+t7r207C0Th0101FjBo8PE+MpXR2t2ech5y0E6RJoaeWFLOUiO8Irb4J
	 dp7ECkI/s0g3X2555ObgX1qP5RfORxeN+QnZ6H/kS8xBLkWoEYnqXw5o8lFkZhrUlzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E2JmxfsD/+dmBELOy4T/CBoJSn6i1K3uWJTzxHYQH7w=;
	b=0FLCNq2a2Y2crn99yr9HGyriLt+mwEU3JrtEeYu2zbqFcAQGLm5B2go8KrwS0JhdhzTJ
	 Mng95e9kdVh/jgBKedDZbTgyX+G3LoWIOeb5UCTWI8mvuGJCjsvBGiISJJOaime7V3mfI
	 iw1ckJptfCUWp3ahaa7O5Lfpshol+Q4IHwS+9MBzsuAA1yKBgltZMPWwVYWhKn0rJNhEU
	 JiNW+GDdjvM4U7KEWaLTecoDoy7qSHTdFecmuWarTsaxfnMKpqXtleDAetxefgz45U0d7
	 sZa3G+eU7nySV881RXxneKKpecZe60dUnJHWtJrilHEezgQYK6pd8nFhqgdJHWgYqqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+WqJu0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7463A606A325;
	Wed, 18 Nov 2026 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+WqJu0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A1E1F000C4;
	Wed, 18 Nov 2026 18:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025829;
	bh=E2JmxfsD/+dmBELOy4T/CBoJSn6i1K3uWJTzxHYQH7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+WqJu0gK7bRDrct9l5Qf7PUPS/f8k7khpyNBsLrNMppjtIWs7d5/Gzv9IZw8O1j5
	 u0u+QPYYOHSuawb1UTPX+jcl5L2BWoVn9SqKug3NJ08lpz5b5GWbQQOZiTY8WZfUi/
	 jsXO7QpcHMPz2Ero99NM3mX+TxL6jST1SKDO2OUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1218/2151] wifi: mt76: mt7996: extend CSA and CCA support for MLO
Date: Wed, 18 Nov 2026 15:49:13 +0100
Message-ID: <20261118150206.568383308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 20743b0b64d91927d1a9346341f3ecdc527c8776 ]

Use correct link_id to report CSA and CCA countdown events, and also
modify mt7996_channel_switch_beacon() to set beacon with the correct
link_id.

Co-developed-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Co-developed-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20251215063728.3013365-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: e75897e6cb8b ("wifi: mt76: mt7996: validate TLV length in mt7996_mcu_ie_countdown()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  23 ++-
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 159 ++++++++++++------
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   |   8 +-
 3 files changed, 131 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 7812f03b3d385..8aa443e768796 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -937,9 +937,30 @@ mt7996_channel_switch_beacon(struct ieee80211_hw *hw,
 			     struct cfg80211_chan_def *chandef)
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	struct mt7996_phy *phy = mt7996_band_phy(dev, chandef->chan->band);
+	struct ieee80211_bss_conf *link_conf;
+	unsigned int link_id;
 
 	mutex_lock(&dev->mt76.mutex);
-	mt7996_mcu_add_beacon(hw, vif, &vif->bss_conf, vif->bss_conf.enable_beacon);
+
+	for_each_vif_active_link(vif, link_conf, link_id) {
+		struct mt7996_vif_link *link =
+			mt7996_vif_link(dev, vif, link_id);
+
+		if (!link || link->phy != phy)
+			continue;
+
+		/* Reset beacon when channel switch triggered during CAC to let
+		 * FW correctly perform CSA countdown
+		 */
+		if (!cfg80211_reg_can_beacon(hw->wiphy, &phy->mt76->chandef,
+					     vif->type))
+			mt7996_mcu_add_beacon(hw, vif, link_conf, false);
+
+		mt7996_mcu_add_beacon(hw, vif, link_conf, true);
+		break;
+	}
+
 	mutex_unlock(&dev->mt76.mutex);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 0d35f238375c6..165535f7f49cf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -387,13 +387,117 @@ int mt7996_mcu_wa_cmd(struct mt7996_dev *dev, int cmd, u32 a1, u32 a2, u32 a3)
 				 sizeof(req), false);
 }
 
+struct mt7996_mcu_countdown_data {
+	struct mt76_phy *mphy;
+	u8 omac_idx;
+};
+
 static void
 mt7996_mcu_csa_finish(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
-	if (!vif->bss_conf.csa_active || vif->type == NL80211_IFTYPE_STATION)
+	struct mt7996_mcu_countdown_data *cdata = (void *)priv;
+	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	struct ieee80211_bss_conf *link_conf = NULL;
+	unsigned long valid_links = vif->valid_links ?: BIT(0);
+	unsigned int link_id;
+
+	if (vif->type == NL80211_IFTYPE_STATION)
+		return;
+
+	for_each_set_bit(link_id, &valid_links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct mt76_vif_link *mlink =
+			rcu_dereference(mvif->mt76.link[link_id]);
+
+		if (mlink && mlink->band_idx == cdata->mphy->band_idx &&
+		    mlink->omac_idx == cdata->omac_idx) {
+			link_conf = rcu_dereference(vif->link_conf[link_id]);
+			break;
+		}
+	}
+
+	if (!link_conf || !link_conf->csa_active)
 		return;
 
-	ieee80211_csa_finish(vif, 0);
+	ieee80211_csa_finish(vif, link_conf->link_id);
+}
+
+static void
+mt7996_mcu_cca_finish(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt7996_mcu_countdown_data *cdata = (void *)priv;
+	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	struct ieee80211_bss_conf *link_conf = NULL;
+	unsigned long valid_links = vif->valid_links ?: BIT(0);
+	unsigned int link_id;
+
+	if (vif->type == NL80211_IFTYPE_STATION)
+		return;
+
+	for_each_set_bit(link_id, &valid_links, IEEE80211_MLD_MAX_NUM_LINKS) {
+		struct mt76_vif_link *mlink =
+			rcu_dereference(mvif->mt76.link[link_id]);
+
+		if (mlink && mlink->band_idx == cdata->mphy->band_idx &&
+		    mlink->omac_idx == cdata->omac_idx) {
+			link_conf = rcu_dereference(vif->link_conf[link_id]);
+			break;
+		}
+	}
+
+	if (!link_conf || !link_conf->color_change_active)
+		return;
+
+	ieee80211_color_change_finish(vif, link_conf->link_id);
+}
+
+static void
+mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
+{
+#define UNI_EVENT_IE_COUNTDOWN_CSA 0
+#define UNI_EVENT_IE_COUNTDOWN_BCC 1
+	struct header {
+		u8 band;
+		u8 rsv[3];
+	};
+	struct mt7996_mcu_rxd *rxd = (struct mt7996_mcu_rxd *)skb->data;
+	const char *data = (char *)&rxd[1], *tail;
+	struct header *hdr = (struct header *)data;
+	struct tlv *tlv = (struct tlv *)(data + 4);
+	struct mt7996_mcu_countdown_notify *event;
+	struct mt7996_mcu_countdown_data cdata;
+
+	if (hdr->band >= ARRAY_SIZE(dev->mt76.phys))
+		return;
+
+	cdata.mphy = dev->mt76.phys[hdr->band];
+	if (!cdata.mphy)
+		return;
+
+	tail = skb->data + skb->len;
+	data += sizeof(*hdr);
+	while (data + sizeof(*tlv) < tail && le16_to_cpu(tlv->len)) {
+		event = (struct mt7996_mcu_countdown_notify *)tlv->data;
+
+		cdata.omac_idx = event->omac_idx;
+
+		switch (le16_to_cpu(tlv->tag)) {
+		case UNI_EVENT_IE_COUNTDOWN_CSA:
+			ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+					IEEE80211_IFACE_ITER_RESUME_ALL,
+					mt7996_mcu_csa_finish, &cdata);
+			break;
+		case UNI_EVENT_IE_COUNTDOWN_BCC:
+			ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+					IEEE80211_IFACE_ITER_RESUME_ALL,
+					mt7996_mcu_cca_finish, &cdata);
+			break;
+		default:
+			break;
+		}
+
+		data += le16_to_cpu(tlv->len);
+		tlv = (struct tlv *)data;
+	}
 }
 
 static void
@@ -492,57 +596,6 @@ mt7996_mcu_rx_log_message(struct mt7996_dev *dev, struct sk_buff *skb)
 	wiphy_info(mt76_hw(dev)->wiphy, "%s: %.*s", type, len, data);
 }
 
-static void
-mt7996_mcu_cca_finish(void *priv, u8 *mac, struct ieee80211_vif *vif)
-{
-	if (!vif->bss_conf.color_change_active || vif->type == NL80211_IFTYPE_STATION)
-		return;
-
-	ieee80211_color_change_finish(vif, 0);
-}
-
-static void
-mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
-{
-#define UNI_EVENT_IE_COUNTDOWN_CSA 0
-#define UNI_EVENT_IE_COUNTDOWN_BCC 1
-	struct header {
-		u8 band;
-		u8 rsv[3];
-	};
-	struct mt76_phy *mphy = &dev->mt76.phy;
-	struct mt7996_mcu_rxd *rxd = (struct mt7996_mcu_rxd *)skb->data;
-	const char *data = (char *)&rxd[1], *tail;
-	struct header *hdr = (struct header *)data;
-	struct tlv *tlv = (struct tlv *)(data + 4);
-
-	if (hdr->band >= ARRAY_SIZE(dev->mt76.phys))
-		return;
-
-	if (hdr->band && dev->mt76.phys[hdr->band])
-		mphy = dev->mt76.phys[hdr->band];
-
-	tail = skb->data + skb->len;
-	data += sizeof(struct header);
-	while (data + sizeof(struct tlv) < tail && le16_to_cpu(tlv->len)) {
-		switch (le16_to_cpu(tlv->tag)) {
-		case UNI_EVENT_IE_COUNTDOWN_CSA:
-			ieee80211_iterate_active_interfaces_atomic(mphy->hw,
-					IEEE80211_IFACE_ITER_RESUME_ALL,
-					mt7996_mcu_csa_finish, mphy->hw);
-			break;
-		case UNI_EVENT_IE_COUNTDOWN_BCC:
-			ieee80211_iterate_active_interfaces_atomic(mphy->hw,
-					IEEE80211_IFACE_ITER_RESUME_ALL,
-					mt7996_mcu_cca_finish, mphy->hw);
-			break;
-		}
-
-		data += le16_to_cpu(tlv->len);
-		tlv = (struct tlv *)data;
-	}
-}
-
 static int
 mt7996_mcu_update_tx_gi(struct rate_info *rate, struct all_sta_trx_rate *mcu_rate)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 29e8f6d64ede3..dab900c98154e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -52,12 +52,10 @@ struct mt7996_mcu_thermal_enable {
 	u8 rsv[2];
 } __packed;
 
-struct mt7996_mcu_csa_notify {
-	struct mt7996_mcu_rxd rxd;
-
+struct mt7996_mcu_countdown_notify {
 	u8 omac_idx;
-	u8 csa_count;
-	u8 band_idx;
+	u8 count;
+	u8 csa_failure_reason; /* 0: success, 1: beacon disabled */
 	u8 rsv;
 } __packed;
 
-- 
2.53.0



