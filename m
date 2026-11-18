Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041003;
	b=cZZVjOPjBjHFFcwM9pM3w/TMwiuoUMCzQVQpWtOUiFXAtunWaDLhrdL8DogxmsbgGPrI
	 msrdqTCqhrY0OabDhdS4tqePUkHLxElW/+mRieh91brZ2RNgR0DMwtu1yFDXxuqwzovuU
	 eInSg0/YsncrmAU30MuyKZACUL7ynrnYhY2ohVL6/mtg2YY1uMllZujxEpKe/DvtiBXJr
	 3JNgKk/VwMT3hiUHnB+1zcxlM5dK++YJKhR2cqGLyTAazJBflyvauk77Qzi+Xi4zFYQr6
	 nNzMMI0IgOfITRrzcZc+JCx0rspra+rgFXZhmhV/mwEwx11y8Ci4aJkTzXFKm9fAILw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QkiefCXC+60ZprGdc9oYJ6PyL4zl7uFV3utgfbG89Kg=;
	b=ePDRwexXfBudjhMoaw0PMkHhI5K9rx4BKzoAZJ8+jg+Z2l137p8O5Xj9RcSb1L9BcQj5
	 D15CDN6HvlUioNlg1mtDLttWpwMDgNgjXr7PlzBgL/EJDnrcnnUe3RX9DsDiercoFMacR
	 JE2326Ba+A/1C2Hy0SBZlkzrK3B7rgnwKE8K0V6MCKSggwOCMDzZwM1JTW1tMrM1GND6c
	 0a9MqXUbDRblOzlDFtcsOzSaMbXc+CYsAiVxeoPfir8Aa9sKcSR5pnDQMoIjNff5ZzxnS
	 FcGiM7MdNNHvUcZhITk6Wj+xigIaOOn0v5a5d2PAxKyUCm+DpG41nalNa6OMEnJIvNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=somLffFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E73E606A32C;
	Wed, 18 Nov 2026 22:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=somLffFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFF51F000C4;
	Wed, 18 Nov 2026 22:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041003;
	bh=QkiefCXC+60ZprGdc9oYJ6PyL4zl7uFV3utgfbG89Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=somLffFTOPRu2SHRINUInPYJ734lC5BtfnnIahYc7IoDFq+4sAqAcde9iKO3JlN3/
	 mFNy492u2pO1OOQAWlw+sbrRVJOABhpS7KvgXKS33YrfqviWN6JsAWuMykbDxw8uxm
	 DTX0AdD0lalfA9yk3le68Ryy4nRyTu4pHmt73fk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2657/3318] wifi: mt76: mt7996: switch to mcu command for TX GI report
Date: Wed, 18 Nov 2026 15:54:39 +0100
Message-ID: <20261118150440.746186365@linuxfoundation.org>
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

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit d57e1b255475957ab9280f8a2a6119853aef4d05 ]

During runtime, the GI value in the WTBL is not updated in real-time. To
obtain the latest results for the TX GI, switch to use an MCU command.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: c88f880c6430 ("wifi: mt76: mt7996: validate firmware event lengths before parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  2 +-
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 48 ++-----------------
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  1 +
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 47 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   | 22 +++++++++
 5 files changed, 74 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index e71bacf1ee7ec..1ca43a480dd8c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1314,7 +1314,7 @@ enum {
 };
 
 enum UNI_ALL_STA_INFO_TAG {
-	UNI_ALL_STA_TX_RATE,
+	UNI_ALL_STA_TXRX_RATE,
 	UNI_ALL_STA_TX_STAT,
 	UNI_ALL_STA_TXRX_ADM_STAT,
 	UNI_ALL_STA_TXRX_AIR_TIME,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index c1a21da9fb7e5..09d313514bb49 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -102,7 +102,6 @@ static void mt7996_mac_sta_poll(struct mt7996_dev *dev)
 	};
 	struct ieee80211_sta *sta;
 	struct mt7996_sta *msta;
-	struct rate_info *rate;
 	u32 tx_time[IEEE80211_NUM_ACS], rx_time[IEEE80211_NUM_ACS];
 	LIST_HEAD(sta_poll_list);
 	int i;
@@ -118,7 +117,6 @@ static void mt7996_mac_sta_poll(struct mt7996_dev *dev)
 		u32 addr, val;
 		u16 idx;
 		s8 rssi[4];
-		u8 bw;
 
 		spin_lock_bh(&dev->mt76.sta_poll_lock);
 		if (list_empty(&sta_poll_list)) {
@@ -174,49 +172,6 @@ static void mt7996_mac_sta_poll(struct mt7996_dev *dev)
 			ieee80211_sta_register_airtime(sta, tid, tx_cur, rx_cur);
 		}
 
-		/* We don't support reading GI info from txs packets.
-		 * For accurate tx status reporting and AQL improvement,
-		 * we need to make sure that flags match so polling GI
-		 * from per-sta counters directly.
-		 */
-		rate = &msta->wcid.rate;
-
-		switch (rate->bw) {
-		case RATE_INFO_BW_320:
-			bw = IEEE80211_STA_RX_BW_320;
-			break;
-		case RATE_INFO_BW_160:
-			bw = IEEE80211_STA_RX_BW_160;
-			break;
-		case RATE_INFO_BW_80:
-			bw = IEEE80211_STA_RX_BW_80;
-			break;
-		case RATE_INFO_BW_40:
-			bw = IEEE80211_STA_RX_BW_40;
-			break;
-		default:
-			bw = IEEE80211_STA_RX_BW_20;
-			break;
-		}
-
-		addr = mt7996_mac_wtbl_lmac_addr(dev, idx, 6);
-		val = mt76_rr(dev, addr);
-		if (rate->flags & RATE_INFO_FLAGS_EHT_MCS) {
-			addr = mt7996_mac_wtbl_lmac_addr(dev, idx, 5);
-			val = mt76_rr(dev, addr);
-			rate->eht_gi = FIELD_GET(GENMASK(25, 24), val);
-		} else if (rate->flags & RATE_INFO_FLAGS_HE_MCS) {
-			u8 offs = 24 + 2 * bw;
-
-			rate->he_gi = (val & (0x3 << offs)) >> offs;
-		} else if (rate->flags &
-			   (RATE_INFO_FLAGS_VHT_MCS | RATE_INFO_FLAGS_MCS)) {
-			if (val & BIT(12 + bw))
-				rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
-			else
-				rate->flags &= ~RATE_INFO_FLAGS_SHORT_GI;
-		}
-
 		/* get signal strength of resp frames (CTS/BA/ACK) */
 		addr = mt7996_mac_wtbl_lmac_addr(dev, idx, 34);
 		val = mt76_rr(dev, addr);
@@ -1246,6 +1201,8 @@ mt7996_mac_add_txs_skb(struct mt7996_dev *dev, struct mt76_wcid *wcid,
 			goto out;
 
 		rate.flags = RATE_INFO_FLAGS_VHT_MCS;
+		if (wcid->rate.flags & RATE_INFO_FLAGS_SHORT_GI)
+			rate.flags |= RATE_INFO_FLAGS_SHORT_GI;
 		break;
 	case MT_PHY_TYPE_HE_SU:
 	case MT_PHY_TYPE_HE_EXT_SU:
@@ -2210,6 +2167,7 @@ void mt7996_mac_work(struct work_struct *work)
 
 		mt7996_mac_update_stats(phy);
 
+		mt7996_mcu_get_all_sta_info(phy, UNI_ALL_STA_TXRX_RATE);
 		if (mtk_wed_device_active(&phy->dev->mt76.mmio.wed)) {
 			mt7996_mcu_get_all_sta_info(phy, UNI_ALL_STA_TXRX_ADM_STAT);
 			mt7996_mcu_get_all_sta_info(phy, UNI_ALL_STA_TXRX_MSDU_COUNT);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d1703813828e1..387baba2ed150 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -995,6 +995,7 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 			sinfo->txrate.he_gi = txrate->he_gi;
 			sinfo->txrate.he_dcm = txrate->he_dcm;
 			sinfo->txrate.he_ru_alloc = txrate->he_ru_alloc;
+			sinfo->txrate.eht_gi = txrate->eht_gi;
 		}
 		sinfo->txrate.flags = txrate->flags;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index fbe16a3208c65..4806a7916c1ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -450,6 +450,43 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 	}
 }
 
+static int
+mt7996_mcu_update_tx_gi(struct rate_info *rate, struct all_sta_trx_rate *mcu_rate)
+{
+	switch (mcu_rate->tx_mode) {
+	case MT_PHY_TYPE_CCK:
+	case MT_PHY_TYPE_OFDM:
+		break;
+	case MT_PHY_TYPE_HT:
+	case MT_PHY_TYPE_HT_GF:
+	case MT_PHY_TYPE_VHT:
+		if (mcu_rate->tx_gi)
+			rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
+		else
+			rate->flags &= ~RATE_INFO_FLAGS_SHORT_GI;
+		break;
+	case MT_PHY_TYPE_HE_SU:
+	case MT_PHY_TYPE_HE_EXT_SU:
+	case MT_PHY_TYPE_HE_TB:
+	case MT_PHY_TYPE_HE_MU:
+		if (mcu_rate->tx_gi > NL80211_RATE_INFO_HE_GI_3_2)
+			return -EINVAL;
+		rate->he_gi = mcu_rate->tx_gi;
+		break;
+	case MT_PHY_TYPE_EHT_SU:
+	case MT_PHY_TYPE_EHT_TRIG:
+	case MT_PHY_TYPE_EHT_MU:
+		if (mcu_rate->tx_gi > NL80211_RATE_INFO_EHT_GI_3_2)
+			return -EINVAL;
+		rate->eht_gi = mcu_rate->tx_gi;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void
 mt7996_mcu_rx_all_sta_info_event(struct mt7996_dev *dev, struct sk_buff *skb)
 {
@@ -466,6 +503,16 @@ mt7996_mcu_rx_all_sta_info_event(struct mt7996_dev *dev, struct sk_buff *skb)
 		struct mt76_wcid *wcid;
 
 		switch (le16_to_cpu(res->tag)) {
+		case UNI_ALL_STA_TXRX_RATE:
+			wlan_idx = le16_to_cpu(res->rate[i].wlan_idx);
+			wcid = rcu_dereference(dev->mt76.wcid[wlan_idx]);
+
+			if (!wcid)
+				break;
+
+			if (mt7996_mcu_update_tx_gi(&wcid->rate, &res->rate[i]))
+				dev_err(dev->mt76.dev, "Failed to update TX GI\n");
+			break;
 		case UNI_ALL_STA_TXRX_ADM_STAT:
 			wlan_idx = le16_to_cpu(res->adm_stat[i].wlan_idx);
 			wcid = rcu_dereference(dev->mt76.wcid[wlan_idx]);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 221faff014fd3..1f61489e33b06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -153,6 +153,27 @@ struct mt7996_mcu_mib {
 	__le64 data;
 } __packed;
 
+struct all_sta_trx_rate {
+	__le16 wlan_idx;
+	u8 __rsv1[2];
+	u8 tx_mode;
+	u8 flags;
+	u8 tx_stbc;
+	u8 tx_gi;
+	u8 tx_bw;
+	u8 tx_ldpc;
+	u8 tx_mcs;
+	u8 tx_nss;
+	u8 rx_rate;
+	u8 rx_mode;
+	u8 rx_nsts;
+	u8 rx_gi;
+	u8 rx_coding;
+	u8 rx_stbc;
+	u8 rx_bw;
+	u8 __rsv2;
+} __packed;
+
 struct mt7996_mcu_all_sta_info_event {
 	u8 rsv[4];
 	__le16 tag;
@@ -163,6 +184,7 @@ struct mt7996_mcu_all_sta_info_event {
 	u8 rsv3[2];
 
 	union {
+		struct all_sta_trx_rate rate[0];
 		struct {
 			__le16 wlan_idx;
 			u8 rsv[2];
-- 
2.53.0



