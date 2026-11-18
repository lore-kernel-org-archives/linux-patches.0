Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025866;
	b=u3BCtxXMV3PGORy2Z8MBfEYKXPrzG4iZalOF/HX3gDYP5Swl67AzHd12vZmeDeJvl1o7
	 VfMufEwKiNaaHFCRDmQGawqXaKPd4mvrPcycP5Xm+bCBofTNUxpU9IHfdoUnSw74WCYKj
	 a1edghWvXVRdHh0lAU2jP0FthPvQrkkwzYjoZ9YWdgiN04+RoG7rZ+rsMkpBlZhmOsp9U
	 qgnHl71v0nVRYbNHPj20kxNh2WM6yJO/vIYg0RyIki6J1px/9FBo/JTxXM7pxp8kZE0ZC
	 FYQm2uAJ23Y1VKWdQLrkPHOlvdoF3Tf2kUnDBbesSZ3lFb9LKu1pH3GVMr7ZQ/8iWFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+CUB+/EUm1TUYH7iR3r/6vs9aJRE+ZvFCdnTO0BibyU=;
	b=jQibvuWj01soVBXqt05TLORH2+F4mkAJx2Nr6ItXr98NHYWFd3vKk/opEsO+dslgntU3
	 Hc/qD6FOTEAPt/zwg2y1lTKsm/LU1nIAkNtN8OcW2qCndU1UGSe/vKuboJFOfduAQ2Z2/
	 ccY7AEHiY9u+q0V5kS6ECzpapLkrPWjSD+ijSH9bBd0RMxGpWGo2z35JifauWqkUimi0q
	 he08r+jwBa3bFLmksTRuhmJPxYNgerTC0vXpd72YqctD8R5wLEITDcgYHrI0imhPhdGWm
	 MAFgeWKd6Y0mVucRSNLEcwUiZ1NOiuc+jSxDlxL30frd1TXEVenERgGUXrCo70TIauA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c8h8e+xR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EA4606A320;
	Wed, 18 Nov 2026 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c8h8e+xR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5D41F000C4;
	Wed, 18 Nov 2026 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025865;
	bh=+CUB+/EUm1TUYH7iR3r/6vs9aJRE+ZvFCdnTO0BibyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8h8e+xRn2q4th4ZPfJKi8qS++nTN5OOmhnqnPhW1ujVxmKEm/pnu9zxwuQmywsVY
	 Yh03swGscrfDX3Ue/nq7ZYDu/BepFRMT1hmaCkQGHry2GhC0BiUHg/7Uc0T2SAYJeG
	 erVAkT4aMu692jXyVPj3r54w5sIMwex/5ZRkZmj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1230/2151] wifi: mt76: mt7996: clear all link wcid entries in sta_pre_rcu_remove
Date: Wed, 18 Nov 2026 15:49:25 +0100
Message-ID: <20261118150206.993196064@linuxfoundation.org>
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
 drivers/net/wireless/mediatek/mt76/mt7996/main.c |   26 ++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1346,6 +1346,30 @@ mt7996_set_active_links(struct ieee80211
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
@@ -2400,7 +2424,7 @@ const struct ieee80211_ops mt7996_ops =
 	.vif_cfg_changed = mt7996_vif_cfg_changed,
 	.link_info_changed = mt7996_link_info_changed,
 	.sta_state = mt7996_sta_state,
-	.sta_pre_rcu_remove = mt76_sta_pre_rcu_remove,
+	.sta_pre_rcu_remove = mt7996_sta_pre_rcu_remove,
 	.link_sta_rc_update = mt7996_link_sta_rc_update,
 	.set_key = mt7996_set_key,
 	.ampdu_action = mt7996_ampdu_action,


