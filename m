Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AB018BB91;
	Fri, 27 Sep 2024 12:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440092; cv=none; b=KY7iHI2nQyZLx/wRWIT6vSsxKEC6tUWTY2Vx14v8elpq/Y0d1Fe0EaLUA0OSblIO4sR/qRO8XL8oYIEgPAeVONRHtkNEMkhC3CmCr/tuiF33LimA0/Gcn4NZDp2SrrNDNyduwdmHq4pBkpXW2gT76qIMBkS/lbz22FtEJiJjMI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440092; c=relaxed/simple;
	bh=YmWiBkSp7MHMTWdM8BjsECkBdMnCjOxNU3NiMzFtWR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpM1S68adGxThE8lyu2iJC+LUl+z5hh1j56YMHEwmfnvNnW96aOnNusYZzmKTeZQSzzJijUPLcXokLLIgu59N17N6EgSzbFZVseI2ZXzUg7R7iW+dtBccnxKQfaqlwcG3+vU0pZa/tS3REb8chv7ZXcM7i/pEFt7bB6dFlK1ceg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwTg9Os8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwTg9Os8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE00EC4CEC4;
	Fri, 27 Sep 2024 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440092;
	bh=YmWiBkSp7MHMTWdM8BjsECkBdMnCjOxNU3NiMzFtWR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwTg9Os8qYdntPbS6nkRcEsHsIWdC1BIPhN1FbhMvVKqOgV98xQP/h1JxkelOEYpn
	 J5HVgMWymAHsa8HikWLJwkdYZeMHPhU5jQrzeCgIOtg2vwwepUk1Gqvxii19UswTnL
	 jWr5T0doJ5su/p0vIWquLKBXZfuFrOffQE7P1NQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 30/58] ASoC: mediatek: mt8188-mt6359: Modify key
Date: Fri, 27 Sep 2024 14:23:32 +0200
Message-ID: <20240927121720.016629841@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 5325b96769a5b282e330023e1d0881018e89e266 ]

In order to get the correct keys when using the ES8326.We will associate
SND_JACK_BTN_1 to KEY_VOLUMEUP and SND_JACK_BTN_2 to KEY_VOLUMEDOWN
when the ES8326 flag is recognized.

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20240816114921.48913-1-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-mt6359.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-mt6359.c b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
index eba6f4c445ffb..08ae962afeb92 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -734,6 +734,7 @@ static int mt8188_headset_codec_init(struct snd_soc_pcm_runtime *rtd)
 	struct mtk_soc_card_data *soc_card_data = snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_jack *jack = &soc_card_data->card_data->jacks[MT8188_JACK_HEADSET];
 	struct snd_soc_component *component = snd_soc_rtd_to_codec(rtd, 0)->component;
+	struct mtk_platform_card_data *card_data = soc_card_data->card_data;
 	int ret;
 
 	ret = snd_soc_dapm_new_controls(&card->dapm, mt8188_nau8825_widgets,
@@ -762,10 +763,18 @@ static int mt8188_headset_codec_init(struct snd_soc_pcm_runtime *rtd)
 		return ret;
 	}
 
-	snd_jack_set_key(jack->jack, SND_JACK_BTN_0, KEY_PLAYPAUSE);
-	snd_jack_set_key(jack->jack, SND_JACK_BTN_1, KEY_VOICECOMMAND);
-	snd_jack_set_key(jack->jack, SND_JACK_BTN_2, KEY_VOLUMEUP);
-	snd_jack_set_key(jack->jack, SND_JACK_BTN_3, KEY_VOLUMEDOWN);
+	if (card_data->flags & ES8326_HS_PRESENT) {
+		snd_jack_set_key(jack->jack, SND_JACK_BTN_0, KEY_PLAYPAUSE);
+		snd_jack_set_key(jack->jack, SND_JACK_BTN_1, KEY_VOLUMEUP);
+		snd_jack_set_key(jack->jack, SND_JACK_BTN_2, KEY_VOLUMEDOWN);
+		snd_jack_set_key(jack->jack, SND_JACK_BTN_3, KEY_VOICECOMMAND);			
+	} else {
+		snd_jack_set_key(jack->jack, SND_JACK_BTN_0, KEY_PLAYPAUSE);
+		snd_jack_set_key(jack->jack, SND_JACK_BTN_1, KEY_VOICECOMMAND);
+		snd_jack_set_key(jack->jack, SND_JACK_BTN_2, KEY_VOLUMEUP);
+		snd_jack_set_key(jack->jack, SND_JACK_BTN_3, KEY_VOLUMEDOWN);	
+	}
+	
 	ret = snd_soc_component_set_jack(component, jack, NULL);
 
 	if (ret) {
-- 
2.43.0



