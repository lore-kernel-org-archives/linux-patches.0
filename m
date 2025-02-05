Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6894E1519BE;
	Wed,  5 Feb 2025 14:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765249; cv=none; b=B5+mgW3eu933pQuHpEA9ajQp0vWvH1+xLUtiED5oStccUl8lX4UKOuxs0sfWIOFSFipeLISDG1e5RrnR5y5frxv+g8ZfIFx6GZ2yziCkl6FM100O9MGvCLNAq728uB95VQ+V1PZSCaELRZ2zg+K61zWogDPgGkKbPpM2LlEWveM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765249; c=relaxed/simple;
	bh=FMK0lm2De6xQ3hwcfsSlEnqTpB9yk5pNfq5pSqosOY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imIc6NIAfsZqGgrI/FmVdB+tOcO8ct+m3IsKSDUsqxE/gCy+jrZMAoOS6G5FZfXqIjNRnXV8DXvTEcwR9BBgjLTIeQCIePf+yTYbiyKK89sYNpbtvX8g1lHz6UC/b6Fiuht1XJytqRFvdi8Ihdl3+KrBYPKTYDmkNGtEDokyDmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVMwXvoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVMwXvoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2995C4CED1;
	Wed,  5 Feb 2025 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765249;
	bh=FMK0lm2De6xQ3hwcfsSlEnqTpB9yk5pNfq5pSqosOY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVMwXvoZV9YyhpDV3rn3K3in/tYKPNzls/xOddowsUeHJcjCFe9zFz1BRBnBe25GS
	 v/k1fdGBKRGKDI4u3m+w2mUNM+JTwDIAJ7Ist4K7h4UEv1kfLmyCm8v4PF8NrdqsEk
	 2XVRj22m7XJY+VnF//P5nK7bVFdBJhpS1Rft43Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/590] wifi: mt76: mt7996: add max mpdu len capability
Date: Wed,  5 Feb 2025 14:39:18 +0100
Message-ID: <20250205134503.048034245@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 1816ad9381e0c150e4c44ce6dd6ee2c52008a052 ]

Set max mpdu len to 11454 according to hardware capability.
Without this patch, the max ampdu length would be 3895 and count not get
expected performance.

Fixes: 348533eb968d ("wifi: mt76: mt7996: add EHT capability init")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250114101026.3587702-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index d5f53abc4dcb4..50ee1e443dfa4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1187,7 +1187,9 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 
 	eht_cap_elem->mac_cap_info[0] =
 		IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
-		IEEE80211_EHT_MAC_CAP0_OM_CONTROL;
+		IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
+		u8_encode_bits(IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_11454,
+			       IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_MASK);
 
 	eht_cap_elem->phy_cap_info[0] =
 		IEEE80211_EHT_PHY_CAP0_NDP_4_EHT_LFT_32_GI |
-- 
2.39.5



