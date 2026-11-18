Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024074;
	b=rHvS7ZLIjBWOxIT/Z/fOCRONwTwbn69VvmZra278kz9siPuNu90khqCMVqyW21aOHuxn
	 ea5ls9EEYCeiDLoqKS8eUzq4Jd2F2Bzmitl3ZvY81ZiN4r3xv3hI4DTjXZzK2CuTlk7Y1
	 JqOJ5wCMGozBQ68Vl4JOqOnmlaMexhlI48CyjOsO7jnu3rGJbwdrdcDINfJST1SND4ppJ
	 ZbVnkHSepJ++dowWXNqkiPv/rxYGSF2292yCCnY3y+1bhG/O6JGSnF1uMlhUzbfZFXklz
	 ytwsRhq+OySYpMCnqZhEZ7mrlIzeblxsXhojwIG+WpwA737o+siclqtuIqZXaRXSXsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hmP7MwIIeXl/WAkiSJFGipAIxmLKT9Wkr+WstA0Jzhw=;
	b=duNk+VxjXuPXugJnyfX+jpGpIaHRj4G0WUaXOXwOq2jfOeVLHfQ4x2diqqzP4ppLbzAi
	 AtOLeV4O6M3E9IZnM8LkuRy1adLXjs7+6StwrZ+EWiqi+pZsjDUwPz6kdtYSWwS/54Wdo
	 ik/X6DD0RfH60f4NDfe5nQp65AyFPhTkMeEKkPqgWIW2TdmMepy3NJhLE/pVOsplWC9hI
	 CBjgTzCU+Fv5dsxDrrtSIIxmrYKUahhtvu8bcCfuibL0KPCRAzoisjfxbCfZNhkBf8RRC
	 4k/S4ME53ebj1ABfnhUuPkc9V4XUYLwNCNRn9x0OmR6Oiqbv4w8pHZsLGc7kQDpdJOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSuTsEKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CA6606A325;
	Wed, 18 Nov 2026 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSuTsEKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED961F000C5;
	Wed, 18 Nov 2026 17:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024074;
	bh=hmP7MwIIeXl/WAkiSJFGipAIxmLKT9Wkr+WstA0Jzhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSuTsEKnA74cZdtB8yFchYCTAVGBEFSfrNu7I9LQZTQkEANCWv2YO+/WLwaEqp9Gl
	 mfypPn7LW15aoYm0nGmsMRENOrZUapmmAUrh7ALZ+bBW8SzmXW1VyW8unWCt/vGMbj
	 yNS7vnsNfzIorWJU6a4N7g95Dq8erDFTrOfEiQds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0595/2151] leds: st1202: Program the channel current for hardware patterns
Date: Wed, 18 Nov 2026 15:38:50 +0100
Message-ID: <20261118150143.629868113@linuxfoundation.org>
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

[ Upstream commit 878eec1475e77ad22059584bc617b6e671a536d9 ]

A channel's output is ILED x Pattern_PWM / 4095, so a pattern is only
visible while the analog current register holds a non-zero value.
st1202_led_pattern_set() programs the PWM slots and starts the sequencer
but never writes ILED, so a channel whose current is zero stays dark
while pattern_set() reports success.

Zero is reached by ordinary use. Writing 0 to brightness sets it, and so
does switching away from the pattern trigger, because
pattern_trig_deactivate() ends with led_set_brightness(LED_OFF). A
sequence as simple as

  echo none > trigger
  echo pattern > trigger
  echo "255 500 0 500" > hw_pattern

therefore programs a pattern that never lights up.

Program the current in pattern_set() and release it in pattern_clear(),
so the pattern path owns ILED for as long as a pattern is loaded.
Releasing it matters because the trigger calls pattern_clear() before it
parses a new pattern: without that, a rejected or empty hw_pattern write
would leave the channel at full current with every PWM slot at full
scale, latching the LED on. Clearing before the slots are raised also
avoids a brief full-brightness flash on every reprogram.

A current of zero is not enough to release the channel, though: the
datasheet notes that it does not switch the channel off but leaves a
small uncontrolled current, which shows as a faint glow. pattern_clear()
therefore also disables the channel, and pattern_set() enables it again.
Both are done before the sequencer is stopped, so an I2C error partway
through a clear cannot leave the channel lit.

Probe clears every channel, so the LEDs now reach user space switched
off. Until now they came up lit at the chip's power-on current, because
pattern_clear() fills every slot at full scale. Probe no longer enables
the channels itself either: st1202_setup() has already disabled them
all, and each path that lights a channel enables it when needed.

The current is programmed to the same max_brightness the PWM values are
scaled against, so a pattern step of N produces the same output as
writing N to brightness, and a board declaring a lower ceiling through
the max-brightness property keeps it on both paths.

Note that this makes a hardware pattern take the channel to its maximum
current, so brightness reads back as max_brightness once a pattern is
loaded and as zero once it is cleared. The pattern's own values, not the
last brightness written, decide what the channel shows while a pattern
is running.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB84978D7C1CC0367D1818093DC5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 135fe0b0f3a5e..25e548b023364 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -222,6 +222,14 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 
 	guard(mutex)(&chip->lock);
 
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, LED_OFF);
+	if (ret != 0)
+		return ret;
+
+	ret = __st1202_channel_set(chip, led->led_num, false);
+	if (ret != 0)
+		return ret;
+
 	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret != 0)
 		return ret;
@@ -288,6 +296,10 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 	if (ret != 0)
 		return ret;
 
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, max_brightness);
+	if (ret != 0)
+		return ret;
+
 	ret = __st1202_channel_set(chip, led->led_num, true);
 	if (ret != 0)
 		return ret;
@@ -456,7 +468,7 @@ static int st1202_setup(struct st1202_chip *chip)
 	/* Duration of initialization */
 	usleep_range(6500, 10000);
 
-	/* Deactivate all LEDS (channels) and activate only the ones found in Device Tree */
+	/* Deactivate all LEDs (channels); each is enabled when it is lit */
 	ret = st1202_write_reg(chip, ST1202_CHAN_ENABLE_LOW, ST1202_CHAN_DISABLE_ALL);
 	if (ret < 0)
 		return ret;
@@ -503,11 +515,6 @@ static int st1202_probe(struct i2c_client *client)
 		if (!led->is_active)
 			continue;
 
-		ret = st1202_channel_set(led->chip, led->led_num, true);
-		if (ret < 0)
-			return dev_err_probe(&client->dev, ret,
-					"Failed to activate LED channel\n");
-
 		ret = st1202_led_pattern_clear(&led->led_cdev);
 		if (ret < 0)
 			return dev_err_probe(&client->dev, ret,
-- 
2.53.0



