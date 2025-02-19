Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A25B155753;
	Wed, 19 Feb 2025 08:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953825; cv=none; b=ErpIUvg7jtL2US6eBlAl8mDu6I8VvMgdln2JaDzTPcQD5X/JuAiTTbeKZdfIw6HoSTniNVuOVoxLZdw8d6xr0wbqB1vdhtjPrxQnXhR30dow5aeGcj9mo8zb9yRZuZbhNnTmahJ35EFcRST03LgcZr4u7oHXT0m0ikYKBh3z8YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953825; c=relaxed/simple;
	bh=XvpeJUIH4V20Va4/AEGvTI0t/ZUZia3rnxnrC/nSnvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6atgdoRrNoOStp3bl4BzFmPxRZQm4fV6zsjCCQ+TRpcYlToxE5B2qmplZZ0Kdrx0K6G1qNy7NzA5NkBEi0CLiheoi8AIGuaGAXTN3sJTAb5sXX86Tkdr0EhuhGnkVwYSZ5rveODM2RC6xs5+SCy2lZvnxgMZg8f0/duzTrmQ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0050PUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0050PUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E17C4CEE7;
	Wed, 19 Feb 2025 08:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953824;
	bh=XvpeJUIH4V20Va4/AEGvTI0t/ZUZia3rnxnrC/nSnvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0050PUE62XTGdP/Q90j4zjqYvIGnojbPqKH6YLVBucGSmupngd1P2MaVS4jZlUZr
	 deD5HVsNRA/nLi42C1bVgZSj8u8O1zrdtGRrkO3GJQ9g0oSKiohJ2ZqrAIND3Xizaj
	 l5Qm6MUaet37Us+xAGWvEtHl7hNT3OEWB0BtTHEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 010/274] pinctrl: cy8c95x0: Rename PWMSEL to SELPWM
Date: Wed, 19 Feb 2025 09:24:24 +0100
Message-ID: <20250219082609.939181665@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index bfa16f70e29ce..75100a9fb8e4c 100644
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
@@ -369,8 +369,8 @@ static bool cy8c95x0_volatile_register(struct device *dev, unsigned int reg)
 	case CY8C95X0_INPUT_(0) ... CY8C95X0_INPUT_(7):
 	case CY8C95X0_INTSTATUS_(0) ... CY8C95X0_INTSTATUS_(7):
 	case CY8C95X0_INTMASK:
+	case CY8C95X0_SELPWM:
 	case CY8C95X0_INVERT:
-	case CY8C95X0_PWMSEL:
 	case CY8C95X0_DIRECTION:
 	case CY8C95X0_DRV_PU:
 	case CY8C95X0_DRV_PD:
@@ -399,7 +399,7 @@ static bool cy8c95x0_muxed_register(unsigned int reg)
 {
 	switch (reg) {
 	case CY8C95X0_INTMASK:
-	case CY8C95X0_PWMSEL:
+	case CY8C95X0_SELPWM:
 	case CY8C95X0_INVERT:
 	case CY8C95X0_DIRECTION:
 	case CY8C95X0_DRV_PU:
@@ -797,7 +797,7 @@ static int cy8c95x0_gpio_get_pincfg(struct cy8c95x0_pinctrl *chip,
 		reg = CY8C95X0_DIRECTION;
 		break;
 	case PIN_CONFIG_MODE_PWM:
-		reg = CY8C95X0_PWMSEL;
+		reg = CY8C95X0_SELPWM;
 		break;
 	case PIN_CONFIG_OUTPUT:
 		reg = CY8C95X0_OUTPUT;
@@ -876,7 +876,7 @@ static int cy8c95x0_gpio_set_pincfg(struct cy8c95x0_pinctrl *chip,
 		reg = CY8C95X0_DRV_PP_FAST;
 		break;
 	case PIN_CONFIG_MODE_PWM:
-		reg = CY8C95X0_PWMSEL;
+		reg = CY8C95X0_SELPWM;
 		break;
 	case PIN_CONFIG_OUTPUT_ENABLE:
 		return cy8c95x0_pinmux_direction(chip, off, !arg);
@@ -1161,7 +1161,7 @@ static void cy8c95x0_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *
 	bitmap_zero(mask, MAX_LINE);
 	__set_bit(pin, mask);
 
-	if (cy8c95x0_read_regs_mask(chip, CY8C95X0_PWMSEL, pwm, mask)) {
+	if (cy8c95x0_read_regs_mask(chip, CY8C95X0_SELPWM, pwm, mask)) {
 		seq_puts(s, "not available");
 		return;
 	}
@@ -1206,7 +1206,7 @@ static int cy8c95x0_set_mode(struct cy8c95x0_pinctrl *chip, unsigned int off, bo
 	u8 port = cypress_get_port(chip, off);
 	u8 bit = cypress_get_pin_mask(chip, off);
 
-	return cy8c95x0_regmap_write_bits(chip, CY8C95X0_PWMSEL, port, bit, mode ? bit : 0);
+	return cy8c95x0_regmap_write_bits(chip, CY8C95X0_SELPWM, port, bit, mode ? bit : 0);
 }
 
 static int cy8c95x0_pinmux_mode(struct cy8c95x0_pinctrl *chip,
-- 
2.39.5



