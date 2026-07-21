Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4B946C4AE;
	Tue, 21 Jul 2026 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649449; cv=none; b=gTaRow2nCNvkNPO1B+yGuYK6oz2+X+PGlNIRNEVAsMoeaG42fULoHDXOD5uGMRePBaXFAwil2mp6sckJRmAdnV2OVQWPkHxgAJM/wkq1u5suOurgmdhQU9Ly6aYKEHjV6B9DSD6L3/ZZOnSR4zyXFa/gG/0yWffdtOzH/k6L4c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649449; c=relaxed/simple;
	bh=XFVGcLMDBvNK5JpM/UcOF8aRJgo7GXPuUQEYMjRxQzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZElsqL6rxNrQ+PYdBt00Td0CgVkkz9+vpdMhD5HUGgffktln/ctkaHjZANJCWwQyVk85PtNN3nCcjr453Qy6hxHMZhJNv8TJfWwHSKUL966M1w2WlpivcPq3cR3hrdSCTATCYKNsKzmYz+7S4KDm0zHGqX000k3HZ/Onj+3YeyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lS096/2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lS096/2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7471F000E9;
	Tue, 21 Jul 2026 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649448;
	bh=yRXJFRPGI08gpqMekV2lxPZHbX7/lXEkrhhIFb/Gxk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lS096/2wj9CQg+xeCiDCw6x89fWCcCpTcrQ2Vdwx6Ug+s+wmLYoAmVmlDlAWKGU94
	 qns31xRWKkIE8kS98vmCFgDU7LTcMtqO/c7mAW/LEjxJ2vwU2R/eLs0BTUYu6yiwaz
	 nj2/jKu68ItKJzOWPAS9sKvUPgtARmtvmctrBtfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0581/2077] wifi: mt76: mt7996: add missing max_remain_on_channel_duration
Date: Tue, 21 Jul 2026 17:04:14 +0200
Message-ID: <20260721152606.513760483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ac41612e0044fa29cf9bc45b6808dda6d87ac2da ]

Having this unset breaks remain-on-channel and mgmt TX.
Move setting it to mt76 core to keep it in one place.

Fixes: 69d54ce7491d0 ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Link: https://patch.msgid.link/20260324154904.2555603-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 1 -
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index b78b4cd206e064..dd09ef1bd0c25a 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -449,6 +449,8 @@ mt76_phy_init(struct mt76_phy *phy, struct ieee80211_hw *hw)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_AQL);
 
+	if (!wiphy->max_remain_on_channel_duration)
+		wiphy->max_remain_on_channel_duration = 5000;
 	if (!wiphy->available_antennas_tx)
 		wiphy->available_antennas_tx = phy->antenna_mask;
 	if (!wiphy->available_antennas_rx)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 42e11ba1206ee8..e437e088b2e913 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -195,7 +195,6 @@ mt7615_check_offload_capability(struct mt7615_dev *dev)
 		ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 
 		wiphy->flags &= ~WIPHY_FLAG_4ADDR_STATION;
-		wiphy->max_remain_on_channel_duration = 5000;
 		wiphy->features |= NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
 				   NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR |
 				   WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 152cfcca2f908a..5a5d7534830bba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -657,7 +657,6 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_P2P_DEVICE);
-	wiphy->max_remain_on_channel_duration = 5000;
 	wiphy->max_scan_ie_len = MT76_CONNAC_SCAN_IE_LEN;
 	wiphy->max_scan_ssids = 4;
 	wiphy->max_sched_scan_plan_interval =
-- 
2.53.0



