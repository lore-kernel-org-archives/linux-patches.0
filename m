Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A6B13398C;
	Tue, 23 Jan 2024 00:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969295; cv=none; b=ca2Sq8UBSll+H/UnWUeVq0tmNxbF1GvLEvtuJ5yGrYlk01AlwwgyPzakzORzDUqmi8qGCDSFMgIGzw2mYMoxr0SaPCWK1WwmmNdKZtvj/PZL1z6PE8cWkAU3XE1kI0C25b+nybvOQRPRF2bcwO5UPOITE32iCTWBVp0EwNncBy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969295; c=relaxed/simple;
	bh=O7iJWddpQS4OMWjO3q+PKPQ2SOEJcjx7XLmGw5rKLtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6e0ihnoYHwr0Oni+49JqG3F0OWf7GDjAOTWfbk8fIs1J2m77m5LludtzMA/iRBJFBxGOez0EqpPJvLulpp7PCNcVgKfCXkeQpRUwMzKqbTPiUDvf4UZAdCnNpSXjOqbcVjnMh5P4Jc98T70ubE06ySh7nhs4y3MY7k7YmQk6g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqKL/Bbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqKL/Bbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD77C43399;
	Tue, 23 Jan 2024 00:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969295;
	bh=O7iJWddpQS4OMWjO3q+PKPQ2SOEJcjx7XLmGw5rKLtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqKL/BboyXLeXcGLvGoCdph3MHtgr9pNWu8jGvggSQMlNj0C0llmWvmFtCRVWqZK6
	 3wDfxdB2W9gaVF0lybpKAilvBkjcf8+6sWcvzP3AM4Y5uIznUvwJSkDBlTWkwq3I5m
	 3HJt/mVnY43nCRUh7VSMcw7EHSDFzHlCHhUyRGns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 152/641] wifi: mt76: mt7915: fix EEPROM offset of TSSI flag on MT7981
Date: Mon, 22 Jan 2024 15:50:56 -0800
Message-ID: <20240122235822.792399425@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



