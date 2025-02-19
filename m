Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BFF1DF74E;
	Wed, 19 Feb 2025 09:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956263; cv=none; b=PiWlHiPd+l/h9/tnaGN7NueK4D3tgeI6Ui1q2ZiWKGdKyM7wb73yosHKw6DpZIfHAiiNFV80H5XIyp18h2RmXufzgMm4/lzrlgoLqlhf4ZlxIg3h9/G8IPAA4YjF6z6EwNP16ROaYdoZYm47T7JeyopHBi/gsz3MXlSkc92TUe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956263; c=relaxed/simple;
	bh=Kx4iSUTLw0jj3jPJaHumWa7iM9jkx/F2+1RMDwwy6IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfTfqFmS3Vj08p0SjdHHo9F1J7S2KHRYtSLyFIxw8/rdD1ka1QXzunBvgg0uPOyU9XWyu2txuli9m0H2dDKujB6TLjjXHldAs1JEXfL3EmSK8GDRwFyML/iAZeCD332hxJmOvKyC8tfFbczfrV4yI1L1AHnhjoRo7YMHgHIx4nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oifd0mPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oifd0mPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FEEC4CEE6;
	Wed, 19 Feb 2025 09:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956263;
	bh=Kx4iSUTLw0jj3jPJaHumWa7iM9jkx/F2+1RMDwwy6IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oifd0mPPZXEXyTsAaF0zcWw1s7ciogaFT35AAi/wfK4n0mQCvZJ4Kh4ima7z81dY0
	 HOeO5TEyzl1g58bHZDrBIAaaQyFEdCJVTi7k/rOgz3pjTRkzjz/CxC39ld5GCw2qWc
	 pAhtxfdVtRenlu6XMolugj+Arh6Kpr/LO+LQdKUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Caron <valentin.caron@foss.st.com>,
	Alexandre TORGUE <alexandre.torgue@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/578] pinctrl: stm32: set default gpio line names using pin names
Date: Wed, 19 Feb 2025 09:22:05 +0100
Message-ID: <20250219082657.743111797@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Caron <valentin.caron@foss.st.com>

[ Upstream commit 32c170ff15b044579b1f8b8cdabf543406dde9da ]

Add stm32_pctrl_get_desc_pin_from_gpio function to find a stm32 pin
descriptor which is matching with a gpio.
Most of the time pin number is equal to pin index in array. So the first
part of the function is useful to speed up.

And during gpio bank register, we set default gpio names with pin names.

Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Acked-by: Alexandre TORGUE <alexandre.torgue@foss.st.com>
Link: https://lore.kernel.org/r/20230620104349.834687-1-valentin.caron@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 451bc9aea9a1 ("pinctrl: stm32: Add check for clk_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 35 +++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index e198233c10bad..ae2b146544758 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1273,6 +1273,28 @@ static const struct pinconf_ops stm32_pconf_ops = {
 	.pin_config_dbg_show	= stm32_pconf_dbg_show,
 };
 
+static struct stm32_desc_pin *stm32_pctrl_get_desc_pin_from_gpio(struct stm32_pinctrl *pctl,
+								 struct stm32_gpio_bank *bank,
+								 unsigned int offset)
+{
+	unsigned int stm32_pin_nb = bank->bank_nr * STM32_GPIO_PINS_PER_BANK + offset;
+	struct stm32_desc_pin *pin_desc;
+	int i;
+
+	/* With few exceptions (e.g. bank 'Z'), pin number matches with pin index in array */
+	pin_desc = pctl->pins + stm32_pin_nb;
+	if (pin_desc->pin.number == stm32_pin_nb)
+		return pin_desc;
+
+	/* Otherwise, loop all array to find the pin with the right number */
+	for (i = 0; i < pctl->npins; i++) {
+		pin_desc = pctl->pins + i;
+		if (pin_desc->pin.number == stm32_pin_nb)
+			return pin_desc;
+	}
+	return NULL;
+}
+
 static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode_handle *fwnode)
 {
 	struct stm32_gpio_bank *bank = &pctl->banks[pctl->nbanks];
@@ -1283,6 +1305,8 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
 	struct resource res;
 	int npins = STM32_GPIO_PINS_PER_BANK;
 	int bank_nr, err, i = 0;
+	struct stm32_desc_pin *stm32_pin;
+	char **names;
 
 	if (!IS_ERR(bank->rstc))
 		reset_control_deassert(bank->rstc);
@@ -1352,6 +1376,17 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
 		}
 	}
 
+	names = devm_kcalloc(dev, npins, sizeof(char *), GFP_KERNEL);
+	for (i = 0; i < npins; i++) {
+		stm32_pin = stm32_pctrl_get_desc_pin_from_gpio(pctl, bank, i);
+		if (stm32_pin && stm32_pin->pin.name)
+			names[i] = devm_kasprintf(dev, GFP_KERNEL, "%s", stm32_pin->pin.name);
+		else
+			names[i] = NULL;
+	}
+
+	bank->gpio_chip.names = (const char * const *)names;
+
 	err = gpiochip_add_data(&bank->gpio_chip, bank);
 	if (err) {
 		dev_err(dev, "Failed to add gpiochip(%d)!\n", bank_nr);
-- 
2.39.5



