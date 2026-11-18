Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024066;
	b=hyQhtJcxqCta+NKP7rMuaAx61PPeHqGbCxXmQmUv9upBq33sbG61vyQT2LkdI2GtXYdn
	 aUch7HeQkzjSI8zcRqKjLsfe0j3PI0bPujOP/aXTBpESIbY6dxsPb1vaQXVxI98p3D6mM
	 dN6U9DIfcFtOhoQ280a7G0PUPE/FYQLFjve0sEqfg+hDCjcNLeN9EDujrSqpbiWyMEk6C
	 b2Mg3RiYEWsS++ifYQLh6406T06GJSAprqqMm74wQktjKtaYMeIPGv77zJMiXUGrZXjgc
	 rSUw4lUbvDxPFaY6fSBtV56iud22HYao/2VuUrYPXhzMgomsIUREPhKdDncXRsoF31A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9OC8oNMN1v3JiAMCF3anoqa6y4Ge/R1k9+sgZ9n04SY=;
	b=xX4XlV1WfL4TzTLZ3WnYO4r3X2r+9ib9/6ov6pRALDaMyCFWYPbGld307Qwro1ZWjTNC
	 i0oSL2cxSaZvmJShYaWLAXtCRVH54d9GDfqaby6XaJ2HDD6mW0AHRV1IuegJPDum98PDn
	 VgjJ1aXnQMsnulfeKEh+XsIKk2QIrAS7MURz0glJsIPhkPpBf/qB2avrwVrLGAiyeHDLu
	 hJhS+JEJO1DaenVHYiL622dyY7Jfm+5WdVqABB95UloaT14StAfv/r7kqsgYtt1SpMEsf
	 KPaUVDk8ZzrNwAyO26WS87UQlx5PVaRjpwaGFlRRcU5YsUIEEj92A2PssJi+xUThspA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Oe3Q/xOL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D68C606A31C;
	Wed, 18 Nov 2026 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oe3Q/xOL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A96A1F000C4;
	Wed, 18 Nov 2026 17:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024065;
	bh=9OC8oNMN1v3JiAMCF3anoqa6y4Ge/R1k9+sgZ9n04SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oe3Q/xOLv1uY17WIeH10zuMEihrvw5+HG8iVDSoYA0Z/H9JCpRhJC85amvQcxzUCk
	 tb/xwQfD4f2VOLEre+OhVTRzCuLNJ0w92gkpyisBZZZwY2qeq5xSwKkIsLgiNi94ZQ
	 tgp1/FvK545zI52FD+iVD2jADSzrmnS+5Pkq9yNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0592/2151] leds: st1202: Scale pattern brightness to the 12-bit PWM range
Date: Wed, 18 Nov 2026 15:38:47 +0100
Message-ID: <20261118150143.519996064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit 82f8b88d6ac2edf01651bbd84e03ede04b2ca80e ]

The LED1202 PWM registers are 12 bits wide, but st1202_led_pattern_set()
writes the 8-bit brightness value carried by struct led_pattern into
them unscaled. A pattern step asking for full brightness therefore
drives the channel at 255 out of 4095, about 6% duty cycle, so a pattern
is dimmer than the same brightness set directly.

Scale the value to the full PWM range before programming it.

Scale against max_brightness rather than the register maximum. The LED
core takes max_brightness from the DT max-brightness property, so a
board can declare a ceiling below full scale, and the pattern trigger
already rejects steps above it. Scaling against a hardcoded 255 would
leave such a board unable to reach its own declared maximum from the
pattern path while the brightness path reaches it.

Scaling divides by max_brightness. The LED core replaces a zero
max-brightness from the device tree with LED_FULL, so the divisor should
never be zero, but the helper returns zero rather than rely on that.
max_brightness is capped at U8_MAX, the driver's own maximum, so a
device tree declaring more than the part supports is treated as full
scale. struct led_pattern brightness is signed, so clamp both ends and
floor a negative value to LED_OFF rather than let it wrap.

Document that a step is relative to max_brightness, since the range
given in the documentation no longer holds when the device tree sets
max-brightness.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB8497B938D3592582E17CB757C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/leds/leds-st1202.rst |  5 +++++
 drivers/leds/leds-st1202.c         | 16 +++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/leds/leds-st1202.rst b/Documentation/leds/leds-st1202.rst
index a2353549469ee..eacc7cfef7415 100644
--- a/Documentation/leds/leds-st1202.rst
+++ b/Documentation/leds/leds-st1202.rst
@@ -19,6 +19,11 @@ brightness (PWM) and duration must be written to hw_pattern.
 - Min pattern duration: 22 ms
 - Max pattern duration: 5610 ms
 
+If the device tree sets max-brightness, that value replaces 255 as the
+upper limit, and a step equal to it drives the channel at full scale.
+The hardware cannot go above 255, so with a larger max-brightness every
+step from 255 upwards is full scale.
+
 The format of the hardware pattern values should be:
 "brightness duration brightness duration ..."
 
diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index b567f97a313c0..8110860d018b9 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -90,6 +90,16 @@ static uint8_t st1202_prescalar_to_miliseconds(unsigned int value)
 	return value / ST1202_MILLIS_PATTERN_DUR_MIN;
 }
 
+static u16 st1202_brightness_to_pwm(int brightness, unsigned int max_brightness)
+{
+	if (!max_brightness)
+		return 0;
+
+	brightness = clamp_t(int, brightness, LED_OFF, max_brightness);
+
+	return brightness * ST1202_PATTERN_PWM_FULL / max_brightness;
+}
+
 static int st1202_pwm_pattern_write(struct st1202_chip *chip, int led_num,
 				int pattern, unsigned int value)
 {
@@ -234,8 +244,11 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 {
 	struct st1202_led *led = cdev_to_st1202_led(ldev);
 	struct st1202_chip *chip = led->chip;
+	unsigned int max_brightness;
 	int ret;
 
+	max_brightness = min_t(unsigned int, ldev->max_brightness, U8_MAX);
+
 	if (len > ST1202_MAX_PATTERNS)
 		return -EINVAL;
 
@@ -253,7 +266,8 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 
 	for (int pattern = 0; pattern < len; pattern++) {
 		ret = st1202_pwm_pattern_write(chip, led->led_num, pattern,
-						patterns[pattern].brightness);
+					st1202_brightness_to_pwm(patterns[pattern].brightness,
+								max_brightness));
 		if (ret != 0)
 			return ret;
 
-- 
2.53.0



