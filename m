Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016909;
	b=OSKRSPnPxrVxQVBWsY7Pi6WLSzpgq5i9f5OOMtkTRVBwCpVHLnbhVnFtaDUnXp1uALJt
	 9G9SC0t4R32hH4DUZpVJ1zLKlV+M89VE3A+6jp6fLQwfQc1wxwI6GljAKWVKA99DRQdfb
	 5P1g1IRKsHc7siy+lwNQx2S7VdqvnTZM66U2wt1ghlKPz+B0q45YT0YIR8IQ8eVfErDzI
	 sIqoX8z0GeyE88z0Zvxae7zp+qFBlg+Hgmq6lXP9wK4xeNjiWwPFB+KDQd/1788i8mHGf
	 blrrvBCN7PokKixwNPPgC4n1jXNcgLjQq3Hgn12vTUczuuxksq8efad5L51HaNUEw0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=omNwX+a8noAI/4BFkIKfUPjON8llfQPl5pD6F0QrvUk=;
	b=XlrQoD38k/u30fPhqRBNR6s5lib23iTaTOUbjqn3TfBAytCVXnpgW9dOgolv+J4uMVKR
	 jwK+EgZutOL9+yie+XeJEQloe64sib7Icc+LhxLe7bQwjJxNrGu4gHxLuPvWM4Wb3+6oP
	 VwsuvZbKfqdXoQ3/6H8v+7/GUgbOoWZ5OVwwOcPAK6PQDTfqNgurDBkItCEuxfktDs8Ik
	 HGida66Qo3uP1JcuMwzZqCj2khnNx8EdwpXkJgevnO+80dmzNWHYo1qKO4VBwr5d+UUUI
	 SJ74rm0Zf9jRkJGUN9Kg2nfadjWRZsO17QACvzF3Ue9/6RZcoypjz8ZyhUKX8lfSKaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFdadF6h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1396606A32A;
	Wed, 18 Nov 2026 15:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFdadF6h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334161F000C4;
	Wed, 18 Nov 2026 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016909;
	bh=omNwX+a8noAI/4BFkIKfUPjON8llfQPl5pD6F0QrvUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFdadF6hGWi8rZm2tOcM0UmMGq4IStrIm6y7FhOaBPKfoYoP5IjAXCbasMMofYUXX
	 hSLuwCeJBL15x6UBxdcHQoBAfH/loUp0VYMPMLhiGfynWn8eUxQT9Lbol6PsrwNJdB
	 WQYY7dfrvppCZ3GY8RuHruJ+znvUYk2jxtGJqzO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0655/2651] leds: st1202: Program the channel current for hardware patterns
Date: Wed, 18 Nov 2026 15:31:35 +0100
Message-ID: <20261118150311.285805148@linuxfoundation.org>
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
index ac94afb2ce87f..be45c9cf14146 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -221,6 +221,14 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 
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
@@ -287,6 +295,10 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 	if (ret != 0)
 		return ret;
 
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, max_brightness);
+	if (ret != 0)
+		return ret;
+
 	ret = __st1202_channel_set(chip, led->led_num, true);
 	if (ret != 0)
 		return ret;
@@ -455,7 +467,7 @@ static int st1202_setup(struct st1202_chip *chip)
 	/* Duration of initialization */
 	usleep_range(6500, 10000);
 
-	/* Deactivate all LEDS (channels) and activate only the ones found in Device Tree */
+	/* Deactivate all LEDs (channels); each is enabled when it is lit */
 	ret = st1202_write_reg(chip, ST1202_CHAN_ENABLE_LOW, ST1202_CHAN_DISABLE_ALL);
 	if (ret < 0)
 		return ret;
@@ -502,11 +514,6 @@ static int st1202_probe(struct i2c_client *client)
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



