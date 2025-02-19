Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151271F3BBC;
	Wed, 19 Feb 2025 08:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954761; cv=none; b=cYbCiAJtAt5QUP09ML5gfzW9Lb0hhs9buWmo1SUe9swjSJeAAW5iu61STI6ggpB8lZVsTRYn72RSPGWET9CKMpE3360sa4LMcm/42d7Dr6v3DhVgXLfSlw1EouFo/lqzkA+IWSQDP1wkWqgB1uqdVeEHv2Q+1svyVguDx2YeEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954761; c=relaxed/simple;
	bh=bQld2ARdwHF7rKI/KIukyXNKFQXse0RhC+wPrT3YbNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/yvlvVLeKR0DmLt+IEfJkOhI/DMNQtbRg9mHSpVD6heRUioUjXcwEuD6Sk94S+1r14m9CK0d21py891JsQad/g6DFojYSaZ6dahmAAYvPx+TtodpktzJHAD5Xr3NL4e7A5/z9xdXhwaXkqoIuU5gVj/PFVDKZDLErfLs0/hmdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6yoKDJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6yoKDJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C10C4CED1;
	Wed, 19 Feb 2025 08:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954761;
	bh=bQld2ARdwHF7rKI/KIukyXNKFQXse0RhC+wPrT3YbNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6yoKDJkBawKa4N3NYcn1R6XLZEDwqSQQ8kuV/0jJWAdiZYGlIZ9c2fM4vi8GWPsO
	 QjPRNfFDYuRxXE1hgH7EpfgN+RhaC1R3TLaDU6vsnYkWTZoiU3tjA1VMkiHjHerdv0
	 KBeSeEoVlKPUCNioDeyzJRm1hlFVuQ1M7nynfheo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/230] pinctrl: cy8c95x0: Rename PWMSEL to SELPWM
Date: Wed, 19 Feb 2025 09:25:24 +0100
Message-ID: <20250219082601.984115932@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0a7404fc5399e1100b14e7e2a4af2e4fd5e3b602 ]

There are two registers in the hardware, one, "Select PWM",
is per-port configuration enabling PWM function instead of GPIO.
The other one is "PWM Select" is per-PWM selector to configure
PWM itself. Original code uses abbreviation of the latter
to describe the former. Rename it to follow the datasheet.

Fixes: e6cbbe42944d ("pinctrl: Add Cypress cy8c95x0 support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/20250203131506.3318201-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index c0f094f51da84..8e65797192abc 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -42,7 +42,7 @@
 #define CY8C95X0_PORTSEL	0x18
 /* Port settings, write PORTSEL first */
 #define CY8C95X0_INTMASK	0x19
-#define CY8C95X0_PWMSEL		0x1A
+#define CY8C95X0_SELPWM		0x1A
 #define CY8C95X0_INVERT		0x1B
 #define CY8C95X0_DIRECTION	0x1C
 /* Drive mode register change state on writing '1' */
@@ -371,8 +371,8 @@ static bool cy8c95x0_volatile_register(struct device *dev, unsigned int reg)
 	case CY8C95X0_INPUT_(0) ... CY8C95X0_INPUT_(7):
 	case CY8C95X0_INTSTATUS_(0) ... CY8C95X0_INTSTATUS_(7):
 	case CY8C95X0_INTMASK:
+	case CY8C95X0_SELPWM:
 	case CY8C95X0_INVERT:
-	case CY8C95X0_PWMSEL:
 	case CY8C95X0_DIRECTION:
 	case CY8C95X0_DRV_PU:
 	case CY8C95X0_DRV_PD:
@@ -401,7 +401,7 @@ static bool cy8c95x0_muxed_register(unsigned int reg)
 {
 	switch (reg) {
 	case CY8C95X0_INTMASK:
-	case CY8C95X0_PWMSEL:
+	case CY8C95X0_SELPWM:
 	case CY8C95X0_INVERT:
 	case CY8C95X0_DIRECTION:
 	case CY8C95X0_DRV_PU:
@@ -807,7 +807,7 @@ static int cy8c95x0_gpio_get_pincfg(struct cy8c95x0_pinctrl *chip,
 		reg = CY8C95X0_DIRECTION;
 		break;
 	case PIN_CONFIG_MODE_PWM:
-		reg = CY8C95X0_PWMSEL;
+		reg = CY8C95X0_SELPWM;
 		break;
 	case PIN_CONFIG_OUTPUT:
 		reg = CY8C95X0_OUTPUT;
@@ -889,7 +889,7 @@ static int cy8c95x0_gpio_set_pincfg(struct cy8c95x0_pinctrl *chip,
 		reg = CY8C95X0_DRV_PP_FAST;
 		break;
 	case PIN_CONFIG_MODE_PWM:
-		reg = CY8C95X0_PWMSEL;
+		reg = CY8C95X0_SELPWM;
 		break;
 	case PIN_CONFIG_OUTPUT_ENABLE:
 		ret = cy8c95x0_pinmux_direction(chip, off, !arg);
@@ -1179,7 +1179,7 @@ static void cy8c95x0_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *
 	bitmap_zero(mask, MAX_LINE);
 	__set_bit(pin, mask);
 
-	if (cy8c95x0_read_regs_mask(chip, CY8C95X0_PWMSEL, pwm, mask)) {
+	if (cy8c95x0_read_regs_mask(chip, CY8C95X0_SELPWM, pwm, mask)) {
 		seq_puts(s, "not available");
 		return;
 	}
@@ -1224,7 +1224,7 @@ static int cy8c95x0_set_mode(struct cy8c95x0_pinctrl *chip, unsigned int off, bo
 	u8 port = cypress_get_port(chip, off);
 	u8 bit = cypress_get_pin_mask(chip, off);
 
-	return cy8c95x0_regmap_write_bits(chip, CY8C95X0_PWMSEL, port, bit, mode ? bit : 0);
+	return cy8c95x0_regmap_write_bits(chip, CY8C95X0_SELPWM, port, bit, mode ? bit : 0);
 }
 
 static int cy8c95x0_pinmux_mode(struct cy8c95x0_pinctrl *chip,
-- 
2.39.5



