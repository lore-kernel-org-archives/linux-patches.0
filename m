Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025871;
	b=uq+ai193OhEnTs8y7Ax+myHIk8WjqWJMTAUZgTQE7tOtK5WE2+gCNtQ0jVNVXipHv2re
	 lYeQHlSxs0BvTCcrEcYTgnSLSWVvujFRXMtwVBRvjuZ5DC/OJUkyVPvefgGalygV1QCwT
	 5Ti4G5HBgUYTyxSl6UfSFcTiUBuqujh2Loj58GgkoprfT0Pwtfz7s4oDPCE8UTBCLR3Go
	 RusWsoou78CnuVAUDbZsdy9icsMWwyMDK3fbo/4mEuAAJqh5E+bS8tHIMUXRWk5R6KZHP
	 i29mlXI9kVMGC1+A4Gzq9L8KclUJsWZKcBALf7NqfasWfDT3UiZzG+AZkWwNPGvtPCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nIsz9C2ecIGd+M7mU0G7Wl5N4oTqx/IkJps1gIP3ikU=;
	b=g+Dg4e/NgR1ysAHX/Sr9ommGbLLqSSCdVynRl1ElXXzraHbuHCFl1IMCm036P3vzrJNe
	 XxrKMnAUyQN1LzeEIpI6ezLVhr95cBtjMhvJ7Y2dfrw6yy3tTHlKcOVhLR9utRSPWKqwA
	 3jNMncVu5WRczsJ95KKmhsp0OlxazmjlnM4M2eQgoCi6kkDkS42q5pDaECwuw/4iBcRCi
	 g2ieNdMfpkCBD/O0G6rEiK0rnDaURjr7Hd5CHdqxQ/igegRI0HzE9WFprNHkwARgiztej
	 jbLW+lePygfcARF+sjNNtdf0WblXCKa/V54xN+JIcex2qR+aln0Bar9zFPrYSfSqJbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gXzLVtH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D8606A31C;
	Wed, 18 Nov 2026 18:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXzLVtH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58201F000C4;
	Wed, 18 Nov 2026 18:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025871;
	bh=nIsz9C2ecIGd+M7mU0G7Wl5N4oTqx/IkJps1gIP3ikU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXzLVtH/b3cwR6agXdf8mS9GjtOtif6WhDela9SUZ/tJTTHb36uhZ9d6CExjjYk/X
	 zBzW9HPUDE35BiIOdKp5ZsnbkhETeAqtxBELXyb3Zf48sH2MlQOGs+nea9py04lyKB
	 xH9taHpjKlVGci6YTTeR3BdNiYeQV2RcA/SinbCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1232/2151] wifi: mt76: mt7996: Remove unnecessary phy filed in mt7996_vif_link struct
Date: Wed, 18 Nov 2026 15:49:27 +0100
Message-ID: <20261118150207.062341331@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 5806c91a3f0d21d233f8c386c892e1ffaf64d7b2 ]

Remove unnecessary phy pointer in mt7996_vif_link struct and rely on
mt7996_vif_link_phy() utility routine.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260306-mt7996-deflink-lookup-link-remove-v1-4-7162b332873c@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: ef28298ab88b ("wifi: mt76: mt7996: fix the hw-queues debugfs queue requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c |   14 +++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c     |    7 +
 drivers/net/wireless/mediatek/mt76/mt7996/main.c    |   43 ++++++++---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c     |   74 ++++++++++++++------
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h  |    2 
 5 files changed, 101 insertions(+), 39 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
@@ -626,13 +626,18 @@ mt7996_sta_hw_queue_read(void *data, str
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	struct mt7996_vif *mvif = msta->vif;
-	struct mt7996_dev *dev = mvif->deflink.phy->dev;
+	struct mt7996_phy *phy = mt7996_vif_link_phy(&mvif->deflink);
 	struct ieee80211_link_sta *link_sta;
 	struct seq_file *s = data;
 	struct ieee80211_vif *vif;
+	struct mt7996_dev *dev;
 	unsigned int link_id;
 
+	if (!phy)
+		return;
+
 	vif = container_of((void *)mvif, struct ieee80211_vif, drv_priv);
+	dev = phy->dev;
 
 	rcu_read_lock();
 
@@ -979,13 +984,17 @@ static ssize_t mt7996_link_sta_fixed_rat
 #define LONG_PREAMBLE 1
 	struct ieee80211_link_sta *link_sta = file->private_data;
 	struct mt7996_sta *msta = (struct mt7996_sta *)link_sta->sta->drv_priv;
-	struct mt7996_dev *dev = msta->vif->deflink.phy->dev;
+	struct mt7996_phy *link_phy = mt7996_vif_link_phy(&msta->vif->deflink);
 	struct mt7996_sta_link *msta_link;
 	struct ra_rate phy = {};
+	struct mt7996_dev *dev;
 	char buf[100];
 	int ret;
 	u16 gi, ltf;
 
+	if (!link_phy)
+		return -EINVAL;
+
 	if (count >= sizeof(buf))
 		return -EINVAL;
 
@@ -1008,6 +1017,7 @@ static ssize_t mt7996_link_sta_fixed_rat
 	 * spe - off: 0, on: 1
 	 * ltf - 1xltf: 0, 2xltf: 1, 4xltf: 2
 	 */
+	dev = link_phy->dev;
 	if (sscanf(buf, "%hhu %hhu %hhu %hhu %hu %hhu %hhu %hhu %hhu %hu",
 		   &phy.mode, &phy.bw, &phy.mcs, &phy.nss, &gi,
 		   &phy.preamble, &phy.stbc, &phy.ldpc, &phy.spe, &ltf) != 10) {
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2274,9 +2274,14 @@ mt7996_update_vif_beacon(void *priv, u8
 
 	for_each_vif_active_link(vif, link_conf, link_id) {
 		struct mt7996_vif_link *link;
+		struct mt7996_phy *link_phy;
 
 		link = mt7996_vif_link(dev, vif, link_id);
-		if (!link || link->phy != phy)
+		if (!link)
+			continue;
+
+		link_phy = mt7996_vif_link_phy(link);
+		if (link_phy != phy)
 			continue;
 
 		mt7996_mcu_add_beacon(dev->mt76.hw, vif, link_conf,
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -243,10 +243,13 @@ mt7996_set_hw_key(struct ieee80211_hw *h
 		link_conf = &vif->bss_conf;
 
 	if (cmd == SET_KEY && !sta && !link->mt76.cipher) {
+		struct mt7996_phy *phy = mt7996_vif_link_phy(link);
+
 		link->mt76.cipher =
 			mt76_connac_mcu_get_cipher(key->cipher);
-		mt7996_mcu_add_bss_info(link->phy, vif, link_conf,
-					&link->mt76, msta_link, true);
+		if (phy)
+			mt7996_mcu_add_bss_info(phy, vif, link_conf,
+						&link->mt76, msta_link, true);
 	}
 
 	if (cmd == SET_KEY)
@@ -323,7 +326,6 @@ int mt7996_vif_link_add(struct mt76_phy
 		return -ENOSPC;
 
 	link->mld_idx = mld_idx;
-	link->phy = phy;
 	mlink->omac_idx = idx;
 	mlink->band_idx = band_idx;
 	mlink->wmm_idx = vif->type == NL80211_IFTYPE_AP ? 0 : 3;
@@ -830,15 +832,17 @@ mt7996_vif_cfg_changed(struct ieee80211_
 
 		for_each_vif_active_link(vif, link_conf, link_id) {
 			struct mt7996_vif_link *link;
+			struct mt7996_phy *phy;
 
 			link = mt7996_vif_link(dev, vif, link_id);
 			if (!link)
 				continue;
 
-			if (!link->phy)
+			phy = mt7996_vif_link_phy(link);
+			if (!phy)
 				continue;
 
-			mt7996_mcu_add_bss_info(link->phy, vif, link_conf,
+			mt7996_mcu_add_bss_info(phy, vif, link_conf,
 						&link->mt76, &link->msta_link,
 						true);
 			mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
@@ -953,10 +957,15 @@ mt7996_channel_switch_beacon(struct ieee
 	mutex_lock(&dev->mt76.mutex);
 
 	for_each_vif_active_link(vif, link_conf, link_id) {
-		struct mt7996_vif_link *link =
-			mt7996_vif_link(dev, vif, link_id);
+		struct mt7996_vif_link *link;
+		struct mt7996_phy *link_phy;
+
+		link = mt7996_vif_link(dev, vif, link_id);
+		if (!link)
+			continue;
 
-		if (!link || link->phy != phy)
+		link_phy = mt7996_vif_link_phy(link);
+		if (link_phy != phy)
 			continue;
 
 		/* Reset beacon when channel switch triggered during CAC to let
@@ -1027,10 +1036,13 @@ mt7996_mac_sta_init_link(struct mt7996_d
 {
 	struct ieee80211_sta *sta = link_sta->sta;
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	struct mt7996_phy *phy = link->phy;
+	struct mt7996_phy *phy = mt7996_vif_link_phy(link);
 	struct mt7996_sta_link *msta_link;
 	int idx;
 
+	if (!phy)
+		return -EINVAL;
+
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, MT7996_WTBL_STA);
 	if (idx < 0)
 		return -ENOSPC;
@@ -1606,8 +1618,8 @@ mt7996_get_stats(struct ieee80211_hw *hw
 
 u64 __mt7996_get_tsf(struct ieee80211_hw *hw, struct mt7996_vif_link *link)
 {
+	struct mt7996_phy *phy = mt7996_vif_link_phy(link);
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
-	struct mt7996_phy *phy = link->phy;
 	union {
 		u64 t64;
 		u32 t32[2];
@@ -1666,7 +1678,7 @@ mt7996_set_tsf(struct ieee80211_hw *hw,
 
 	n = link->mt76.omac_idx > HW_BSSID_MAX ? HW_BSSID_0
 					       : link->mt76.omac_idx;
-	phy = link->phy;
+	phy = mt7996_vif_link_phy(link);
 	if (!phy)
 		goto unlock;
 
@@ -1700,7 +1712,7 @@ mt7996_offset_tsf(struct ieee80211_hw *h
 	if (!link)
 		goto unlock;
 
-	phy = link->phy;
+	phy = mt7996_vif_link_phy(link);
 	if (!phy)
 		goto unlock;
 
@@ -1838,9 +1850,14 @@ static void mt7996_link_rate_ctrl_update
 					 struct mt7996_sta_link *msta_link)
 {
 	struct mt7996_sta *msta = msta_link->sta;
-	struct mt7996_dev *dev = msta->vif->deflink.phy->dev;
+	struct mt7996_phy *phy = mt7996_vif_link_phy(&msta->vif->deflink);
+	struct mt7996_dev *dev;
 	u32 *changed = data;
 
+	if (!phy)
+		return;
+
+	dev = phy->dev;
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
 
 	msta_link->changed |= *changed;
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -125,9 +125,16 @@ mt7996_mcu_set_sta_he_mcs(struct ieee802
 			  struct mt7996_vif_link *link,
 			  __le16 *he_mcs, u16 mcs_map)
 {
+	struct mt76_phy *mphy = mt76_vif_link_phy(&link->mt76);
 	int nss, max_nss = link_sta->rx_nss > 3 ? 4 : link_sta->rx_nss;
-	enum nl80211_band band = link->phy->mt76->chandef.chan->band;
-	const u16 *mask = link->bitrate_mask.control[band].he_mcs;
+	enum nl80211_band band;
+	const u16 *mask;
+
+	if (!mphy)
+		return;
+
+	band = mphy->chandef.chan->band;
+	mask = link->bitrate_mask.control[band].he_mcs;
 
 	for (nss = 0; nss < max_nss; nss++) {
 		int mcs;
@@ -1904,9 +1911,8 @@ mt7996_mcu_sta_bfer_tlv(struct mt7996_de
 #define EBF_MODE	BIT(0)
 #define IBF_MODE	BIT(1)
 #define BF_MAT_ORDER	4
+	struct mt7996_phy *phy = mt7996_vif_link_phy(link);
 	struct ieee80211_vif *vif = link_conf->vif;
-	struct mt7996_phy *phy = link->phy;
-	int tx_ant = hweight16(phy->mt76->chainmask) - 1;
 	struct sta_rec_bf *bf;
 	struct tlv *tlv;
 	static const u8 matrix[BF_MAT_ORDER][BF_MAT_ORDER] = {
@@ -1915,8 +1921,12 @@ mt7996_mcu_sta_bfer_tlv(struct mt7996_de
 		{2, 4, 4, 0},	/* 3x1, 3x2, 3x3, 3x4 */
 		{3, 5, 6, 0}	/* 4x1, 4x2, 4x3, 4x4 */
 	};
+	int tx_ant;
 	bool ebf;
 
+	if (!phy)
+		return;
+
 	if (!(link_sta->ht_cap.ht_supported || link_sta->he_cap.has_he))
 		return;
 
@@ -1932,17 +1942,18 @@ mt7996_mcu_sta_bfer_tlv(struct mt7996_de
 	 * ht: iBF only, since mac80211 lacks of eBF support
 	 */
 	if (link_sta->eht_cap.has_eht)
-		mt7996_mcu_sta_bfer_eht(link_sta, vif, link->phy, bf, ebf);
+		mt7996_mcu_sta_bfer_eht(link_sta, vif, phy, bf, ebf);
 	else if (link_sta->he_cap.has_he)
-		mt7996_mcu_sta_bfer_he(link_sta, vif, link->phy, bf, ebf);
+		mt7996_mcu_sta_bfer_he(link_sta, vif, phy, bf, ebf);
 	else if (link_sta->vht_cap.vht_supported)
-		mt7996_mcu_sta_bfer_vht(link_sta, link->phy, bf, ebf);
+		mt7996_mcu_sta_bfer_vht(link_sta, phy, bf, ebf);
 	else if (link_sta->ht_cap.ht_supported)
-		mt7996_mcu_sta_bfer_ht(link_sta, link->phy, bf, ebf);
+		mt7996_mcu_sta_bfer_ht(link_sta, phy, bf, ebf);
 	else
 		return;
 
 	bf->bf_cap = ebf ? EBF_MODE : (dev->ibf ? IBF_MODE : 0);
+	tx_ant = hweight16(phy->mt76->chainmask) - 1;
 	if (is_mt7992(&dev->mt76) && tx_ant == 4)
 		bf->bf_cap |= IBF_MODE;
 
@@ -1974,11 +1985,14 @@ mt7996_mcu_sta_bfee_tlv(struct mt7996_de
 			struct ieee80211_link_sta *link_sta,
 			struct mt7996_vif_link *link)
 {
-	struct mt7996_phy *phy = link->phy;
-	int tx_ant = hweight8(phy->mt76->antenna_mask) - 1;
+	struct mt7996_phy *phy = mt7996_vif_link_phy(link);
 	struct sta_rec_bfee *bfee;
 	struct tlv *tlv;
 	u8 nrow = 0;
+	int tx_ant;
+
+	if (!phy)
+		return;
 
 	if (!(link_sta->vht_cap.vht_supported || link_sta->he_cap.has_he))
 		return;
@@ -2002,6 +2016,7 @@ mt7996_mcu_sta_bfee_tlv(struct mt7996_de
 	}
 
 	/* reply with identity matrix to avoid 2x2 BF negative gain */
+	tx_ant = hweight8(phy->mt76->antenna_mask) - 1;
 	bfee->fb_identity_matrix = (nrow == 1 && tx_ant == 2);
 }
 
@@ -2185,6 +2200,7 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt
 	struct ieee80211_sta *sta;
 	int ret, nrates = 0, idx;
 	enum nl80211_band band;
+	struct mt76_phy *mphy;
 	bool has_he;
 
 #define __sta_phy_bitrate_mask_check(_mcs, _gi, _ht, _he)			\
@@ -2218,7 +2234,11 @@ mt7996_mcu_add_rate_ctrl_fixed(struct mt
 	if (!link_sta)
 		goto error_unlock;
 
-	band = link->phy->mt76->chandef.chan->band;
+	mphy = mt76_vif_link_phy(&link->mt76);
+	if (!mphy)
+		goto error_unlock;
+
+	band = mphy->chandef.chan->band;
 	has_he = link_sta->he_cap.has_he;
 	mask = link->bitrate_mask;
 	idx = msta_link->wcid.idx;
@@ -2298,18 +2318,25 @@ mt7996_mcu_sta_rate_ctrl_tlv(struct sk_b
 			     struct mt7996_vif_link *link)
 {
 #define INIT_RCPI 180
-	struct mt76_phy *mphy = link->phy->mt76;
-	struct cfg80211_chan_def *chandef = &mphy->chandef;
+	struct mt76_phy *mphy = mt76_vif_link_phy(&link->mt76);
 	struct cfg80211_bitrate_mask *mask = &link->bitrate_mask;
 	u32 cap = link_sta->sta->wme ? STA_CAP_WMM : 0;
-	enum nl80211_band band = chandef->chan->band;
+	struct cfg80211_chan_def *chandef;
 	struct sta_rec_ra_uni *ra;
+	enum nl80211_band band;
 	struct tlv *tlv;
-	u32 supp_rate = link_sta->supp_rates[band];
+	u32 supp_rate;
+
+	if (!mphy)
+		return;
 
 	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_RA, sizeof(*ra));
 	ra = (struct sta_rec_ra_uni *)tlv;
 
+	chandef = &mphy->chandef;
+	band = chandef->chan->band;
+	supp_rate = link_sta->supp_rates[band];
+
 	ra->valid = true;
 	ra->auto_rate = true;
 	ra->phy_mode = mt76_connac_get_phy_mode(mphy, vif, band, link_sta);
@@ -2658,6 +2685,7 @@ void mt7996_mcu_update_sta_rec_bw(void *
 {
 	struct mt7996_vif_link *link = (struct mt7996_vif_link *)data;
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_phy *phy = mt7996_vif_link_phy(link);
 	struct mt7996_sta_link *msta_link;
 	struct mt7996_dev *dev;
 	struct ieee80211_bss_conf *link_conf;
@@ -2666,10 +2694,13 @@ void mt7996_mcu_update_sta_rec_bw(void *
 	struct sk_buff *skb;
 	int link_id;
 
+	if (!phy)
+		return;
+
 	if (link->mt76.mvif != &msta->vif->mt76)
 		return;
 
-	dev = link->phy->dev;
+	dev = phy->dev;
 	link_id = link->msta_link.wcid.link_id;
 	link_sta = link_sta_dereference_protected(sta, link_id);
 	if (!link_sta)
@@ -2936,6 +2967,7 @@ int mt7996_mcu_add_beacon(struct ieee802
 {
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_vif_link *link = mt7996_vif_conf_link(dev, vif, link_conf);
+	struct mt76_phy *mphy = link ? mt76_vif_link_phy(&link->mt76) : NULL;
 	struct mt76_vif_link *mlink = link ? &link->mt76 : NULL;
 	struct ieee80211_mutable_offsets offs;
 	struct ieee80211_tx_info *info;
@@ -2950,7 +2982,7 @@ int mt7996_mcu_add_beacon(struct ieee802
 	if (!mlink)
 		return -EINVAL;
 
-	if (link->phy && link->phy->mt76->offchannel)
+	if (mphy && mphy->offchannel)
 		enabled = false;
 
 	rskb = __mt7996_mcu_alloc_bss_req(&dev->mt76, mlink,
@@ -3001,9 +3033,9 @@ int mt7996_mcu_beacon_inband_discov(stru
 {
 #define OFFLOAD_TX_MODE_SU	BIT(0)
 #define OFFLOAD_TX_MODE_MU	BIT(1)
+	struct mt76_phy *mphy = mt76_vif_link_phy(&link->mt76);
 	struct ieee80211_vif *vif = link_conf->vif;
 	struct ieee80211_hw *hw = mt76_hw(dev);
-	struct mt7996_phy *phy = link->phy;
 	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
 	struct bss_inband_discovery_tlv *discov;
 	struct ieee80211_tx_info *info;
@@ -3014,10 +3046,10 @@ int mt7996_mcu_beacon_inband_discov(stru
 	u8 *buf, interval;
 	int len;
 
-	if (!phy)
+	if (!mphy)
 		return -EINVAL;
 
-	chandef = &phy->mt76->chandef;
+	chandef = &mphy->chandef;
 	band = chandef->chan->band;
 
 	if (link_conf->nontransmitted)
@@ -3053,7 +3085,7 @@ int mt7996_mcu_beacon_inband_discov(stru
 	info = IEEE80211_SKB_CB(skb);
 	info->control.vif = vif;
 	info->band = band;
-	info->hw_queue |= FIELD_PREP(MT_TX_HW_QUEUE_PHY, phy->mt76->band_idx);
+	info->hw_queue |= FIELD_PREP(MT_TX_HW_QUEUE_PHY, mphy->band_idx);
 
 	len = ALIGN(sizeof(*discov) + MT_TXD_SIZE + skb->len, 4);
 	tlv = mt7996_mcu_add_uni_tlv(rskb, UNI_BSS_INFO_OFFLOAD, len);
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -252,8 +252,6 @@ struct mt7996_vif_link {
 	struct mt76_vif_link mt76; /* must be first */
 
 	struct mt7996_sta_link msta_link;
-	struct mt7996_phy *phy;
-
 	struct cfg80211_bitrate_mask bitrate_mask;
 
 	u8 mld_idx;


