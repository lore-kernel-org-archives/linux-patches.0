Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD73248F6A;
	Tue, 11 Nov 2025 01:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823264; cv=none; b=d3Ocg5mmjdrhVIbDoewcgFZRYZpdEXB0Fxi64LteY/YtgpiKFKPDEK4rRnaHBAqo17/CEYFnUs4af72E//NAVCwbETismAQmD7TzGW77pbYp1BKqT8xBc4ZQGkFb0RB4HrUEkzBLbGXhLzvy6lJcey6k29YX5NkGU4qhA7z8BK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823264; c=relaxed/simple;
	bh=KYrUoiCEoXNB1Zt3RT38rFm8aqwExEh31Bgq9WyLv8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2lJqRC2+4L4lx3UiWG3AMcTpS8x8e0mKD1eDj3hG0qpk4hyM281YRh4hNV9NYIishsQiE1FWKfDfro5NOvrrLHnByFQla3eIusKIoT/51jcqkmiK4jVMv3fgBKppPXw7jpRiCV6Vnaf4eOHUgTZB+id6iLv/Bc/hjhqIZtoScY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqV6h7N3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqV6h7N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F27C116B1;
	Tue, 11 Nov 2025 01:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823263;
	bh=KYrUoiCEoXNB1Zt3RT38rFm8aqwExEh31Bgq9WyLv8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqV6h7N3usT15aH1844jenuk3qie9VebSfEMW7Y2PjA3xExdDOgjpgnklL1SDsnKW
	 2tQrnarYRXs1G3ufvJY9ZsBCF1pS1Ww8c6l3EZNQvEwbbxixJAgu6t78nwycKoRkFX
	 khG7ZVndWQuKwvcSqB1j13RTebbe/SbvtAfqh7X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Cheong <htcheong@chromium.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 264/849] ASoC: mediatek: Use SND_JACK_AVOUT for HDMI/DP jacks
Date: Tue, 11 Nov 2025 09:37:14 +0900
Message-ID: <20251111004542.815821560@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Cheong <htcheong@chromium.org>

[ Upstream commit 8ed2dca4df2297177e0edcb7e0c72ef87f3fd81a ]

The SND_JACK_AVOUT is a more specific jack type for HDMI and DisplayPort.
Updatae the MediaTek drivers to use such jack type, allowing system to
determine the device type based on jack event.

Signed-off-by: Terry Cheong <htcheong@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20250723-mtk-hdmi-v1-1-4ff945eb6136@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                 | 2 +-
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c        | 2 +-
 .../soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c  | 2 +-
 sound/soc/mediatek/mt8186/mt8186-mt6366.c                 | 2 +-
 sound/soc/mediatek/mt8188/mt8188-mt6359.c                 | 8 ++++----
 sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c   | 2 +-
 sound/soc/mediatek/mt8195/mt8195-mt6359.c                 | 4 ++--
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-rt5650.c b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
index 7d6a3586cdd55..3d6d7bc05b872 100644
--- a/sound/soc/mediatek/mt8173/mt8173-rt5650.c
+++ b/sound/soc/mediatek/mt8173/mt8173-rt5650.c
@@ -159,7 +159,7 @@ static int mt8173_rt5650_hdmi_init(struct snd_soc_pcm_runtime *rtd)
 {
 	int ret;
 
-	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_LINEOUT,
+	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_AVOUT,
 				    &mt8173_rt5650_hdmi_jack);
 	if (ret)
 		return ret;
diff --git a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
index 3388e076ccc9e..983f3b91119a9 100644
--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -378,7 +378,7 @@ static int mt8183_da7219_max98357_hdmi_init(struct snd_soc_pcm_runtime *rtd)
 		snd_soc_card_get_drvdata(rtd->card);
 	int ret;
 
-	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_LINEOUT,
+	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_AVOUT,
 				    &priv->hdmi_jack);
 	if (ret)
 		return ret;
diff --git a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
index 497a9043be7bb..0bc1f11e17aa7 100644
--- a/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-mt6358-ts3a227-max98357.c
@@ -383,7 +383,7 @@ mt8183_mt6358_ts3a227_max98357_hdmi_init(struct snd_soc_pcm_runtime *rtd)
 		snd_soc_card_get_drvdata(rtd->card);
 	int ret;
 
-	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_LINEOUT,
+	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_AVOUT,
 				    &priv->hdmi_jack);
 	if (ret)
 		return ret;
diff --git a/sound/soc/mediatek/mt8186/mt8186-mt6366.c b/sound/soc/mediatek/mt8186/mt8186-mt6366.c
index 43546012cf613..45df69809cbab 100644
--- a/sound/soc/mediatek/mt8186/mt8186-mt6366.c
+++ b/sound/soc/mediatek/mt8186/mt8186-mt6366.c
@@ -362,7 +362,7 @@ static int mt8186_mt6366_rt1019_rt5682s_hdmi_init(struct snd_soc_pcm_runtime *rt
 		return ret;
 	}
 
-	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_LINEOUT, jack);
+	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_AVOUT, jack);
 	if (ret) {
 		dev_err(rtd->dev, "HDMI Jack creation failed: %d\n", ret);
 		return ret;
diff --git a/sound/soc/mediatek/mt8188/mt8188-mt6359.c b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
index ea814a0f726d6..c6e7461e8f764 100644
--- a/sound/soc/mediatek/mt8188/mt8188-mt6359.c
+++ b/sound/soc/mediatek/mt8188/mt8188-mt6359.c
@@ -250,14 +250,14 @@ enum mt8188_jacks {
 static struct snd_soc_jack_pin mt8188_hdmi_jack_pins[] = {
 	{
 		.pin = "HDMI",
-		.mask = SND_JACK_LINEOUT,
+		.mask = SND_JACK_AVOUT,
 	},
 };
 
 static struct snd_soc_jack_pin mt8188_dp_jack_pins[] = {
 	{
 		.pin = "DP",
-		.mask = SND_JACK_LINEOUT,
+		.mask = SND_JACK_AVOUT,
 	},
 };
 
@@ -638,7 +638,7 @@ static int mt8188_hdmi_codec_init(struct snd_soc_pcm_runtime *rtd)
 	int ret = 0;
 
 	ret = snd_soc_card_jack_new_pins(rtd->card, "HDMI Jack",
-					 SND_JACK_LINEOUT, jack,
+					 SND_JACK_AVOUT, jack,
 					 mt8188_hdmi_jack_pins,
 					 ARRAY_SIZE(mt8188_hdmi_jack_pins));
 	if (ret) {
@@ -663,7 +663,7 @@ static int mt8188_dptx_codec_init(struct snd_soc_pcm_runtime *rtd)
 	struct snd_soc_component *component = snd_soc_rtd_to_codec(rtd, 0)->component;
 	int ret = 0;
 
-	ret = snd_soc_card_jack_new_pins(rtd->card, "DP Jack", SND_JACK_LINEOUT,
+	ret = snd_soc_card_jack_new_pins(rtd->card, "DP Jack", SND_JACK_AVOUT,
 					 jack, mt8188_dp_jack_pins,
 					 ARRAY_SIZE(mt8188_dp_jack_pins));
 	if (ret) {
diff --git a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
index bf483a8fb34a4..91c57765ab57b 100644
--- a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
+++ b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
@@ -368,7 +368,7 @@ static int mt8192_mt6359_hdmi_init(struct snd_soc_pcm_runtime *rtd)
 		snd_soc_rtd_to_codec(rtd, 0)->component;
 	int ret;
 
-	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_LINEOUT, jack);
+	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_AVOUT, jack);
 	if (ret) {
 		dev_err(rtd->dev, "HDMI Jack creation failed: %d\n", ret);
 		return ret;
diff --git a/sound/soc/mediatek/mt8195/mt8195-mt6359.c b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
index e57391c213e7d..7b96c843a14a5 100644
--- a/sound/soc/mediatek/mt8195/mt8195-mt6359.c
+++ b/sound/soc/mediatek/mt8195/mt8195-mt6359.c
@@ -360,7 +360,7 @@ static int mt8195_dptx_codec_init(struct snd_soc_pcm_runtime *rtd)
 		snd_soc_rtd_to_codec(rtd, 0)->component;
 	int ret;
 
-	ret = snd_soc_card_jack_new(rtd->card, "DP Jack", SND_JACK_LINEOUT, jack);
+	ret = snd_soc_card_jack_new(rtd->card, "DP Jack", SND_JACK_AVOUT, jack);
 	if (ret)
 		return ret;
 
@@ -375,7 +375,7 @@ static int mt8195_hdmi_codec_init(struct snd_soc_pcm_runtime *rtd)
 		snd_soc_rtd_to_codec(rtd, 0)->component;
 	int ret;
 
-	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_LINEOUT, jack);
+	ret = snd_soc_card_jack_new(rtd->card, "HDMI Jack", SND_JACK_AVOUT, jack);
 	if (ret)
 		return ret;
 
-- 
2.51.0



