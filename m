Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062233;
	b=AeBVipIaxDteMAzHPbpfUocYKjvWhXE81FmG+OauleJ9OkWZPBHrelQR2HOYy1tPZc4l
	 73I653h0NJinyNTicOj5KCIQAy+3IJgb4aBpQdZCEXB++ZXdczL4ju9q4b7rneLBo1G1C
	 uDMSFBT/ufo+J0OD1FOqh79bohepialAm/KlI6eMfoRqd7OWdBsGETVOaeVPzv86mk2Wr
	 qaSntyAkZOpgAKzmwJ9LLmn8LIXRgbGD9V2yzIw5PCOfm51n16GExZXir46VogQxBlWql
	 LAdK1tgVf/QzqZ7Rt6EUkt4oj9UEaPcqUq55/PwemIB2Sp2Dbpzkv0o0uEWAj9m8w1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZacSltHtUcVK0YYxmH9PX8Xxz9doB0D3MaIqOIGcAI0=;
	b=Q0cJhbyXOdn/nSrIZEynRMwuwGfVb11OuAeNQGdsIjAyn4a7Ndum6Tr14ADXuFw7tziB
	 +qzqG+3Z0dhvnKBB0LrI1Tv/SLt5J66AWmwvYEIHeNi0/BaHQ2lru9pmhINF9ReZtyCCj
	 bNjcUTXOHlROW2Rfo3QyoaogsevwT4SY48WovwLq95GVTVjE3P3NUI+C2KMDdeYEFYHe2
	 Dx4/QvgeMimjnuZOqj/DsjEcmdAaAA6UL6jA+uEPDtvy/RYy5+xeiU5PkrkyixX26z80T
	 w4DL0F7/CpU288FtJT2d6AjAHJF7qow7mttzhImalIcyVO4oG3t59vAOxR0W7YE09Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFG8aedu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9D0606D827;
	Sat,  7 Nov 2026 14:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFG8aedu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F69B1F008A1;
	Sat,  7 Nov 2026 14:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062232;
	bh=ZacSltHtUcVK0YYxmH9PX8Xxz9doB0D3MaIqOIGcAI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFG8aeduKPHwZJGHivED9/tE/gkO2IiVAYG4+yhju3iRgZPkiCOpMsFYhTlNFlMH6
	 sxiCoAn3WQKD1crpAA+jiElm0uyCq4mTKk9JgOr6tcMHzDR6JscJ8gWNTEmCBZ+DyM
	 iXl8IGb54nH/Pg85z3/uL+ZXKN6V4PBkQXhd635o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1182/1536] wifi: mt76: mt7615: restore DBDC state after ext PHY failure
Date: Sat,  7 Nov 2026 08:53:18 -0500
Message-ID: <20261107135030.939958018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d0d880f8c0aa4..e4677fa28c0a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -542,8 +542,10 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
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
@@ -573,7 +575,7 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
 	ret = mt76_eeprom_override(mphy);
 	if (ret)
-		return ret;
+		goto error_free_hw;
 
 	/* second phy can only handle 5 GHz */
 	mphy->cap.has_5ghz = true;
@@ -591,7 +593,14 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
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



