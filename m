Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB2E217723;
	Thu, 30 Jul 2026 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428098; cv=none; b=I4zL9WuuX0df9vWRu5Wk87vbJDVckW3RY/QjG2qvjJeS2m8NMHGOLPVS/bQEgS96+K7r3HOiyjYrhl5LpEJy1YKBTaFxUZMsxOPbUhzkaCwWCZiydagsfKRzRpRka2YPTt/csggyhDYnG95GNJkXOx9qvAG+D58Jm7Md3x3CM3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428098; c=relaxed/simple;
	bh=lbN8fvSvhNaWf5/iDhzj+WZUGZhzppr6pK+lDqhYddE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9xFUVIpZOW+IMA1LYiV+pQugRyHkGux7e377+htKq8GDIou62EiwpWcBV9FgoC3iGsQbkPhoNziUwyaH3n5CUqGvjKRKMNfjv/weOLpTgu1t3cDhQedb0NHy1dT1TMhSnL5nxBZNpscftHIMLstT4PD1CELlMBSfLFXuPj8Kqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNQkWF5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNQkWF5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63A31F00AC4;
	Thu, 30 Jul 2026 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428096;
	bh=pbucJ9qmnTzOqc0oceeUBAzdWJMu0i/AqO4vJN4Qk8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNQkWF5LF91iTjdLHrIkpX7NGmX1CaXpOkGlvsdKHCPkBXqR7s66JctFEoxKoMh7/
	 fJyTQ5epnUXjwpGcJgczTgQN1wz2cd3wMSevGVU8ZD9ju6RgpSVVjLJ/qgl8bNZItV
	 cW1zR/z5SYCIJTZnP7wAoJP1qsXbbYpZPbJ5hSEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 401/484] ASoC: mediatek: Use common mtk_afe_pcm_platform with common probe cb
Date: Thu, 30 Jul 2026 16:14:58 +0200
Message-ID: <20260730141432.186557704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 1d2a6b3b5189b6c3e51f29e050aa9b2337b774e8 ]

Since the mtk-afe-platform-driver generic mtk_afe_pcm_platform now has
a common .probe() callback, there is no reason to keep duplicating this
function over and over in the SoC specific AFE-PCM drivers: switch over
to register with the common bits instead.

Note that MT8186 was left out of this because it is registering some
extra sinegen controls in the AFE-PCM probe callback and needs extra
cleanups to be able to use the common bits.

Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240416071410.75620-13-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e24d5dde56a5 ("ASoC: mediatek: mt8192: Check runtime resume during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt6797/mt6797-afe-pcm.c |   14 +-------------
 sound/soc/mediatek/mt7986/mt7986-afe-pcm.c |   14 +-------------
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c |   14 +-------------
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c |   21 +--------------------
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c |   25 ++-----------------------
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c |   21 +--------------------
 6 files changed, 7 insertions(+), 102 deletions(-)

--- a/sound/soc/mediatek/mt6797/mt6797-afe-pcm.c
+++ b/sound/soc/mediatek/mt6797/mt6797-afe-pcm.c
@@ -704,18 +704,6 @@ static int mt6797_afe_runtime_resume(str
 	return 0;
 }
 
-static int mt6797_afe_component_probe(struct snd_soc_component *component)
-{
-	return mtk_afe_add_sub_dai_control(component);
-}
-
-static const struct snd_soc_component_driver mt6797_afe_component = {
-	.name		= AFE_PCM_NAME,
-	.probe		= mt6797_afe_component_probe,
-	.pointer	= mtk_afe_pcm_pointer,
-	.pcm_construct	= mtk_afe_pcm_new,
-};
-
 static int mt6797_dai_memif_register(struct mtk_base_afe *afe)
 {
 	struct mtk_base_afe_dai *dai;
@@ -852,7 +840,7 @@ static int mt6797_afe_pcm_dev_probe(stru
 	pm_runtime_get_sync(&pdev->dev);
 
 	/* register component */
-	ret = devm_snd_soc_register_component(dev, &mt6797_afe_component,
+	ret = devm_snd_soc_register_component(dev, &mtk_afe_pcm_platform,
 					      NULL, 0);
 	if (ret) {
 		dev_warn(dev, "err_platform\n");
--- a/sound/soc/mediatek/mt7986/mt7986-afe-pcm.c
+++ b/sound/soc/mediatek/mt7986/mt7986-afe-pcm.c
@@ -429,18 +429,6 @@ static int mt7986_afe_runtime_resume(str
 	return 0;
 }
 
-static int mt7986_afe_component_probe(struct snd_soc_component *component)
-{
-	return mtk_afe_add_sub_dai_control(component);
-}
-
-static const struct snd_soc_component_driver mt7986_afe_component = {
-	.name = AFE_PCM_NAME,
-	.probe = mt7986_afe_component_probe,
-	.pointer	= mtk_afe_pcm_pointer,
-	.pcm_construct	= mtk_afe_pcm_new,
-};
-
 static int mt7986_dai_memif_register(struct mtk_base_afe *afe)
 {
 	struct mtk_base_afe_dai *dai;
@@ -573,7 +561,7 @@ static int mt7986_afe_pcm_dev_probe(stru
 
 	/* register component */
 	ret = devm_snd_soc_register_component(&pdev->dev,
-					      &mt7986_afe_component,
+					      &mtk_afe_pcm_platform,
 					      NULL, 0);
 	if (ret)
 		return dev_err_probe(dev, ret, "Cannot register AFE component\n");
--- a/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-pcm.c
@@ -1043,18 +1043,6 @@ skip_regmap:
 	return 0;
 }
 
-static int mt8183_afe_component_probe(struct snd_soc_component *component)
-{
-	return mtk_afe_add_sub_dai_control(component);
-}
-
-static const struct snd_soc_component_driver mt8183_afe_component = {
-	.name		= AFE_PCM_NAME,
-	.probe		= mt8183_afe_component_probe,
-	.pointer	= mtk_afe_pcm_pointer,
-	.pcm_construct	= mtk_afe_pcm_new,
-};
-
 static int mt8183_dai_memif_register(struct mtk_base_afe *afe)
 {
 	struct mtk_base_afe_dai *dai;
@@ -1250,7 +1238,7 @@ static int mt8183_afe_pcm_dev_probe(stru
 
 	/* register component */
 	ret = devm_snd_soc_register_component(&pdev->dev,
-					      &mt8183_afe_component,
+					      &mtk_afe_pcm_platform,
 					      NULL, 0);
 	if (ret) {
 		dev_warn(dev, "err_platform\n");
--- a/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-pcm.c
@@ -3027,25 +3027,6 @@ skip_regmap:
 	return 0;
 }
 
-static int mt8188_afe_component_probe(struct snd_soc_component *component)
-{
-	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(component);
-	int ret;
-
-	snd_soc_component_init_regmap(component, afe->regmap);
-
-	ret = mtk_afe_add_sub_dai_control(component);
-
-	return ret;
-}
-
-static const struct snd_soc_component_driver mt8188_afe_component = {
-	.name = AFE_PCM_NAME,
-	.pointer       = mtk_afe_pcm_pointer,
-	.pcm_construct = mtk_afe_pcm_new,
-	.probe         = mt8188_afe_component_probe,
-};
-
 static int init_memif_priv_data(struct mtk_base_afe *afe)
 {
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
@@ -3347,7 +3328,7 @@ static int mt8188_afe_pcm_dev_probe(stru
 	}
 
 	/* register component */
-	ret = devm_snd_soc_register_component(dev, &mt8188_afe_component,
+	ret = devm_snd_soc_register_component(dev, &mtk_afe_pcm_platform,
 					      afe->dai_drivers, afe->num_dai_drivers);
 	if (ret) {
 		dev_warn(dev, "err_platform\n");
--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2126,22 +2126,6 @@ skip_regmap:
 	return 0;
 }
 
-static int mt8192_afe_component_probe(struct snd_soc_component *component)
-{
-	return mtk_afe_add_sub_dai_control(component);
-}
-
-static const struct snd_soc_component_driver mt8192_afe_component = {
-	.name = AFE_PCM_NAME,
-	.probe = mt8192_afe_component_probe,
-	.pointer = mtk_afe_pcm_pointer,
-	.pcm_construct = mtk_afe_pcm_new,
-};
-
-static const struct snd_soc_component_driver mt8192_afe_pcm_component = {
-	.name = "mt8192-afe-pcm-dai",
-};
-
 static int mt8192_dai_memif_register(struct mtk_base_afe *afe)
 {
 	struct mtk_base_afe_dai *dai;
@@ -2318,16 +2302,11 @@ static int mt8192_afe_pcm_dev_probe(stru
 
 	/* register platform */
 	ret = devm_snd_soc_register_component(&pdev->dev,
-					      &mt8192_afe_component, NULL, 0);
-	if (ret)
-		return dev_err_probe(dev, ret, "Couldn't register AFE component\n");
-
-	ret = devm_snd_soc_register_component(&pdev->dev,
-					      &mt8192_afe_pcm_component,
+					      &mtk_afe_pcm_platform,
 					      afe->dai_drivers,
 					      afe->num_dai_drivers);
 	if (ret)
-		return dev_err_probe(dev, ret, "Couldn't register AFE-PCM component\n");
+		return dev_err_probe(dev, ret, "Couldn't register AFE component\n");
 
 	return 0;
 }
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -2944,25 +2944,6 @@ skip_regmap:
 	return 0;
 }
 
-static int mt8195_afe_component_probe(struct snd_soc_component *component)
-{
-	struct mtk_base_afe *afe = snd_soc_component_get_drvdata(component);
-	int ret = 0;
-
-	snd_soc_component_init_regmap(component, afe->regmap);
-
-	ret = mtk_afe_add_sub_dai_control(component);
-
-	return ret;
-}
-
-static const struct snd_soc_component_driver mt8195_afe_component = {
-	.name = AFE_PCM_NAME,
-	.pointer = mtk_afe_pcm_pointer,
-	.pcm_construct = mtk_afe_pcm_new,
-	.probe = mt8195_afe_component_probe,
-};
-
 static int init_memif_priv_data(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
@@ -3164,7 +3145,7 @@ static int mt8195_afe_pcm_dev_probe(stru
 	}
 
 	/* register component */
-	ret = devm_snd_soc_register_component(dev, &mt8195_afe_component,
+	ret = devm_snd_soc_register_component(dev, &mtk_afe_pcm_platform,
 					      afe->dai_drivers, afe->num_dai_drivers);
 	if (ret) {
 		dev_warn(dev, "err_platform\n");


