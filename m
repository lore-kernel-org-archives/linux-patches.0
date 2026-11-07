Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063233;
	b=XVlmXj9yKTb4cf1Y2kRyjVBXgfsB7+fQ0wweNmRS7Q1M6hFvtBoYCCgKL9EYN4uDIuiM
	 avsxHAmoGLfD2ftFWFyRf5i/RyiSzsPrImzjYjCF0IvbHMU3kmNDNpkiuqzKsA57yVtzm
	 mc0YGwNvlLlngoqbwOw8pNWKMQFyQEwEWoiBf2dO9aFCBU6UprT2/eDjjelJ2VgmRrlW3
	 UlGXuzEJoOC2ofGJtCmY68iRG/uix1cI0bEtzV/xFiNMiPaSg/slDVdBcr0587xbnDGWD
	 WrBupGMOlWMgllu2/eS17COmfWP7zTNILznl1THhaqDu3sBi8JWzxi4JxiRAEnx4tNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7cHlCJrcd/DK3MjnFwDcoZ5vQu1zX9AQxnQdQ92KUmg=;
	b=V779Zh+WW8H3cG/tJSL8lceA0VDZHJb3tMPxt+pWvRBJganp4+SFdW9kxJ6LQtr4r0RB
	 LhSHXVHwRnt1UVDHqpHmJbw/VVFMuhHswlm9M28kNMv9yb5UYKU65Ac7MdsjGypPNmvD+
	 +fPzHUjpCZ4a80RNOp1av6Q8dfVLn5xjX1i9+OWol1arwUUnbjV2PPuNwqx6Dbxh3bbiy
	 cUB0IYpghMczM7/dDa1Ok95ODTqYjyXdeNAO3fq34hQFfN8ZyLRjlmHs8J76EIm3/WVuf
	 Jw4CQ/TM32kqGo2swSqyUwxmCJTdRdoG3ft8oP6i8G9veylg+S+FtA2TTBN7MAZAp6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLDelSzU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACEA606A32D;
	Sat,  7 Nov 2026 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLDelSzU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBB81F0089F;
	Sat,  7 Nov 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063232;
	bh=7cHlCJrcd/DK3MjnFwDcoZ5vQu1zX9AQxnQdQ92KUmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLDelSzUa8vG7T+CHsuOEGMa7UN1pc3qGmrKrIl/18UO1MZJJHpm2/uaRHjX/7vcp
	 HoKt1ZXCdmuHJ851CyQUHDbF8/PfWBvS5mc57L+Oj8aupawFX1726BBwSNGI+tthjA
	 gTAD8nouaDn4b75QzrQ/w/Y8Esewc0AFp2ezsAmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 401/869] wifi: mt76: mt7615: restore DBDC state after ext PHY failure
Date: Sat,  7 Nov 2026 08:51:23 -0500
Message-ID: <20261107134906.985190886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c4f5f6ee916af..4b41462413bcf 100644
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



