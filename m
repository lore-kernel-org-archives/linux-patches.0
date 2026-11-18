Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016904;
	b=AtEW/+uZGZuvXHKKjm0n1Brnc9bl3558XjoPqtZtVRocfwPVhFoQOIwA248nSX31IJ2Q
	 r13DwqKk2dh4ztteoC5pYVoo6aifosIHwAiDDmnz4O9EB6JZOfHnAjbBk8Wgh1sb9Hx7E
	 72ejQOHLN9xrmeuUmC0lSZKVmRhti3BBDFUHbzsxoY8/SovZ2GX6G8oEkNU7h8YfBRQyp
	 cZ12e52JpAu7ObstHkEsHkp2jKx71iUFUGvi49+aa0vybDDPGd/Gdv/hJuurfQ2X5NWZW
	 7cscmESUy+phMXfPlK9MRHSRPewZrHuQAEw+3TfXj1+stnLCiEdcg698n7aN3pDFI5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M7ztkj7zuzl56RxQ1bBPWH5DRTIkrDu1KWpLmFNfMpY=;
	b=SjBYKCB5EtAmgZP/ShZj/26N6D4h53oZyZ8tSkJ50i1bUqSGSmrc6uXDAYFDfj/IbPuV
	 SRxzwXDMRtjSkzKVMSPwvDWSfPCDA1WjLzFK1uSr/STz9AERTdt929sVyKy+TMV/PXzJo
	 NrpxGjoZsE/DGiFjl59oEjHHsBH5NJg3aWykMvogjcNeZGMNnf69axNYAjzWcOx9q3By3
	 m26uJ/xsDRctdYHLFdNxbXjfsQCwaVO3YX+SpF5V0dUy8sOK4bOJPyNY6WpYaElvfrEMP
	 zYl1kw+HANxYTpJWKsfCbk4eaRO7h/8z9eK+6s9oqnUtFda2yEj8wYur1i2IqLD7euA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JCWCknBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF0606A31C;
	Wed, 18 Nov 2026 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JCWCknBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A943C1F000C4;
	Wed, 18 Nov 2026 15:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016904;
	bh=M7ztkj7zuzl56RxQ1bBPWH5DRTIkrDu1KWpLmFNfMpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCWCknBwd5z49l52ymMzfqJOUMUUYq5maIdW2sfnTdg+b6HlhTJ68jhpHcizIn0B+
	 HLNDX6DqQTQLDQ6dBc1y0cOLv89VBpeIPwVi+AYOq9uyWv6pzOD/qy35DBGDFIqxzY
	 w6ykpGbbBu0XmEA/9hJFl6slbbGgfnJNi8C/o1uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0653/2651] leds: st1202: Add hardware-accelerated blink support
Date: Wed, 18 Nov 2026 15:31:33 +0100
Message-ID: <20261118150311.194035384@linuxfoundation.org>
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

[ Upstream commit 35cbd34a6a05cc53882b1b7ca6f338a93ab29fcb ]

Implement blink_set() to enable hardware-accelerated blinking via the
timer trigger. The LED1202 pattern engine is used to produce a two-step
sequence: full brightness for delay_on, off for delay_off, repeating
indefinitely.

Requested delays are clamped to the hardware range [22ms, 5610ms] then
rounded up to the nearest 22ms step. Clamping before rounding prevents
integer overflow in roundup() for extreme input values; since
ST1202_MILLIS_PATTERN_DUR_MAX is an exact multiple of
ST1202_MILLIS_PATTERN_DUR_MIN, rounding a clamped value cannot exceed
the maximum. A zero delay is replaced with the default of 500ms
independently for each of delay_on and delay_off.

The LED1202 pattern sequencer is global and its timing registers are
shared across all channels, so only one blink configuration can be
active at a time. Other active channels have their PWM slots zeroed for
both pattern steps so they remain dark rather than outputting unintended
values when the sequencer runs. The target channel's ILED register is
set to full brightness and the channel is enabled, since the timer
trigger deactivates the current trigger before calling blink_set which
would otherwise leave the channel disabled.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Link: https://patch.msgid.link/GV1PR08MB84973F79E871176EB387C377C5DA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 878eec1475e7 ("leds: st1202: Program the channel current for hardware patterns")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 89 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 21d1aa4d460ec..2f202e74ffa38 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
+#define ST1202_BLINK_DEFAULT_DELAY         500
 #define ST1202_CHAN_DISABLE_ALL            0x00
 #define ST1202_CHAN_ENABLE_HIGH            0x03
 #define ST1202_CHAN_ENABLE_LOW             0x02
@@ -297,6 +298,93 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 	return 0;
 }
 
+static int st1202_blink_set(struct led_classdev *led_cdev,
+			unsigned long *delay_on, unsigned long *delay_off)
+{
+	struct st1202_led *led = cdev_to_st1202_led(led_cdev);
+	struct st1202_chip *chip = led->chip;
+	unsigned long on, off;
+	int ret;
+
+	if (!*delay_on)
+		*delay_on = ST1202_BLINK_DEFAULT_DELAY;
+	if (!*delay_off)
+		*delay_off = ST1202_BLINK_DEFAULT_DELAY;
+
+	on = *delay_on;
+	off = *delay_off;
+
+	on = clamp_val(on, ST1202_MILLIS_PATTERN_DUR_MIN, ST1202_MILLIS_PATTERN_DUR_MAX);
+	off = clamp_val(off, ST1202_MILLIS_PATTERN_DUR_MIN, ST1202_MILLIS_PATTERN_DUR_MAX);
+	on = roundup(on, ST1202_MILLIS_PATTERN_DUR_MIN);
+	off = roundup(off, ST1202_MILLIS_PATTERN_DUR_MIN);
+
+	guard(mutex)(&chip->lock);
+
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	if (ret)
+		return ret;
+
+	/* Zero out PWM for all other active channels to prevent them from blinking */
+	for (int chan = 0; chan < ST1202_MAX_LEDS; chan++) {
+		if (!chip->leds[chan].is_active || chan == led->led_num)
+			continue;
+
+		ret = st1202_pwm_pattern_write(chip, chan, 0, LED_OFF);
+		if (ret)
+			return ret;
+
+		ret = st1202_pwm_pattern_write(chip, chan, 1, LED_OFF);
+		if (ret)
+			return ret;
+	}
+
+	ret = st1202_pwm_pattern_write(chip, led->led_num, 0, ST1202_PATTERN_PWM_FULL);
+	if (ret)
+		return ret;
+
+	ret = st1202_pwm_pattern_write(chip, led->led_num, 1, LED_OFF);
+	if (ret)
+		return ret;
+
+	ret = st1202_duration_pattern_write(chip, 0, on);
+	if (ret)
+		return ret;
+
+	ret = st1202_duration_pattern_write(chip, 1, off);
+	if (ret)
+		return ret;
+
+	for (int pattern = 2; pattern < ST1202_MAX_PATTERNS; pattern++) {
+		ret = st1202_write_reg(chip, ST1202_PATTERN_DUR + pattern, 0);
+		if (ret)
+			return ret;
+	}
+
+	ret = st1202_write_reg(chip, ST1202_PATTERN_REP, U8_MAX);
+	if (ret)
+		return ret;
+
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, U8_MAX);
+	if (ret)
+		return ret;
+
+	ret = __st1202_channel_set(chip, led->led_num, true);
+	if (ret)
+		return ret;
+
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG,
+				ST1202_CONFIG_REG_PATSR | ST1202_CONFIG_REG_PATS |
+				ST1202_CONFIG_REG_SHFT);
+	if (ret)
+		return ret;
+
+	*delay_on = on;
+	*delay_off = off;
+
+	return 0;
+}
+
 static int st1202_dt_init(struct st1202_chip *chip)
 {
 	struct device *dev = &chip->client->dev;
@@ -323,6 +411,7 @@ static int st1202_dt_init(struct st1202_chip *chip)
 		led->led_cdev.pattern_set = st1202_led_pattern_set;
 		led->led_cdev.pattern_clear = st1202_led_pattern_clear;
 		led->led_cdev.default_trigger = "pattern";
+		led->led_cdev.blink_set = st1202_blink_set;
 		led->led_cdev.brightness_set = st1202_brightness_set;
 		led->led_cdev.brightness_get = st1202_brightness_get;
 	}
-- 
2.53.0



