Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019119;
	b=3Vrgax7e1pYd6OY/mfYVR8fLvuBjscW+j6D7nZ0+2yAWUfasL9xu0wMJkyOAumoaQwNA
	 ClpBkcgT7846Ix416D2N8SxabTK9+5bjczdXd2xeBvCwXUb5YeX137JX8GjIeCXHBLa4+
	 7RABV8l0Jom2ofIZ9y9SswsDXJBXv0JMb2xJtZ9lpzgO3HUAnGYaEz0Ik+WuXM0Q+XQYh
	 EkXisxmBDFV0Lg7W+DbjbI0bz1Emy7LwBVFm0DYJMN35Gzy01d+eqLXbk8Ptbk1nUmoE7
	 mX3Kov+rABDl1RtXRpYxDL88JA0IwW6Lyezkoyj8uSNGEQ5k+zGBYP4fDleep4fj/Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6wR/wO9rp89/84Ccj+7BSpvVBZSTlsrhkxnkxWSozAo=;
	b=hjXpe5/75ACZBC57D5nof3Dgtqp7jqOrVvTtS4NNfUBRp2ZxVi+68frC00zC5w6d2e9k
	 CpvdmWeaPpTQoeRCep/7/fE0VLdB8WLD12jhRoQWDzTBS+zF2vRGgcDfZrpNF1F0K9hUZ
	 qV5b0p/tAMHSqPJTZpXqQM1/9SQbskhO5k+bu77qch9CoMg0JqlggCLxRgRxuDKPNB8p8
	 xFKDQvzprLevnH/VnJhoa3c7E2KwsU4oQZVPYSdGK7piJKcFQrhxyhoDFTGNfM1N6N/2j
	 1npj+JIN3JFB6dJnz/QQVCgml34NgDdKLxXUYTqRNPsTvbOBjcPBx1aSyzPPjrKNI+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ii6YUpwK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50901606A31C;
	Wed, 18 Nov 2026 16:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ii6YUpwK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501F31F000C4;
	Wed, 18 Nov 2026 16:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019118;
	bh=6wR/wO9rp89/84Ccj+7BSpvVBZSTlsrhkxnkxWSozAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ii6YUpwK/7h79jxPbrWVrw1UCPxOa2EirBDq/cvu+lz2nVRRUDZCXt2HBWv+EhSF9
	 w76gLsWGZprzJrdniGuHXMplkVqaDpc4ZM8CT6bqRMToWAfpK7FYNOVGZEhlc/C2ib
	 YMcDnPvgoaoa+iGD4OFb5a8XjdP4CohofZkNBjU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1480/2651] wifi: mt76: mt7996: add the station BMC entry as new once per BSSID
Date: Wed, 18 Nov 2026 15:45:20 +0100
Message-ID: <20261118150341.306804141@linuxfoundation.org>
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

[ Upstream commit 854c8d4358272ad1204e9436996dec264fe334b1 ]

A station link sends its broadcast STA_REC with EXTRA_INFO_NEW on every
BSS_CHANGED_BSSID. Commit 8e3e7567b8c1 ("mt76: mt7915: add sta_rec with
EXTRA_INFO_NEW for the first time only") notes that the firmware may
remove an entry that is added as new twice. Since a removed vif link
keeps its firmware entry, this happens on a link that is deactivated and
activated again: _ieee80211_set_active_links() reports
BSS_CHANGED_BSSID with the same BSSID, after ieee80211_key_switch_links()
has installed the group keys of the link, and nothing in the driver
installs them again after the entry is added as new.

Record the BSSID the entry was added with, and add it as new only for
a different BSSID. A BSSID that goes to zero on disconnection clears
the record, so that the next association adds the entry as new again.
A link that is set up clears the record as well, since the firmware has
no entry for it then.

Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Link: https://patch.msgid.link/20261006205936.669125-16-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 38 ++++++++++++-------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 8a00ab49d90dc..3e55f7b19895a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -341,6 +341,7 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		return -ENOSPC;
 
 	link->mld_idx = mld_idx;
+	eth_zero_addr(link->bmc_bssid);
 	mlink->omac_idx = idx;
 	mlink->band_idx = band_idx;
 	mlink->wmm_idx = vif->type == NL80211_IFTYPE_AP ? 0 : 3;
@@ -905,6 +906,23 @@ mt7996_update_mu_group(struct ieee80211_hw *hw, struct mt7996_vif_link *link,
 	mt76_wr(dev, MT_WF_PHYRX_BAND_GID_TAB_POS3(band), mu[3]);
 }
 
+static void
+mt7996_vif_link_bss_add(struct mt7996_phy *phy, struct ieee80211_vif *vif,
+			struct ieee80211_bss_conf *link_conf,
+			struct mt7996_vif_link *link, bool newly)
+{
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		newly = !ether_addr_equal_unaligned(link->bmc_bssid,
+						    link_conf->bssid);
+		memcpy(link->bmc_bssid, link_conf->bssid, ETH_ALEN);
+	}
+
+	mt7996_mcu_add_bss_info(phy, vif, link_conf, &link->mt76,
+				&link->msta_link, true);
+	mt7996_mcu_add_sta(phy->dev, link_conf, NULL, link, NULL,
+			   CONN_STATE_PORT_SECURE, newly);
+}
+
 static void
 mt7996_vif_cfg_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       u64 changed)
@@ -936,12 +954,8 @@ mt7996_vif_cfg_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			if (!phy)
 				continue;
 
-			mt7996_mcu_add_bss_info(phy, vif, link_conf,
-						&link->mt76, &link->msta_link,
-						true);
-			mt7996_mcu_add_sta(dev, link_conf, NULL, link, NULL,
-					   CONN_STATE_PORT_SECURE,
-					   !!(changed & BSS_CHANGED_BSSID));
+			mt7996_vif_link_bss_add(phy, vif, link_conf, link,
+						!!(changed & BSS_CHANGED_BSSID));
 		}
 	}
 
@@ -987,13 +1001,11 @@ mt7996_link_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	 * and then peer references bss_info_rfch to set bandwidth cap.
 	 */
 	if ((changed & BSS_CHANGED_BSSID && !is_zero_ether_addr(info->bssid)) ||
-	    (changed & BSS_CHANGED_BEACON_ENABLED && info->enable_beacon)) {
-		mt7996_mcu_add_bss_info(phy, vif, info, &link->mt76,
-					&link->msta_link, true);
-		mt7996_mcu_add_sta(dev, info, NULL, link, NULL,
-				   CONN_STATE_PORT_SECURE,
-				   !!(changed & BSS_CHANGED_BSSID));
-	}
+	    (changed & BSS_CHANGED_BEACON_ENABLED && info->enable_beacon))
+		mt7996_vif_link_bss_add(phy, vif, info, link,
+					!!(changed & BSS_CHANGED_BSSID));
+	else if (changed & BSS_CHANGED_BSSID)
+		eth_zero_addr(link->bmc_bssid);
 
 	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
 		mt7996_mcu_set_protection(phy, link, info->ht_operation_mode,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 82a2a8a5db69e..03fc0e7fd4f1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -279,6 +279,7 @@ struct mt7996_vif_link {
 	struct cfg80211_bitrate_mask bitrate_mask;
 
 	u8 mld_idx;
+	u8 bmc_bssid[ETH_ALEN];
 };
 
 struct mt7996_vif_link_info {
-- 
2.53.0



