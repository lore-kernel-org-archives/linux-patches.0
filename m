Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7BB39FE1;
	Fri, 24 Nov 2023 18:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZ5dkzeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18915C433C8;
	Fri, 24 Nov 2023 18:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849234;
	bh=8GJ27+aFnWiltRaoUV4ZInpw8SZXhssuFdg5rMunFqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZ5dkzePaXTC6RZ0Pfql6O50DFxOMPHr9B+r+zgSNZnW9CQ2q8DsMHBqajNvfuYSE
	 VaH3wbB4+wC5VTbBh1Tb9PsJ4/KUA7ysNKDOKVG39VdWdqyxCJ1FWtI1fUGe+TjHXg
	 5MO/nwcxksrbYDWY1gvkvOuOxUFblidsHcdsyVNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/530] gpiolib: of: Add quirk for mt2701-cs42448 ASoC sound
Date: Fri, 24 Nov 2023 17:44:26 +0000
Message-ID: <20231124172031.157282069@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 9e189e80dcb68528dea9e061d9704993f98cb84f ]

These gpio names are due to old DT bindings not following the
"-gpio"/"-gpios" conventions. Handle it using a quirk so the
driver can just look up the GPIOs.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20231006-descriptors-asoc-mediatek-v1-1-07fe79f337f5@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 531faabead0f4..d9525d95e818d 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -512,6 +512,10 @@ static struct gpio_desc *of_find_gpio_rename(struct device_node *np,
 #if IS_ENABLED(CONFIG_SND_SOC_CS42L56)
 		{ "reset",	"cirrus,gpio-nreset",	"cirrus,cs42l56" },
 #endif
+#if IS_ENABLED(CONFIG_SND_SOC_MT2701_CS42448)
+		{ "i2s1-in-sel-gpio1",	NULL,	"mediatek,mt2701-cs42448-machine" },
+		{ "i2s1-in-sel-gpio2",	NULL,	"mediatek,mt2701-cs42448-machine" },
+#endif
 #if IS_ENABLED(CONFIG_SND_SOC_TLV320AIC3X)
 		{ "reset",	"gpio-reset",	"ti,tlv320aic3x" },
 		{ "reset",	"gpio-reset",	"ti,tlv320aic33" },
-- 
2.42.0



