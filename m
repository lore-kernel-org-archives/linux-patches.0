Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4935FBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1067C433EF;
	Tue,  7 Mar 2023 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210023;
	bh=z84F0HEu790UqBUHkBsNtX8uxxqN9Hq53NDjpScuJDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piiYbYqXj9L8xx+fM0+KZwc69yGmC1AcBQmtoTZAVOpSTjHx6wKh6nAWoq+T4++M4
	 3pKfM93IZmgfHSiJHMch3M1wuj4SFvP82g7NT79BNR0viZd1/4XwGqu86gqpWUta5P
	 +4UptnyZ+LbRdwW1zzDuCgV0GerkFyyvND26NJbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0408/1001] ASoC: mchp-spdifrx: disable all interrupts in mchp_spdifrx_dai_remove()
Date: Tue,  7 Mar 2023 17:53:00 +0100
Message-Id: <20230307170039.033110409@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit aaecdc32b7e35b4f9b457fb3509414aa9a932589 ]

CSC interrupts which might be used in controls are on bits 8 and 9 of
SPDIFRX_IDR register. Thus disable all the interrupts that are exported
by driver.

Fixes: ef265c55c1ac ("ASoC: mchp-spdifrx: add driver for SPDIF RX")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230130120647.638049-5-claudiu.beznea@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index 31ffaaf46dec0..b81fc77728dfc 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -921,7 +921,7 @@ static int mchp_spdifrx_dai_remove(struct snd_soc_dai *dai)
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
 
 	/* Disable interrupts */
-	regmap_write(dev->regmap, SPDIFRX_IDR, 0xFF);
+	regmap_write(dev->regmap, SPDIFRX_IDR, GENMASK(14, 0));
 
 	clk_disable_unprepare(dev->pclk);
 
-- 
2.39.2



