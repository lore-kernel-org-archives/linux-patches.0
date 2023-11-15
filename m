Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335C941A80
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rieBt+EL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33A5C433C8;
	Wed, 15 Nov 2023 19:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076979;
	bh=l5UAmf1Evp1Cr07sqQK/qRv6grCcatrzX8JZlyCmIdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rieBt+EL+RIFU7G1T1+1tvqE3a9rziJ3gFzSfNnAnBgwsdGleqCPaq6bKZVYmWRRD
	 zCLHn4BQaEV2n9ad2/UdWp7nIZKGvklfrEBaz2+9TGcMCIeNGgtSEm/f98PsvN2x19
	 9PCvYCLcsokvucgKK3IULkbB21lIB/Cdv+2cne+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/603] wifi: mt76: mt7996: fix beamformee ss subfield in EHT PHY cap
Date: Wed, 15 Nov 2023 14:10:30 -0500
Message-ID: <20231115191619.008342996@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit e19028104b2de5510b43282f632c4b6453568c41 ]

According to P802.11be_D3.2 Table 9-404m, the minimum value of
Beamformee SS field shall be 3. Fix the values to follow the spec.

Fixes: 348533eb968d ("wifi: mt76: mt7996: add EHT capability init")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 26e03b28935f2..66d8cc0eeabee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -733,16 +733,17 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 		IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMER |
 		IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMEE;
 
+	val = max_t(u8, sts - 1, 3);
 	eht_cap_elem->phy_cap_info[0] |=
-		u8_encode_bits(u8_get_bits(sts - 1, BIT(0)),
+		u8_encode_bits(u8_get_bits(val, BIT(0)),
 			       IEEE80211_EHT_PHY_CAP0_BEAMFORMEE_SS_80MHZ_MASK);
 
 	eht_cap_elem->phy_cap_info[1] =
-		u8_encode_bits(u8_get_bits(sts - 1, GENMASK(2, 1)),
+		u8_encode_bits(u8_get_bits(val, GENMASK(2, 1)),
 			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_80MHZ_MASK) |
-		u8_encode_bits(sts - 1,
+		u8_encode_bits(val,
 			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_160MHZ_MASK) |
-		u8_encode_bits(sts - 1,
+		u8_encode_bits(val,
 			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK);
 
 	eht_cap_elem->phy_cap_info[2] =
-- 
2.42.0



