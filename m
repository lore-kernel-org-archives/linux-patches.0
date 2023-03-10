Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722908481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED534C433D2;
	Fri, 10 Mar 2023 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457363;
	bh=rXFzxb7jhWiX/anZkxrUeOxUc2zSdHxJZmDQVP+y1lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzwNkhPXE/aKlScqJF+USLaR4oxoK2jSoG2G4mTBlDClCnTXCOoPQPjubpWOJSopf
	 cNO13qx4hWA4ezVEL3YjM6kF1X5Sm46Sea06rNBR86HKzCm95I2/5HXE/KJz1Ozq8T
	 IDevVdkn2Dixp9c8lSNGg3y/kpBMwQYpF3FAoLCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Wu <trevor.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/200] ASoC: mediatek: mt8195: add missing initialization
Date: Fri, 10 Mar 2023 14:38:39 +0100
Message-Id: <20230310133720.541107286@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trevor Wu <trevor.wu@mediatek.com>

[ Upstream commit b56ec2992a2e43bc3e60d6db86849d31640e791f ]

In etdm dai driver, dai_etdm_parse_of() function is used to parse dts
properties to get parameters. There are two for-loops which are
sepearately for all etdm and etdm input only cases. In etdm in only
loop, dai_id is not initialized, so it keeps the value intiliazed in
another loop.

In the patch, add the missing initialization to fix the unexpected
parsing problem.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Signed-off-by: Trevor Wu <trevor.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230301110200.26177-3-trevor.wu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index c2e268054773d..f2c9a1fdbe0d0 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2567,6 +2567,9 @@ static void mt8195_dai_etdm_parse_of(struct mtk_base_afe *afe)
 
 	/* etdm in only */
 	for (i = 0; i < 2; i++) {
+		dai_id = ETDM_TO_DAI_ID(i);
+		etdm_data = afe_priv->dai_priv[dai_id];
+
 		ret = snprintf(prop, sizeof(prop),
 			       "mediatek,%s-chn-disabled",
 			       of_afe_etdms[i].name);
-- 
2.39.2



