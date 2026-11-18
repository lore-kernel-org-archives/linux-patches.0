Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059856;
	b=FcaKX9ECKVKmU6jBl7DmyCLL1v5WFJYcRRdAmzJIGZLhNNng2ezTc1/9yKQYgVcjIJwL
	 +kjkibEAXXkwLti9YhGlcoutrnaU8vJPAslqeJDs5zhcZYhGnjS1Pf9Z8HbAjhB87vOa7
	 i7YBWOeTidHtyQTsiSowHINWfmzGPhX3xH6a6GT106NX8thsl1FN13sMrPCb9tQyNhKkL
	 TywrNNXASiXFhbB1H7qgeERgm3L0RH+ZSK4Yix5Msw546yfNapqK4EGbPYi01mO4QQTNL
	 SSYNVUf3GfzgeruO+l7FASJmKv0g5Hynpbn0LG+UwBgIG+VNaNrdulSWgcu2OkovRYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U4gRUhExVVO1+MC+mKs14B76ymZq59FL4fTR2Tmkg80=;
	b=t/l+tNmYqLPJi06xTf2pXjiijssOAcShrvsR3LrfMwG1lci1PDvFrEgZ0FzCCPzWFOSY
	 SjRXjQXP4RcUXqGqbbREzfUTl9zVgKwEpePmYNWd8wvctWtySIzWdveSjg54gv/SG8C4t
	 UlPXf69J+CT5EhvUMg2EQvuusAbxigNrFPFSzFSmY6TPknY0+AXJcj4kPHshWjE0tDhlH
	 mhJovW+nlXXoRRnyXBvr9HNEmQpTwdBW5q48dA7KqvNR9s/ahMU+h055kZ8s7GfetaOmq
	 KE2qeRnONnW3Y0iHtTRZW264Sm6Z0c49AIvd4ZC8+yLNPSAgGrSKXj5eHFlG6YVBDUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhYYzVw5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22F9606A325;
	Thu, 19 Nov 2026 03:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JhYYzVw5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5C01F000C4;
	Thu, 19 Nov 2026 03:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059855;
	bh=U4gRUhExVVO1+MC+mKs14B76ymZq59FL4fTR2Tmkg80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JhYYzVw5/v4huLB1/NaduK9RoMV6VJwXMHbjXNzuL4/+FzkWILGAQntEucuc263XH
	 25Vj0VSsip8Z5/g7/Ay/xHkduR29K4gXMDDBHVVOlFnHI3zaYmpcahXuoGnNBaHejq
	 HdEO3Xn6TxRJ2buOz8RunCnpVJMebEUsR0QtcIX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0992/1848] wifi: mt76: mt7615: restore DBDC state after ext PHY failure
Date: Wed, 18 Nov 2026 15:50:30 +0100
Message-ID: <20261118145958.402175450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for older mt76 PHY API signatures and omitted the unavailable EEPROM override error handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index e194259c84e90..b579dbf173f1e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -398,8 +398,10 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
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
@@ -431,7 +433,14 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 
 	ret = mt76_register_phy(mphy);
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



