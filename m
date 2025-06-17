Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874A81E8332;
	Tue, 17 Jun 2025 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175003; cv=none; b=IHr0W7sOhNdH5LY8k7Z8hw3ahrlC2I+v53NIBkt2jZxJmZu2CHTJPDVuRAENsJUX/b5NEfM/a+Cgt3BnMDhKYSqAQdfsptRQYWSMI0jDCRaMaegvQh5+hHe2zx2w6yX8jjQseZYYYVxqftac08KiIyb9fuuDjc4q9DGHLCz0SlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175003; c=relaxed/simple;
	bh=VCs4wzm4XLikx5RIaSnaSkpEq130fbz1v+ROIzJCbTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmVRE8v6Dlg3d7VlWRdpmsu6GYrxoV47AKEZizfzoRDY73CY2sCVNcgkhOgP9T82TncarM6IUx7cY5o7m8MubsMm3L+BOrSARQ8wxJXciMo80AyUa8ldikIjHVdatZuK7aWvWcrMMbhzIfJZ5/C3o4JtAOKROfYCYBp6KH+AdtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gn+e4BWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gn+e4BWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062E2C4CEE7;
	Tue, 17 Jun 2025 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175003;
	bh=VCs4wzm4XLikx5RIaSnaSkpEq130fbz1v+ROIzJCbTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gn+e4BWAYbfGWYl6WsCm2scQqy4TsfP//p8m+/nom/55BE5nIS7BOaxufuXsZaWV5
	 Hlazq69dRAWUfj2qlY6UMckAblYfZrx/v9h49NrL3zoMVbFIpr6dAVn0Y9gbSgzR7v
	 pMbV1nX8Ft0h2/j59XwuZlUqzFq+zLjpYo5NvWis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/356] wifi: mt76: mt7996: set EHT max ampdu length capability
Date: Tue, 17 Jun 2025 17:24:10 +0200
Message-ID: <20250617152343.668223793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

[ Upstream commit 8b2f574845e33d02e7fbad2d3192a8b717567afa ]

Set the max AMPDU length in the EHT MAC CAP. Without this patch, the
peer station cannot obtain the correct capability, which prevents
achieving peak throughput on the 2 GHz band.

Fixes: 1816ad9381e0 ("wifi: mt76: mt7996: add max mpdu len capability")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250515032952.1653494-3-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 0a701dcb8a92c..375a3d6f4b384 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -735,6 +735,9 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 		u8_encode_bits(IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_11454,
 			       IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_MASK);
 
+	eht_cap_elem->mac_cap_info[1] |=
+		IEEE80211_EHT_MAC_CAP1_MAX_AMPDU_LEN_MASK;
+
 	eht_cap_elem->phy_cap_info[0] =
 		IEEE80211_EHT_PHY_CAP0_NDP_4_EHT_LFT_32_GI |
 		IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMER |
-- 
2.39.5



