Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3D16025E;
	Tue, 23 Jan 2024 01:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974713; cv=none; b=MXzVOxY1eNB9cOeFH7xOOSzVRS6yV9cuoTHxJ8bEbsQ2PiWFjsBoAJKoBfd0m2y86HMHZCe5rKXdnUEgcnSloktbinY1OpdjYHT3VzW0aO7cLH4a+r6feZY0e9ON9gG6poTAZgAq4ay+ftC5wkN7Xz7WG3Lg040n8oO/RRtk9Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974713; c=relaxed/simple;
	bh=hVRsc0xGzxjjn1RGqxpPbYpIRvFfRLPzeI19VbUIYKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7QBW/hBQbzw0+kMnxFKaOJ3iJdEJaxSugwFAQQNn898XwKMfSmOp/pJaMqean+42fBWiNVfqW/ZbvQAKen9j5MnDuhpekSYueCbSUSlKdhPrhdTehCpQd0lQwEN4q9na9Z+sV26ho+2cb8jlMCpeEokAQ9cTwERL29ySQaE6Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixankxj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixankxj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235FBC433F1;
	Tue, 23 Jan 2024 01:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974713;
	bh=hVRsc0xGzxjjn1RGqxpPbYpIRvFfRLPzeI19VbUIYKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixankxj9dZD0qjLjqswUjexYyzaCv62Y1jQVRIeNApf0OArpBm7c0fAmByRZifibe
	 duzY7CdeFj4afZQHFi6rWEUsNqT1wuVV5VbzQAs+PeWymhWEdeZ97oe4unQ95U4Ach
	 EgeEMByOeErUvEqo5Zey28Vho3IgLznvQtn0BmdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/583] wifi: mt76: mt7915: fix EEPROM offset of TSSI flag on MT7981
Date: Mon, 22 Jan 2024 15:53:10 -0800
Message-ID: <20240122235816.355100594@linuxfoundation.org>
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

[ Upstream commit 3531c72aedb95261f4d78c47efa4b5ba7cdcddd9 ]

The offset of the TSSI flag on the EEPROM of MT7981 devices was wrong.
Set the correct offset instead.

Fixes: 6bad146d162e ("wifi: mt76: mt7915: add support for MT7981")
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
index f3e56817d36e..adc26a222823 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
@@ -144,7 +144,8 @@ static inline bool
 mt7915_tssi_enabled(struct mt7915_dev *dev, enum nl80211_band band)
 {
 	u8 *eep = dev->mt76.eeprom.data;
-	u8 val = eep[MT_EE_WIFI_CONF + 7];
+	u8 offs = is_mt7981(&dev->mt76) ? 8 : 7;
+	u8 val = eep[MT_EE_WIFI_CONF + offs];
 
 	if (band == NL80211_BAND_2GHZ)
 		return val & MT_EE_WIFI_CONF7_TSSI0_2G;
-- 
2.43.0



