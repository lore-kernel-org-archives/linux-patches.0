Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054192;
	b=c8C+7xKMEDH8RbPVYadHld7U/8crf8iw2gBThVb8BEQXWo/jhUNl+gLsrTvz8m/IIYMq
	 bU4H7TsSRDwZ0uuqtD1pdePxLrEnyGMqQr1P1nm7Jn4mqnwoToavEaUs/VmBZ61wsPJSz
	 c+ViarRFyRQKPOJ+H5aq7wgWTvkbIb8jz0Tn9LszsgsZCN/8fdhbxGMJ6GHwN82tU552l
	 DsHxo6Z2O1rEG8jnDUVi+7ua9kGX33fxizNyHyHbHw9dNZOMbwvYu3AyL5kSADI9y2Df0
	 EGbE3WIes40VImtQkbIGmlZjqA4UfLoNVp8mhNvYmi+zE+s3qjptwVrn2mkhjFKx1gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aZzfi4wX/RDL3qJuTn//+xa4TJT6TpypEzuHnG9j/II=;
	b=rfNAfsHn6hkRdHfbIW96klIYZVbNlx6v9DEdj11VS/WbbZUT1+HiPNfSxlc+iAp+5kBl
	 PMIEed9Bsnkn0iOGhxrC3I39EglK1OCNqZVjryAzh/pwzuMGEmGKOGwQv5FHBq2O3G2eV
	 RqKHoO9CTRe5IaPJOshd4c7Ju6cheBGpsI6tIG0yMG6blKFKB1cdYdsXnZxZ5Gg0tIF81
	 sBwUADdZ4yFtZDaFydm5zhZLdiR772S07JKeXdoxzh59KS3h1ZUu54VCYx9hwAEWtE7al
	 7LrLcYj0OSNwetEU4wPzEgLIzjGywS4Q63uaMcpEbH4OuvRmjHcptj6P2J4mdLgMtxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CU67diKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29140606A320;
	Thu, 19 Nov 2026 02:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CU67diKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D601F000C5;
	Thu, 19 Nov 2026 02:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054192;
	bh=aZzfi4wX/RDL3qJuTn//+xa4TJT6TpypEzuHnG9j/II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CU67diKUWjN+B94oUiiaUB3hzKe0rMXzrmt/C8tHG+EY4IAbAxk4iiNZRzf7hT+rm
	 ERpWIDEdICs+m1QwXpshovLyhkjs/GtRXXMm369SqhYYX14x51MKDNWuixPve2Ebwj
	 WFMRuanohHVUtRY5MjF5jLHoSJrecEOKupj1nXoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1186/2214] wifi: mt76: mt7615: restore DBDC state after ext PHY failure
Date: Wed, 18 Nov 2026 15:47:42 +0100
Message-ID: <20261118150059.363786999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted to three-argument mt76_alloc_phy() and omitted error handling for void-returning mt76_eeprom_override() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index b284e264d89a2..bae48fbed116f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -461,8 +461,10 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
 	mt7615_cap_dbdc_enable(dev);
 	mphy = mt76_alloc_phy(&dev->mt76, sizeof(*phy), &mt7615_ops);
-	if (!mphy)
-		return -ENOMEM;
+	if (!mphy) {
+		ret = -ENOMEM;
+		goto error;
+	}
 
 	phy = mphy->priv;
 	phy->dev = dev;
@@ -501,7 +503,14 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
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



