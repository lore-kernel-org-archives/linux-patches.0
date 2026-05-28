Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4C9344DAC;
	Thu, 28 May 2026 20:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998849; cv=none; b=ESAhUJe8KaGWFzxetX6AsldOmR527bsqov1z0zHxbHUM6uY0uguLbstiH1fZub30maoYqyRV8hnB95eqy6NzqAXNH7T/Tj4h7LqMBURd9c9CpVNLrXKDqG1g/3rUs/Eky2k4qh19Fx+ogxzINoKlaG21b5lcNRtwFy76yGrxSkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998849; c=relaxed/simple;
	bh=KIZ14uAf4lA2/aayQtBrXFO3ykxkMIeAaNl7SylbMhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmvkp2//FcKPmXpRhX+V6iosny/zGTxnAIuZgitVxHf98AHeeXyrP+RDu/nv2y3W5AVbZNVpEmvJ0qnZlHUW8zFPhacF4qOOgnDzTBnf1npSr6JKdZd6Oy+Vgx1WrnP1VjSpyq2hOWG32uO6PB9yx+zTAIFQ19h9uSkPtkkOkbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETYiTuk7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETYiTuk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2398B1F000E9;
	Thu, 28 May 2026 20:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998847;
	bh=nyM+3cn0UMgGeeq3TRtTVboSQ/NTUTYXND/hTijc/dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETYiTuk7iGgOzT5EUqkQH17Dj4id2vrm8IxZHBNR9t5+6BMEdDMPFGelrfHC76ii8
	 OnZyFbqaVDMqIBkjhVjSNHaQHEtcjgjcBUw6lG0yZIpOJee4M5orjhv7pKRz0jq0sB
	 wVHU6KFX99Uci6/lUHhwMDOFSIUwkWLkuErwvvwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Aaron Ma <aaron.ma@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 312/461] ASoC: sdw_utils: cs42l43: allow spk component names to be combined
Date: Thu, 28 May 2026 21:47:21 +0200
Message-ID: <20260528194656.319581757@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 87a3f5c8ac2096e9406ce2ed3bf5b9bc1589a92d ]

Move handling of cs42l43-spk component string into SOF mechanism [1]
which will allow it to be aggregated with other speakers.
Likewise handle the cs35l56-bridge special case which should not be
combined to keep compatibility with UCM.

Link: https://github.com/thesofproject/linux/pull/5445 [1]
Link: https://github.com/alsa-project/alsa-ucm-conf/pull/747
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Suggested-by: Aaron Ma <aaron.ma@canonical.com>
Tested-by: Aaron Ma <aaron.ma@canonical.com>
Link: https://patch.msgid.link/20260420114823.194226-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 5a30862dec5a ("ASoC: sdw_utils: Check speaker component string allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c |  6 ------
 sound/soc/sdw_utils/soc_sdw_cs42l43.c        | 12 +-----------
 sound/soc/sdw_utils/soc_sdw_utils.c          | 20 ++++++++++++++++----
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c b/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
index 2a7109d53cbe3..e0e32a279787c 100644
--- a/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
+++ b/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
@@ -40,12 +40,6 @@ static int asoc_sdw_bridge_cs35l56_asp_init(struct snd_soc_pcm_runtime *rtd)
 	struct snd_soc_dai *codec_dai;
 	struct snd_soc_dai *cpu_dai;
 
-	card->components = devm_kasprintf(card->dev, GFP_KERNEL,
-					  "%s spk:cs35l56-bridge",
-					  card->components);
-	if (!card->components)
-		return -ENOMEM;
-
 	ret = snd_soc_dapm_new_controls(dapm, bridge_widgets,
 					ARRAY_SIZE(bridge_widgets));
 	if (ret) {
diff --git a/sound/soc/sdw_utils/soc_sdw_cs42l43.c b/sound/soc/sdw_utils/soc_sdw_cs42l43.c
index 4a451b9d4f137..e99ea3c4e5dde 100644
--- a/sound/soc/sdw_utils/soc_sdw_cs42l43.c
+++ b/sound/soc/sdw_utils/soc_sdw_cs42l43.c
@@ -107,21 +107,11 @@ EXPORT_SYMBOL_NS(asoc_sdw_cs42l43_hs_rtd_init, "SND_SOC_SDW_UTILS");
 
 int asoc_sdw_cs42l43_spk_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_soc_dai *dai)
 {
-	struct snd_soc_component *component = snd_soc_rtd_to_codec(rtd, 0)->component;
+	struct snd_soc_component *component = dai->component;
 	struct snd_soc_card *card = rtd->card;
 	struct snd_soc_dapm_context *dapm = snd_soc_card_to_dapm(card);
-	struct asoc_sdw_mc_private *ctx = snd_soc_card_get_drvdata(card);
 	int ret;
 
-	if (!(ctx->mc_quirk & SOC_SDW_SIDECAR_AMPS)) {
-		/* Will be set by the bridge code in this case */
-		card->components = devm_kasprintf(card->dev, GFP_KERNEL,
-						  "%s spk:cs42l43-spk",
-						  card->components);
-		if (!card->components)
-			return -ENOMEM;
-	}
-
 	ret = snd_soc_limit_volume(card, "cs42l43 Speaker Digital Volume",
 				   CS42L43_SPK_VOLUME_0DB);
 	if (ret)
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index f54043e5ff450..bf6629dd48860 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -713,6 +713,7 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 			{
 				.direction = {true, false},
 				.codec_name = "cs42l43-codec",
+				.component_name = "cs42l43-spk",
 				.dai_name = "cs42l43-dp6",
 				.dai_type = SOC_SDW_DAI_TYPE_AMP,
 				.dailink = {SOC_SDW_AMP_OUT_DAI_ID, SOC_SDW_UNUSED_DAI_ID},
@@ -922,6 +923,7 @@ static int asoc_sdw_find_codec_info_dai_index(const struct asoc_sdw_codec_info *
 int asoc_sdw_rtd_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_card *card = rtd->card;
+	struct asoc_sdw_mc_private *ctx = snd_soc_card_get_drvdata(card);
 	struct snd_soc_dapm_context *dapm = snd_soc_card_to_dapm(card);
 	struct asoc_sdw_codec_info *codec_info;
 	struct snd_soc_dai *dai;
@@ -997,16 +999,26 @@ int asoc_sdw_rtd_init(struct snd_soc_pcm_runtime *rtd)
 		/* Generate the spk component string for card->components string */
 		if (codec_info->dais[dai_index].dai_type == SOC_SDW_DAI_TYPE_AMP &&
 		    codec_info->dais[dai_index].component_name) {
+			const char *component;
+
+			/*
+			 * For the special case of cs42l43 with sidecar amps, use only
+			 * "cs35l56-bridge" as the component name in card->components
+			 */
+			if (ctx->mc_quirk & SOC_SDW_SIDECAR_AMPS &&
+			    !strcmp(codec_info->dais[dai_index].component_name, "cs42l43-spk"))
+				component = "cs35l56-bridge";
+			else
+				component = codec_info->dais[dai_index].component_name;
+
 			if (strlen (spk_components) == 0)
 				spk_components =
-					devm_kasprintf(card->dev, GFP_KERNEL, "%s",
-						       codec_info->dais[dai_index].component_name);
+					devm_kasprintf(card->dev, GFP_KERNEL, "%s", component);
 			else
 				/* Append component name to spk_components */
 				spk_components =
 					devm_kasprintf(card->dev, GFP_KERNEL,
-						       "%s+%s", spk_components,
-						       codec_info->dais[dai_index].component_name);
+						       "%s+%s", spk_components, component);
 		}
 
 		codec_info->dais[dai_index].rtd_init_done = true;
-- 
2.53.0



