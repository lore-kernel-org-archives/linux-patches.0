Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA92B6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D56C433EF;
	Mon,  3 Apr 2023 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532573;
	bh=WamK9sCvCYLHnmBW33jQHUEzfx0faqK9l3F9CwjpECc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdMelVn6mJhh6goAJ8Q2UdBLvDtIb0vk0HNUjVa+CmRv+05Y2Oge24xzc4HrwV2Bi
	 m6QVhupGvI1LllAMUUCSKAWufEGpFvD3I9+FoKjnn6mZ056HeNTk1Be/Lx4bzgdPgU
	 au25XsFvUw96s0wXsa66bCzKvvWX6FifdvhqbV30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/181] ASoC: Intel: avs: ssm4567: Remove nau8825 bits
Date: Mon,  3 Apr 2023 16:07:50 +0200
Message-Id: <20230403140416.299007645@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 933de2d127281731166cf2880fa1e23c5a0f7faa ]

Some of the nau8825 clock control got into the ssm4567, remove it.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230303134854.2277146-5-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/ssm4567.c | 31 ----------------------------
 1 file changed, 31 deletions(-)

diff --git a/sound/soc/intel/avs/boards/ssm4567.c b/sound/soc/intel/avs/boards/ssm4567.c
index 9f84c8ab34478..51a8867326b47 100644
--- a/sound/soc/intel/avs/boards/ssm4567.c
+++ b/sound/soc/intel/avs/boards/ssm4567.c
@@ -15,7 +15,6 @@
 #include <sound/soc-acpi.h>
 #include "../../../codecs/nau8825.h"
 
-#define SKL_NUVOTON_CODEC_DAI	"nau8825-hifi"
 #define SKL_SSM_CODEC_DAI	"ssm4567-hifi"
 
 static struct snd_soc_codec_conf card_codec_conf[] = {
@@ -34,41 +33,11 @@ static const struct snd_kcontrol_new card_controls[] = {
 	SOC_DAPM_PIN_SWITCH("Right Speaker"),
 };
 
-static int
-platform_clock_control(struct snd_soc_dapm_widget *w, struct snd_kcontrol *control, int event)
-{
-	struct snd_soc_dapm_context *dapm = w->dapm;
-	struct snd_soc_card *card = dapm->card;
-	struct snd_soc_dai *codec_dai;
-	int ret;
-
-	codec_dai = snd_soc_card_get_codec_dai(card, SKL_NUVOTON_CODEC_DAI);
-	if (!codec_dai) {
-		dev_err(card->dev, "Codec dai not found\n");
-		return -EINVAL;
-	}
-
-	if (SND_SOC_DAPM_EVENT_ON(event)) {
-		ret = snd_soc_dai_set_sysclk(codec_dai, NAU8825_CLK_MCLK, 24000000,
-					     SND_SOC_CLOCK_IN);
-		if (ret < 0)
-			dev_err(card->dev, "set sysclk err = %d\n", ret);
-	} else {
-		ret = snd_soc_dai_set_sysclk(codec_dai, NAU8825_CLK_INTERNAL, 0, SND_SOC_CLOCK_IN);
-		if (ret < 0)
-			dev_err(card->dev, "set sysclk err = %d\n", ret);
-	}
-
-	return ret;
-}
-
 static const struct snd_soc_dapm_widget card_widgets[] = {
 	SND_SOC_DAPM_SPK("Left Speaker", NULL),
 	SND_SOC_DAPM_SPK("Right Speaker", NULL),
 	SND_SOC_DAPM_SPK("DP1", NULL),
 	SND_SOC_DAPM_SPK("DP2", NULL),
-	SND_SOC_DAPM_SUPPLY("Platform Clock", SND_SOC_NOPM, 0, 0, platform_clock_control,
-			    SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
 };
 
 static const struct snd_soc_dapm_route card_base_routes[] = {
-- 
2.39.2



