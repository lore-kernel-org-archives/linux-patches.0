Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016901;
	b=UJs+bBfDwJ6iKVtWtiv6zXu5sP7WvoDpavzv0AXCHcIjt642OjQrfsH5aKpeUUbrk+VS
	 0bTfp+R2JV4K/Nt1CMT82M9DiuVh3+VIZuMcQkTIXU6eFMAirTkcqCccQCHoOycGdtZJz
	 cNVDg6RTxICHlkE7I58HNN188YyI/tbnmay+sZxaw3/udcqbYYiPr53SkDDnPcCHQ2aUT
	 cQAOsw5xDRISHY5OO+GhovQZ4kofrOQsG1CUJmeFLcjr12EwZS9SMgnu1glne4zhKdZ56
	 23geZ+w5g6/HimD2yeMroX/pE1xCwEYk7aQgAV19CcnNS5pokuOcpUgGD6E4tprwQAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+arbI3VkAcmZ7dL36okAGoAtEjubzDWFwsb3Qr0OyOc=;
	b=zMSi3nD5D8bgtUt0ae6QpZBeq8PR8ESlQKNuYIOvXEmYp/yinyKhfVRNNpWSIhvaDFak
	 pnqbOFZyuEvkA4rZzm6Yhfi9cOVqezJvnk5Lw/35gTmr6jx/AlOkofECSB684wSgWaj0/
	 Xwz0e5TZ+7qaWW4+F87ZIqPuHCC+CLS8hLGtpddeOX8Xua70HudmZJcUKCuSMf0U5Xgk4
	 sb4lNb37gum6oguyA1L9haZLa1l4Yw7uUnG6LGzXyLczsDEcCLDHzLxMILXebQXQxFhsi
	 f+ebKebyEvaXl4Z1tXDMPI61UJ2l7UFeK23AqmsoC1F0Hf4e8W9zNVTxtN31pnxZ3FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JdYQ6eFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB53D606A31C;
	Wed, 18 Nov 2026 15:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JdYQ6eFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A2D1F000C4;
	Wed, 18 Nov 2026 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016901;
	bh=+arbI3VkAcmZ7dL36okAGoAtEjubzDWFwsb3Qr0OyOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JdYQ6eFFRINYo9v9elzGvTQXHbDy8xalZKJs2Fg92LzRaaInbKzT+fLUAZ1/CWrTj
	 1ZNMSA+OxgSrnbr7nKF9EvMpRgLyUNDmkhOdhfs8cyiMpsGI4D0AJqEywV8UJ3RAoa
	 oViDSgpYzbN1Za4FF8E1HBRSpuVXLgrdKcep/ZSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0652/2651] leds: st1202: Scale pattern brightness to the 12-bit PWM range
Date: Wed, 18 Nov 2026 15:31:32 +0100
Message-ID: <20261118150311.158286875@linuxfoundation.org>
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
index ed32eb3a27d45..28479a1123899 100644
--- a/Documentation/leds/leds-st1202.rst
+++ b/Documentation/leds/leds-st1202.rst
@@ -20,6 +20,11 @@ brightness (PWM) and duration must be written to hw_pattern.
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
index 4ef1cdc86de34..21d1aa4d460ec 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -89,6 +89,16 @@ static uint8_t st1202_prescalar_to_miliseconds(unsigned int value)
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
@@ -233,8 +243,11 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 {
 	struct st1202_led *led = cdev_to_st1202_led(ldev);
 	struct st1202_chip *chip = led->chip;
+	unsigned int max_brightness;
 	int ret;
 
+	max_brightness = min_t(unsigned int, ldev->max_brightness, U8_MAX);
+
 	if (len > ST1202_MAX_PATTERNS)
 		return -EINVAL;
 
@@ -252,7 +265,8 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 
 	for (int pattern = 0; pattern < len; pattern++) {
 		ret = st1202_pwm_pattern_write(chip, led->led_num, pattern,
-						patterns[pattern].brightness);
+					st1202_brightness_to_pwm(patterns[pattern].brightness,
+								max_brightness));
 		if (ret != 0)
 			return ret;
 
-- 
2.53.0



