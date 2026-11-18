Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024069;
	b=e6eeQLbW+Eh2MxV0gEeismQiHImy3aClnijpEk37cXIVeso+W5qXVUH4HgaD7qBh4G1V
	 MB/EuRQdjyWzyKBh4xoLzeFzU9ICHzdYHnVlwL6o6zLB4wndNeSEqVsUuqppTXKk8FDvx
	 ITuO+ageTxKE8O6URQFyO1EHWsJJ6+lM59qQqNrHdRNSkE5OBUGPJQyyWYz9yRFvIHgiv
	 WLuvExnJLFXEuCdcSdyz1sMd8qrg7jWyqJ9meM+fpeen+PmNL5QZ/O9FhSvNjrN/0bMRj
	 gYaa5yaWwXuJ3SrxjOq+DML7RNJA+0eV3go6+DpTWB0mokaQLJJbqhT70MZZDKe9ocA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Idrn1D0z/gCkA9ZHKK4FkbQ36F1R8BF8EoHjBFesCE=;
	b=D6smfQhi/0V7lpNfoCOnp9mF/YTFra6koRD7c6yal6a7t5NcLhuSCwS5Ao4wxHLJxhA4
	 TZyLENwM5L0XQQe77OkbYWV3CQEi3KpEsm8RT8MYU32gTa8P2NAaqNPvpiKnFlwVqkqgx
	 9YSSfhOJdzrYDX8s5SWIIxZUzTlzAGoNHXbaA867wbBv1o4FiQfOhoIXvKzL3mnu9hl7w
	 7DCOUNqaSCsxo2Falw5fzF6y9W0SHIM++dNtceMqf+WvsS4UimWiRIdQaO0xqHLErlnOS
	 5m8srW6biK5pqZnyK2LpX1iJWYv8ejQuhY6Gko4OSDN1dJHTHMMuwbz3aJeuD4VpCuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPT8n7Kf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04E4606A325;
	Wed, 18 Nov 2026 17:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPT8n7Kf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA4C1F000C4;
	Wed, 18 Nov 2026 17:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024068;
	bh=/Idrn1D0z/gCkA9ZHKK4FkbQ36F1R8BF8EoHjBFesCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPT8n7Kf9MnZGift4ADJrVB02dI5xliLl5U3H/+MvUYYs3AHVdshSvedXjMaOAryl
	 nlOcf6j/VM14J3C/KVQkRPY9pplNCrSsvszblEM9pI+dHISwyrnexXdAcjBtM4qV8u
	 USu0QwPP0gVO4qSXtP+/JM+hgSH/XVxcAHZy67r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0593/2151] leds: st1202: Add hardware-accelerated blink support
Date: Wed, 18 Nov 2026 15:38:48 +0100
Message-ID: <20261118150143.558890721@linuxfoundation.org>
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
index 8110860d018b9..f1abb37520188 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
+#define ST1202_BLINK_DEFAULT_DELAY         500
 #define ST1202_CHAN_DISABLE_ALL            0x00
 #define ST1202_CHAN_ENABLE_HIGH            0x03
 #define ST1202_CHAN_ENABLE_LOW             0x02
@@ -298,6 +299,93 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
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
@@ -324,6 +412,7 @@ static int st1202_dt_init(struct st1202_chip *chip)
 		led->led_cdev.pattern_set = st1202_led_pattern_set;
 		led->led_cdev.pattern_clear = st1202_led_pattern_clear;
 		led->led_cdev.default_trigger = "pattern";
+		led->led_cdev.blink_set = st1202_blink_set;
 		led->led_cdev.brightness_set = st1202_brightness_set;
 		led->led_cdev.brightness_get = st1202_brightness_get;
 	}
-- 
2.53.0



