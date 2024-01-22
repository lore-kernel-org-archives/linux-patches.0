Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394936086A;
	Tue, 23 Jan 2024 01:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974715; cv=none; b=L+24qQ87CATV+srhhqYlJEU0ROxOkm30aUl++Wrn+m6CxV3rjSK1wjoAKoev0vHKVNVRAS9jlYgClanBQE0eFJre0FjQi8N38KsUzkdDKOfN04FASlNn2PSeaFjyL5jg1GYD8aYyZSgj01T6xsLpwbeD9TMv48J8HLmI8a5Cxh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974715; c=relaxed/simple;
	bh=1LvaeeoNVCHncp+ZMMuiksgx9DpZbxGz/BXH9l+QJSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeKUEn5GrFlP3JQuhtStK3wJU/vKHcCNpBi2bV2LAgdgLVDfpjZe1n60rg7+1lqAf2d7fcWnLeTCbyLQ3jhRdipQOeCiaxYRmrbxchbS13IWr8mujbi6BLWQRPykaqWi8UOZZHUuX0qD6gT2+Y8Q46tWSyKJiR9YUvzbHaGhrEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZGXaLZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZGXaLZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CBFC43394;
	Tue, 23 Jan 2024 01:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974715;
	bh=1LvaeeoNVCHncp+ZMMuiksgx9DpZbxGz/BXH9l+QJSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZGXaLZoSENXmnx1t5hUcOBULQCO6KhQaEEN+TdUOPL2nP8DssPC9pG+VOni4Jmvz
	 HCGTIA2BBdqCmA+1cu/ugjEMMPHX7R9a67IQmi3KpTU3dgD26O+xElDKRwFQC4xBYr
	 HsLbeT9ze1vcHrq7ogWVhhWyxR2nwLvtAJykebl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/583] wifi: mt76: mt7915: also MT7981 is 3T3R but nss2 on 5 GHz band
Date: Mon, 22 Jan 2024 15:53:11 -0800
Message-ID: <20240122235816.383287140@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit ff434cc129d6907e6dbc89dd0ebc59fd3646d4c2 ]

Just like MT7916 also MT7981 can handle 3T3R DBDC frontend and should
hence be included in the corresponding conditional expression in the
driver. Add it.

Fixes: 6bad146d162e ("wifi: mt76: mt7915: add support for MT7981")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index d85105a43d70..3196f56cdf4a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1047,8 +1047,9 @@ mt7915_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 
 	phy->mt76->antenna_mask = tx_ant;
 
-	/* handle a variant of mt7916 which has 3T3R but nss2 on 5 GHz band */
-	if (is_mt7916(&dev->mt76) && band && hweight8(tx_ant) == max_nss)
+	/* handle a variant of mt7916/mt7981 which has 3T3R but nss2 on 5 GHz band */
+	if ((is_mt7916(&dev->mt76) || is_mt7981(&dev->mt76)) &&
+	    band && hweight8(tx_ant) == max_nss)
 		phy->mt76->chainmask = (dev->chainmask >> chainshift) << chainshift;
 	else
 		phy->mt76->chainmask = tx_ant << (chainshift * band);
-- 
2.43.0



