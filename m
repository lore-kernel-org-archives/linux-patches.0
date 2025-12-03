Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB47832ED39;
	Wed,  3 Dec 2025 16:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779323; cv=none; b=S7RjwEKrNUPtcZfxtenrkAc7P717rf+g730R0LyyaA7EWg0eFgU09H2l1w4ygOaoOyUG1i3Wz+6MRs1ilcqXVYaQu/qyvahQZtPpM9ixAQWJqtet73FVrg7U+kvgU5uteO6L0QAoX4jvUzROg78C4uLh1y9i99FpDigODXUXo/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779323; c=relaxed/simple;
	bh=eErzncC9T5nLS8pxbrhLJ7Es9HRfVn5E4OWXYuBg4BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvHvFccjYh+lW6auBuoo3v6IJG46WJoMuC7/6dr8pnAysl4637tW5yjfGJoUE8Uco9qDljmdavR6n0oNT1RPC88RqqolMjQVioVT4p+y9RYX41gjl06+ph30U7law9nna/eicR2GTNxG/Mu5MrMJHZEdLKr6lNs6kHfqFGGQPiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5IPgVy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5IPgVy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5746EC4CEF5;
	Wed,  3 Dec 2025 16:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779322;
	bh=eErzncC9T5nLS8pxbrhLJ7Es9HRfVn5E4OWXYuBg4BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5IPgVy8hP+iDaQ0JDSNa/hzJBwyZ0K5cJktzPLA5ItgFoRgReXp7pK50AfgXJ5wY
	 lKtsqXWASiMWQfBP+ZVfmv0WdpwrA8h0PpIvnl4Xrp3lL37HmKpEQQwPgT9TlP8dJS
	 kd/WWkSo5uegJhcpelwMLxkI2A5JrgcuRp8RQteQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 224/568] wifi: mt76: mt7921: Add 160MHz beamformee capability for mt7922 device
Date: Wed,  3 Dec 2025 16:23:46 +0100
Message-ID: <20251203152448.927186534@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit 25ef5b5d02ac03fe8dd91cf25bd011a570fbeba2 ]

Enable 160MHz beamformee support on mt7922 by updating HE capability
element configuration. Previously, only 160MHz channel width was set,
but beamformee for 160MHz was not properly advertised. This patch
adds BEAMFORMEE_MAX_STS_ABOVE_80MHZ_4 capability to allow devices
to utilize 160MHz BW for beamforming.

Tested by connecting to 160MHz-bandwidth beamforming AP and verified
HE capability.

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Link: https://patch.msgid.link/ae637afaffed387018fdc43709470ef65898ff0b.1756383627.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 7adda1718d6ac..fd91d2c537603 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -156,6 +156,8 @@ mt7921_init_he_caps(struct mt7921_phy *phy, enum nl80211_band band,
 			if (is_mt7922(phy->mt76->dev)) {
 				he_cap_elem->phy_cap_info[0] |=
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G;
+				he_cap_elem->phy_cap_info[4] |=
+					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_4;
 				he_cap_elem->phy_cap_info[8] |=
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
 					IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU;
-- 
2.51.0



