Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018985;
	b=glqm3Soug3EGmWb+1cxo1bwTN7hBxIKMa89x9SwLJr8iQVMbm4aR/kbXs4fkEEVLVIak
	 FVmXVmsEJzMWcn3T4y2gATGjgDNQgcNonoMKZws2hyIVWS4yO6Mh1nqghcJW1I5y7Ca19
	 besrbt2z5NpzC2lkysiDz3dB+BlNCrVtfbuGDYN69Y98VGu/KanlPTQ/M26zwr8pTcGAB
	 uKQ47xxbdd5U6kUWQ+bOW6nYDJFXxdfWp6okbQ6Ww4Kt8UPPihmzVN+x10WGa9k+2Pvi1
	 Wa4wp1yqvlo1QKG6SXQKA19dm1X6EAnsSJKM7z3nU4O9/k6BouubJYjGCzZ5C/0/k7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SoH8x4oIVNe/n0zrUp31C8Z/n+cYWQC1r0E0shHfYew=;
	b=ssiMSwBommmp28g6VlUn+CXarMIR834KW74P3qxs5By5twkiCXR3Oj3BiHbtsX83R0jo
	 /BKd2/0eyQhj53yRroN4nyJvwg7s2vZFGvkI27Wzz0a/wzF/9W100k0Yk59YFsfEqSquK
	 h+INY/Hh011s3Pn90373E9uZdgxxbuRZo4z3Xy0uTquQU5ThoC5+2LoSfi1r136uPrip1
	 Jo2AKrfpUCTCT2twaSdPFpSC/nu2f+Pt+ty4IMOEstesXU1c6A2Dxtkp3lc0HbxVWwDms
	 SiU0pG+RrDI7udNNvA4hEM3FndNzHM0pyb3UMwkOU5/A2U+scDJXW1gpC8lh2+1UZ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E39gdGRL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18B3606A320;
	Wed, 18 Nov 2026 16:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E39gdGRL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BE81F000C8;
	Wed, 18 Nov 2026 16:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018984;
	bh=SoH8x4oIVNe/n0zrUp31C8Z/n+cYWQC1r0E0shHfYew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E39gdGRLv8LAhgXqrAlOBnVQvDfBDgvhC1LyhhhHz22h2nOl/R1rxYgN3VPD4tq7O
	 pWWxd3naAepBidYSs1h+mbvG9hJ9UTBVBYHwMqo6ti01Xc5YcrQBcNSDa3DmveFlXV
	 BHO8NkFK/g5hT9Txy5BNSZIbmdnAWNX66wVYBdEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1432/2651] wifi: mt76: mt7925: fix HT/VHT caps and rates for NAN NDP peers
Date: Wed, 18 Nov 2026 15:44:32 +0100
Message-ID: <20261118150339.601555871@linuxfoundation.org>
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

From: Jacobs Wu <jacobs.wu@mediatek.com>

[ Upstream commit 3590825b642ccda15690125d82d3d82206671486 ]

NAN NDP peers were added with bare link_sta caps: no HT cap or QoS
flag (so no BA/A-MPDU), no VHT cap / bandwidth / rx_nss, a data BSS
phy mode that still read legacy when the firmware built the peer's
rate table, and caps filtered down by the currently committed
schedule.

Push the NAN_DATA BSS phymode before sta_update, force the HT cap and
QoS flag, seed VHT80 / bandwidth / rx_nss=2 from the BSS RLM, fix the
NDP HT/VHT rate selection and stop filtering the link_sta caps by the
schedule, so rate control always sees the peer's real capabilities.

Bench (MT7925<->MT7925 NDP, 5 GHz ch149): 866.7M VHT80 MCS9 NSS2 link
rate, UDP ~290 Mbit/s.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-16-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 19 +++++-
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 62 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  4 ++
 3 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index daa0ff1526fc6..d71e60594ea51 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -964,6 +964,21 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 
 	link_conf = mt792x_vif_to_bss_conf(vif, link_id);
 
+	/* NAN_DATA (NDI) peers skip association - fill link_sta caps
+	 * from sband and push BSS_INFO with correct phymode + RLM.
+	 */
+	if (vif->type == NL80211_IFTYPE_NAN_DATA) {
+		struct ieee80211_chanctx_conf *nan_ctx;
+
+		nan_ctx = mt7925_nan_seed_link_sta(dev, link_sta);
+		mconf->mt76.ctx = nan_ctx;
+
+		ret = mt7925_mcu_add_bss_info(&dev->phy, nan_ctx,
+					      link_conf, link_sta, true);
+		if (ret)
+			goto out_pm;
+	}
+
 	/* should update bss info before STA add */
 	if (vif->type == NL80211_IFTYPE_STATION && !link_sta->sta->tdls) {
 		struct mt792x_link_sta *mlink_bc;
@@ -2601,8 +2616,8 @@ static int mt7925_start_nan(struct ieee80211_hw *hw,
 	cfg80211_chandef_create(&link_conf->chanreq.oper, chan,
 				NL80211_CHAN_NO_HT);
 
-	err = mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf,
-				      NULL, true);
+	err = mt7925_mcu_add_bss_info(&dev->phy, NULL,
+				      link_conf, NULL, true);
 	if (err < 0)
 		goto out;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 5fa0f11d62b68..1adef4d52f655 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -267,6 +267,68 @@ int mt7925_nan_update_phy_setting(struct mt792x_dev *dev)
 				 &req, sizeof(req), true);
 }
 
+struct ieee80211_chanctx_conf *
+mt7925_nan_seed_link_sta(struct mt792x_dev *dev,
+			 struct ieee80211_link_sta *link_sta)
+{
+	struct ieee80211_supported_band *sband_2g, *sband_5g;
+	struct ieee80211_chanctx_conf *nan_ctx = NULL;
+	struct ieee80211_vif *nan_vif = dev->nan_vif;
+
+	/* Fill HT cap from 2G sband */
+	sband_2g = dev->mphy.hw->wiphy->bands[NL80211_BAND_2GHZ];
+	sband_5g = dev->mphy.hw->wiphy->bands[NL80211_BAND_5GHZ];
+	if (sband_2g)
+		link_sta->ht_cap = sband_2g->ht_cap;
+
+	link_sta->sta->wme = true;
+	link_sta->rx_nss = hweight8(dev->mphy.antenna_mask);
+
+	/* Get chanctx from NAN schedule.
+	 * Prefer 5G committed slot for wider BW (VHT), fallback
+	 * to first valid slot if no 5G data slot is scheduled.
+	 */
+	if (nan_vif) {
+		struct ieee80211_nan_channel **slots =
+			nan_vif->cfg.nan_sched.schedule;
+		int i;
+
+		for (i = 0; i < CFG80211_NAN_SCHED_NUM_TIME_SLOTS; i++) {
+			struct ieee80211_chanctx_conf *ctx;
+
+			if (!slots[i] || IS_ERR(slots[i]) ||
+			    !slots[i]->chanctx_conf)
+				continue;
+
+			ctx = slots[i]->chanctx_conf;
+			if (!nan_ctx)
+				nan_ctx = ctx;
+			if (ctx->def.chan->band == NL80211_BAND_5GHZ) {
+				nan_ctx = ctx;
+				break;
+			}
+		}
+	}
+
+	/* Capability describes what the device can do and must not be
+	 * filtered by the current schedule - firmware gates the VHT rate
+	 * mode per the data schedule and re-derives it on schedule
+	 * change, which only works if the caps are present up front.
+	 */
+	if (sband_5g)
+		link_sta->vht_cap = sband_5g->vht_cap;
+
+	/* Bandwidth here is the capability ceiling, not the operating
+	 * width - the per-slot operating bandwidth follows the current
+	 * slot channel via the firmware RLM sync, so deriving it from
+	 * the schedule at STA-add time would cap a later 5 GHz schedule
+	 * at the bring-up width.
+	 */
+	link_sta->bandwidth = IEEE80211_STA_RX_BW_80;
+
+	return nan_ctx;
+}
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index f9644945a22cd..9a0cd1d06d456 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -479,6 +479,10 @@ struct mt7925_nan_update_phy_setting_tlv {
 
 int mt7925_nan_update_phy_setting(struct mt792x_dev *dev);
 
+struct ieee80211_chanctx_conf *
+mt7925_nan_seed_link_sta(struct mt792x_dev *dev,
+			 struct ieee80211_link_sta *link_sta);
+
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf);
-- 
2.53.0



