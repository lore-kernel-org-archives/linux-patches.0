Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF1062805;
	Tue, 23 Jan 2024 00:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971467; cv=none; b=S5W58+rFG5L95aN6Mg9lxz8NsxoBcHK7b0eBtggxM2gs/scNeCAX57i3qtZvHiJ3EDsAjORKQhcx5rKD60rqOU0HXNKE6Ib2yEUSqAOhULr4BXv1XiFl82Uur8K2aSWN5HY7gA8enLHL/xlPOAN/2e0NeKIr966jEKTuqwlVj1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971467; c=relaxed/simple;
	bh=rnQEcyQfgKVV/yy1OOJVjZ0TopI/a5FVzGTgxRe9YUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxfiUliw31hnltgv9oY7Z9crZhzwflNYmrDki/K6vTwNcjiSNg9ZjAIJFg/2o0ft8XUZH7cNOtYBxb4PArM9HDWS/8nIadhPTQat0jaFb7XZxhlXd9NbP0Noi8wzCYYs9jHYYN/Tn72qp+eh9CsnZmFozk/WgsiZZ6w/4ukt/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyQcOsAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyQcOsAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FBEC433F1;
	Tue, 23 Jan 2024 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971467;
	bh=rnQEcyQfgKVV/yy1OOJVjZ0TopI/a5FVzGTgxRe9YUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyQcOsAhhFFf2Qr2wgun5z0D1hr7f1U3nbgNI57m9o2VNfcQqp2vpCAIb4T9Z3dxi
	 XYSnnh8nCGu0VNnPmFiiCgB5G//hla92svax5O66lOnHtvPDcjQXOu/v7OyM2E9qJN
	 D4QVI6HyOiJ6SxSrJ6kPdw3ubzX6tzljcVk2uKwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/286] ASoC: cs35l34: Fix GPIO name and drop legacy include
Date: Mon, 22 Jan 2024 15:57:42 -0800
Message-ID: <20240122235738.180657195@linuxfoundation.org>
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

[ Upstream commit a6122b0b4211d132934ef99e7b737910e6d54d2f ]

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

Fixes: c1124c09e103 ("ASoC: cs35l34: Initial commit of the cs35l34 CODEC driver.")
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20231201-descriptors-sound-cirrus-v2-3-ee9f9d4655eb@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l34.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs35l34.c b/sound/soc/codecs/cs35l34.c
index b792c006e530..d9f975b52b21 100644
--- a/sound/soc/codecs/cs35l34.c
+++ b/sound/soc/codecs/cs35l34.c
@@ -20,14 +20,12 @@
 #include <linux/regulator/machine.h>
 #include <linux/pm_runtime.h>
 #include <linux/of_device.h>
-#include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
-#include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <sound/initval.h>
 #include <sound/tlv.h>
@@ -1058,7 +1056,7 @@ static int cs35l34_i2c_probe(struct i2c_client *i2c_client,
 		dev_err(&i2c_client->dev, "Failed to request IRQ: %d\n", ret);
 
 	cs35l34->reset_gpio = devm_gpiod_get_optional(&i2c_client->dev,
-				"reset-gpios", GPIOD_OUT_LOW);
+				"reset", GPIOD_OUT_LOW);
 	if (IS_ERR(cs35l34->reset_gpio))
 		return PTR_ERR(cs35l34->reset_gpio);
 
-- 
2.43.0



