Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018525;
	b=kfw2GI2DosZMmFF9JSkvkkcR6z8uCKkf7tZ9cjmlQpaBtY4zCf15pTzRtdDOsPWUERNV
	 9A9BNqZEVsHPcs1vkkyNWBl8DoVrLbgsEooUk6BIpggE0MLnE1tsYX7tqfV89ssovLbNG
	 9idwGKAETtIvebQiFIXFuObD4jSbAx3rGqiXdr7t4pBgZ8dl8dF53KLSNy70hyoX8zyn3
	 dmoht8qLvrwd31EH2yMDV2y1m6k0wjnBj4ZfwNNSJi1CforoXo/+ydLDq9JzUKhW6kdM2
	 bX0O5Ae2AE8miFwdAbkyew1eXZ8mi+YwlaoOM2qe0UxfdJ0vOQPbRnLqSwtOvLOBETg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q5Lo7vQCP7tF2EpbH8WutB+NVydo8rAr0zZTlnsPvac=;
	b=qX+5Hw94NhyGCd1BkmGxirXB9m843nS529Efepf4rrc18geKB4MrroOySbeNic8ERYoF
	 3OEuyGRtJ864AegIy/OOfIEEH79HECx8ANWtWfzrGEF/W6+sjkRHuWEIvxKkUBg4PU34O
	 96/XIhw++kZeN9/ryJkvH/46+GgUdl5+vJ3Vg1YEW36qObBRnoKIfiGkPZ5jEBj6Im1Cl
	 lcshjzkRX5dSjEMobmeA5GSwUh7SbrJ6ISM5tN7FlcspdsbM9ORMS/EsPn/vlGISmTomK
	 DObklAIJbNQ/9E696PycYVr5Xz5rNbYZfyuoyZZReOvDTydazJ/D/sphOEkM/1BhIEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DsXJhQUa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A27B606A31C;
	Wed, 18 Nov 2026 16:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DsXJhQUa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9A21F000C4;
	Wed, 18 Nov 2026 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018525;
	bh=Q5Lo7vQCP7tF2EpbH8WutB+NVydo8rAr0zZTlnsPvac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsXJhQUajrEchdlE26TOIr7LKsAXgEmP9Bang2tBiFjsqIh49jypOJ2U7Va2K/Ovx
	 iP3ClyO0DP+Tz/+1tHWPXTMyeoxWnapX6BUKodWiPSlxtOnoNrKU4mc0LifnuI940v
	 rUPAMnXCduqpoIuPCOP7fjwM6g2fbOfi3AXvtOIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1272/2651] power: supply: ab8500_charger: Skip absent AB8505 main charger
Date: Wed, 18 Nov 2026 15:41:52 +0100
Message-ID: <20261118150333.750289297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 52c8cdcc1146d86fae524a589d4512c8d59ea8b4 ]

AB8505 contains only the USB charger. It has no integrated main
charger, main-charger status register, or main-charger interrupts.

Avoid reading the missing status register, requesting the five missing
interrupts, or disabling an AC charger which was never enabled. This
lets the driver bind using only the AB8505 USB charger resources.

Fixes: d4337660d069 ("ab8500-charger: Add AB8505_USB_LINK_STATUS")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-11-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 32 ++++++++++++++++++---------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index c500f468c4639..04c578899468f 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -692,16 +692,19 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 	int ret;
 	u8 val;
 
-	/* Check for AC charger */
-	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
-		AB8500_CH_STATUS1_REG, &val);
-	if (ret < 0) {
-		dev_err(di->dev, "%s ab8500 read failed\n", __func__);
-		return ret;
-	}
+	/* AB8505 has no integrated main charger. */
+	if (!is_ab8505(di->parent)) {
+		ret = abx500_get_register_interruptible(di->dev,
+							AB8500_CHARGER,
+							AB8500_CH_STATUS1_REG, &val);
+		if (ret < 0) {
+			dev_err(di->dev, "%s ab8500 read failed\n", __func__);
+			return ret;
+		}
 
-	if (val & MAIN_CH_DET)
-		result = AC_PW_CONN;
+		if (val & MAIN_CH_DET)
+			result = AC_PW_CONN;
+	}
 
 	/* Check for USB charger */
 
@@ -3500,7 +3503,8 @@ static void ab8500_charger_unbind(struct device *dev)
 	int ret;
 
 	/* Disable AC charging */
-	ab8500_charger_ac_en(&di->ac_chg, false, 0, 0);
+	if (di->ac_chg.enabled)
+		ab8500_charger_ac_en(&di->ac_chg, false, 0, 0);
 
 	/* Disable USB charging */
 	ab8500_charger_usb_en(&di->usb_chg, false, 0, 0);
@@ -3724,7 +3728,13 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	}
 
 	/* Request interrupts */
-	for (i = 0; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
+	/* The first five interrupts belong to the AB8500 main charger. */
+	if (is_ab8505(di->parent))
+		i = 5;
+	else
+		i = 0;
+
+	for (; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
 		irq = platform_get_irq_byname(pdev, ab8500_charger_irq[i].name);
 		if (irq < 0)
 			return irq;
-- 
2.53.0



