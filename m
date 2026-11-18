Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030848;
	b=5UuHXd8uSTflmtO7TpmCVoBcuXNc/mYx0q73H/HSIVMQfujIRoHIXDve1kmthF6UGEnT
	 dilnUF7qCev7Piu7K9D3CtQ4MY/nH7MlphCvGjQLJlYRqYi7CBFKRHkuEqOAAzeMP7PUm
	 s0qYfHh26955p4HO62wa1N1XqT1HxntIV+xt2OVIOgZbioNsGt/clASHDod+AVwr2XJaq
	 E4YFVGYtoX/+WqQth55ONsXhm0dq08KwJFTcm73HtIku1gmsrSV525Zz0k8FHr4s0u8X5
	 jEcXKz2njVfKsFl8E39eKhCQF5OlnBcn2dtdvTau07yvE021YLVUF7dkuPFE8iVUM2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HSgGauMbux59OTyag8nB0V2EGntXl7xt5bAUS017yUI=;
	b=f2QLUylW44MZX5IOOmGP39rzT4rkhkk37jqFkHrzMJuF50Iz+o/m2Z4OmHDu7elzGQBr
	 S1CEhCZfGbBa2ybH+Z0npHuasByWel3ar+5gyNGYich90iIG0fTECQPiyr990Haa5s4iV
	 3XYysqlcUqKwWpxtA7PLI5iGVPgZtXnpU5iDTy0DqcUMhPNC9H//bpo5xAzYjj3Jbpget
	 nkJrpJEnd2wJH5JwVf6d7pn996/uuI0BXEj8z4zpLY23ctKt9PXmjNAHfsfxK0hSSeQ8S
	 rIwWml9345FehMXNy7Gsvjquvr2TNbsdXnvcnO98mlnOGpNaN+TLOe80cGmJJXdW52Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXURDyH+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6FE606D344;
	Wed, 18 Nov 2026 19:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rXURDyH+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883A91F000C4;
	Wed, 18 Nov 2026 19:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030848;
	bh=HSgGauMbux59OTyag8nB0V2EGntXl7xt5bAUS017yUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXURDyH+rGRsxIvUcOhvrBsaTZtEp1yKZNZ2an5cEkdr11G4e4FpWpY4OzKXnuuH2
	 lK8VSQ0BFntb0l1E+ELoEKpeHjXW63swYz8h5Uxdx7K+fZCRMlcdBXKtccvMCVLzQW
	 NdrlWzmmBtVUHJCWvDQJCf90+e2OQdBhDUo5skOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0833/1756] power: supply: ab8500_charger: Respect AB8505 register layout
Date: Wed, 18 Nov 2026 15:49:20 +0100
Message-ID: <20261118150042.649319383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 8715f54f0a3ca..9c81f79502870 100644
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
@@ -383,6 +383,10 @@ static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
 	u8 bit;
 	int ret;
 
+	/* SwControlFallback is reserved and must remain clear on AB8505. */
+	if (is_ab8505(di->parent))
+		return;
+
 	dev_dbg(di->dev, "SW Fallback: %d\n", fallback);
 
 	if (is_ab8500(di->parent)) {
@@ -703,12 +707,16 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 
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
@@ -719,7 +727,7 @@ static int ab8500_charger_detect_chargers(struct ab8500_charger *di, bool probe)
 	dev_dbg(di->dev,
 		"%s AB8500_CH_USBCH_STAT1_REG %x\n", __func__,
 		val);
-	if ((val & VBUS_DET_DBNC1) && (val & VBUS_DET_DBNC100))
+	if ((val & VBUS_DET_DBNC1) && (val & VBUS_DET_DBNC_LONG))
 		result |= USB_PW_CONN;
 
 	return result;
@@ -3186,7 +3194,7 @@ static int ab8500_charger_init_hw_registers(struct ab8500_charger *di)
 		}
 	}
 
-	if (is_ab8505_2p0(di->parent))
+	if (is_ab8505(di->parent))
 		ret = abx500_mask_and_set_register_interruptible(di->dev,
 			AB8500_CHARGER,
 			AB8500_USBCH_CTRL2_REG,
@@ -3535,11 +3543,14 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
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
 	if (!is_ab8505(di->parent)) {
-- 
2.53.0



