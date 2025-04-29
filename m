Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C65240611;
	Tue, 29 Apr 2025 18:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950756; cv=none; b=f5mezaIieCHOYjPilWQ3MuSNVYbRUUX70GySCmSbTLoI+FlifAuP6YYvtnQlPa4yp5cH+V0I+b2dxCwW57wRpNK71kKdqRMQzHIZ7lT0EP2R7xI9HfHkStfLIURrqUmH2rHFCubElOQ27zAi7Gmz3EMlk6kAZkgh6VeQU5E2Dpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950756; c=relaxed/simple;
	bh=AvmAVe+PPoVMFRSvbv/d92BmKVF9eF9TNQrPNZZawDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujaD77+KyMXD5TzA90WX/8bNEmCCg6lPwByH6CeMA0l9POgtEb/9UBwZOftSJqQi0W2ICwcrwlgUGVR6Ka6DIBkmUu0d2vSD0SR4g2xJv+KrivDH0YVPR2KH7wcBcZ5de+/AyyRlTerK7GvWQqvjICHwjyuH9GPhUK5ZhpdsgSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/OlJrTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/OlJrTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F00C4CEEE;
	Tue, 29 Apr 2025 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950756;
	bh=AvmAVe+PPoVMFRSvbv/d92BmKVF9eF9TNQrPNZZawDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/OlJrTb3k2DtdRP7zwI/i63E7L8X5zMlhvZHytQH3lxTKl/rjYSA/LpLl+5u73Sr
	 qnI3MiKIa84HCGnykE6YsoNvxiwQx5im45a2+3A3JwF5MaKYJpQX80JQfN+Bb2J18s
	 3epenvLsdwIW8gfabKFuI9J0nbKpelG/WYbaIk7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/204] gpiolib: of: Move Atmel HSMCI quirk up out of the regulator comment
Date: Tue, 29 Apr 2025 18:44:13 +0200
Message-ID: <20250429161106.156392660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b8c7a1ac884cc267d1031f8de07f1a689a69fbab ]

The regulator comment in of_gpio_set_polarity_by_property()
made on top of a couple of the cases, while Atmel HSMCI quirk
is not related to that. Make it clear by moving Atmel HSMCI
quirk up out of the scope of the regulator comment.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250402122058.1517393-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index cec9e8f29bbdf..a0a2a0f75bba4 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -247,6 +247,9 @@ static void of_gpio_set_polarity_by_property(const struct device_node *np,
 		{ "fsl,imx8qm-fec",  "phy-reset-gpios", "phy-reset-active-high" },
 		{ "fsl,s32v234-fec", "phy-reset-gpios", "phy-reset-active-high" },
 #endif
+#if IS_ENABLED(CONFIG_MMC_ATMELMCI)
+		{ "atmel,hsmci",       "cd-gpios",     "cd-inverted" },
+#endif
 #if IS_ENABLED(CONFIG_PCI_IMX6)
 		{ "fsl,imx6q-pcie",  "reset-gpio", "reset-gpio-active-high" },
 		{ "fsl,imx6sx-pcie", "reset-gpio", "reset-gpio-active-high" },
@@ -272,9 +275,6 @@ static void of_gpio_set_polarity_by_property(const struct device_node *np,
 #if IS_ENABLED(CONFIG_REGULATOR_GPIO)
 		{ "regulator-gpio",    "enable-gpio",  "enable-active-high" },
 		{ "regulator-gpio",    "enable-gpios", "enable-active-high" },
-#endif
-#if IS_ENABLED(CONFIG_MMC_ATMELMCI)
-		{ "atmel,hsmci",       "cd-gpios",     "cd-inverted" },
 #endif
 	};
 	unsigned int i;
-- 
2.39.5



