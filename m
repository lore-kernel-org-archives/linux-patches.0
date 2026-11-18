Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047289;
	b=xvpCzr47Vx4UNCB5p+es+Vk5TZlLIL8WdR/M/jjghSw4CptTymqXl0DX0aWB2Ol5I7g5
	 /6/x0kNV7Nf5b3N4FzkVUdZXC9s6to7SUOYRfiTqOaR2XnMIz4xKzxv/fYw6n1fvGcXou
	 e2DmbHWeRrjbwnZB0uTRzsv+Ijtml6YnppMznfMVj/SDo/318BD3vE4OMAL2AO6kDUbDv
	 313IKbBsMyqxTSBJRTbLPbKDzDnIHpTNZI0qLxlJvD/w3E+jv3KIKlVVczI37U1wHhvTn
	 hP5cuNrzYK4oFVriflT7wOQixrRYQjnMTsIcFW+RCy1I9ioTSWDti6KeRLbSdiX4cMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3oeThaTgltsdWtNBg9/7nZkkZx+64g5Dx7w7nOUu+c=;
	b=QfMuwL0PkXnmtfrhIwkGz7xSAQ13KKgR/u1T6QhLaQ8N9PQfwiBylB+gHI+16O3fqAS8
	 GM9aFoE2h3EhteqVhqESk/luyG7OYFATB0Px9ORYKF+gDGZqRCZZMzNDfKhy1omE+d9F+
	 3czx8dq2LbMU31KXxBvHiM8enWbAdfmdFRIqePbwBqKzOAuutA+u93gytEVG6nmMYhVk8
	 V7XZMqAPGmileKRBgmgK/n/S4wa2sztYYuYyb2aSqgjLYvHIWItw+hAsCiH0OlmlwZjTi
	 iEEMggtY/iBgO2qKK4ouMWKcrqmb4erBuKY3JudNbQscDZs6AdU29To1yghmzH3P9XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBq2OGnd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99275606A31C;
	Thu, 19 Nov 2026 00:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBq2OGnd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A641F000C4;
	Thu, 19 Nov 2026 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047289;
	bh=Q3oeThaTgltsdWtNBg9/7nZkkZx+64g5Dx7w7nOUu+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBq2OGndUKJOddR/NutE7dPYr9KJFBc3gAfOc19Y/1J8VjL5zgu5JLaDjaUVaiB7O
	 86rZ45On0rBjThIDhGS8eRu5MTwcmBBprSTrarqXj5LK4hJ1o+3dBA/59z3Elm4r57
	 +uYuuOcPLRScuOqodgbp2+2wtSlo+pu9i0bXXyx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1585/2857] wifi: mt76: mt7615: restore DBDC state after ext PHY failure
Date: Wed, 18 Nov 2026 15:43:39 +0100
Message-ID: <20261118150258.444295038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted the mt76_eeprom_override() error-path change because that call is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index cb5965700dfbb..333e33189c4e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -463,8 +463,10 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
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
@@ -503,7 +505,14 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
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



