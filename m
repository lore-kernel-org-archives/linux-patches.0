Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF90192B90;
	Tue, 17 Jun 2025 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177412; cv=none; b=tIqqKDbhvFbWZ2WRszlMbM/gvYpIFagEWs0w2Kdj1hQvzIN96CANdHiskb3qbUdxJXtR2RIYcRHgRYYS915+muxd9Du+4XeEOtH3EjgdQOdrfJpWUQCaLrD2uXh3VjDfJfxnAsA6Z/Xa+d45hsutPJ9WNB/jWCQ7V9v+qPZFF3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177412; c=relaxed/simple;
	bh=widlisDYqv6yTi49PprZ0EsfQqsGkLWF3AaNwupX03o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t25M25gMYIZGBXDcdOZuCD86vBzHIv1LW/9CXEu4Ma/Rymk+TMPUth5irF82+EZVIbgSvK4/BrbqJUT3wSFYa1M14szIjMeAFiDJ1J/3ThM99Zv3IqPe53o8jIkrv9hVjrTefxHG6uPebkf5iGZ5/3JI9d4+78ERl/PONNzb9qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3ddkDvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3ddkDvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869B0C4CEE3;
	Tue, 17 Jun 2025 16:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177412;
	bh=widlisDYqv6yTi49PprZ0EsfQqsGkLWF3AaNwupX03o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3ddkDvK6565OzQIVxoiPGKbilJqDrKF6A7iEL1gz/ChP0izRdZtdnWWf1x2cJPEM
	 W9jUHBaQuuj6asHJeDSsQlVbV0nitS70RE7T8YG+lM5Zpp3XJGX0RC2IcPvDjCQWio
	 fPKhLzOH+t4zxD5M4VFXWaiP1ZUHzPMhrdbLfPJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 302/780] wifi: mt76: mt7996: set EHT max ampdu length capability
Date: Tue, 17 Jun 2025 17:20:10 +0200
Message-ID: <20250617152503.765929230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e99dfd1771d52..4906b0ecc73e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1321,6 +1321,9 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
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



