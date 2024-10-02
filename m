Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BB41D0E3A;
	Wed,  2 Oct 2024 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877649; cv=none; b=aKcE1N/Qh92Tq+GLO2rKHnAkshBF3au6ADslxVlawdjcS+iuizyU34OxNVfGGXMYIPM+Thso8VcZnsC+Pc7JfT4sl3DEIULmZBtbOLxe43JQbdVexcSHoCGvaI5ghu++c2meHpicDSZwd24k6JpQ7Yx3Q+I+U9mL/Qx2J5mP5Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877649; c=relaxed/simple;
	bh=0VhPhgj8QyGXdvAVsODNHd4atVdbuuuwfBgFV0avioE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JG/7b38KQzRCmNAQaOl4K6MbnWBRRiEX+2dfEgY4TqWvcvL9fqHdo4TI0hJ5E2DRM4356xcmU3PCG2c1cxwFWfhU4/fe5bAdpxZ15zC+VfjAsxc5m85YznrFGOmXGkRLnQgZ7yiodzJrjfHiWCl/OJA6nTdni3yYj90WY8F4Y74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTCeDXT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTCeDXT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE40C4CEC2;
	Wed,  2 Oct 2024 14:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877648;
	bh=0VhPhgj8QyGXdvAVsODNHd4atVdbuuuwfBgFV0avioE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTCeDXT1dpisAxs1uzKyNirEQhNR2H9ap05JmD2aD6GVMg3VppcDF7/mehMQzLKq1
	 vNLcy3Vcgc1NeZYfXOWeC4UH+6I0aDqvfKuIWcPMRtr9Dj+l0GgpVtXaE0uAN4qf1l
	 gwSeMfc08nlgR10TaqwVAdf5GZUO1J2KH6KQGWfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 147/634] ASoC: tas2781-i2c: Get the right GPIO line
Date: Wed,  2 Oct 2024 14:54:07 +0200
Message-ID: <20241002125816.912668777@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 1c4b509edad15192bfb64c81d3c305bbae8070db ]

The code is obtaining a GPIO reset using the reset GPIO
name "reset-gpios", but the gpiolib is already adding the
suffix "-gpios" to anything passed to this function and
will be looking for "reset-gpios-gpios" which is most
certainly not what the author desired.

Fix it up.

Fixes: ef3bcde75d06 ("ASoC: tas2781: Add tas2781 driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20240807-asoc-tas-gpios-v2-2-bd0f2705d58b@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index d6bbf94d55713..edd1ad3062c88 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -655,7 +655,7 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 		tas_priv->tasdevice[i].dev_addr = dev_addrs[i];
 
 	tas_priv->reset = devm_gpiod_get_optional(&client->dev,
-			"reset-gpios", GPIOD_OUT_HIGH);
+			"reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(tas_priv->reset))
 		dev_err(tas_priv->dev, "%s Can't get reset GPIO\n",
 			__func__);
-- 
2.43.0



