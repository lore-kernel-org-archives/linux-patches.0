Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016796;
	b=3vwh88ZtKwBF49pbheYfwIhK5+xlHvB420V8+rVVoS8uAFldNlCX2t+uumTox/CIFlYK
	 ua0eQtrBt2F/hDFKBiD//e2/9ADIbBbAnoeLChGWJ0DZQny92k/wxrz7DeoKltHm92aih
	 3IarINA83sTNLWLgoer9EPsvaRobyI60+d411AVygN1eo2DpJwOYUzROS/kn/sgtKeEgg
	 8w6RG1Nh7WFHMfb2K7kr0RzyK6cMLZkICFhuzHffMdzLZex8d4LLV+nKBGZnJGXAzYWa0
	 PTeAcTJ/ajiu6hucebj4Y+cG6VANLI7KWGkGdHzaE9NxbsQNmzeCRR4KUsTXJaCzGIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3WU0+vAxYCBwBf2C/Zvgxw/lqjPAUSNBvljojSaxuXo=;
	b=QGRhPW+V3fR3aRxSoMDlHROlMoMBRiqSNl3SJBJXL/7xmEoBD68pAjHoRdLdyV6ssoej
	 BGAkl5oBEIZq0qsem4RHgR5Mb/St54CTZnLthaKb8w+f+67mcTx5ImaL4cauS4Fbf8q0D
	 //o76Pm3U34aSuA8TkOYGhRGgqkKvJrErt3pYacZR8zsZvxA1QAVaPtNVJnAVujmzHNDb
	 kNBRBzgqWI196spoX5HVm62cXLLTKGYbTXOca+nPUlqjvfsllLHz2xUxxBHiB3wyksgwh
	 y6LoNlDy5jaiSCUEzroPWBYEz6OJYX1YK+3Co7tDMuI+ysiJqtXhci1FektcSIXRXhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RRr9asva;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF86606A31C;
	Wed, 18 Nov 2026 15:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RRr9asva
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D0D1F000C4;
	Wed, 18 Nov 2026 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016795;
	bh=3WU0+vAxYCBwBf2C/Zvgxw/lqjPAUSNBvljojSaxuXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRr9asvavV9NSfYWA5lkd1gxQfNFpS/LrI+Z0ghZCvdlZhmrggkD1KfNipvvGdLYL
	 FKRJPnLLDJ5fzKZMAqy9WdjOstwgjUGGG8UUMPO+JtcHiX/NRArSKe5mkoM2I/2U9T
	 K1WkfdyY0cpy1MsuLYWm60X1Ev9B/XzwhWQzCxLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0657/2651] leds: st1202: Do not set brightness from atomic context
Date: Wed, 18 Nov 2026 15:31:37 +0100
Message-ID: <20261118150311.463003098@linuxfoundation.org>
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

[ Upstream commit 1ec35fa181981b4b9581b3dae967bac7ed82c89c ]

st1202_brightness_set() takes the chip mutex and performs I2C transfers,
both of which can sleep, but it is installed as the brightness_set
callback. led_set_brightness_nopm() calls that op directly on the
assumption that it never sleeps, including from softirq context, so the
driver can sleep in atomic context.

The driver also installs brightness_set_blocking, but the core only
falls back to it when brightness_set is absent, so st1202_led_set() was
never reached. It merely turned the channel on or off and ignored the
requested brightness, so dropping brightness_set on its own would have
lost brightness control entirely.

Move the register programming into st1202_led_set() so the blocking
callback honours the brightness value, and drop brightness_set. The core
now defers the update to a work queue, where sleeping is allowed. Errors
from the register writes are propagated rather than discarded.
st1202_led_set() was the last user of the locking st1202_channel_set()
wrapper, which is removed.

Programming every PWM slot to full scale is kept: it is what makes the
brightness visible while the global sequencer is running, without having
to stop the sequencer and disturb the other channels.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB8497CF8FB57A272EB671F0C6C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 45 +++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index f30cbfdb4f367..6051f985d95d9 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -173,27 +173,6 @@ static int __st1202_channel_set(struct st1202_chip *chip, int led_num, bool acti
 	return 0;
 }
 
-static int st1202_channel_set(struct st1202_chip *chip, int led_num, bool active)
-{
-	guard(mutex)(&chip->lock);
-
-	return __st1202_channel_set(chip, led_num, active);
-}
-
-static void st1202_brightness_set(struct led_classdev *led_cdev,
-				enum led_brightness value)
-{
-	struct st1202_led *led = cdev_to_st1202_led(led_cdev);
-	struct st1202_chip *chip = led->chip;
-
-	guard(mutex)(&chip->lock);
-
-	for (int pattern = 0; pattern < ST1202_MAX_PATTERNS; pattern++)
-		st1202_pwm_pattern_write(chip, led->led_num, pattern, ST1202_PATTERN_PWM_FULL);
-	st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, value);
-	__st1202_channel_set(chip, led->led_num, !!value);
-}
-
 static enum led_brightness st1202_brightness_get(struct led_classdev *led_cdev)
 {
 	struct st1202_led *led = cdev_to_st1202_led(led_cdev);
@@ -210,8 +189,29 @@ static enum led_brightness st1202_brightness_get(struct led_classdev *led_cdev)
 static int st1202_led_set(struct led_classdev *ldev, enum led_brightness value)
 {
 	struct st1202_led *led = cdev_to_st1202_led(ldev);
+	struct st1202_chip *chip = led->chip;
+	int ret;
+
+	guard(mutex)(&chip->lock);
+
+	/*
+	 * The output of a channel is ILED x Pattern_PWM / 4095. Setting every
+	 * PWM slot to full scale makes it equal ILED whatever the state of the
+	 * sequencer, so the brightness takes effect without stopping the
+	 * sequencer, which is global and would disturb the other channels.
+	 */
+	for (int pattern = 0; pattern < ST1202_MAX_PATTERNS; pattern++) {
+		ret = st1202_pwm_pattern_write(chip, led->led_num, pattern,
+						ST1202_PATTERN_PWM_FULL);
+		if (ret)
+			return ret;
+	}
+
+	ret = st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, value);
+	if (ret)
+		return ret;
 
-	return st1202_channel_set(led->chip, led->led_num, !!value);
+	return __st1202_channel_set(chip, led->led_num, !!value);
 }
 
 static int st1202_led_pattern_clear(struct led_classdev *ldev)
@@ -436,7 +436,6 @@ static int st1202_dt_init(struct st1202_chip *chip)
 		led->led_cdev.pattern_clear = st1202_led_pattern_clear;
 		led->led_cdev.default_trigger = "pattern";
 		led->led_cdev.blink_set = st1202_blink_set;
-		led->led_cdev.brightness_set = st1202_brightness_set;
 		led->led_cdev.brightness_get = st1202_brightness_get;
 	}
 
-- 
2.53.0



