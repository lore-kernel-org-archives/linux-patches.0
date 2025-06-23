Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7B570838;
	Mon, 23 Jun 2025 21:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713064; cv=none; b=Mxu+pMcnFSpu4bnwhC6DYoXxPPOxY+DPihUD73hww5d6ArEocyhhO/g7kOxwRP4BgLsMsGgyR8m6TDdGrNr+agdRfb3ovU+N1aQRIyot6mkTUFlz9lLSL2VfggA3xMUo2qnsfW4geYS0VRw152pZpQUBX10Uxj8TFcEr7um6ay4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713064; c=relaxed/simple;
	bh=sF/gL5nw3eEnYa9iIcunDGTo+9zyXKeXQRUHzC13l2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVJOoozGR2hn3isytmuwwMXQ0CLYYeX4Riv1TgPIVJsTk5nAQysqOFmpDIuhtMa2Vp7la7wDlDyxwJ0onXc3gr147mY+wiULpVZXRIQ+OqiMpfm5a90fh/JkrKzjD03rjozh2c3//Nc1bXHMw4dHfRKW/JxNsTvXKCG3tH4v/nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Psn6hxlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Psn6hxlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D09CC4CEEA;
	Mon, 23 Jun 2025 21:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713064;
	bh=sF/gL5nw3eEnYa9iIcunDGTo+9zyXKeXQRUHzC13l2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Psn6hxlSe/RKMxrTtvxFTyfoe4Ow2MG+bvyQx7VIHa89Q6S6PK08IeIB0t0NyCsGk
	 UCV3IJCO0MEaeO98jJsZUiLybFWNXCCdv9e55ZBkmqsnE6A90wcRY37U3SzJWbQ3OO
	 e8s8hXRIuXJqV+86mAX0EhWIDGXjcd5q3TcLgl0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Williams <sam8641@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 326/592] wifi: mt76: mt7921: add 160 MHz AP for mt7922 device
Date: Mon, 23 Jun 2025 15:04:44 +0200
Message-ID: <20250623130708.207707890@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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
index 826c48a2ee696..1fffa43379b2b 100644
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



