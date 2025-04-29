Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FAF215F7C;
	Tue, 29 Apr 2025 17:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948190; cv=none; b=TgU+8FcUkCo6NaduivEI4kwchAcNeGf6pjX+utp4ydPEW8MzeW8FxdEITa4pePuADOFNcBRrVdXLjHaXMn5zgjEPTHfKkbd/sFKgc5X+T6+mMmc/8rTIXGusaZIOLlsuHcnR0oECnAc0vfnMSzRog3KDiycjSPugwBycYF04JWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948190; c=relaxed/simple;
	bh=nP6hhQ2AwJNz4sZVtcEOte9LFRQGbR/4mafVumfBPEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIUguIq2CdsHX4cee+GrknuATJFrnOBB3PoLdSxUQkN9kX8qfAYppmF5ldafblI7Qb1x2bBQ1xA0jxmaMwj7HJqP3gU/Su9TbxAvFkC27RMkJw/pSq47Xiv6hFc08m7UdXDSRQg36Lr7TitxlyCYB8dqniRWq2vTtHvIZW0TSG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBdwQRMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBdwQRMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B0CC4CEE3;
	Tue, 29 Apr 2025 17:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948189;
	bh=nP6hhQ2AwJNz4sZVtcEOte9LFRQGbR/4mafVumfBPEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBdwQRMkptbxb5mV2QGpu5CwFwtIYC5GXVVlGtuDSPIxWF4hU4o+dSiQithsNZkC5
	 iWHzpnzgbHaTF89Hi8iKX0irEkTnVbMSqQm97vZqEO9lK7J7U9BDb1a7PPUcPaLfLE
	 P9srPFbEGQ6y69UtXnAunmMr6r7pycdFc1XhHbic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/280] gpiolib: of: Move Atmel HSMCI quirk up out of the regulator comment
Date: Tue, 29 Apr 2025 18:42:36 +0200
Message-ID: <20250429161123.922246782@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
index e543129d36050..626daedb01698 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -259,6 +259,9 @@ static void of_gpio_set_polarity_by_property(const struct device_node *np,
 		{ "fsl,imx8qm-fec",  "phy-reset-gpios", "phy-reset-active-high" },
 		{ "fsl,s32v234-fec", "phy-reset-gpios", "phy-reset-active-high" },
 #endif
+#if IS_ENABLED(CONFIG_MMC_ATMELMCI)
+		{ "atmel,hsmci",       "cd-gpios",     "cd-inverted" },
+#endif
 #if IS_ENABLED(CONFIG_PCI_IMX6)
 		{ "fsl,imx6q-pcie",  "reset-gpio", "reset-gpio-active-high" },
 		{ "fsl,imx6sx-pcie", "reset-gpio", "reset-gpio-active-high" },
@@ -284,9 +287,6 @@ static void of_gpio_set_polarity_by_property(const struct device_node *np,
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



