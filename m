Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019099;
	b=Wt0tzOFnLmUddhpGGc+CToG9n2Llg57hDE5KHS2ICbXA5vKYfhi/P8Gb6RlQ2nlBaXad
	 yhS0Ivnnr2Ae+IDnqQV7XotxoDbZ9i3DnCgKED0PHkg2G7Xzl76hHUgu7mTOz2D3YcdJP
	 JCMS6o3Kvn3BivcEmmQMR15k4Ap6V5HoHcuqZ7rjqLmhmCy74I+dvokm5lMCKheh57ITZ
	 QRnd2BcWk/vCwWbWR2OMP5pT0i9hVibvAsYFdfGPMgWbsH+rwTRPd4ZZg9iv63AznvrrY
	 oeh4cnoaCqnYK2uZhW9kY7BDO+3rwsdl1j/udG1tJMnHAgfz0pghw+RvvMd1+WPlOtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZR0l8xfPqY2m0GKMQTip5Cbr8KnD2/2bIZcJsvoYLQs=;
	b=gENXZlF3Lpo2LbJueIbbqyBlQYaBrZAWJigkn43JPSuAK1O8PELsfqt1TqmTp6XqKLKK
	 kpbGbIklE8utpn/TAeVr0+qcrxOEhquhwzS+Pd9NQ7SyDsvzbsKOMl/qas/77veZjQhy7
	 0bJ+NgXwcL2rwgJSMBc3lJm8wcNbhxsR3wP6sR/CuvG4U6XvfDgSnoW6eGs6Fihk5ANo6
	 8WPdhSAlZBJH55WDf6cgDbvFwfxf0ORJqjEWr8jBlCgfMKIGuGDE2gaKU28EsmbBbPBYM
	 nkswRlN+qO1fZg7ifp5HZl115VevIKPB52BwBuFHSsyfnxC2ZpVL1BW1FbPKNV/z8/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOBvdq7C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C5D60A2606;
	Wed, 18 Nov 2026 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tOBvdq7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3961F000CF;
	Wed, 18 Nov 2026 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019099;
	bh=ZR0l8xfPqY2m0GKMQTip5Cbr8KnD2/2bIZcJsvoYLQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOBvdq7CwLI99IIMhARUuKq5bWFmVF0OuuIVLEc5SdvaocwIUDhuaTgCTi3BEqaqA
	 XA5pmtynNQyvkiIGxIo3ODPajSHUmH3JYF6PZLJJFZw3j/34GmSz8O3YqvhxKJDAiO
	 aXhrDfF0wYu3gOzTs9gf5A0Q+CIi7V8qSX1tkoKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1474/2651] wifi: mt76: mt7996: clear all link wcid entries in sta_pre_rcu_remove
Date: Wed, 18 Nov 2026 15:45:14 +0100
Message-ID: <20261118150341.095507735@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit a53699a3d482a980efb016469b99ffac172280af ]

mt76_sta_pre_rcu_remove() clears the wcid table entry of msta->deflink
only. mac80211 calls it before the synchronize_net() that ends the RCU
readers of the station, and frees the station right after
mt7996_mac_sta_remove(). For an MLD station, the wcid table entries of
the other links stay set until mt7996_mac_sta_remove(), after that
grace period. An RX or TX status reader that looks up one of these
entries in that window can follow msta_link->sta or def_wcid into the
freed station.

Clear the wcid table entries of all links of the station in
.sta_pre_rcu_remove.

Fixes: dd82a9e02c05 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Link: https://patch.msgid.link/20261006205936.669125-10-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index b52308c42d106..3b50457955978 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1521,6 +1521,30 @@ mt7996_set_active_links(struct ieee80211_vif *vif)
 	ieee80211_set_active_links_async(vif, active_links);
 }
 
+static void
+mt7996_sta_pre_rcu_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta)
+{
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	unsigned int link_id;
+
+	mutex_lock(&dev->mt76.mutex);
+	spin_lock_bh(&dev->mt76.status_lock);
+
+	for (link_id = 0; link_id < ARRAY_SIZE(msta->link); link_id++) {
+		struct mt7996_sta_link *msta_link;
+
+		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
+		if (msta_link)
+			rcu_assign_pointer(dev->mt76.wcid[msta_link->wcid.idx],
+					   NULL);
+	}
+
+	spin_unlock_bh(&dev->mt76.status_lock);
+	mutex_unlock(&dev->mt76.mutex);
+}
+
 static int
 mt7996_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		 struct ieee80211_sta *sta, enum ieee80211_sta_state old_state,
@@ -2626,7 +2650,7 @@ const struct ieee80211_ops mt7996_ops = {
 	.vif_cfg_changed = mt7996_vif_cfg_changed,
 	.link_info_changed = mt7996_link_info_changed,
 	.sta_state = mt7996_sta_state,
-	.sta_pre_rcu_remove = mt76_sta_pre_rcu_remove,
+	.sta_pre_rcu_remove = mt7996_sta_pre_rcu_remove,
 	.link_sta_rc_update = mt7996_link_sta_rc_update,
 	.set_key = mt7996_set_key,
 	.ampdu_action = mt7996_ampdu_action,
-- 
2.53.0



