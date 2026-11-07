Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064507;
	b=JbEBVYiucu5uXxJhq4ScXaxK3nJXiVsgJ3BuDJxAlCTCUAK2KxsqGf5JOoe8n9vtHcKw
	 H47L0zCro3nwlhmhm+h1OeFPlOZGoiybwOrniLfek1h1WKh+xTsIa3ayBDskXG6k5vqgA
	 63SYJm+TKXpFK0KeQhyq85a6Ahs8jAeru0vxqxFqF7HQj4zm78Vhc7K1egrWlpETbJDRG
	 DlhZnwOdEHaKewNRYyYUVLl6F/fdBEuvAokiGOhjIk1H9UYzG9jd3WOroo900/wHBSeOY
	 9o7Pmp1chxo75UejjyAH7x86gxSldBx4XwZHgPexU1VbdQFGXLgSVTaNZOkkBosn/2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=373sRGXGrxkAkt25fQIHjzW/eJmFem5CQDBEuUMsVfA=;
	b=WZNd6tVXJ17J4uhK7oQ0FzKqDdphhP9UQ56KXhJkLsAugSQVHMkZ5oy61Fsv50F6QwET
	 WzNIsxCqOeD0yDc93zChYB8tHAoJvw1EvLkEc2wRtQQK0iOPuhPXQMTJVMEIP3XegXDiL
	 tRESWNiLbwdbN8+oGgtFBY5jIUi28MEH5Oxu4R0PJ9xWo17enP1NpJlXEBQHqRi3LydUy
	 cZFdukYqf41/jZnHFB/e/jEirkSBhh0g5cvSlIfNRg4tXIvS54EeG1lGaxntE9OR6Asg9
	 RbNjuJFUIrAfAt5Q15Fa6Wwt1V/+XNBn0sMo4ws8/ZeB6V+toSBAROCtWuFgtuTKwKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMNHV0Tk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4D5606CE50;
	Sat,  7 Nov 2026 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMNHV0Tk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CD81F0089F;
	Sat,  7 Nov 2026 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064507;
	bh=373sRGXGrxkAkt25fQIHjzW/eJmFem5CQDBEuUMsVfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMNHV0Tk4YFYZpqJOJs/CJncS5P103L9VqvbbvHODfD2C7wvD2HrH/E8Ep8FnoCxk
	 yhbF1cTHNLsuAhjyPFScypA0dRnFL/7tzfZ+QIaCSKgEBhVq8Vvfd/gVjjFiRBgN8p
	 90oJsBMbbzrYXqEVyLZP4uzrm53V+RHPM0DhNV2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0539/1257] wifi: mt76: mt7615: restore DBDC state after ext PHY failure
Date: Sat,  7 Nov 2026 08:47:15 -0500
Message-ID: <20261107134954.290185755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 7907d5270dc5c13b6a95754c08a77d5b06bbc786 ]

mt7615_register_ext_phy() limits the primary PHY to DBDC capabilities
before allocating and registering the secondary PHY. If allocation,
EEPROM override, or PHY registration fails, it returns without restoring
the primary PHY capabilities. The EEPROM override failure also leaks the
newly allocated ieee80211_hw.

Route all failures through common labels that free the secondary hardware
when it was allocated and restore the primary PHY capabilities.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 0f2173f093b3 ("mt76: mt7615: add support for registering a second wiphy via debugfs")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260910215441.76683-1-mhun512@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/init.c    | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index e437e088b2e91..665b0f1e939f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -541,8 +541,10 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
 	mt7615_cap_dbdc_enable(dev);
 	mphy = mt76_alloc_phy(&dev->mt76, sizeof(*phy), &mt7615_ops, MT_BAND1);
-	if (!mphy)
-		return -ENOMEM;
+	if (!mphy) {
+		ret = -ENOMEM;
+		goto error;
+	}
 
 	phy = mphy->priv;
 	phy->dev = dev;
@@ -572,7 +574,7 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
 	ret = mt76_eeprom_override(mphy);
 	if (ret)
-		return ret;
+		goto error_free_hw;
 
 	/* second phy can only handle 5 GHz */
 	mphy->cap.has_5ghz = true;
@@ -590,7 +592,14 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 	ret = mt76_register_phy(mphy, true, mt76_rates,
 				ARRAY_SIZE(mt76_rates));
 	if (ret)
-		ieee80211_free_hw(mphy->hw);
+		goto error_free_hw;
+
+	return 0;
+
+error_free_hw:
+	ieee80211_free_hw(mphy->hw);
+error:
+	mt7615_cap_dbdc_disable(dev);
 
 	return ret;
 }
-- 
2.53.0



