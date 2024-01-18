Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762E522F06;
	Thu, 18 Jan 2024 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575396; cv=none; b=BUOpEEE8hh4M5hWT099bdciPnHnKSdgR46DSNIWrcWZzD18FvQxPRbY5xUwUVg8oI6cW1gitnYinXBzHK4iJEso4PvIHLHyRlG9s2/hc6b5EOqr8ZmLr3NW0QjA8LTKzRNGx2ghIoSf9b8RYD6/kvafHBsXyyB5S+pmEByNDJTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575396; c=relaxed/simple;
	bh=2b8LSXk3RfvAQqSIMf9mwtEBV3qv1r0KRzgHPva7e9M=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=aSwXHaufKVMNtDCEwSIhpGLKz/tKDVuyn11dPMyCZILwI8IJ+PvKsB/7SROv8RibDVDGOBIJyrvf6MCXag6coa/IIJNgxWBDrIpS8P1XHLNsNmhLNtv75IhlUFTuQTYl7vopJGkWRZy3TBEwZUW0ldEUthVtfmv/+z3nh6r6LVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLRNFAWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLRNFAWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF424C433F1;
	Thu, 18 Jan 2024 10:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575396;
	bh=2b8LSXk3RfvAQqSIMf9mwtEBV3qv1r0KRzgHPva7e9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLRNFAWuDsuH6RrWsAbjPkuYprTjB7VYqeg/ZE5nFzEpbxD/Fv4SS3wxLPf38OUrE
	 9b8kZfDZyhmGC2iB8gpJbwGSam1IVfreXpXZH3UqgP/Hqp8M4DKcAEmpeL9sQ+QkHO
	 /IAwhD07P/ro8QaRiJaOvl6WAwHGahNVpc0kQ4TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/150] pinctrl: cy8c95x0: Fix regression
Date: Thu, 18 Jan 2024 11:48:59 +0100
Message-ID: <20240118104325.471458411@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 04dfca968cf7349773126340991b68a83378aca2 ]

Commit 1fa3df901f2c ("pinctrl: cy8c95x0: Remove custom ->set_config()")
removed support for PIN_CONFIG_INPUT_ENABLE and
PIN_CONFIG_OUTPUT.

Add the following options to restore functionality:
- PIN_CONFIG_INPUT_ENABLE
- PIN_CONFIG_OUTPUT_ENABLE

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20231219125120.4028862-2-patrick.rudolph@9elements.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 993b30ebc684..280d7ebd50b7 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -307,6 +307,9 @@ static const char * const cy8c95x0_groups[] = {
 	"gp77",
 };
 
+static int cy8c95x0_pinmux_direction(struct cy8c95x0_pinctrl *chip,
+				     unsigned int pin, bool input);
+
 static inline u8 cypress_get_port(struct cy8c95x0_pinctrl *chip, unsigned int pin)
 {
 	/* Account for GPORT2 which only has 4 bits */
@@ -726,6 +729,7 @@ static int cy8c95x0_gpio_set_pincfg(struct cy8c95x0_pinctrl *chip,
 	u8 port = cypress_get_port(chip, off);
 	u8 bit = cypress_get_pin_mask(chip, off);
 	unsigned long param = pinconf_to_config_param(config);
+	unsigned long arg = pinconf_to_config_argument(config);
 	unsigned int reg;
 	int ret;
 
@@ -764,6 +768,12 @@ static int cy8c95x0_gpio_set_pincfg(struct cy8c95x0_pinctrl *chip,
 	case PIN_CONFIG_MODE_PWM:
 		reg = CY8C95X0_PWMSEL;
 		break;
+	case PIN_CONFIG_OUTPUT_ENABLE:
+		ret = cy8c95x0_pinmux_direction(chip, off, !arg);
+		goto out;
+	case PIN_CONFIG_INPUT_ENABLE:
+		ret = cy8c95x0_pinmux_direction(chip, off, arg);
+		goto out;
 	default:
 		ret = -ENOTSUPP;
 		goto out;
-- 
2.43.0



