Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041000;
	b=RTRIa4M6BhnOEAxMU0BVZEtawz3NBNw8QwE4+x065VFNU0OzdjCH5m+a1UrF6CicJx9D
	 SWIEtIKkdXaGZnSSF0Jtb3/UnEruEnCCZQixIiIbDkK6N+wjKEQe3Ld22E7ewEIYJmBjT
	 dFqEuRbXBV7GYQ4anLa15piJPz4/VECx6nk2006PgC5L8XkbJS+Vp1tuO8P/mbxundqHO
	 rt5/sayt0ZrrzXXu2sN6WUORI1Gj1OoLGvEog4Dsjn06qP/Dnrx+cKJ0TU41U737DBD9F
	 aMwWtoRNbd1OpAoo9k3Hi75/4dTadLJjP8f4vQvn2mEzanHTK/oj17PwHHceKxnNcDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zXQC7/iTGg18GflY8+gVKcHPWN0pYTrVwyecuCYztEU=;
	b=m1cD3tTbVCBbUUwrKR34eUVuMIttcwjKGXuQ3vyOjsDsu+izc/Fs/Ifvj/Whadoavf12
	 r4FAH+zL3K3al3Iygu57dFSfYLC6QZDMl40RlCC0f8DSc8PbR/6kVXgh1veDDl6TJMDRP
	 ure4kYr/QkQ/9OMsMUvVCkLwO1cMVfF67OqGWSxZP1wARM0CmWH1FMqaIvwlprB5uyZii
	 8WROEuzIMCfOFDQoBBjApTK05doTpD5uBH0ngLEkFl+9Co+WTMJfdmZ1ZY+Rzd31+ZSMV
	 IePjtfI8uQArzNHjbthJnS4AiYy5BIGrc2f2itP/qDG3nmpAznogHvG1576W99+XorA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+vuDh3R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A332606A32A;
	Wed, 18 Nov 2026 22:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+vuDh3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E851F1F000C4;
	Wed, 18 Nov 2026 22:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041000;
	bh=zXQC7/iTGg18GflY8+gVKcHPWN0pYTrVwyecuCYztEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+vuDh3RxPbckH137la0ibBbP78CVBa9Y/E0eUWe1/m1gWeZLoX33pM6e99aLOZlu
	 tIZ6x/wiHWlOqV8A6/sMpR6P/T1raW6bxpHD8c26EBzyldJeRbOWp21Y+XCxCdw7Gk
	 ywtUhbQB+Ma2o79Fxog4HpWbTDOGEfC28TqR/wqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi-Chia Hsieh <yi-chia.hsieh@mediatek.com>,
	Money Wang <Money.Wang@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Evelyn Tsai <evelyn.tsai@mediatek.com>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2656/3318] wifi: mt76: mt7996: Add mcu commands for getting sta tx statistic
Date: Wed, 18 Nov 2026 15:54:38 +0100
Message-ID: <20261118150440.719766315@linuxfoundation.org>
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

From: Yi-Chia Hsieh <yi-chia.hsieh@mediatek.com>

[ Upstream commit adde3eed4a75fe346d5ec1d78cd117e06bd70404 ]

Per peer Tx/Rx statistic can only be obtained by querying WM when WED is
on. This patch switches to periodic event reporting in the case of WED
being enabled.

Signed-off-by: Yi-Chia Hsieh <yi-chia.hsieh@mediatek.com>
Signed-off-by: Money Wang <Money.Wang@mediatek.com>
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Evelyn Tsai <evelyn.tsai@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: c88f880c6430 ("wifi: mt76: mt7996: validate firmware event lengths before parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  | 15 ++++
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  5 ++
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 15 ++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 68 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   | 26 +++++++
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 6 files changed, 130 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index c4273f602d355..e71bacf1ee7ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1018,6 +1018,8 @@ enum {
 	MCU_UNI_EVENT_ROC = 0x27,
 	MCU_UNI_EVENT_TX_DONE = 0x2d,
 	MCU_UNI_EVENT_NIC_CAPAB = 0x43,
+	MCU_UNI_EVENT_PER_STA_INFO = 0x6d,
+	MCU_UNI_EVENT_ALL_STA_INFO = 0x6e,
 };
 
 #define MCU_UNI_CMD_EVENT			BIT(1)
@@ -1231,6 +1233,8 @@ enum {
 	MCU_UNI_CMD_VOW = 0x37,
 	MCU_UNI_CMD_RRO = 0x57,
 	MCU_UNI_CMD_OFFCH_SCAN_CTRL = 0x58,
+	MCU_UNI_CMD_PER_STA_INFO = 0x6d,
+	MCU_UNI_CMD_ALL_STA_INFO = 0x6e,
 	MCU_UNI_CMD_ASSERT_DUMP = 0x6f,
 };
 
@@ -1309,6 +1313,17 @@ enum {
 	UNI_OFFLOAD_OFFLOAD_BMC_RPY_DETECT,
 };
 
+enum UNI_ALL_STA_INFO_TAG {
+	UNI_ALL_STA_TX_RATE,
+	UNI_ALL_STA_TX_STAT,
+	UNI_ALL_STA_TXRX_ADM_STAT,
+	UNI_ALL_STA_TXRX_AIR_TIME,
+	UNI_ALL_STA_DATA_TX_RETRY_COUNT,
+	UNI_ALL_STA_GI_MODE,
+	UNI_ALL_STA_TXRX_MSDU_COUNT,
+	UNI_ALL_STA_MAX_NUM
+};
+
 enum {
 	MT_NIC_CAP_TX_RESOURCE,
 	MT_NIC_CAP_TX_EFUSE_ADDR,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 42e75e7416ed4..c1a21da9fb7e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2209,6 +2209,11 @@ void mt7996_mac_work(struct work_struct *work)
 		mphy->mac_work_count = 0;
 
 		mt7996_mac_update_stats(phy);
+
+		if (mtk_wed_device_active(&phy->dev->mt76.mmio.wed)) {
+			mt7996_mcu_get_all_sta_info(phy, UNI_ALL_STA_TXRX_ADM_STAT);
+			mt7996_mcu_get_all_sta_info(phy, UNI_ALL_STA_TXRX_MSDU_COUNT);
+		}
 	}
 
 	mutex_unlock(&mphy->dev->mutex);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index dd00a0fb5df0e..d1703813828e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -981,6 +981,7 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 				  struct ieee80211_sta *sta,
 				  struct station_info *sinfo)
 {
+	struct mt7996_phy *phy = mt7996_hw_phy(hw);
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	struct rate_info *txrate = &msta->wcid.rate;
 
@@ -1004,6 +1005,20 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 
 	sinfo->avg_ack_signal = -(s8)ewma_avg_signal_read(&msta->avg_ack_signal);
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
+
+	if (mtk_wed_device_active(&phy->dev->mt76.mmio.wed)) {
+		sinfo->tx_bytes = msta->wcid.stats.tx_bytes;
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BYTES64);
+
+		sinfo->rx_bytes = msta->wcid.stats.rx_bytes;
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_BYTES64);
+
+		sinfo->tx_packets = msta->wcid.stats.tx_packets;
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_PACKETS);
+
+		sinfo->rx_packets = msta->wcid.stats.rx_packets;
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
+	}
 }
 
 static void mt7996_sta_rc_work(void *data, struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 6c9517e4cea43..fbe16a3208c65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -450,6 +450,54 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 	}
 }
 
+static void
+mt7996_mcu_rx_all_sta_info_event(struct mt7996_dev *dev, struct sk_buff *skb)
+{
+	struct mt7996_mcu_all_sta_info_event *res;
+	u16 i;
+
+	skb_pull(skb, sizeof(struct mt7996_mcu_rxd));
+
+	res = (struct mt7996_mcu_all_sta_info_event *)skb->data;
+
+	for (i = 0; i < le16_to_cpu(res->sta_num); i++) {
+		u8 ac;
+		u16 wlan_idx;
+		struct mt76_wcid *wcid;
+
+		switch (le16_to_cpu(res->tag)) {
+		case UNI_ALL_STA_TXRX_ADM_STAT:
+			wlan_idx = le16_to_cpu(res->adm_stat[i].wlan_idx);
+			wcid = rcu_dereference(dev->mt76.wcid[wlan_idx]);
+
+			if (!wcid)
+				break;
+
+			for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+				wcid->stats.tx_bytes +=
+					le32_to_cpu(res->adm_stat[i].tx_bytes[ac]);
+				wcid->stats.rx_bytes +=
+					le32_to_cpu(res->adm_stat[i].rx_bytes[ac]);
+			}
+			break;
+		case UNI_ALL_STA_TXRX_MSDU_COUNT:
+			wlan_idx = le16_to_cpu(res->msdu_cnt[i].wlan_idx);
+			wcid = rcu_dereference(dev->mt76.wcid[wlan_idx]);
+
+			if (!wcid)
+				break;
+
+			wcid->stats.tx_packets +=
+				le32_to_cpu(res->msdu_cnt[i].tx_msdu_cnt);
+			wcid->stats.rx_packets +=
+				le32_to_cpu(res->msdu_cnt[i].rx_msdu_cnt);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 static void
 mt7996_mcu_rx_ext_event(struct mt7996_dev *dev, struct sk_buff *skb)
 {
@@ -494,6 +542,9 @@ mt7996_mcu_uni_rx_unsolicited_event(struct mt7996_dev *dev, struct sk_buff *skb)
 	case MCU_UNI_EVENT_RDD_REPORT:
 		mt7996_mcu_rx_radar_detected(dev, skb);
 		break;
+	case MCU_UNI_EVENT_ALL_STA_INFO:
+		mt7996_mcu_rx_all_sta_info_event(dev, skb);
+		break;
 	default:
 		break;
 	}
@@ -3851,3 +3902,20 @@ int mt7996_mcu_set_rro(struct mt7996_dev *dev, u16 tag, u8 val)
 	return mt76_mcu_send_msg(&dev->mt76, MCU_WM_UNI_CMD(RRO), &req,
 				 sizeof(req), true);
 }
+
+int mt7996_mcu_get_all_sta_info(struct mt7996_phy *phy, u16 tag)
+{
+	struct mt7996_dev *dev = phy->dev;
+	struct {
+		u8 _rsv[4];
+
+		__le16 tag;
+		__le16 len;
+	} __packed req = {
+		.tag = cpu_to_le16(tag),
+		.len = cpu_to_le16(sizeof(req) - 4),
+	};
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_WM_UNI_CMD(ALL_STA_INFO),
+				 &req, sizeof(req), false);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 70f65350111d2..221faff014fd3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -153,6 +153,32 @@ struct mt7996_mcu_mib {
 	__le64 data;
 } __packed;
 
+struct mt7996_mcu_all_sta_info_event {
+	u8 rsv[4];
+	__le16 tag;
+	__le16 len;
+	u8 more;
+	u8 rsv2;
+	__le16 sta_num;
+	u8 rsv3[2];
+
+	union {
+		struct {
+			__le16 wlan_idx;
+			u8 rsv[2];
+			__le32 tx_bytes[IEEE80211_NUM_ACS];
+			__le32 rx_bytes[IEEE80211_NUM_ACS];
+		} adm_stat[0];
+
+		struct {
+			__le16 wlan_idx;
+			u8 rsv[2];
+			__le32 tx_msdu_cnt;
+			__le32 rx_msdu_cnt;
+		} msdu_cnt[0];
+	};
+} __packed;
+
 enum mt7996_chan_mib_offs {
 	UNI_MIB_OBSS_AIRTIME = 26,
 	UNI_MIB_NON_WIFI_TIME = 27,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 7d2074e2b635e..1cc08208f629e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -405,6 +405,7 @@ int mt7996_mcu_fw_dbg_ctrl(struct mt7996_dev *dev, u32 module, u8 level);
 int mt7996_mcu_trigger_assert(struct mt7996_dev *dev);
 void mt7996_mcu_rx_event(struct mt7996_dev *dev, struct sk_buff *skb);
 void mt7996_mcu_exit(struct mt7996_dev *dev);
+int mt7996_mcu_get_all_sta_info(struct mt7996_phy *phy, u16 tag);
 
 static inline u8 mt7996_max_interface_num(struct mt7996_dev *dev)
 {
-- 
2.53.0



