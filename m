Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D8734DB64;
	Fri, 21 Nov 2025 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732753; cv=none; b=hNd2vkI0xv++TPYl33IAtX9S8uB89pa5xHSWX/NPI3LVHKL2NLuPsLtYaZndB/27xwF1zgyWWoAwTQSzb5d6T5j5O93wG4THHmL9J94mRbB2XrjpTLJhtv6HhEqPxYFKJkKqU3hlqzXFenoL5rP+vyQ4TOzFc7cQ4OhSz9m+85w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732753; c=relaxed/simple;
	bh=s04OMNekA51Cl81ARyJ7SGv/G5L1tn55NxeyX+nZoLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8C5CsOXev579JOh6nXDSA0+7D8jzD4tDwer7V5ON7xTAc0hyuFkq9qfw59GdAU2uJwjRZKDmCS7hXovEIZVAkktKwKxccGKfJhKGvptuXQ89kUPo2w5OCYX7APrYo5UdT4+iXrRUooiIOmelNPYiA6Bnzeh974998oyRLAEzeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSTfpSli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSTfpSli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BBAC4CEF1;
	Fri, 21 Nov 2025 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732753;
	bh=s04OMNekA51Cl81ARyJ7SGv/G5L1tn55NxeyX+nZoLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSTfpSliW5FhyC4+/9NFFyZAUaiKsa/+ANwchF6JWz/N97H68kj5Ec4tTWHgbe2LZ
	 PaSAnecQURU9ozKkjXZZWa02lv+2LhcldCoLQ5MBC/gpzIKuxN4jb9kR3ZyzbDZrVe
	 eeHeQvWn3ekmKkqsPlBBx3je6Dgf+DL4HW++4lqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/529] wifi: mt76: mt7996: Temporarily disable EPCS
Date: Fri, 21 Nov 2025 14:08:50 +0100
Message-ID: <20251121130239.238093166@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit e6291bb7a5935b2f1d337fd7a58eab7ada6678ad ]

EPCS is not yet ready, so do not claim to support it.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250904-mt7996-mlo-more-fixes-v1-4-89d8fed67f20@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 375a3d6f4b384..fa81a1c30704b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -730,7 +730,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 	eht_cap->has_eht = true;
 
 	eht_cap_elem->mac_cap_info[0] =
-		IEEE80211_EHT_MAC_CAP0_EPCS_PRIO_ACCESS |
 		IEEE80211_EHT_MAC_CAP0_OM_CONTROL |
 		u8_encode_bits(IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_11454,
 			       IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_MASK);
-- 
2.51.0



