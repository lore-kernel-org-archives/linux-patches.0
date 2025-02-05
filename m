Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC81515A86B;
	Wed,  5 Feb 2025 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765763; cv=none; b=jyPzjHrjutdw6xRfB3M/7H53+O9SGRd0VKr+u7f+YpSIAWfFSDEHWgEwhWkjsd7C4apg7MuUNhnwY/pcnvo9J2/L/u8X1JBAzLoYAoIPUUh7A4+VdYQHYcQBjrvtfFyreCswp614xiA6gu2DAdiXzgBJUBSE0Ui8JG1xmm/y+Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765763; c=relaxed/simple;
	bh=DXl1zoknPsb9EWlfE1owiI1P6NbNj/K0q8Imx6hvHd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwdP59bEiIEOvl51D1MPhQRl7Z3wOJCCP9IKw4i+lnesUrbOi8tiyKd8FMKO6D6mQ5a56STHrKWwxFqFxmTSf9vKxjiHRuSxsdzHX9yOxtUy46LOM59cRXBJnWQVuM1Gsx6LK1YEWnZJ/gKxXXVK703an/oLSEf0yPIGqcMmYSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8mkm0Jb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8mkm0Jb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4122AC4CED1;
	Wed,  5 Feb 2025 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765762;
	bh=DXl1zoknPsb9EWlfE1owiI1P6NbNj/K0q8Imx6hvHd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8mkm0JbfjZ7Bm0BCVbcEcF87b5Vk74b8iTU/+tL8UhvF8SkcmwIX8GxTLnAWaylN
	 VCobQ/PJgo1jboXy4jpCmnmS7AAVPv402CC0YxcvK6otOsXYmpySGjl96gMSYvNw7s
	 arCcAfSAyR2Wv+3dv96yiYsK0TqVy0ERU+03MtMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 211/623] wifi: mt76: mt7996: fix HE Phy capability
Date: Wed,  5 Feb 2025 14:39:13 +0100
Message-ID: <20250205134504.300471481@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 7e3aef59a403ade5dd4ea02edc2d7138a66d74b6 ]

Set HE SU PPDU And HE MU PPDU With 4x HE-LTF And 0.8 us GI within HE PHY
Capabilities element as 1 since hardware can support.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250114101026.3587702-3-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index e04abd57b3b3a..d8a013812d1e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1077,6 +1077,9 @@ mt7996_init_he_caps(struct mt7996_phy *phy, enum nl80211_band band,
 	he_cap_elem->phy_cap_info[2] = IEEE80211_HE_PHY_CAP2_STBC_TX_UNDER_80MHZ |
 				       IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ;
 
+	he_cap_elem->phy_cap_info[7] =
+			IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI;
+
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 		he_cap_elem->mac_cap_info[0] |= IEEE80211_HE_MAC_CAP0_TWT_RES;
@@ -1116,8 +1119,7 @@ mt7996_init_he_caps(struct mt7996_phy *phy, enum nl80211_band band,
 			IEEE80211_HE_PHY_CAP6_PARTIAL_BW_EXT_RANGE |
 			IEEE80211_HE_PHY_CAP6_PPE_THRESHOLD_PRESENT;
 		he_cap_elem->phy_cap_info[7] |=
-			IEEE80211_HE_PHY_CAP7_POWER_BOOST_FACTOR_SUPP |
-			IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI;
+			IEEE80211_HE_PHY_CAP7_POWER_BOOST_FACTOR_SUPP;
 		he_cap_elem->phy_cap_info[8] |=
 			IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G |
 			IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
-- 
2.39.5



