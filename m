Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B1415C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F23EC433D6;
	Mon,  5 Dec 2022 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268437;
	bh=oOjJ7oy7vQNNkY8AZvhXMOlLj0itVUchqVA+Ib7LLq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNt1b5yvn378+OyBMpKe0PIV7/Q6YQyaM1myMVqy1VEiDi5hwEZ2UmPeTkvN17ImL
	 BvPPKQqc40WgB/WQYPtlxd5NK7FN3jPvWUl2A+b4/eWBmYJSU/mWNja6s9mzepTxOY
	 YijjvfJMO19KQtRxXYqNk7ITUFALJGW+PJ4RNwWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Tang <tanghui20@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 102/124] ASoC: tlv320adc3xxx: Fix build error for implicit function declaration
Date: Mon,  5 Dec 2022 20:10:08 +0100
Message-Id: <20221205190811.320275719@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 19c5bda74dc45fee598a57600b550c9ea7662f10 ]

sound/soc/codecs/tlv320adc3xxx.c: In function ‘adc3xxx_i2c_probe’:
sound/soc/codecs/tlv320adc3xxx.c:1359:21: error: implicit declaration of function ‘devm_gpiod_get’; did you mean ‘devm_gpio_free’? [-Werror=implicit-function-declaration]
  adc3xxx->rst_pin = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
                     ^~~~~~~~~~~~~~
                     devm_gpio_free
  CC [M]  drivers/gpu/drm/nouveau/nvkm/engine/disp/sorgt215.o
  LD [M]  sound/soc/codecs/snd-soc-ak4671.o
  LD [M]  sound/soc/codecs/snd-soc-arizona.o
  LD [M]  sound/soc/codecs/snd-soc-cros-ec-codec.o
  LD [M]  sound/soc/codecs/snd-soc-ak4641.o
  LD [M]  sound/soc/codecs/snd-soc-alc5632.o
sound/soc/codecs/tlv320adc3xxx.c:1359:50: error: ‘GPIOD_OUT_LOW’ undeclared (first use in this function); did you mean ‘GPIOF_INIT_LOW’?
  adc3xxx->rst_pin = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
                                                  ^~~~~~~~~~~~~
                                                  GPIOF_INIT_LOW
sound/soc/codecs/tlv320adc3xxx.c:1359:50: note: each undeclared identifier is reported only once for each function it appears in
  LD [M]  sound/soc/codecs/snd-soc-cs35l32.o
sound/soc/codecs/tlv320adc3xxx.c:1408:2: error: implicit declaration of function ‘gpiod_set_value_cansleep’; did you mean ‘gpio_set_value_cansleep’? [-Werror=implicit-function-declaration]
  gpiod_set_value_cansleep(adc3xxx->rst_pin, 1);
  ^~~~~~~~~~~~~~~~~~~~~~~~
  gpio_set_value_cansleep
  LD [M]  sound/soc/codecs/snd-soc-cs35l41-lib.o
  LD [M]  sound/soc/codecs/snd-soc-cs35l36.o
  LD [M]  sound/soc/codecs/snd-soc-cs35l34.o
  LD [M]  sound/soc/codecs/snd-soc-cs35l41.o
  CC [M]  drivers/gpu/drm/nouveau/nvkm/engine/disp/sormcp89.o
cc1: all warnings being treated as errors

Fixes: e9a3b57efd28 ("ASoC: codec: tlv320adc3xxx: New codec driver")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Link: https://lore.kernel.org/r/20220512074640.75550-3-tanghui20@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adc3xxx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/tlv320adc3xxx.c b/sound/soc/codecs/tlv320adc3xxx.c
index 8a0965cd3e66..297c458c4d8b 100644
--- a/sound/soc/codecs/tlv320adc3xxx.c
+++ b/sound/soc/codecs/tlv320adc3xxx.c
@@ -14,6 +14,7 @@
 
 #include <dt-bindings/sound/tlv320adc3xxx.h>
 #include <linux/clk.h>
+#include <linux/gpio/consumer.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/io.h>
@@ -1025,7 +1026,9 @@ static const struct gpio_chip adc3xxx_gpio_chip = {
 
 static void adc3xxx_free_gpio(struct adc3xxx *adc3xxx)
 {
+#ifdef CONFIG_GPIOLIB
 	gpiochip_remove(&adc3xxx->gpio_chip);
+#endif
 }
 
 static void adc3xxx_init_gpio(struct adc3xxx *adc3xxx)
-- 
2.35.1



