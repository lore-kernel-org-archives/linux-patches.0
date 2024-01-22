Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EA01852;
	Tue, 23 Jan 2024 00:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969486; cv=none; b=aqjeOQKIUBKLAimXCqZ9Xpl3xV4iW+/grDUX1m+51MowD+lmtlis4GpS6FuucrIGZZcZ5XTvHeaZ8+lUCCoY3JlWwV9oa2znCDOskg/0YuEJyqAMQHp3+Nf5UIgrjARcZcVYh4DFU0iMSNaf6cOVqbtTv3LQQw/5aENdJyTfPvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969486; c=relaxed/simple;
	bh=qqbkei2Ql7ZS1sOiJ/OOn8GHuAWX9ad8Delzn2bZhZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLqcwsz0OU8qVvg8u/uBOsV0ChH7tbgLHaoWixHnAvA+Cb2VtM6XpchRTaJjBXpOF1ebr5WKkK6StuzY1XFmjFW3vHK3px7oYqEu0SZoOiT6P4g+9VWDcgVMmOJd3AG58SK6jpkekDXqmhl7L+R6/CQ/EP2BMl/70NXwE6m/G14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my/lLnVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my/lLnVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E382AC43399;
	Tue, 23 Jan 2024 00:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969486;
	bh=qqbkei2Ql7ZS1sOiJ/OOn8GHuAWX9ad8Delzn2bZhZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=my/lLnVoiMqVJcr5PW4g2RV6lLMJHgf+2w5cLF87/Kciq/uOBxl/svpjrXRTstNuH
	 dTtBzTS3K4tgIcdIGrzAlx5jR+oo3w4dbVIKXZy/K9RqbcrmbPc8I84SMjpUcMyGmV
	 wb577uNFUM81vB6OzNc7FZs3lcAwr+ZCHwC7+tzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 276/641] ASoC: cs35l33: Fix GPIO name and drop legacy include
Date: Mon, 22 Jan 2024 15:53:00 -0800
Message-ID: <20240122235826.550012294@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 4010a2d33a33..a19a2bafb37c 100644
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
 
 #include "cs35l33.h"
@@ -1165,7 +1163,7 @@ static int cs35l33_i2c_probe(struct i2c_client *i2c_client)
 
 	/* We could issue !RST or skip it based on AMP topology */
 	cs35l33->reset_gpio = devm_gpiod_get_optional(&i2c_client->dev,
-			"reset-gpios", GPIOD_OUT_HIGH);
+			"reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(cs35l33->reset_gpio)) {
 		dev_err(&i2c_client->dev, "%s ERROR: Can't get reset GPIO\n",
 			__func__);
-- 
2.43.0



