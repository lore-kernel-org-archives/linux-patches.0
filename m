Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAAE2580D0;
	Thu, 17 Apr 2025 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912519; cv=none; b=Sb2JVOm8DIm+5FDi5mhf8RzOgvPScyuOMPiMOJ+ob9wwBULPgkQ7GZyAecR7/zCl93enstjgBMWt8JjZA/t7uV35nGM/u+N9mYN9fWkuxQ4HxuzYBaommhUo17juEcp78pbVgLJIT+nNYYr1yVgoxLvYxvrL7QvhxB/bQetjRZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912519; c=relaxed/simple;
	bh=SvX30tiwWZOIxJ9iXCjitya+OC0X1L0j1ZU2mW2MZoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+cUprZrdRpird6jPiK6C5NX+c6ysOHSL+DzMORUKarGbQXKxsif9JAt1dAWnCahmTxY2L738V1J0rpTfAdegEUm82Ir4u9d1JWzOW9+tEW7hqXWr+B4RK7HXlKVYrqSj7OeEWCLyJKnI2TBTimOB968QlGQWT0SoWlOBdAvKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7KD5O8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7KD5O8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092DAC4CEE4;
	Thu, 17 Apr 2025 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912518;
	bh=SvX30tiwWZOIxJ9iXCjitya+OC0X1L0j1ZU2mW2MZoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7KD5O8vbdYlMWyRh7RBnCZMtMv//418ultIqVO5XsX7Sw5oFARnLGO41XOI1QTfT
	 xYA2tG2XszKhJmWUHyvmSzfWGLMF3R+q8wCYWqxY20JTzD12fJ3LhaclqeSasvyNSm
	 MP54iaxtbx8brV/jVSQNG5kxvwpWHV4+QKMyrydw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 006/449] gpiolib: of: Fix the choice for Ingenic NAND quirk
Date: Thu, 17 Apr 2025 19:44:54 +0200
Message-ID: <20250417175118.240064472@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2b9c536430126c233552cdcd6ec9d5077454ece4 ]

The Ingenic NAND quirk has been added under CONFIG_LCD_HX8357 ifdeffery
which sounds quite wrong. Fix the choice for Ingenic NAND quirk
by wrapping it into own ifdeffery related to the respective driver.

Fixes: 3a7fd473bd5d ("mtd: rawnand: ingenic: move the GPIO quirk to gpiolib-of.c")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250402122058.1517393-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 2e537ee979f3e..176e9142fd8f8 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -193,6 +193,8 @@ static void of_gpio_try_fixup_polarity(const struct device_node *np,
 		 */
 		{ "himax,hx8357",	"gpios-reset",	false },
 		{ "himax,hx8369",	"gpios-reset",	false },
+#endif
+#if IS_ENABLED(CONFIG_MTD_NAND_JZ4780)
 		/*
 		 * The rb-gpios semantics was undocumented and qi,lb60 (along with
 		 * the ingenic driver) got it wrong. The active state encodes the
-- 
2.39.5



