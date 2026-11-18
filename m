Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049325;
	b=vtkyIQ3ZUtrAkXZwugvxUqPBd8hpfW1jS8HoQWIbnIVaTzgOC6y8DeSvLhlLFbzp71SO
	 bKp8TWXTNlF4h/WEZBmmPvX3mF6ZTXemvHCUtMRN5xTh5qC/td41LVi3KjKusvLx3Fgjq
	 VmbM7WZUVjJX6iWjiNKrVjgEPtdAHTmiRrizAhur+nu5I2mu1I21wnbrOOsPLJphDFLWK
	 wyE1Yjuq7VrM3fpT5u/X4ACHISdE2bkMqPODAw9urDDJDQdOiBMr7cxhyHsLz1/F9bYGM
	 P7FQi0lLNctuma123l5XCmPjhGrXny/r/Y3Gz+SCijMmoE0/pHQVMpwB7l8XKiZBeBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sxBoH65QACUY0H2oW0veBZ4ZOL0HdRvDFWZRWR2crd0=;
	b=netF8d7o6bE9qXz84UnEZm1WRSZEPfOapgS2GPsVLA63YQBzG1K9ErNLEuvLR2a5kcLk
	 jCJrFi8bes9bW3BuiGC2FFLWkQ/RS8x5J5595mcu50a2pCtsK+gIi2Vuk6cryOy50WMyJ
	 KusMuLIexllkCVx8JrJS8hZ1groT82kS/RALhtK3DPKx8CPIkkA0rwwzsXmPtjfKqcgWB
	 0yXck4d00nVUO5Y9nZq5hbDXNMvXDUKetmUHuqYX7krZ6YOxU0yc+5jsqd4Rtd8Sz111Z
	 Mxx61rG+o1WW8WxT0IzXRtpeaBu35MDH0DcnHcML26SKgrr8J77fmL5BA1+UwicePEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWiCA7tZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D5460A2603;
	Thu, 19 Nov 2026 00:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWiCA7tZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CAB1F000C4;
	Thu, 19 Nov 2026 00:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049324;
	bh=sxBoH65QACUY0H2oW0veBZ4ZOL0HdRvDFWZRWR2crd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWiCA7tZtEoSMru7RHuvbPKGugx7EcVmSHI7essvL7KaZG51L8roVXNKYMv9lkFia
	 ukJn25nxESlZbSKyxaV22U4V29CQRhMdgp0VoAcljcEPq0Un5a7kuzYbgG5pXKCoIm
	 DD9NJR6Pu1dC4TvAJM1S1u493DfGNGNCn9+2ku3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shurong Wen <shurong.wen@mediatek.com>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2310/2857] wifi: mt76: mt7915: add ack signal support
Date: Wed, 18 Nov 2026 15:55:44 +0100
Message-ID: <20261118150324.669674931@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit a71b648e352787db13184b9355c0b3ffc8a0824a ]

This reports signal strength of ACK packets from the peer as measured
at each interface.

Tested-by: Shurong Wen <shurong.wen@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: e1534fef1ae4 ("wifi: mt76: feed the station RSSI average from the chain signals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c |  9 ++++-----
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt7915/init.c  |  7 +++++++
 .../net/wireless/mediatek/mt76/mt7915/mac.c   | 19 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7915/main.c  |  8 ++++++++
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  6 +++++-
 .../net/wireless/mediatek/mt76/mt7915/regs.h  |  8 ++++++++
 7 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 5bcb2837efaa9..6afd3f65a5d34 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -955,14 +955,12 @@ void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 }
 EXPORT_SYMBOL(mt76_wcid_key_setup);
 
-static int
-mt76_rx_signal(struct mt76_rx_status *status)
+int mt76_rx_signal(u8 chain_mask, s8 *chain_signal)
 {
-	s8 *chain_signal = status->chain_signal;
 	int signal = -128;
 	u8 chains;
 
-	for (chains = status->chains; chains; chains >>= 1, chain_signal++) {
+	for (chains = chain_mask; chains; chains >>= 1, chain_signal++) {
 		int cur, diff;
 
 		cur = *chain_signal;
@@ -984,6 +982,7 @@ mt76_rx_signal(struct mt76_rx_status *status)
 
 	return signal;
 }
+EXPORT_SYMBOL(mt76_rx_signal);
 
 static void
 mt76_rx_convert(struct mt76_dev *dev, struct sk_buff *skb,
@@ -1013,7 +1012,7 @@ mt76_rx_convert(struct mt76_dev *dev, struct sk_buff *skb,
 	status->ampdu_reference = mstat.ampdu_ref;
 	status->device_timestamp = mstat.timestamp;
 	status->mactime = mstat.timestamp;
-	status->signal = mt76_rx_signal(&mstat);
+	status->signal = mt76_rx_signal(mstat.chains, mstat.chain_signal);
 	if (status->signal <= -128)
 		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5b03e3b33d546..6bae36e4f25a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1165,6 +1165,7 @@ void mt76_update_survey(struct mt76_phy *phy);
 void mt76_update_survey_active_time(struct mt76_phy *phy, ktime_t time);
 int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 		    struct survey_info *survey);
+int mt76_rx_signal(u8 chain_mask, s8 *chain_signal);
 void mt76_set_stream_caps(struct mt76_phy *phy, bool vht);
 
 int mt76_rx_aggr_start(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index b9971dcae6003..cd9bf39861158 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -352,6 +352,7 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_BEACON_RATE_HE);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_UNSOL_BCAST_PROBE_RESP);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_FILS_DISCOVERY);
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
 
 	if (mt7915_eeprom_has_background_radar(phy->dev) &&
 	    (!mdev->dev->of_node ||
@@ -461,6 +462,12 @@ mt7915_mac_init_band(struct mt7915_dev *dev, u8 band)
 	set = FIELD_PREP(MT_WF_RMAC_MIB_OBSS_BACKOFF, 0) |
 	      FIELD_PREP(MT_WF_RMAC_MIB_ED_OFFSET, 4);
 	mt76_rmw(dev, MT_WF_RMAC_MIB_AIRTIME0(band), mask, set);
+
+	/* filter out non-resp frames and get instanstaeous signal reporting */
+	mask = MT_WTBLOFF_TOP_RSCR_RCPI_MODE | MT_WTBLOFF_TOP_RSCR_RCPI_PARAM;
+	set = FIELD_PREP(MT_WTBLOFF_TOP_RSCR_RCPI_MODE, 0) |
+	      FIELD_PREP(MT_WTBLOFF_TOP_RSCR_RCPI_PARAM, 0x3);
+	mt76_rmw(dev, MT_WTBLOFF_TOP_RSCR(band), mask, set);
 }
 
 void mt7915_mac_init(struct mt7915_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index c4d7126e05c89..7412404b7315e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -9,7 +9,7 @@
 #include "mac.h"
 #include "mcu.h"
 
-#define to_rssi(field, rxv)	((FIELD_GET(field, rxv) - 220) / 2)
+#define to_rssi(field, rcpi)	((FIELD_GET(field, rcpi) - 220) / 2)
 
 static const struct mt7915_dfs_radar_spec etsi_radar_specs = {
 	.pulse_th = { 110, -10, -80, 40, 5200, 128, 5200 },
@@ -119,6 +119,7 @@ static void mt7915_mac_sta_poll(struct mt7915_dev *dev)
 		bool clear = false;
 		u32 addr, val;
 		u16 idx;
+		s8 rssi[4];
 		u8 bw;
 
 		spin_lock_bh(&dev->sta_poll_lock);
@@ -132,6 +133,8 @@ static void mt7915_mac_sta_poll(struct mt7915_dev *dev)
 		spin_unlock_bh(&dev->sta_poll_lock);
 
 		idx = msta->wcid.idx;
+
+		/* refresh peer's airtime reporting */
 		addr = mt7915_mac_wtbl_lmac_addr(dev, idx, 20);
 
 		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
@@ -210,6 +213,20 @@ static void mt7915_mac_sta_poll(struct mt7915_dev *dev)
 			else
 				rate->flags &= ~RATE_INFO_FLAGS_SHORT_GI;
 		}
+
+		/* get signal strength of resp frames (CTS/BA/ACK) */
+		addr = mt7915_mac_wtbl_lmac_addr(dev, idx, 30);
+		val = mt76_rr(dev, addr);
+
+		rssi[0] = to_rssi(GENMASK(7, 0), val);
+		rssi[1] = to_rssi(GENMASK(15, 8), val);
+		rssi[2] = to_rssi(GENMASK(23, 16), val);
+		rssi[3] = to_rssi(GENMASK(31, 14), val);
+
+		msta->ack_signal =
+			mt76_rx_signal(msta->vif->phy->mt76->antenna_mask, rssi);
+
+		ewma_avg_signal_add(&msta->avg_ack_signal, -msta->ack_signal);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 4707e7727f179..dde451d818ba4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -693,6 +693,8 @@ int mt7915_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	msta->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 	msta->jiffies = jiffies;
 
+	ewma_avg_signal_init(&msta->avg_ack_signal);
+
 	mt7915_mac_wtbl_update(dev, idx,
 			       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 
@@ -1055,6 +1057,12 @@ static void mt7915_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->tx_retries = msta->wcid.stats.tx_retries;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_RETRIES);
 	}
+
+	sinfo->ack_signal = (s8)msta->ack_signal;
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
+
+	sinfo->avg_ack_signal = -(s8)ewma_avg_signal_read(&msta->avg_ack_signal);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
 }
 
 static void mt7915_sta_rc_work(void *data, struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index c2b3a28d71691..09773b0fce946 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -114,6 +114,8 @@ struct mt7915_twt_flow {
 	u8 sched:1;
 };
 
+DECLARE_EWMA(avg_signal, 10, 8)
+
 struct mt7915_sta {
 	struct mt76_wcid wcid; /* must be first */
 
@@ -123,10 +125,12 @@ struct mt7915_sta {
 	struct list_head rc_list;
 	u32 airtime_ac[8];
 
+	int ack_signal;
+	struct ewma_avg_signal avg_ack_signal;
+
 	unsigned long changed;
 	unsigned long jiffies;
 	unsigned long ampdu_state;
-
 	struct mt76_connac_sta_key_conf bip;
 
 	struct {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index 252ba7f057b15..c06a23c9ac83b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -241,6 +241,14 @@ enum offs_rev {
 #define MT_DMA_DCR0_MAX_RX_LEN		GENMASK(15, 3)
 #define MT_DMA_DCR0_RXD_G5_EN		BIT(23)
 
+/* WTBLOFF TOP: band 0(0x820e9000),band 1(0x820f9000) */
+#define MT_WTBLOFF_TOP_BASE(_band)	((_band) ? 0x820f9000 : 0x820e9000)
+#define MT_WTBLOFF_TOP(_band, ofs)	(MT_WTBLOFF_TOP_BASE(_band) + (ofs))
+
+#define MT_WTBLOFF_TOP_RSCR(_band)	MT_WTBLOFF_TOP(_band, 0x008)
+#define MT_WTBLOFF_TOP_RSCR_RCPI_MODE	GENMASK(31, 30)
+#define MT_WTBLOFF_TOP_RSCR_RCPI_PARAM	GENMASK(25, 24)
+
 /* ETBF: band 0(0x820ea000), band 1(0x820fa000) */
 #define MT_WF_ETBF_BASE(_band)		((_band) ? 0x820fa000 : 0x820ea000)
 #define MT_WF_ETBF(_band, ofs)		(MT_WF_ETBF_BASE(_band) + (ofs))
-- 
2.53.0



