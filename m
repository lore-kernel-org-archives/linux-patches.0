Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6E91519AA;
	Wed,  5 Feb 2025 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763998; cv=none; b=jP1JhtyO/UvCIm76rcnQG0rpF4Xy/UugYol3tLmBPZKRNW3RE4kiB4B0QfaKzgHdDLJINQIcI9/WJvKIoU5gZdZgWhaSlWqFOglf60tbAoOgBPAHFAAOeNoSG5OfaP0Y3tDb3vRFFJEyewuJrUaOFGzyr6yvuLxbD82YTWVynro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763998; c=relaxed/simple;
	bh=L8nSkxldXuTkoCscATtXkUDAGkJbwv08093QsC+fg/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4BqRlBpFkjH342/2lN9KqQBN1MPJZhRkwLeGyUJ7bCYWR1Zquo2rOv7JJ5YVvSpdJphDreFjMiniEjJz1exV8TLHUDxdcPLxiHEvae2pETuFFnYTMHJ0y9rUT442UY+7T66/UqJqZCx4pzUjFStn0XDYdokuIY4NmtNzL+8tKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gwnOcpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gwnOcpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A09C4CED1;
	Wed,  5 Feb 2025 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763997;
	bh=L8nSkxldXuTkoCscATtXkUDAGkJbwv08093QsC+fg/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gwnOcprvX5EvdFuYuPZj3WfCjUX59wM2qYl7UKRd9Zhd/eivYYCc1ZyifgoPbbn4
	 QsUat1DcHaBVyseZUVptFk5K0NXyZ69lFNpfhBo2H7PVPzRbOKo7KjLH+E3Iw8zrJx
	 jk3x8Ax+EVmmvOR7vxE1TTP8BlFXCv3R8HeH1sYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/393] wifi: mt76: mt7996: add max mpdu len capability
Date: Wed,  5 Feb 2025 14:40:45 +0100
Message-ID: <20250205134425.113645809@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aee531cab46f6..7931e43e8b6df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -729,7 +729,9 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 
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



