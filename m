Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019138;
	b=glgKhnqIOv/b3AiskPix5haj91Ynq+uPYHDtOwbueiHFqDb1y8A6r1JI/O4T4HaO1n8k
	 5Wi9dBmtP0aA9Su2kNx7x8n/pUyg57Aa6EPKFQsvRSzw4YfXyE+4uQUpYnuBm/dUP3wsh
	 AIvUzlB/BaLJ7dyxzcAlPTjQMmVJRZaDGXHccbPykVALaP9yTeL1kRORzJ0To0a/oDIqQ
	 ikzWuVveA4fvG+s42bZR7kunJ9GGKWL9IVhp+zsLR+5GF9TO65FQ+DjSMJArukYSu5eNW
	 D4ki2LtsbE+JKXidrK4KCgNPUcFfcQBMyOs/bQNsQA1BGtlw1PJkRu5rT0/UV0V4Zvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oM8c948fCvwuU910WuI6LcaCZMQ9aitOIlT36oraWPM=;
	b=XReagrh5RGWAKD7Kev1bhPbW3Wd0+vi+a8uIIREUUcloOyhxFC0tMXfHcUa2eSN1BFVA
	 AMim0C1F2W10oRyhPPKuutMfS/O2g04B2d0QocUNIXvA0V9v+hrChch2qFKU8Ps5umjEy
	 0s2VJbmYX9//QahwF5VOAXiKB159b4EVNPHnRHSUC1V6FZAuQq2qppkTpvdK4A1J+L1Qj
	 9be7UeWaazyGaE+AnsLRN3Usk3B7WNBi5KJ4YMBw9D7BCiM803UFLJRSPv1Elhii3ZrOV
	 U5goOcByQ+eXMFucgAxamjSfzWIaqgPldAmHnYdZaM+A5afUJbCj9Gk2GQx5IELrcGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1HXiNxZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A36606A31C;
	Wed, 18 Nov 2026 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1HXiNxZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57E71F000C4;
	Wed, 18 Nov 2026 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019138;
	bh=oM8c948fCvwuU910WuI6LcaCZMQ9aitOIlT36oraWPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1HXiNxZAGoYyAz9Fh1nGBxBkNpJiNsMKZ+PvjdXFPRmPufccRsxjgmGZOV5r0g5t
	 IoJsW60hhKaPEnUJrIAHwZMjR1KqpSc82FLu+/kMjnmtofKSnSn9LAKcb/5NKVNX2I
	 xNyKs5YvFs6+wrfEE604bqAWjF3DbfPTXFfXxhoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1482/2651] wifi: mt76: mt7996: do not add a station link in disconnected state
Date: Wed, 18 Nov 2026 15:45:22 +0100
Message-ID: <20261118150341.375360248@linuxfoundation.org>
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

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit ad8e618e4474dda22936a52757838ff990e6cda1 ]

Since the driver uses the .sta_state op, mt7996_mac_sta_init_link()
sends a STA_REC with CONN_STATE_DISCONNECT when a station link is set
up. Before that change, the first STA_REC for a station was the one
that connects it. MediaTek reports that DL OFDMA fails after a station
reconnects.

Only send a STA_REC for a station link when it connects. Until then the
firmware has no STA_REC for the link, so track whether a link is
connected, and skip rate control updates and the 4-address and decap
updates for a link that is not. wcid.sta cannot be used for this,
since it is set when the link is set up.

Fixes: 13e2e9c6b348 ("wifi: mt76: mt7996: use mac80211 .sta_state op")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Link: https://patch.msgid.link/20261006205936.669125-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |  4 +++
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 33 +++++++++++++------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index eb39526548e8a..c4e82b1e259c2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2948,6 +2948,10 @@ void mt7996_mac_sta_rc_work(struct work_struct *work)
 
 		changed = msta_link->changed;
 		msta_link->changed = 0;
+
+		if (!msta_link->connected)
+			continue;
+
 		mvif = msta_link->sta->vif;
 		vif = container_of((void *)mvif, struct ieee80211_vif,
 				   drv_priv);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index ab31fafd5c8d1..cc65964abbef9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1236,7 +1236,6 @@ mt7996_sta_seclink_get(struct mt7996_dev *dev, struct mt7996_sta *msta)
 
 static int
 mt7996_mac_sta_init_link(struct mt7996_dev *dev,
-			 struct ieee80211_bss_conf *link_conf,
 			 struct ieee80211_link_sta *link_sta,
 			 struct mt7996_vif_link *link, unsigned int link_id)
 {
@@ -1269,6 +1268,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	INIT_LIST_HEAD(&msta_link->rc_list);
 	INIT_LIST_HEAD(&msta_link->wcid.poll_list);
 	msta_link->sta = msta;
+	msta_link->connected = false;
 	msta_link->wcid.sta = 1;
 	msta_link->wcid.idx = idx;
 	msta_link->wcid.link_id = link_id;
@@ -1287,8 +1287,6 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	msta->seclink_id = mt7996_sta_seclink_get(dev, msta);
 
 	mt7996_mac_wtbl_update(dev, idx, MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
-	mt7996_mcu_add_sta(dev, link_conf, link_sta, link, msta_link,
-			   CONN_STATE_DISCONNECT, true);
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], &msta_link->wcid);
 	mt76_wcid_init(&msta_link->wcid, phy->mt76->band_idx);
@@ -1391,7 +1389,6 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	int err = 0;
 
 	for_each_set_bit(link_id, &new_links, IEEE80211_MLD_MAX_NUM_LINKS) {
-		struct ieee80211_bss_conf *link_conf;
 		struct ieee80211_link_sta *link_sta;
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
@@ -1409,8 +1406,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			continue;
 		}
 
-		link_conf = link_conf_dereference_protected(vif, link_id);
-		if (!link_conf) {
+		if (!link_conf_dereference_protected(vif, link_id)) {
 			err = -EINVAL;
 			goto error_unlink;
 		}
@@ -1433,8 +1429,7 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			goto error_unlink;
 		}
 
-		err = mt7996_mac_sta_init_link(dev, link_conf, link_sta, link,
-					       link_id);
+		err = mt7996_mac_sta_init_link(dev, link_sta, link, link_id);
 		if (err)
 			goto error_unlink;
 
@@ -1522,6 +1517,7 @@ mt7996_mac_sta_links_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			if (err)
 				return err;
 
+			msta_link->connected = true;
 			err = mt7996_mcu_add_rate_ctrl(dev, msta_link->sta, vif,
 						       link_id, false);
 			if (err)
@@ -1559,16 +1555,33 @@ mt7996_mac_sta_links_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	return 0;
 }
 
+static void
+mt7996_mac_sta_clear_connected(struct mt7996_dev *dev, struct mt7996_sta *msta)
+{
+	unsigned int link_id;
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		struct mt7996_sta_link *msta_link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (msta_link)
+			msta_link->connected = false;
+	}
+}
+
 static int
 mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		     struct ieee80211_sta *sta, enum mt76_sta_event ev)
 {
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
 	int err;
 
 	mutex_lock(&dev->mt76.mutex);
 	err = mt7996_mac_sta_links_event(dev, vif, sta,
 					 mt7996_mac_sta_links(dev, vif, sta),
 					 ev);
+	if (!err && ev == MT76_STA_EVENT_DISASSOC)
+		mt7996_mac_sta_clear_connected(dev, msta);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return err;
@@ -2201,7 +2214,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 			continue;
 
 		mt7996_sta_link_hdr_trans_set(msta, msta_link);
-		if (!msta_link->wcid.sta)
+		if (!msta_link->connected)
 			continue;
 
 		mt7996_mcu_wtbl_update_hdr_trans(dev, vif, link, msta_link);
@@ -2244,7 +2257,7 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 			continue;
 
 		mt7996_sta_link_hdr_trans_set(msta, msta_link);
-		if (!msta_link->wcid.sta)
+		if (!msta_link->connected)
 			continue;
 
 		mt7996_mcu_wtbl_update_hdr_trans(dev, vif, link, msta_link);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 949e659b8e2d7..ec453f5ff3a55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -244,6 +244,7 @@ struct mt7996_sta_link {
 	struct mt76_wcid wcid; /* must be first */
 
 	struct mt7996_sta *sta;
+	bool connected;
 
 	struct list_head rc_list;
 	u32 airtime_ac[8];
-- 
2.53.0



