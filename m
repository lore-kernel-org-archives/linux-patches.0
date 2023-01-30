Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3045028EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE61C433EF;
	Mon, 30 Jan 2023 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087259;
	bh=G4XPmdx5KaEEhEv2bHO6cgTlKpzA5zHAYv4LaMMmdPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpMQxQN/q7dwGirUXqq6e8XrUXZ6fb3+fSusTSkWilOr44rgbmFsPfzuDTvjajZ2U
	 ySuF4UnsHoBSKsqUOgpN63MRG7bIEyHMZK2B2LemYPpw/kkm/sRseu1f8b4gy7EMCb
	 wrN2VDsLORLZ9vKbu7KJsfu25sbUlr7hsvGaMA8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/313] ASoC: mediatek: mt8186: Add machine support for max98357a
Date: Mon, 30 Jan 2023 14:49:45 +0100
Message-Id: <20230130134343.644185973@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit 8a54f666db581bbf07494cca44a0124acbced581 ]

Add support for mt8186 with mt6366 and max98357a.

Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Link: https://lore.kernel.org/r/20221228115756.28014-1-allen-kh.cheng@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/Kconfig b/sound/soc/mediatek/Kconfig
index 363fa4d47680..7bdb0ded831c 100644
--- a/sound/soc/mediatek/Kconfig
+++ b/sound/soc/mediatek/Kconfig
@@ -182,9 +182,10 @@ config SND_SOC_MT8186_MT6366_DA7219_MAX98357
 	  If unsure select "N".
 
 config SND_SOC_MT8186_MT6366_RT1019_RT5682S
-	tristate "ASoC Audio driver for MT8186 with RT1019 RT5682S codec"
+	tristate "ASoC Audio driver for MT8186 with RT1019 RT5682S MAX98357A/MAX98360 codec"
 	depends on I2C && GPIOLIB
 	depends on SND_SOC_MT8186 && MTK_PMIC_WRAP
+	select SND_SOC_MAX98357A
 	select SND_SOC_MT6358
 	select SND_SOC_RT1015P
 	select SND_SOC_RT5682S
-- 
2.39.0



