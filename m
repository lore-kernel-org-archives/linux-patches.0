Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214887;
	b=ohdyDTWdOSYNRj2HKBv6H+V3Ynlde1cL52kl3VETqz8ew1pN/no/aCuNbgR9jOTMf09P
	 nn9UCSAZ/uEmBNJxpXqmzWob6ay3KADn6g7kMUr/F8/iEXM5uAteNuJ5dfjeCvDysIjZX
	 a3/PFInvCpn4kQvAK8cOkuof4o8Rsu0TyRx8v0mL5EVaxgVV6YujszCzCCM3otzF66WyC
	 YzU4Ypnd77VDkvZ5LZ1OXXCjFncEKGHrvOJW12rjShB8Yjeg6pAjP1878SJ+cN5RikVC7
	 l3kRRahZ2ebf1DhuUq8fgFJtysCRM2vVkh9YBcj0UcCPV19nuSiVbJF8U/JEPseTVLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/hO26fCTMPtzUTikxPv6w9CWji0z7Tt5rLRfUF0pug=;
	b=3YhF4ODK+ydf0rxj9Uu/iGAk5GBA8avTBGr4cguwqEnk4xR2QDk3ePfN6+WG09RfwNZu
	 03amn31nLSLmxcLHsi9e4l2M4MQPXMZElprX0hFFWUgo0lV4lS5Kcj6gT5IqoGZMcM6cj
	 6caGD1m9zJmJ2ZhUrbr6F1nzFgyzx7vL/EaIW8QjL/DhHjtmevn/v3Z8ycNhRl6Zdgue1
	 EbZYuSx0VPIGnjUxcqPG84bUxCFcxEbGOu2KFFuWad1GGk+XZlX+hhn52WB7F+Vf6u6OL
	 lvbJMnKUNQme+RIjul4H37V6ffAxNFZzT59wXC5qAbzuEa5vwhfa3WgXRTIyVfAz2Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K+aBm8pe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD08606BF8D;
	Wed, 28 Oct 2026 19:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K+aBm8pe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179691F01825;
	Wed, 28 Oct 2026 19:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214886;
	bh=S/hO26fCTMPtzUTikxPv6w9CWji0z7Tt5rLRfUF0pug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+aBm8peQCuVXHJ1DOiiuDfgtFslYj4BUuqG1JySp9GJuR0U+CNBcul6ZhyLz6olI
	 EajWMryHHLfKMYEuEbNxMYBLbED64ogFg9oMAuQCWrwkkGsSxAJywKui3COPSbZtEE
	 EIJs2fPjAgvh0YRCs9OxuSk8cSWVBhui6qlvBSwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1017/1887] ASoC: amd: acp: Add setbias level for rt5682s codec in machine driver
Date: Wed, 28 Oct 2026 17:51:53 +0100
Message-ID: <20261028170522.559857544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 9e693e81745f03845788ef409f03a39e92f8dd48 ]

Add set_bais_level function for rt5682s codec to enable bclk and lrclk
before codec widgets power on and disable bclk and lrclk after widgets
power down, to avoid pop noise

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://lore.kernel.org/r/20220921090750.3833256-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 30c64fb98399 ("ASoC: amd: acp-mach-common: Add missing error check for clock acquisition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-mach-common.c | 62 ++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 6 deletions(-)

diff --git a/sound/soc/amd/acp/acp-mach-common.c b/sound/soc/amd/acp/acp-mach-common.c
index 4c69cb6e34006..a78cf29387a77 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -167,11 +167,14 @@ static int acp_card_hs_startup(struct snd_pcm_substream *substream)
 				      &constraints_channels);
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
 				      &constraints_rates);
-	if (!drvdata->soc_mclk) {
-		ret = acp_clk_enable(drvdata);
-		if (ret < 0) {
-			dev_err(rtd->card->dev, "Failed to enable HS clk: %d\n", ret);
-			return ret;
+
+	if (strcmp(codec_dai->name, "rt5682s-aif1") && strcmp(codec_dai->name, "rt5682s-aif2")) {
+		if (!drvdata->soc_mclk) {
+			ret = acp_clk_enable(drvdata);
+			if (ret < 0) {
+				dev_err(rtd->card->dev, "Failed to enable HS clk: %d\n", ret);
+				return ret;
+			}
 		}
 	}
 
@@ -280,7 +283,6 @@ static int acp_card_rt5682s_init(struct snd_soc_pcm_runtime *rtd)
 
 static const struct snd_soc_ops acp_card_rt5682s_ops = {
 	.startup = acp_card_hs_startup,
-	.shutdown = acp_card_shutdown,
 };
 
 static const unsigned int dmic_channels[] = {
@@ -570,6 +572,52 @@ SND_SOC_DAILINK_DEF(sof_dmic,
 SND_SOC_DAILINK_DEF(pdm_dmic,
 	DAILINK_COMP_ARRAY(COMP_CPU("acp-pdm-dmic")));
 
+static int acp_rtk_set_bias_level(struct snd_soc_card *card,
+				  struct snd_soc_dapm_context *dapm,
+				  enum snd_soc_bias_level level)
+{
+	struct snd_soc_component *component = dapm->component;
+	struct acp_card_drvdata *drvdata = card->drvdata;
+	int ret = 0;
+
+	if (!component)
+		return 0;
+
+	if (strncmp(component->name, "i2c-RTL5682", 11) &&
+	    strncmp(component->name, "i2c-10EC1019", 12))
+		return 0;
+
+	/*
+	 * For Realtek's codec and amplifier components,
+	 * the lrck and bclk must be enabled brfore their all dapms be powered on,
+	 * and must be disabled after their all dapms be powered down
+	 * to avoid any pop.
+	 */
+	switch (level) {
+	case SND_SOC_BIAS_STANDBY:
+		if (snd_soc_dapm_get_bias_level(dapm) == SND_SOC_BIAS_OFF) {
+			clk_set_rate(drvdata->wclk, 48000);
+			clk_set_rate(drvdata->bclk, 48000 * 64);
+
+			/* Increase bclk's enable_count */
+			ret = clk_prepare_enable(drvdata->bclk);
+			if (ret < 0)
+				dev_err(component->dev, "Failed to enable bclk %d\n", ret);
+		} else {
+			/*
+			 * Decrease bclk's enable_count.
+			 * While the enable_count is 0, the bclk would be closed.
+			 */
+			clk_disable_unprepare(drvdata->bclk);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 int acp_sofdsp_dai_links_create(struct snd_soc_card *card)
 {
 	struct snd_soc_dai_link *links;
@@ -730,6 +778,7 @@ int acp_sofdsp_dai_links_create(struct snd_soc_card *card)
 
 	card->dai_link = links;
 	card->num_links = num_links;
+	card->set_bias_level = acp_rtk_set_bias_level;
 
 	return 0;
 }
@@ -907,6 +956,7 @@ int acp_legacy_dai_links_create(struct snd_soc_card *card)
 
 	card->dai_link = links;
 	card->num_links = num_links;
+	card->set_bias_level = acp_rtk_set_bias_level;
 
 	return 0;
 }
-- 
2.53.0



