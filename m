Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3751376BDD;
	Tue, 16 Dec 2025 12:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888069; cv=none; b=rZ6rHD5qB0xNZTGdcZtSUIMtUy7kkiWkpkdF2XkCDinOG5ZC4ugs6TtajyVTSLHnI83aGAIEEkiPQDiCd0DtZPC3OYlbX4AzN9KJovVXHCyuqdp96Nm5kkK+nY1Q50iCuAgcR5FOOQtqo0X+WK5U8dkBDPP56GP5L0PtBDlJVDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888069; c=relaxed/simple;
	bh=aW/QI9BHT/aQPopGr6c+3EltXseIbcPNV6WJ1kuAHBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2jrgzWiEh0VqzMvIiKJEkYPY0Yv4VOBQihlhWgL9ZqcBxLN32qUpkgVfpDOHddhMtF94xb0DpVYLNkBRCZC+WU4+9wEzv53s/AMh7U35pbtMLSrNMh3QgvYi0fxxKi1uSr2SlB167ZIp9OiWKYFq2UXmVJnXnnz1OsUEXrAAwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSN2v9/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSN2v9/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6684AC4CEF1;
	Tue, 16 Dec 2025 12:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888068;
	bh=aW/QI9BHT/aQPopGr6c+3EltXseIbcPNV6WJ1kuAHBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSN2v9/wKzVFpRXw5LjmKmo30AARec2Hg/fEMve2KBN1TNUSRkAuXCl2PzjkGQB7S
	 AqAZRxQsnrFWHI6wIOjQ01puD96C+4zOpzvrzzv2B6knr++tlA1Q33hxHXI7qHIRmU
	 Pb6A0/qcG/8jAvN3uiyQlzGdUVoQB2JXXPwrqXVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/614] wifi: mt76: mt7996: fix several fields in mt7996_mcu_bss_basic_tlv()
Date: Tue, 16 Dec 2025 12:12:37 +0100
Message-ID: <20251216111415.502628858@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit bb705a606734e1ce0ff17a4f368a896757ba686d ]

Fix several fields in mt7996_mcu_bss_basic_tlv() that were not obtained
from the correct link. Without this patch, the MLD station interface
does not function properly.

Fixes: 34a41bfbcb71 ("wifi: mt76: mt7996: prepare mt7996_mcu_add_dev/bss_info for MLO support")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106064203.1000505-5-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 9af3c48707ab7..21be88e76c655 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1034,7 +1034,6 @@ mt7996_mcu_bss_basic_tlv(struct sk_buff *skb,
 	struct mt76_connac_bss_basic_tlv *bss;
 	u32 type = CONNECTION_INFRA_AP;
 	u16 sta_wlan_idx = wlan_idx;
-	struct ieee80211_sta *sta;
 	struct tlv *tlv;
 	int idx;
 
@@ -1045,14 +1044,18 @@ mt7996_mcu_bss_basic_tlv(struct sk_buff *skb,
 		break;
 	case NL80211_IFTYPE_STATION:
 		if (enable) {
+			struct ieee80211_sta *sta;
+
 			rcu_read_lock();
-			sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
-			/* TODO: enable BSS_INFO_UAPSD & BSS_INFO_PM */
+			sta = ieee80211_find_sta(vif, link_conf->bssid);
 			if (sta) {
-				struct mt76_wcid *wcid;
+				struct mt7996_sta *msta = (void *)sta->drv_priv;
+				struct mt7996_sta_link *msta_link;
+				int link_id = link_conf->link_id;
 
-				wcid = (struct mt76_wcid *)sta->drv_priv;
-				sta_wlan_idx = wcid->idx;
+				msta_link = rcu_dereference(msta->link[link_id]);
+				if (msta_link)
+					sta_wlan_idx = msta_link->wcid.idx;
 			}
 			rcu_read_unlock();
 		}
@@ -1069,8 +1072,6 @@ mt7996_mcu_bss_basic_tlv(struct sk_buff *skb,
 	tlv = mt7996_mcu_add_uni_tlv(skb, UNI_BSS_INFO_BASIC, sizeof(*bss));
 
 	bss = (struct mt76_connac_bss_basic_tlv *)tlv;
-	bss->bcn_interval = cpu_to_le16(link_conf->beacon_int);
-	bss->dtim_period = link_conf->dtim_period;
 	bss->bmc_tx_wlan_idx = cpu_to_le16(wlan_idx);
 	bss->sta_idx = cpu_to_le16(sta_wlan_idx);
 	bss->conn_type = cpu_to_le32(type);
@@ -1090,10 +1091,10 @@ mt7996_mcu_bss_basic_tlv(struct sk_buff *skb,
 
 	memcpy(bss->bssid, link_conf->bssid, ETH_ALEN);
 	bss->bcn_interval = cpu_to_le16(link_conf->beacon_int);
-	bss->dtim_period = vif->bss_conf.dtim_period;
+	bss->dtim_period = link_conf->dtim_period;
 	bss->phymode = mt76_connac_get_phy_mode(phy, vif,
 						chandef->chan->band, NULL);
-	bss->phymode_ext = mt76_connac_get_phy_mode_ext(phy, &vif->bss_conf,
+	bss->phymode_ext = mt76_connac_get_phy_mode_ext(phy, link_conf,
 							chandef->chan->band);
 
 	return 0;
-- 
2.51.0



