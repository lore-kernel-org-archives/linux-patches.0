Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774362;
	b=ckhyzAf+C70dqrj4FzZ4XqmIzMYYvpY9wRcgXGv03XtBCOC35AG0uMafJxJCzTn/lQpn
	 wlq934TABcG5vN0hro6pdyYG691mA1PkcOWy7K8MvmV3o8bRuqtJzAHOhzQCRDAKc6vzy
	 V0mKmBAYbVM2Ulm2sABrsT0TXYckg3YGbJibo7eZpzZQ3F3HeqUohciFn1TBzDKbz0ijP
	 K24Nq39Af3vq9dQGkwepCvQUynXvLXdHb5UxGMhPpJVApg8YPLaUkGVlqa5qBaVgEcNi8
	 UkmldbzmhU/roI8HUweFpZMw5SZPEacZ2/VdUt0wEwOWY+q8XIh9guchMKO5rMatzuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IdmcBgcnPFcEUljtVVqFqsNBoq3bwEWGE3nrHnsHOSE=;
	b=PKM+NV3C3FMhS+wpm/LXqGmstnJpnuyEz4iLXNUmWIqBmGp84PFWjlrIC/WKRW+CGYlT
	 hdXgQeamYJXDnPdMPpAYf54DWGXIypQNBTfJKc3+O/PDolK4Ibg6JyrDE4bv+IRKhyCe4
	 tiwswkyLLWlQcbhqXwp+qIR/1j+9B4avjeuZEyrmiODQxf7MhTcWt70juwVjgqE1AQulZ
	 bIuuDMOqP/fAR0+7h9JbYAhjrAylhB2OpjtLwtjkZgMH77eiA3SNi8u07QPwQVQM90PE7
	 okFoLE2UCQ1193rCAFRaU5Tp78GHzydL0EZA3yDOtHXfa5bY1+2XWcg/38+9YHLPhzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GE1o7YBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97963606A31D;
	Fri, 23 Oct 2026 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GE1o7YBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF621F01828;
	Fri, 23 Oct 2026 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774362;
	bh=IdmcBgcnPFcEUljtVVqFqsNBoq3bwEWGE3nrHnsHOSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GE1o7YBasPV4SdvbK87HgK4Te1i/tty4oG+O0qU86bp963CRfp8Od7mjueOPMM/5v
	 +Qz1H4P1SpdkgYRgFu8dXJ9PAxU2Ykt3PhBajy7PKqRkwB49b2lGMLXX/Gx6Q5wVwt
	 IYJq+PgvXWAYaxVYFXGt9Dg/v/KGchjb+EHWRsKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 016/242] pinctrl: qcom: spmi-gpio: make direction changes exclusive
Date: Fri, 23 Oct 2026 18:37:38 +0200
Message-ID: <20261023163714.174230814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

[ Upstream commit 19fc4240358be2a25ce8e0a49a2819588ed61c5d ]

Neither direction callback clears the opposite buffer: .direction_output()
only packs PIN_CONFIG_LEVEL and .direction_input() only packs
PIN_CONFIG_INPUT_ENABLE.  As pmic_gpio_populate() seeds input_enabled and
output_enabled from MODE_CTL, a pad left in DIGITAL_INPUT[_OUTPUT] by the
bootloader ends up in DIGITAL_INPUT_OUTPUT whichever direction is
requested.  That leaves an input still driving the line, and makes
pmic_gpio_get_direction() report an output as an input, which breaks
consumers that read the direction back:

  reg-fixed-voltage regulator-wcn-core-vm-1p35: setup of GPIO (default) failed: -1
  reg-fixed-voltage regulator-wcn-core-vm-1p35: error -EPERM: can't get GPIO

Pack the opposite buffer's PIN_CONFIG_*_ENABLE along with the requested
direction, so MODE_CTL becomes DIGITAL_INPUT or DIGITAL_OUTPUT, never
both.  pmic_gpio_config_set() writes the registers once after walking all
configs, so this stays a single write.

An open-drain or open-source output is the exception: it only drives one
rail, so pmic_gpio_get() needs the input buffer to sample the line rather
than return the value last written.  Program the input buffer from
pad->buffer_type, which gpiolib has already updated via
PIN_CONFIG_DRIVE_OPEN_DRAIN, and key pmic_gpio_get_direction() off
output_enabled so such pads still read back as outputs.

Genuinely bidirectional pads can still be described that way through
pinconf; the gpiolib callbacks now mean what gpiolib says they mean.

Fixes: 263447532463 ("pinctrl: qcom: spmi-gpio: implement .get_direction()")
Assisted-by: LLM
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260927010913.1212600-1-shengchao.guo@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 37 +++++++++++++++++++-----
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index cdd61dae74cf9..9fc6230ffc36c 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -734,29 +734,50 @@ static int pmic_gpio_get_direction(struct gpio_chip *chip, unsigned pin)
 	    (!pad->input_enabled && !pad->output_enabled))
 		return -EINVAL;
 
-	/* Make sure the state is aligned on what pmic_gpio_get() returns */
-	return pad->input_enabled ? GPIO_LINE_DIRECTION_IN : GPIO_LINE_DIRECTION_OUT;
+	/*
+	 * An open-drain or open-source pad keeps its input buffer enabled while
+	 * driving, so the output buffer is what tells the direction.
+	 */
+	return pad->output_enabled ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
 }
 
 static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned pin)
 {
 	struct pmic_gpio_state *state = gpiochip_get_data(chip);
-	unsigned long config;
+	unsigned long configs[2];
 
-	config = pinconf_to_config_packed(PIN_CONFIG_INPUT_ENABLE, 1);
+	configs[0] = pinconf_to_config_packed(PIN_CONFIG_OUTPUT_ENABLE, 0);
+	configs[1] = pinconf_to_config_packed(PIN_CONFIG_INPUT_ENABLE, 1);
 
-	return pmic_gpio_config_set(state->ctrl, pin, &config, 1);
+	return pmic_gpio_config_set(state->ctrl, pin, configs,
+				    ARRAY_SIZE(configs));
 }
 
 static int pmic_gpio_direction_output(struct gpio_chip *chip,
 				      unsigned pin, int val)
 {
 	struct pmic_gpio_state *state = gpiochip_get_data(chip);
-	unsigned long config;
+	struct pmic_gpio_pad *pad = state->ctrl->desc->pins[pin].drv_data;
+	unsigned long configs[2];
 
-	config = pinconf_to_config_packed(PIN_CONFIG_LEVEL, val);
+	/*
+	 * An open-drain or open-source pad only ever drives one rail, so the
+	 * line can still be sampled while the pad is an output.  Keep the input
+	 * buffer enabled for those, so that pmic_gpio_get() reports what is on
+	 * the wire rather than the value last written, and disable it for a
+	 * CMOS pad, so that the pad ends up in DIGITAL_OUTPUT rather than
+	 * DIGITAL_INPUT_OUTPUT.  Program it either way, as the buffer may have
+	 * been left in the opposite state by the bootloader or by an earlier
+	 * direction change with a different buffer type.  gpiolib applies
+	 * PIN_CONFIG_DRIVE_OPEN_DRAIN before calling this, so buffer_type is
+	 * already up to date here.
+	 */
+	configs[0] = pinconf_to_config_packed(PIN_CONFIG_INPUT_ENABLE,
+					     pad->buffer_type != PMIC_GPIO_OUT_BUF_CMOS);
+	configs[1] = pinconf_to_config_packed(PIN_CONFIG_LEVEL, val);
 
-	return pmic_gpio_config_set(state->ctrl, pin, &config, 1);
+	return pmic_gpio_config_set(state->ctrl, pin, configs,
+				    ARRAY_SIZE(configs));
 }
 
 static int pmic_gpio_get(struct gpio_chip *chip, unsigned pin)
-- 
2.53.0



