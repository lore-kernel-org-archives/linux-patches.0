Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A75C62805;
	Tue, 23 Jan 2024 00:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971462; cv=none; b=MsvHiANgpIguhBQu7JeBmmm19kcbFHfdfpWzPAm8nbHOcvjBSU9PQc4UBeT8MyqLu6HsY3EW7DmuxjChDD6eAbiP0w2WhTtGm3zk8OgKAalRrEi+E60I83iMSIut5jHL6nIPwp/BrGRCHV2HZL0jiYuVk4G1oF2yc9V5AzYjTE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971462; c=relaxed/simple;
	bh=9v8qw1T3EyLUhZaR9RXlgRSKlDaCKZn5NJ9hWbtp0ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcH1+/dfsO11anry5lWtZ36FVtf65vzUJFL49cgcO60P/7n6q9rlzNG/j5gdph5+6v8/4tkx4cEWapmTkZvXxu+7DCekyoI3vipRHNu2R1t1LcuQ1oOn8/a51AfcpB/7t8jJXL8e2AYUiWh0oT+r43jHkzsW457r2pLsQj2yzUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2aZYYHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2aZYYHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1096C433F1;
	Tue, 23 Jan 2024 00:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971462;
	bh=9v8qw1T3EyLUhZaR9RXlgRSKlDaCKZn5NJ9hWbtp0ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2aZYYHR4cbN/u7Vc1CpJA8VF6t9X1DnDjstn/S+upRns8nG9YoSh8Rh0OflgEDxK
	 yUL30QNN3+PQhAZBCbNrK+W3ycw63v/Txf2QJSh8ISM3Dszz15JPm2e5BWipntxZ1y
	 jqA/12/bef7GSFlJycNc8/XwDi8goT07uL/2N+9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/286] ASoC: cs35l33: Fix GPIO name and drop legacy include
Date: Mon, 22 Jan 2024 15:57:41 -0800
Message-ID: <20240122235738.135553019@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 50678d339d670a92658e5538ebee30447c88ccb3 ]

This driver includes the legacy GPIO APIs <linux/gpio.h> and
<linux/of_gpio.h> but does not use any symbols from any of
them.

Drop the includes.

Further the driver is requesting "reset-gpios" rather than
just "reset" from the GPIO framework. This is wrong because
the gpiolib core will add "-gpios" before processing the
request from e.g. device tree. Drop the suffix.

The last problem means that the optional RESET GPIO has
never been properly retrieved and used even if it existed,
but nobody noticed.

Fixes: 3333cb7187b9 ("ASoC: cs35l33: Initial commit of the cs35l33 CODEC driver.")
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20231201-descriptors-sound-cirrus-v2-2-ee9f9d4655eb@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l33.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs35l33.c b/sound/soc/codecs/cs35l33.c
index 8894369e329a..87b299d24bd8 100644
--- a/sound/soc/codecs/cs35l33.c
+++ b/sound/soc/codecs/cs35l33.c
@@ -22,13 +22,11 @@
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
 #include <sound/tlv.h>
-#include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <sound/cs35l33.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/machine.h>
-#include <linux/of_gpio.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
@@ -1168,7 +1166,7 @@ static int cs35l33_i2c_probe(struct i2c_client *i2c_client,
 
 	/* We could issue !RST or skip it based on AMP topology */
 	cs35l33->reset_gpio = devm_gpiod_get_optional(&i2c_client->dev,
-			"reset-gpios", GPIOD_OUT_HIGH);
+			"reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(cs35l33->reset_gpio)) {
 		dev_err(&i2c_client->dev, "%s ERROR: Can't get reset GPIO\n",
 			__func__);
-- 
2.43.0



