Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055781;
	b=igGswd+YyH/cnw3UHccjfO/6/ljHL1gODjHnJDsRU/xF6239TMN2wPBL+MJvi37oCnub
	 KJUAWtuFezt8aTAVQNxTOemWInUTr+P3ujs+0rBeD2RJVof8wscEd/hM/9qqwOsIX1cx7
	 6MXtZJwiHp7/SUaEKZrKEI31OUewZCghHe8BSHurOcIQ8sTewJMmEKYyJG7G0MYmeYnUk
	 Aq0wUNOcBnWcjAt7X6E/w/vdUkRFS+ygF7Qs2xYifZV6D2BgKB5T5S4B2SB6MeyKbDMTK
	 +RlAQsXAGnYKPaaaovClCRYBsshNyV4++3Ng9BxVa9x2Xv4UnvSViV+9Tug8nJgMtyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wyjCyOVek9ewZIqjfeUPpX5n96QUqFhXoLHjtGlaIzs=;
	b=M9+1r/b6q/1XuZ66gU9/qC6leGuoNombiYFyh6HkNJ+hMULWiQpQECxWV5QpOvg/v59t
	 LSvISbxMvmN/dxdqLxKIHakBWaMU3G2QGjhb5SGZzdCn0hoNheOZrDOM80qhOAklwAzl7
	 VSoBh2bFs5T2PApC9H0eBWa32MnWu3Bs0NqwBriPik61UZxxB7MJGZPS6QaR2wKtKBnQp
	 eoyCt+Hg9Q9Xa7BWrzmaPJmwsdrzp82DJSfDJowaR266M1ykExdRZWbK4kOYN8gFFVemQ
	 sQgN+sEmlQChJWA82o/Lv1r1WXWzoqNr2e7EwNqeQwx9/ZyNwIoYr+Kph7HZlSkdSqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oj6OVseX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD2A606A320;
	Thu, 19 Nov 2026 02:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oj6OVseX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9361F000C4;
	Thu, 19 Nov 2026 02:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055781;
	bh=wyjCyOVek9ewZIqjfeUPpX5n96QUqFhXoLHjtGlaIzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oj6OVseXjWwoMn1KyAzjFhot/FwqNsCOEaYd0BMv0z86Ud0YWxb70z5UuHx/j6dLd
	 DWI2D13u6O04i4eT24YPzz9QEU16QcvGVGigFUTzQeS++cRFJ4OCfvwesWzfoi8sO+
	 8t2TjDOhRqHatGC5Gg8ObB/oMgb/iFFYxCFlsaL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1727/2214] power: supply: ab8500_charger: Respect AB8505 register layout
Date: Wed, 18 Nov 2026 15:56:43 +0100
Message-ID: <20261118150120.792606881@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit dcecf527632297011153f088573689a1ad1de790 ]

Several AB8505 charger fields differ from AB8500. Its long VBUS
falling debounce is 300 ms rather than 100 ms, and its VBUS
overvoltage selector has a different encoding programmed through OTP.
Writing the AB8500 6.3 V value selects 9 V on AB8505.

AB8505 revision 3 also defines SwControlFallback as reserved,
correcting older documentation which led the driver to support
autopower there. Preserve the AB8505 overvoltage setting, wait for its
documented debounce, and reject the unsupported autopower setting.

Fixes: 0ed5107fa860 ("ab8500-charger: Do not touch VBUSOVV bits")
Fixes: b016322293c7 ("ab8500-charger: Add support for autopower on AB8505 and AB9540")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-9-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index cce2f3c13b797..ae9e938188829 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -52,7 +52,7 @@
 #define MAIN_CH_DET			0x01
 #define MAIN_CH_CV_ON			0x04
 #define USB_CH_CV_ON			0x08
-#define VBUS_DET_DBNC100		0x02
+#define VBUS_DET_DBNC_LONG		0x02
 #define VBUS_DET_DBNC1			0x01
 #define OTP_ENABLE_WD			0x01
 #define DROP_COUNT_RESET		0x01
@@ -356,6 +356,10 @@ static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
 	u8 bit;
 	int ret;
 
+	/* SwControlFallback is reserved and must remain clear on AB8505. */
+	if (is_ab8505(di->parent))
+		return;
+
 	dev_dbg(di->dev, "SW Fallback: %d\n", fallback);
 
 	if (is_ab8500(di->parent)) {
@@ -660,12 +664,16 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 
 	if (!probe) {
 		/*
-		 * AB8500 says VBUS_DET_DBNC1 & VBUS_DET_DBNC100
+		 * AB8500 says VBUS_DET_DBNC1 & VBUS_DET_DBNC_LONG
 		 * when disconnecting ACA even though no
 		 * charger was connected. Try waiting a little
-		 * longer than the 100 ms of VBUS_DET_DBNC100...
+		 * longer than its 100 ms debounce. AB8505 uses
+		 * a 300 ms falling debounce for the same bit.
 		 */
-		msleep(110);
+		if (is_ab8505(di->parent))
+			msleep(310);
+		else
+			msleep(110);
 	}
 	ret = abx500_get_register_interruptible(di->dev, AB8500_CHARGER,
 		AB8500_CH_USBCH_STAT1_REG, &val);
@@ -676,7 +684,7 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 	dev_dbg(di->dev,
 		"%s AB8500_CH_USBCH_STAT1_REG %x\n", __func__,
 		val);
-	if ((val & VBUS_DET_DBNC1) && (val & VBUS_DET_DBNC100))
+	if ((val & VBUS_DET_DBNC1) && (val & VBUS_DET_DBNC_LONG))
 		result |= USB_PW_CONN;
 
 	return result;
@@ -3060,7 +3068,7 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 		}
 	}
 
-	if (is_ab8505_2p0(di->parent))
+	if (is_ab8505(di->parent))
 		ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_CHARGER,
 			AB8500_USBCH_CTRL2_REG,
@@ -3413,11 +3421,14 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	di->bm = &ab8500_bm_data;
 
-	di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
-
 	/* get parent data */
 	di->dev = dev;
 	di->parent = dev_get_drvdata(pdev->dev.parent);
+	di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
+	if (di->autopower_cfg && is_ab8505(di->parent)) {
+		dev_warn(dev, "autopower is not supported on AB8505\n");
+		di->autopower_cfg = false;
+	}
 
 	/* Get ADC channels */
 	di->adc_main_charger_v = devm_iio_channel_get(dev, "main_charger_v");
-- 
2.53.0



