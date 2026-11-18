Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018962;
	b=SQfUW9PQOf/dh0e7iwiv/2ldeBHPg47rlqzpOXkgTiUj5T1UCjUSCLvFzoqlWakI7/X8
	 HB1psCFMu7D5mUMK8y7DPztdSWKIXARxR+Mt0tGblb5BU4D5LLz4wSHsmV91WKLz04jji
	 5cSTTItaH5HCxxuyrz2nX6S1dGMp+3GgXHIPmY5UHps/8+CSK0uWu6xZRlLVNZBWCPe3Y
	 Rc9x7sPyosUT/wDjhnA/2xUXqg5GUj8jfdijccn54E45tYML4q/C3ou6pYJuGe+PZk0ho
	 iA8y06kajZqxXUUFISz2rvlFm2plb3YliqUcumWvwSYGTjXx2A0tNfHWl0zUlQ/HYHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNTlFkCdn6Hl5GcX1fGFnuOC9BY/Arnf1yq0H9RGvEg=;
	b=pbQGVvWT08Wd0HRcHpF9CbLKu1C8Euj4TpbWbRiZdHYWmndSKd53Z6IPKpwTUAPHDNhT
	 3f9AI0l16R3n1jndm26I4dDvrRycAdmyl94R25DVSYXZHHO2v/qmEpMIOkOEnqs8W4cBS
	 5qAnIx97Jv66IgNeoRx8tlXPOQTC7aVhFDsbxvEjN4bv2vkdXVLBh+xgfYVKdv+C3wZyI
	 ydyfC/6TlIuLt80oCsU1cs1QcvEWDn1RHBC4sW9zqOM174QVm4aJpSMS5N88xNSVHCeMZ
	 VrEY/Vv/vDAXYSb/04xxZDZfeTeG++BobI6nzqAm6K/2e42+vrtzLWDA1mjFBM+0nfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjQJ+i9O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C58D60A2601;
	Wed, 18 Nov 2026 16:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjQJ+i9O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5A71F000C9;
	Wed, 18 Nov 2026 16:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018962;
	bh=CNTlFkCdn6Hl5GcX1fGFnuOC9BY/Arnf1yq0H9RGvEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjQJ+i9OgoW7tt/Lx2wTMc5xu++MBMluAEZqEu7FM/+Y0tO+xZLkvxEf+ZmIgES6l
	 hTM6kPPhBG+URUruoNxTjXQlpycx401sN7BvhGSUiPNEmGDcPGZT3ioCFGB57n+aBo
	 IWCh5L92eJezBqDO84C2v/LxP9brBhmd8HqBm6U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1425/2651] wifi: mt76: mt7925: share TLV setup for NAN enable command
Date: Wed, 18 Nov 2026 15:44:25 +0100
Message-ID: <20261118150339.351180853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stella Liu <yu-ching.liu@mediatek.com>

[ Upstream commit 9d758e4f60c12a396bd75b246b30cc9064dd1e47 ]

Refactor mt7925_nan_enable() to build the MCU command from separate
TLVs via skb instead of inline fields in the enable request struct.
The cluster ID, DW interval, discovery beacon interval and RSSI
threshold settings are now shared with mt7925_nan_change_configure()
through the common TLV helpers, avoiding duplicated setup code.

Fixes: a5487a682406 ("wifi: mt76: mt7925: add NAN MCU helpers")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-9-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 190 +++++++-----------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |   7 +
 2 files changed, 78 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 2be2251aeadb6..1c69db94b73db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -42,63 +42,6 @@ static void mt7925_nan_set_5g_channel(struct mt792x_dev *dev,
 	req->channel_5g_val = cpu_to_le32(ch5g);
 }
 
-static void mt7925_nan_set_cluster_id(struct mt7925_nan_enable_req_tlv *req,
-				      const u8 *cluster_id)
-{
-	if (!cluster_id)
-		return;
-
-	req->cluster_high = cpu_to_le16(cluster_id[4] | cluster_id[5] << 8);
-	req->cluster_low = cpu_to_le16((u16)cluster_id[3]);
-}
-
-static void mt7925_nan_set_dw_interval(struct mt7925_nan_enable_req_tlv *req,
-				       struct cfg80211_nan_conf *conf)
-{
-	if (conf->band_cfgs[NL80211_BAND_2GHZ].awake_dw_interval > 0) {
-		req->config_dw.config_2dot4g_dw_band = 1;
-		req->config_dw.dw_2dot4g_interval_val =
-			cpu_to_le32(conf->band_cfgs[NL80211_BAND_2GHZ].awake_dw_interval);
-	}
-
-	if (conf->band_cfgs[NL80211_BAND_5GHZ].awake_dw_interval > 0) {
-		req->config_dw.config_5g_dw_band = 1;
-		req->config_dw.dw_5g_interval_val =
-			cpu_to_le32(conf->band_cfgs[NL80211_BAND_5GHZ].awake_dw_interval);
-	}
-}
-
-static void mt7925_nan_set_disc_beacon(struct mt7925_nan_enable_req_tlv *req,
-				       struct cfg80211_nan_conf *conf)
-{
-	if (conf->discovery_beacon_interval > 0) {
-		req->config_2dot4g_beacons = true;
-		req->beacon_2dot4g_val = conf->discovery_beacon_interval;
-	}
-}
-
-static void mt7925_nan_set_rssi_thresholds(struct mt7925_nan_enable_req_tlv *req,
-					   struct cfg80211_nan_conf *conf)
-{
-	if (conf->band_cfgs[NL80211_BAND_2GHZ].chan) {
-		req->config_2dot4g_rssi_close = 1;
-		req->rssi_close_2dot4g_val =
-			abs(conf->band_cfgs[NL80211_BAND_2GHZ].rssi_close);
-		req->config_2dot4g_rssi_middle = 1;
-		req->rssi_middle_2dot4g_val =
-			abs(conf->band_cfgs[NL80211_BAND_2GHZ].rssi_middle);
-	}
-
-	if (conf->band_cfgs[NL80211_BAND_5GHZ].chan) {
-		req->config_5g_rssi_close = 1;
-		req->rssi_close_5g_val =
-			abs(conf->band_cfgs[NL80211_BAND_5GHZ].rssi_close);
-		req->config_5g_rssi_middle = 1;
-		req->rssi_middle_5g_val =
-			abs(conf->band_cfgs[NL80211_BAND_5GHZ].rssi_middle);
-	}
-}
-
 static void mt7925_nan_set_scan_params(struct mt7925_nan_enable_req_tlv *req,
 				       struct cfg80211_nan_conf *conf)
 {
@@ -132,68 +75,6 @@ mt7925_nan_update_conf(struct mt792x_vif *mvif,
 	memcpy(mvif->nan.conf.cluster_id, conf->cluster_id, ETH_ALEN);
 }
 
-int mt7925_nan_enable(struct ieee80211_vif *vif,
-		      struct mt792x_dev *dev,
-		      struct cfg80211_nan_conf *conf)
-{
-	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
-	struct mt76_dev *mdev = &dev->mt76;
-	struct {
-		u8 rsv[4];
-		struct mt7925_nan_enable_req_tlv nan_req_tlv;
-	} nan_cmd = {
-		.rsv = { 0 },
-		.nan_req_tlv = {
-			.tag = cpu_to_le16(NAN_UNI_CMD_ENABLE_REQUEST),
-			.len = cpu_to_le16(sizeof(struct mt7925_nan_enable_req_tlv)),
-			.config_random_factor_force = 0,
-			.random_factor_force_val = 0,
-			.config_hop_count_force = 0,
-			.hop_count_force_val = 0,
-		},
-	};
-	struct mt7925_nan_enable_req_tlv *p_nan_req_tlv = &nan_cmd.nan_req_tlv;
-	int ret;
-
-	if (!vif || !dev || !conf)
-		return -EINVAL;
-
-	p_nan_req_tlv->master_pref = conf->master_pref;
-
-	mt7925_nan_set_5g_channel(dev, p_nan_req_tlv, conf);
-	mt7925_nan_set_cluster_id(p_nan_req_tlv, conf->cluster_id);
-	mt7925_nan_set_dw_interval(p_nan_req_tlv, conf);
-	mt7925_nan_set_disc_beacon(p_nan_req_tlv, conf);
-	mt7925_nan_set_rssi_thresholds(p_nan_req_tlv, conf);
-	mt7925_nan_set_scan_params(p_nan_req_tlv, conf);
-
-	mt7925_nan_update_conf(mvif, conf);
-
-	ret = mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nan_cmd, sizeof(nan_cmd), true);
-
-	return ret;
-}
-
-int mt7925_nan_disable(struct ieee80211_vif *vif, struct mt792x_dev *dev)
-{
-	struct mt76_dev *mdev = &dev->mt76;
-	struct {
-		u8 rsv[4];
-		struct tlv nan_dis_tlv;
-	} nan_cmd = {
-		.rsv = { 0 },
-		.nan_dis_tlv = {
-			.tag = cpu_to_le16(NAN_UNI_CMD_DISABLE_REQUEST),
-			.len = cpu_to_le16(sizeof(struct tlv)),
-		},
-	};
-
-	if (!dev)
-		return -EINVAL;
-
-	return mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nan_cmd, sizeof(nan_cmd), true);
-}
-
 static int
 mt7925_nan_mp_tlv(struct sk_buff *skb, u8 master_pref)
 {
@@ -312,6 +193,77 @@ mt7925_nan_sync_rssi_tlv(struct sk_buff *skb, struct cfg80211_nan_conf *conf)
 	return 0;
 }
 
+int mt7925_nan_enable(struct ieee80211_vif *vif,
+		      struct mt792x_dev *dev,
+		      struct cfg80211_nan_conf *conf)
+{
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct mt76_dev *mdev = &dev->mt76;
+	struct mt7925_nan_common_hdr *hdr;
+	struct mt7925_nan_enable_req_tlv *req;
+	struct sk_buff *skb;
+
+	if (!vif || !dev || !conf)
+		return -EINVAL;
+
+	skb = mt76_mcu_msg_alloc(mdev, NULL, MT7925_NAN_ENABLE_MAX_SIZE);
+	if (!skb)
+		return -ENOMEM;
+
+	hdr = (struct mt7925_nan_common_hdr *)skb_put(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(*hdr));
+
+	/* Set cluster id before joining cluster */
+	if (mt7925_nan_cluster_id_tlv(skb, conf->cluster_id)) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	/* NAN enable request tlv */
+	req = (struct mt7925_nan_enable_req_tlv *)
+		mt76_connac_mcu_add_tlv(skb, NAN_UNI_CMD_ENABLE_REQUEST,
+					sizeof(*req));
+	if (!req) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	req->master_pref = conf->master_pref;
+
+	mt7925_nan_set_5g_channel(dev, req, conf);
+	mt7925_nan_set_scan_params(req, conf);
+
+	if (mt7925_nan_dw_tlv(skb, conf) ||
+	    mt7925_nan_sync_rssi_tlv(skb, conf)) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	mt7925_nan_update_conf(mvif, conf);
+
+	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
+}
+
+int mt7925_nan_disable(struct ieee80211_vif *vif, struct mt792x_dev *dev)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	struct {
+		u8 rsv[4];
+		struct tlv nan_dis_tlv;
+	} nan_cmd = {
+		.rsv = { 0 },
+		.nan_dis_tlv = {
+			.tag = cpu_to_le16(NAN_UNI_CMD_DISABLE_REQUEST),
+			.len = cpu_to_le16(sizeof(struct tlv)),
+		},
+	};
+
+	if (!dev)
+		return -EINVAL;
+
+	return mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nan_cmd, sizeof(nan_cmd), true);
+}
+
 int mt7925_nan_change_configure(struct ieee80211_vif *vif,
 				struct mt792x_dev *dev,
 				struct cfg80211_nan_conf *conf)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index fab10b829eaac..31341c1df8f9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -28,6 +28,13 @@
 #define NAN_MAX_CONN_CFG		8
 #define NAN_MAX_NDP_CXT			4
 
+#define MT7925_NAN_ENABLE_MAX_SIZE					\
+	(sizeof(struct mt7925_nan_common_hdr) +				\
+	 sizeof(struct mt7925_nan_enable_req_tlv) +			\
+	 sizeof(struct mt7925_nan_dw_interval_tlv) +			\
+	 sizeof(struct mt7925_nan_cluster_id_tlv) +			\
+	 sizeof(struct mt7925_nan_sync_rssi_tlv))
+
 #define MT7925_NAN_CONF_MAX_SIZE					\
 	(sizeof(struct mt7925_nan_common_hdr) +				\
 	 sizeof(struct mt7925_nan_master_preference_tlv) +		\
-- 
2.53.0



