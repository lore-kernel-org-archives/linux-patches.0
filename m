Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AACD330B00;
	Fri, 17 Oct 2025 15:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715988; cv=none; b=ik+apOvnhFY9UMnTv+jka16WjfC5pVgXfIQ6tatsdbjdFXukvDjqD93c5jVxmRcMss48pQmbWSEBX1vxymuTKdy2Kh9VuxPR0r7ZAplEXIiV5QsHRntpg4H4McyZzxq2v/WVgXMB1rLETLdJlmZYBKXsFTE6aAvlAxIF9rFIAU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715988; c=relaxed/simple;
	bh=P9xbXyUdeVPr/11eQyQsJMTe5LvCJO33Qq4MdWEV2Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlHSr5qQX9pmhhmNvS7jj7TDHbbETGENUgDZauBNRYqChQTipi4c6FZ4CPPzRUsconzFEICgUPwbMvoZ3WkRriVTVRPXYNhLzEJhIk3N7GMJjODbXnpgbjT3M+H56prx9+Z5wfhSsER0KUuI/SmYmO7lTlaHJyPA/nK+6hfS2Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNmbzD+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNmbzD+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DC3C116B1;
	Fri, 17 Oct 2025 15:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715988;
	bh=P9xbXyUdeVPr/11eQyQsJMTe5LvCJO33Qq4MdWEV2Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNmbzD+5c7cbz7LLxQivvJRl8XG/3k/Xq8flU3l+6mYJlVxiwRyJFWMUCQFb6LVQ0
	 0tW3pWpc+9Q/kKK0rSO+/PO2r2gLmAIMtQKF9HUAY7paUnyK/Ab4PeUXJbUT+tvTyK
	 AW1JuByGR8S0vcJYMWbHOejRUVdvRViesrMv/e2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/276] pinctrl: meson-gxl: add missing i2c_d pinmux
Date: Fri, 17 Oct 2025 16:52:06 +0200
Message-ID: <20251017145143.614438058@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Da Xue <da@libre.computer>

[ Upstream commit d8c2a9edd181f0cc4a66eec954b3d8f6a1d954a7 ]

Amlogic GXL has 4 I2C attached to gpio-periphs. I2C_D is on GPIOX_10/11.

Add the relevant func 3 pinmux per the datasheet for S805X/S905X/S905D.

Fixes: 0f15f500ff2c ("pinctrl: meson: Add GXL pinctrl definitions")
Signed-off-by: Da Xue <da@libre.computer>
Link: https://lore.kernel.org/20250821233335.1707559-1-da@libre.computer
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson-gxl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-gxl.c b/drivers/pinctrl/meson/pinctrl-meson-gxl.c
index 51408996255bd..e2601e45935e6 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-gxl.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-gxl.c
@@ -187,6 +187,9 @@ static const unsigned int i2c_sda_c_pins[]	= { GPIODV_28 };
 static const unsigned int i2c_sck_c_dv19_pins[] = { GPIODV_19 };
 static const unsigned int i2c_sda_c_dv18_pins[] = { GPIODV_18 };
 
+static const unsigned int i2c_sck_d_pins[]	= { GPIOX_11 };
+static const unsigned int i2c_sda_d_pins[]	= { GPIOX_10 };
+
 static const unsigned int eth_mdio_pins[]	= { GPIOZ_0 };
 static const unsigned int eth_mdc_pins[]	= { GPIOZ_1 };
 static const unsigned int eth_clk_rx_clk_pins[] = { GPIOZ_2 };
@@ -411,6 +414,8 @@ static struct meson_pmx_group meson_gxl_periphs_groups[] = {
 	GPIO_GROUP(GPIO_TEST_N),
 
 	/* Bank X */
+	GROUP(i2c_sda_d,	5,	5),
+	GROUP(i2c_sck_d,	5,	4),
 	GROUP(sdio_d0,		5,	31),
 	GROUP(sdio_d1,		5,	30),
 	GROUP(sdio_d2,		5,	29),
@@ -651,6 +656,10 @@ static const char * const i2c_c_groups[] = {
 	"i2c_sck_c", "i2c_sda_c", "i2c_sda_c_dv18", "i2c_sck_c_dv19",
 };
 
+static const char * const i2c_d_groups[] = {
+	"i2c_sck_d", "i2c_sda_d",
+};
+
 static const char * const eth_groups[] = {
 	"eth_mdio", "eth_mdc", "eth_clk_rx_clk", "eth_rx_dv",
 	"eth_rxd0", "eth_rxd1", "eth_rxd2", "eth_rxd3",
@@ -777,6 +786,7 @@ static struct meson_pmx_func meson_gxl_periphs_functions[] = {
 	FUNCTION(i2c_a),
 	FUNCTION(i2c_b),
 	FUNCTION(i2c_c),
+	FUNCTION(i2c_d),
 	FUNCTION(eth),
 	FUNCTION(pwm_a),
 	FUNCTION(pwm_b),
-- 
2.51.0



