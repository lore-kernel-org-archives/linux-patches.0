Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A535155751;
	Wed,  5 Feb 2025 14:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765741; cv=none; b=FalRXtVTImcHLBaqX2jJXLrY/4fkbdPTe+f6sm4+fRi1KsS0pOip/9PWOIaPKmDMcDYiKBDLxwXSo6Y7UYrU/KvCOSBJ7gPCHUJr96c158pmjplZWxSXn/g8uE8fzW806eyNZsg13pEeSuOzXkIZbNDwlrWXOFbgX1QgvjxvP9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765741; c=relaxed/simple;
	bh=cfADiCgCHcNQfSQLrr3zH4qNk0VJUULGVU811itAx30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozHo9icZEGpf0drmhkxarAGYEnj+Ag/bblh7ic+ZDlu9MCuVYFq1rOa/FOUdYhZceKGnwJ0P6EJcvYmO15RAgsxXZ8n6mlNtYQveBlF3D7U98C2x5mVjsa2IkbHRCzAk9KGqvlhLUgii/X6wJXTls5VyHSyeOunWjGmIXUr2+QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5otIwxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5otIwxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC29C4CED1;
	Wed,  5 Feb 2025 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765741;
	bh=cfADiCgCHcNQfSQLrr3zH4qNk0VJUULGVU811itAx30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5otIwxddM3D6Vy1rweR+ebnaeMORXEan5P1u2mi4UVVEovEVQUoT5j0DJ7ds7abO
	 LSzwAwGq741bclO1UNyWX3Okv1YyFAOHrF8QBokD7V7uAR00e757g5QVLGdbsG/Vpj
	 CF+c8E80y/6/ZYtIy4Rg5NwvAo1aEZGhcb+YLepM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 209/623] wifi: mt76: mt7996: add max mpdu len capability
Date: Wed,  5 Feb 2025 14:39:11 +0100
Message-ID: <20250205134504.225186236@linuxfoundation.org>
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



