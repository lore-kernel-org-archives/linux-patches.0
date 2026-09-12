Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022CE429000;
	Sat, 12 Sep 2026 12:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216776; cv=none; b=DesiMSLJYTw0u6URkWEAv53rfQIzP24FVWp99CFDP3p9esywUW3Ehl20aRb6E7oj4b+cUSdhcwnuI2ztG9r9G/+X6PC+ZG5TlQnc/7gngx75m6s3291b2Wi3iCseYj1JKDlMhNOXVAMlIQs4r9LrP/x181EfwJcUBKC/vyGp1Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216776; c=relaxed/simple;
	bh=YxMAzs/Ly6cxCnBdsh2FQxyC2PrFLbfSldZ96v7fsrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6xT7o3jEuKU4+wuLHxmwdMa55HfyL//1IrkPSGJfmU04fcxDQx9tpSLwivzn2bWmBesTSigW8M816Ma/JOg1QOWADj+PAf2Gdy7oGYAYEz6MR3BptnrRNQQUEAKK61BgNH9WszkyHqoeS3lMhGkQKhdBT5b1IAIqBqnXDdKz9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12hTNkRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12hTNkRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAAA1F000FF;
	Sat, 12 Sep 2026 12:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216774;
	bh=hB0iJpeE+mtmQTDhuzuHjU46jPF9QAkkz9gAOWlf1Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12hTNkRCHy9KEKXpCIfsADtVUa1osKgnFytxF+9LLJa0So4UH0wBEzshae4bLsmmi
	 VDS/SsGC/G3LkkLHYjzQ5E5oXlEhy7EXTuK0mR8ZkSaIFKeMQTrlHfFdlbiyYK5gq+
	 lZDVWvhVx78kA+EwSy4KY5wF+n3dviSoIYFY0ohc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0806/1376] wifi: mt76: mt7996: fix capability of EHT-MCS 15 in MRU
Date: Sat, 12 Sep 2026 08:53:52 +0200
Message-ID: <20260912065625.502252685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 29e889c4ada83c69d10a3937f5ae2934306e2e3d ]

According to the definition in IEEE Std 802.11be-2024, Table 9-417r:
- If 80 MHz is not supported, bit 1-3 are set to 0.
- If 160 MHz is not supported, bit 2-3 are set to 0.
- If 320 MHz is not supported, bit 3 is set to 0.

Fixes: 348533eb968d ("wifi: mt76: mt7996: add EHT capability init")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20260313062150.3165433-2-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index fc2d46b10b720..d3d63f07d7b05 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1181,7 +1181,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 	struct ieee80211_sta_eht_cap *eht_cap = &data->eht_cap;
 	struct ieee80211_eht_cap_elem_fixed *eht_cap_elem = &eht_cap->eht_cap_elem;
 	struct ieee80211_eht_mcs_nss_supp *eht_nss = &eht_cap->eht_mcs_nss_supp;
-	enum nl80211_chan_width width = phy->mt76->chandef.width;
 	int nss = hweight8(phy->mt76->antenna_mask);
 	int sts = hweight16(phy->mt76->chainmask);
 	u8 val;
@@ -1250,11 +1249,16 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 		u8_encode_bits(u8_get_bits(1, GENMASK(1, 0)),
 			       IEEE80211_EHT_PHY_CAP5_MAX_NUM_SUPP_EHT_LTF_MASK);
 
-	val = width == NL80211_CHAN_WIDTH_320 ? 0xf :
-	      width == NL80211_CHAN_WIDTH_160 ? 0x7 :
-	      width == NL80211_CHAN_WIDTH_80 ? 0x3 : 0x1;
-	eht_cap_elem->phy_cap_info[6] =
-		u8_encode_bits(val, IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK);
+	eht_cap_elem->phy_cap_info[6] = IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK;
+	if (band != NL80211_BAND_6GHZ) {
+		eht_cap_elem->phy_cap_info[6] &=
+			~IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_320MHZ;
+
+		if (band != NL80211_BAND_5GHZ)
+			eht_cap_elem->phy_cap_info[6] &=
+				~(IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_160MHZ |
+				  IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_80MHZ);
+	}
 
 	val = u8_encode_bits(nss, IEEE80211_EHT_MCS_NSS_RX) |
 	      u8_encode_bits(nss, IEEE80211_EHT_MCS_NSS_TX);
-- 
2.53.0



