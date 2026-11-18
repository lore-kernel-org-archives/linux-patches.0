Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041009;
	b=DsR553V7kc8+Yv4nwtaxhBNqWtACHLoUvGwjxDaexsbV88e/l/6jc5Ow0qgpawl75nqi
	 kdDDz3WoJ7gR9lt8t1dc0+mv1eAPGmbnAftwo5jabCxaDPCsBoeUfkoKiMqDC5dBBlb51
	 SRAe1co5eYLWkib9i3hJBB8MM7WyAPFVgpGNGT9ql5jbzPE3lEVdPgEwWENAA1o/CiekA
	 u60/dNJas5qNVwgU/6x8iwRX6iei0Tjif2wiryMzde1viXVw9FwkgA3OgagXSKzDL4pnF
	 WnjpG8tVbnCFRTvdFlY4A/6cacMREmqO/LjDE66cpFWcHUT8btHJTAVftOcdlYeha1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H++sO0d0m0QtxPo38Ax+6lanGFN+OAp3v39PH7OHMbo=;
	b=o1ruuPE33C7soqi4p450TuHWHPotOoO4QryGkY9PHt2EiFZjHYJUBbAbRois/wWyv68E
	 gDQX5iIBb87L7d6aqljyQaxykjvYVBiqriQttqcbmVDRWVAKUyZRhBWRage3hcEwv8OC9
	 2L3+tgjznJkzdyDJ2gDK9j+Lpv9YOrtbUTpqT6k6Nbh/3p+Q6QYYqnmtzbUghn3yQq1VP
	 jorp85MXLqVOjPqXFbWhN7HJRrzRlP5XsT8ecMlsR0GybRhTpQTkU6U2j8TcFpKv2m2lc
	 2+AGR/AkSm6BWIvwE6IrOai7gBAxr3zkV3sBV/gTl6FjVzjHYJuakAkU5xL8JR598NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhKE7Tg2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75990606A31C;
	Wed, 18 Nov 2026 22:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhKE7Tg2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715B21F000C4;
	Wed, 18 Nov 2026 22:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041009;
	bh=H++sO0d0m0QtxPo38Ax+6lanGFN+OAp3v39PH7OHMbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhKE7Tg2O1iGnIVUyLhVyKxNi+9x3pPj0guv8hjXa68G0DQJ3BTGn6VaD2NOFrB/M
	 3GqRfXQDs7AQn+YThlUiVffa52c/ucQWttKNCR8PpN0ndn/h0WeBA9yh90+0GgFJHH
	 z3zo7EK9PuZXgvQrPRKz9PuU/8q8aZBzGW0fEVoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2659/3318] wifi: mt76: Use PTR_ERR_OR_ZERO() to simplify code
Date: Wed, 18 Nov 2026 15:54:41 +0100
Message-ID: <20261118150440.801503585@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit ed160b600ffc1a23fe04c6e8c1b0210f70c45d39 ]

Return PTR_ERR_OR_ZERO() instead of return 0 or PTR_ERR() to
simplify code.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: b8286bc7fe52 ("wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 5 +----
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 5 +----
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c  | 5 +----
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 5 +----
 4 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index e50dcfc8bcf2e..b4ab52a64fa49 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -61,10 +61,7 @@ int mt7615_thermal_init(struct mt7615_dev *dev)
 
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, dev,
 						       mt7615_hwmon_groups);
-	if (IS_ERR(hwmon))
-		return PTR_ERR(hwmon);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(hwmon);
 }
 EXPORT_SYMBOL_GPL(mt7615_thermal_init);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 711de6b1ce5bd..8d7d828e28206 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -215,10 +215,7 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy,
 						       mt7915_hwmon_groups);
-	if (IS_ERR(hwmon))
-		return PTR_ERR(hwmon);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(hwmon);
 }
 
 static void mt7915_led_set_config(struct led_classdev *led_cdev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index f182ea7c5f1b8..40d825ce0a7e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -1219,10 +1219,7 @@ static int mt798x_wmac_init(struct mt7915_dev *dev)
 		return PTR_ERR(dev->sku);
 
 	dev->rstc = devm_reset_control_get(pdev, "consys");
-	if (IS_ERR(dev->rstc))
-		return PTR_ERR(dev->rstc);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(dev->rstc);
 }
 
 static int mt798x_wmac_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 61de6b03fa0be..1748625243c14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -57,10 +57,7 @@ static int mt7921_thermal_init(struct mt792x_phy *phy)
 
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy,
 						       mt7921_hwmon_groups);
-	if (IS_ERR(hwmon))
-		return PTR_ERR(hwmon);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(hwmon);
 }
 
 static void
-- 
2.53.0



