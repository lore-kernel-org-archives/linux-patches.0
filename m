Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053DD155335;
	Wed,  5 Feb 2025 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765752; cv=none; b=Wl4TBBhk8eioKCHoQ3Xb/Fz6wMsSnvZOrdkOp5KyapBuqrVq1Jn8fJXlGpDy81Pd6oyx/BbFpUul4gKo5HXcK3MY8x3MUBKyClv6J2heXtkylMqm3qRdXhC05DtpRmI+gJhOx9jTPPp67A1Wlutz6zeucj50n+Jkbfyyz3/YZnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765752; c=relaxed/simple;
	bh=27gmfMdpr7cLMogWHfRJ/nsMlVZSbiKnc+XF71e2q+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFqc0fDPJNK0L9BjG8/I5j+vKHswoJfvyv7I3M1GDjZWIPyGDogZs79OblrL3kVkXEdGqC5kYe6vxkx18SLYIzo17z20vr2bjpcoZn8dl9F7PxP6UJErSgY1cvUAtQthCr5nSPU4yg0WrbMwcgkIIvxDQNqJHFZYFiDedCjhvZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhQGu/fM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhQGu/fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64860C4CED1;
	Wed,  5 Feb 2025 14:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765751;
	bh=27gmfMdpr7cLMogWHfRJ/nsMlVZSbiKnc+XF71e2q+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhQGu/fMwcDf29aZovypPNNAN3vdL7lVF/d5dg5jtHIgtIeM8CaSQcbp/EAKIwjJp
	 yLLiDkhkXVxV+Tur7luzfjVmdeXmqd+Ho6+wUjEfKAv+6URoU7znTcA4C1wz4QB3zD
	 RI7JiuM59vVNYyUSz/r93pVpsD+AQLcpg3q2OEvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 210/623] wifi: mt76: mt7996: fix the capability of reception of EHT MU PPDU
Date: Wed,  5 Feb 2025 14:39:12 +0100
Message-ID: <20250205134504.262675334@linuxfoundation.org>
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

[ Upstream commit 2ffbdfc1bd78ba944c5754791c84f32232b513c6 ]

This commit includes two changes. First, enable "EHT MU PPDU With 4x
EHT-LTF And 0.8us GI" in EHT Phy capabilities element since hardware
can support. Second, fix the value of "Maximum number of supported
EHT LTFs" in the same element, where the previous setting of 3 in
Bit 3-4 was incorrect.

Fixes: 348533eb968d ("wifi: mt76: mt7996: add EHT capability init")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250114101026.3587702-2-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 50ee1e443dfa4..e04abd57b3b3a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1232,21 +1232,20 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 		IEEE80211_EHT_PHY_CAP3_CODEBOOK_7_5_MU_FDBK;
 
 	eht_cap_elem->phy_cap_info[4] =
+		IEEE80211_EHT_PHY_CAP4_EHT_MU_PPDU_4_EHT_LTF_08_GI |
 		u8_encode_bits(min_t(int, sts - 1, 2),
 			       IEEE80211_EHT_PHY_CAP4_MAX_NC_MASK);
 
 	eht_cap_elem->phy_cap_info[5] =
 		u8_encode_bits(IEEE80211_EHT_PHY_CAP5_COMMON_NOMINAL_PKT_PAD_16US,
 			       IEEE80211_EHT_PHY_CAP5_COMMON_NOMINAL_PKT_PAD_MASK) |
-		u8_encode_bits(u8_get_bits(0x11, GENMASK(1, 0)),
+		u8_encode_bits(u8_get_bits(1, GENMASK(1, 0)),
 			       IEEE80211_EHT_PHY_CAP5_MAX_NUM_SUPP_EHT_LTF_MASK);
 
 	val = width == NL80211_CHAN_WIDTH_320 ? 0xf :
 	      width == NL80211_CHAN_WIDTH_160 ? 0x7 :
 	      width == NL80211_CHAN_WIDTH_80 ? 0x3 : 0x1;
 	eht_cap_elem->phy_cap_info[6] =
-		u8_encode_bits(u8_get_bits(0x11, GENMASK(4, 2)),
-			       IEEE80211_EHT_PHY_CAP6_MAX_NUM_SUPP_EHT_LTF_MASK) |
 		u8_encode_bits(val, IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK);
 
 	val = u8_encode_bits(nss, IEEE80211_EHT_MCS_NSS_RX) |
-- 
2.39.5



