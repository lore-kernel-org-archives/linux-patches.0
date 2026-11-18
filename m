Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038804;
	b=cU2z6r8TFQwDlfA7kley7jRzhvqmR+MvIwhLMMulqGaF8P4CSLnbZaUYHbNqGPsLNhKT
	 1MRdXIGDo4D9Jx4Dhj520Sp9h7a4O1pUOaQ5JlUHhnp5kLVVPoWZlPu75h4XnCeWt/e1p
	 gOkgYSM9MTA9ZScGzaQbefp4wI+WFS9yKi48tGL+KAv9TtrDDP/rt1gNUv/tNZXIHYRW3
	 XyaYo4VQCmS7NU1S0K/SjXhE23eCFD/ed04IzHy/363hH7SuXNGSkyBRiWLpOAf96pZFC
	 SurGP4jdod2Q1BlsgB4yH5b78PwRaeSBR79lb+Fg5KiRF/HNByMu6tjQObTAmSNWFDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nJNt3SKEBN6LcqXfRExcWhIR4Elk1zSQKa58Sp2fYus=;
	b=jvnYh2BTZ6y0kg7u1NbK2M6Ghd/ALBqW7hGEmKSSJ/hbh1v+CrLJ/q3tVG7ayhDhgbM9
	 Qd9Cv0bGDAzCZYd/bhDFc/rCZWFTnFTJV37F2KtF5rqnxxzIyiCfZDuUIMOt1F7CP8kQc
	 iFyhhzVvIF1EiZeLQpe/Tdchkn//lh6AK0TTE5o4VQ12vkjSpvKObWiUZmoA6qmWeoSsi
	 h2j90ETD5GdixKuyJMPAIaYZjMWD+NEbVBvKfHBycTq3sywCZfmntxiZkwG8ayQxpNac3
	 4T/YkHm2mOuDZ1yKo3v4uWZvPCGzz8o1rKwJokf6s9xXDQulDiZvJmqxmKBryoTHT4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ed7/nnqI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB45606A320;
	Wed, 18 Nov 2026 21:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ed7/nnqI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2CA1F000C4;
	Wed, 18 Nov 2026 21:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038804;
	bh=nJNt3SKEBN6LcqXfRExcWhIR4Elk1zSQKa58Sp2fYus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ed7/nnqIV9jHh4EoEZN0tMGsxtnvRWE7ugWZwboUZ7oI2RCNKifs2tCmFvyIKQqUk
	 QI21MMsVf0Kao4wt+YFiOdxR/Dpjl13xGTWwMBocBTTPAgy4YqKZdh+OilRfsR4wjW
	 mR8WfcR76IsQgJqb47lHuBbtPQ/iUbuS917cPwL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1831/3318] wifi: mt76: mt7615: restore DBDC state after ext PHY failure
Date: Wed, 18 Nov 2026 15:40:53 +0100
Message-ID: <20261118150416.790569542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted error handling for mt76_eeprom_override() because it returns void. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 129350186d5d5..e50dcfc8bcf2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -545,8 +545,10 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
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



