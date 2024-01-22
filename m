Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB7412BF3D;
	Tue, 23 Jan 2024 00:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968948; cv=none; b=EkF3blidQ/3ulfoChpQ6SiNo2sJn5yWF1WanghhQbIKC3JqlVDmFvDppGxkuZfdVskacYIr6vP056c/GDxaRkWTVToV04vSuuYCe7ZlYEMN+eo81mJQplW9wPKjJU2OROiJg9v5aMyAjK2meeHmarqHla0EnqjTc6a6rsqk6Sz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968948; c=relaxed/simple;
	bh=wMaecmZnTxaeRVJHs83Uy7MW1pHcClbH0tfnTzESMtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujDADQPgu2AvP8aEDcwmq80KLlaPJ53bBhqrfl/fQU8nkCuE2aze38DofJ+ex8wlrmwVb/NnpG4j2BXZmom01jBguvBeFUYu6IVs90I70BC72T+g+26UtaoQBCAsNZszYM0VRnOG0H2A6Gdnll6T/td4ihuzyTKHfNleGF0Yk44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDwCfIOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDwCfIOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A94C433F1;
	Tue, 23 Jan 2024 00:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968948;
	bh=wMaecmZnTxaeRVJHs83Uy7MW1pHcClbH0tfnTzESMtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDwCfIOh/e3HcPGwwDpXrNIaI3ahN1A67ll0+s8X7mwEc5hQ+yBFdGHxlhRHoeqdf
	 W3jQ9WNhB7pbDfqB3m/8py55BVw5UfFV+KesFYzg/YiJlZKNxkaonEdfPQoFj/dupZ
	 2FVueqeumeBM0Kpkhai9VpyfXU+2P25mk7GnUnL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/194] ASoC: cs35l34: Fix GPIO name and drop legacy include
Date: Mon, 22 Jan 2024 15:57:27 -0800
Message-ID: <20240122235724.254139017@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



