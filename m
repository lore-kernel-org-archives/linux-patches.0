Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116FB314B8F;
	Mon, 27 Oct 2025 19:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593602; cv=none; b=eML60VAxpqesohPEhKR7vSzaK8tm+sqoijDxNGtDFHm1vRyhIIFjyJ/lJvhlFZuwemEgCJwyqBmmfsjg9dq2WqGt5wvssKOKb/WgZfmQikOo1vJehy0T1UbwlSRlrkrKdAQCaY+VPoRShXIYze0Fr6NA4IKrP6zCV+TZw2HXk/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593602; c=relaxed/simple;
	bh=7LeG4WxPGqgwKiTwQ/3bjQ4RkPzMd4D/TPoptv1J+hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyFGnnQGb/gMttIv4k+rxxztK8LqfqNBdkjUeA58G8uFkbbdcL63TCP3P/OugUQoJGvE5YdnKPTfwuPb6iOhTR0geNyWrWxbK4f3ZoKJkq3Q0uz4E5fr5WzZaLVajJcNF7I1vVjcHtp483ai2DuqgZcRSuhvlvYgL23WzNmflio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJlF1Ib5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJlF1Ib5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CA3C113D0;
	Mon, 27 Oct 2025 19:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593601;
	bh=7LeG4WxPGqgwKiTwQ/3bjQ4RkPzMd4D/TPoptv1J+hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJlF1Ib5xyitaFNEGnYZwhWwOpC3XfkOq1Po0i3JD2YV/7harte4ptmDCG6bM6Ne8
	 HaWTBC2YVrZ6QWa/O/1xwVtj5H8QmnFMurmlUkTKEiJ1QMEjGvF3C3jiCB3v9tHdcn
	 0/C+u6ohD7nhA722sTuDxBNiNNjFzYchBZTpgOfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Michael Walle <mwalle@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 184/184] gpio: idio-16: Define fixed direction of the GPIO lines
Date: Mon, 27 Oct 2025 19:37:46 +0100
Message-ID: <20251027183519.881563849@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Breathitt Gray <wbg@kernel.org>

[ Upstream commit 2ba5772e530f73eb847fb96ce6c4017894869552 ]

The direction of the IDIO-16 GPIO lines is fixed with the first 16 lines
as output and the remaining 16 lines as input. Set the gpio_config
fixed_direction_output member to represent the fixed direction of the
GPIO lines.

Fixes: db02247827ef ("gpio: idio-16: Migrate to the regmap API")
Reported-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Closes: https://lore.kernel.org/r/9b0375fd-235f-4ee1-a7fa-daca296ef6bf@nutanix.com
Suggested-by: Michael Walle <mwalle@kernel.org>
Cc: stable@vger.kernel.org # ae495810cffe: gpio: regmap: add the .fixed_direction_output configuration parameter
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20251020-fix-gpio-idio-16-regmap-v2-3-ebeb50e93c33@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-idio-16.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpio/gpio-idio-16.c
+++ b/drivers/gpio/gpio-idio-16.c
@@ -6,6 +6,7 @@
 
 #define DEFAULT_SYMBOL_NAMESPACE "GPIO_IDIO_16"
 
+#include <linux/bitmap.h>
 #include <linux/bits.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -107,6 +108,7 @@ int devm_idio_16_regmap_register(struct
 	struct idio_16_data *data;
 	struct regmap_irq_chip *chip;
 	struct regmap_irq_chip_data *chip_data;
+	DECLARE_BITMAP(fixed_direction_output, IDIO_16_NGPIO);
 
 	if (!config->parent)
 		return -EINVAL;
@@ -164,6 +166,9 @@ int devm_idio_16_regmap_register(struct
 	gpio_config.irq_domain = regmap_irq_get_domain(chip_data);
 	gpio_config.reg_mask_xlate = idio_16_reg_mask_xlate;
 
+	bitmap_from_u64(fixed_direction_output, GENMASK_U64(15, 0));
+	gpio_config.fixed_direction_output = fixed_direction_output;
+
 	return PTR_ERR_OR_ZERO(devm_gpio_regmap_register(dev, &gpio_config));
 }
 EXPORT_SYMBOL_GPL(devm_idio_16_regmap_register);


