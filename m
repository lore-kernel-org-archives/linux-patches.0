Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA7882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD84C433D2;
	Fri, 10 Mar 2023 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460964;
	bh=SeEn6f+3/BbGp4/UdMZLC+n2s3vlSqlMJpBey+2Ae6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwIS2/WdmilqGGFFwHW+ZPz0R5PZNm5YDFJG5ct55deEcG8GHKFWsNtTBncnYNwpS
	 IvlYBLLMWCo2kyHil1Jcm2xIZvexZJ6ZFOpknWVUO+PTcAS3Ri1SlHPHohulVJZbyj
	 NuPvYeJOmfagZxW+LHJwA3rQ5XaiayowNO/JcP4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 480/529] ASoC: zl38060 add gpiolib dependency
Date: Fri, 10 Mar 2023 14:40:23 +0100
Message-Id: <20230310133827.086448064@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0de2cc3707b6b6e2ad40bd24ce09a5c1f65d01e1 ]

Without gpiolib, this driver fails to link:

arm-linux-gnueabi-ld: sound/soc/codecs/zl38060.o: in function `chip_gpio_get':
zl38060.c:(.text+0x30): undefined reference to `gpiochip_get_data'
arm-linux-gnueabi-ld: sound/soc/codecs/zl38060.o: in function `zl38_spi_probe':
zl38060.c:(.text+0xa18): undefined reference to `devm_gpiochip_add_data_with_key'

This appears to have been in the driver since the start, but is hard to
hit in randconfig testing since gpiolib is almost always selected by something
else.

Fixes: 52e8a94baf90 ("ASoC: Add initial ZL38060 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230227085850.2503725-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index a96f18a9479e8..f1c9e563994b2 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1701,6 +1701,7 @@ config SND_SOC_WSA881X
 config SND_SOC_ZL38060
 	tristate "Microsemi ZL38060 Connected Home Audio Processor"
 	depends on SPI_MASTER
+	depends on GPIOLIB
 	select REGMAP
 	help
 	  Support for ZL38060 Connected Home Audio Processor from Microsemi,
-- 
2.39.2



