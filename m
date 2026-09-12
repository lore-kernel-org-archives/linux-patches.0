Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DED38DC59;
	Sat, 12 Sep 2026 10:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209158; cv=none; b=bN1m2LRcByygEFLQgXDdZdpH7cVpjGNf/D4oUmek4EKoMKfB68xluNy931Tw6AXQMUQq8AcLxaHfJLh8I7LaOxtNTMTTOaXXiy+a5lcyIcxKNXz3x/m4DlXE72OLisBMtOWPDml3/VRMhwv8XIqq67fSDkkDITxSQMI4Hn8izLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209158; c=relaxed/simple;
	bh=HU/twhIJs7z+mBp4MoQci9fstUisuLh1BBC4Vm07C/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edQ4tRMmDMHeFEBdXbDc38D+RgK0ZcBNpr0PCnNS+lwklTK10KblpD/y+8mLLjBQxwPyXm6AIL1IUuFGOV3EzVqxuwMTkYTpQEP7AtdB8a6W+IT+NHHsc4AkKhg+m8kMzxQ6k7sNye5b1U4lGcPQVy9QsWZ0cotccWftfL2Dkx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htkoNHr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htkoNHr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDA21F00893;
	Sat, 12 Sep 2026 10:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209157;
	bh=A/FKnDBJl+j45mqkTC0Mc5y3ZsgrZZDNR7BDqOQslb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htkoNHr6lw7CQYIfFUpyD6/0u5LNeojLJHVpVlWBBW2rDqKmovo3o+HFb1LYZJDyt
	 r0UuNfsTzmmGT/tWFPxdd3HoYhoHUG+NtPpTAytSiVjgJs+5PMDgPEeqvzpas7QBbL
	 akyxv23b9PtpXB1TXrWLjJJ2TyThm3WQSjQC+qBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0737/1518] wifi: mt76: mt7996: fix capability of EHT-MCS 15 in MRU
Date: Sat, 12 Sep 2026 08:48:26 +0200
Message-ID: <20260912065640.107479394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index efbd46d649017..462322896b474 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1502,7 +1502,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 	struct ieee80211_sta_eht_cap *eht_cap = &data->eht_cap;
 	struct ieee80211_eht_cap_elem_fixed *eht_cap_elem = &eht_cap->eht_cap_elem;
 	struct ieee80211_eht_mcs_nss_supp *eht_nss = &eht_cap->eht_mcs_nss_supp;
-	enum nl80211_chan_width width = phy->mt76->chandef.width;
 	int nss = hweight8(phy->mt76->antenna_mask);
 	int sts = hweight16(phy->mt76->chainmask);
 	u8 val;
@@ -1578,11 +1577,16 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
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



