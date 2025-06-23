Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668011AD3FA;
	Mon, 23 Jun 2025 21:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715707; cv=none; b=VZutZU3Vhuxyz+BlJhDyiJEpENeqXD7GGCCGplrXs3K7Hst5dSCMJ+A3QnLX+4N9t1MVsxT+q+rkoXHLjzSk1MOiehDT5GV1UMPy+eqIuQ9pGfBI5LwloJE8+F9lTVnOs3gfIfEm8iA0jkQlKF3NKH9NjGlf/HZGKy6ibuqb3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715707; c=relaxed/simple;
	bh=zdNcHYBiDTIcmBM2+teBA+ZmlMpF9Kgt8NCEuPlvniI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6QiCMIwosrhOf3kCR9hKul2D8AaLnw5MKxa0+2w54+RtoaE8Vp01TRl4DtP51YukP10/K8aj/LDDvXD0/Y308mKAv3+dw6+BngPAR5xxOhQonVYBme3FgWSaxZACSWc/ZJx2nElVPKIUMpzQIGlZe+uVbad9ybBxaHzD0SQV4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=notKpaFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="notKpaFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4158C4CEEA;
	Mon, 23 Jun 2025 21:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715707;
	bh=zdNcHYBiDTIcmBM2+teBA+ZmlMpF9Kgt8NCEuPlvniI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=notKpaFkanf4yT4qXSvwYZY8rTc4vCnax7Yc6b7dpjp5A7SipDaB0Kpg3KVlrU+/R
	 /9bOHk2yLPa67dRSzDpGVkIXdqAIXHTbO5Oetyg/tLLI9foHguyGzbR1aTFLubi2qd
	 WxB9FeCN6W2InLfF4IuXcv2rT8lB6Smk+T/mRcQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Williams <sam8641@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/414] wifi: mt76: mt7921: add 160 MHz AP for mt7922 device
Date: Mon, 23 Jun 2025 15:05:39 +0200
Message-ID: <20250623130647.059375406@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Samuel Williams <sam8641@gmail.com>

[ Upstream commit 7011faebe543f8f094fdb3281d0ec9e1eab81309 ]

This allows mt7922 in hostapd mode to transmit up to 1.4 Gbps.

Signed-off-by: Samuel Williams <sam8641@gmail.com>
Link: https://patch.msgid.link/20250511005316.1118961-1-sam8641@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 6a3629f71caaa..9c245c23a2d73 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -83,6 +83,11 @@ mt7921_init_he_caps(struct mt792x_phy *phy, enum nl80211_band band,
 			he_cap_elem->phy_cap_info[9] |=
 				IEEE80211_HE_PHY_CAP9_TX_1024_QAM_LESS_THAN_242_TONE_RU |
 				IEEE80211_HE_PHY_CAP9_RX_1024_QAM_LESS_THAN_242_TONE_RU;
+
+			if (is_mt7922(phy->mt76->dev)) {
+				he_cap_elem->phy_cap_info[0] |=
+					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G;
+			}
 			break;
 		case NL80211_IFTYPE_STATION:
 			he_cap_elem->mac_cap_info[1] |=
-- 
2.39.5



