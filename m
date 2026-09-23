Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5825383E1;
	Wed, 23 Sep 2026 14:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174702; cv=none; b=jcMQWReOyKSkKA6kZhpn1dyxLYXuMjnPUDOrO7ggzM8nYvJKzfnbT3AwtAo2ZrCzRy50Opi1Rz5Kwa+CFODpriUPYderXOI5mNrhjZm4QOGAayytFGUDIldZVQR8CcTSq64Xv5RqRxAr9pVB4wlkNPaUXktSxUS+0pIfAIlYUj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174702; c=relaxed/simple;
	bh=TL8x6L59XeUWbGQbm60rhuTNvZiq5O2P5yHgqFtqwLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqKBxznm/dekrPwqHHXHRIwqRHTMoweKL13VPYhTcbQGL+yNpoSaP8qhum+H5Dq+t/fPjA1vz9cXXACT/SQlE3i6poX3zrtaJROyK1BEzvBL/fOlLgyBz0qbyKJsth1cvUFv46ySmINIXB7vFxOvOUforXLPy4g+WxMtatWMJFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXCJo1mK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXCJo1mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3EF1F0089B;
	Wed, 23 Sep 2026 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174700;
	bh=hrnssL50iBiOi1QKGk/+HH8+GaApzYBJYAW1qEagUOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXCJo1mKvFRxxhVAXIcNH2eP0mXdbZ+dOAnynQqGxmbM5xRQDzTX6XwnrGdo4fLbN
	 x1Hnh+0wMy7+kBL1B99Ml2NP8XAsvH3/OdsCIEaiswIn5CzU18sXLg9iUKBROYZkQ2
	 w71yIIi27ZnTt83hXqnEcYmvuieyI6AnWp+ii/oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/398] ASoC: sdw_utils: tidyup .count_sidecar
Date: Wed, 23 Sep 2026 16:04:05 +0200
Message-ID: <20260923140647.866414202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit c97f0bf5f705b16d150f2b0d5ce0ee24eee4f68a ]

count_sidecar() is not using *card. Tidyup it.

Current code makes old style / new style conversion difficult.
To make future conversions easier to understand, this patch clean up the
code a little. but no functional change.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/87jyrlety1.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0b7d55d3a912 ("ASoC: amd: acp: refactor codec config count in SOF SoundWire machine driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc_sdw_utils.h                | 28 ++++++++++----------
 sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c |  4 +--
 sound/soc/sdw_utils/soc_sdw_utils.c          |  2 +-
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/include/sound/soc_sdw_utils.h b/include/sound/soc_sdw_utils.h
index 7badbd1d32319..f27019f1b4e51 100644
--- a/include/sound/soc_sdw_utils.h
+++ b/include/sound/soc_sdw_utils.h
@@ -44,6 +44,18 @@
 
 struct asoc_sdw_codec_info;
 
+struct asoc_sdw_mc_private {
+	struct snd_soc_card card;
+	struct snd_soc_jack sdw_headset;
+	struct device *headset_codec_dev; /* only one headset per card */
+	struct device *amp_dev1, *amp_dev2;
+	bool append_dai_type;
+	bool ignore_internal_dmic;
+	void *private;
+	unsigned long mc_quirk;
+	int codec_info_list_count;
+};
+
 struct asoc_sdw_dai_info {
 	const bool direction[2]; /* playback & capture support */
 	const char *dai_name;
@@ -84,25 +96,13 @@ struct asoc_sdw_codec_info {
 
 	int (*codec_card_late_probe)(struct snd_soc_card *card);
 
-	int  (*count_sidecar)(struct snd_soc_card *card,
+	int  (*count_sidecar)(struct asoc_sdw_mc_private *ctx,
 			      int *num_dais, int *num_devs);
 	int  (*add_sidecar)(struct snd_soc_card *card,
 			    struct snd_soc_dai_link **dai_links,
 			    struct snd_soc_codec_conf **codec_conf);
 };
 
-struct asoc_sdw_mc_private {
-	struct snd_soc_card card;
-	struct snd_soc_jack sdw_headset;
-	struct device *headset_codec_dev; /* only one headset per card */
-	struct device *amp_dev1, *amp_dev2;
-	bool append_dai_type;
-	bool ignore_internal_dmic;
-	void *private;
-	unsigned long mc_quirk;
-	int codec_info_list_count;
-};
-
 struct asoc_sdw_endpoint {
 	struct list_head list;
 
@@ -219,7 +219,7 @@ int asoc_sdw_cs42l43_spk_init(struct snd_soc_card *card,
 			      bool playback);
 
 /* CS AMP support */
-int asoc_sdw_bridge_cs35l56_count_sidecar(struct snd_soc_card *card,
+int asoc_sdw_bridge_cs35l56_count_sidecar(struct asoc_sdw_mc_private *ctx,
 					  int *num_dais, int *num_devs);
 int asoc_sdw_bridge_cs35l56_add_sidecar(struct snd_soc_card *card,
 					struct snd_soc_dai_link **dai_links,
diff --git a/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c b/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
index c7e55f4433514..8f189025c20cc 100644
--- a/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
+++ b/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
@@ -104,11 +104,9 @@ static const struct snd_soc_dai_link bridge_dai_template = {
 	SND_SOC_DAILINK_REG(asoc_sdw_bridge_dai),
 };
 
-int asoc_sdw_bridge_cs35l56_count_sidecar(struct snd_soc_card *card,
+int asoc_sdw_bridge_cs35l56_count_sidecar(struct asoc_sdw_mc_private *ctx,
 					  int *num_dais, int *num_devs)
 {
-	struct asoc_sdw_mc_private *ctx = snd_soc_card_get_drvdata(card);
-
 	if (ctx->mc_quirk & SOC_SDW_SIDECAR_AMPS) {
 		(*num_dais)++;
 		(*num_devs) += ARRAY_SIZE(bridge_cs35l56_name_prefixes);
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 80f24a2296f03..7336375cd386d 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1405,7 +1405,7 @@ int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
 			ctx->ignore_internal_dmic |= codec_info->ignore_internal_dmic;
 
 			if (codec_info->count_sidecar && codec_info->add_sidecar) {
-				ret = codec_info->count_sidecar(card, &num_dais, num_devs);
+				ret = codec_info->count_sidecar(ctx, &num_dais, num_devs);
 				if (ret)
 					return ret;
 
-- 
2.53.0



