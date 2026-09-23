Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9257D418368;
	Wed, 23 Sep 2026 14:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173289; cv=none; b=KGdMzpopTJLaDG6nlp40IAE/bdlZwEfGbcXVpcSsUU4qhul4wxrMf1KyA64TKomWrb0lyBfJfpddxPzH4AeVCGyI6WHDykVoBe1183yBok4hoS8XyxkYTsbWQGct025Z4zeKATC75TKqXtmrk76BJkH/rtGKOjg02rVBtm7a5WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173289; c=relaxed/simple;
	bh=qLr8yRpgg+rSNeRoMMIZ2YZ1lbWLdW4ADK9zeCkucFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXy9ubMmi/hvmF0I7eFSn8SurM0MWoNevhYCUoydsmaUnfw8Pt4NhttgsG35bvQf9J6pPPw7gisxFngug2qDroZKCRnDlePvqhb96oV86WvTsgO5EGDTI2ovm92rJdtkgfGkiyj/w+9P7bMjEoWNah1ZSZov/8X7u4QmpCQp/w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8S3C4n6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8S3C4n6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8241F000FF;
	Wed, 23 Sep 2026 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173288;
	bh=rBJerXTgQLcf2ftim1RntQBT2KjqnBW4WtN5qPKjDQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8S3C4n6XC2Xr8jVaysvTzJu0DT9rmnJDDpPWePncy8Eg8SvxiFUrY6M5F0w0NESb
	 rrgt0+jXZfZmulXNJAUg3zRe7Q08Mlm7Ra1UptM5HGx1zZ5vj/ov7LWOn+K1lzDT40
	 yBrRu2FVoVnsn1U5gvxHmhAMdQah1x6DktnPapRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 201/438] ASoC: sdw_utils: tidyup .count_sidecar
Date: Wed, 23 Sep 2026 16:03:42 +0200
Message-ID: <20260923140649.975772423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 79c21966220b2..443d63dc6ea37 100644
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
 	const char *codec_name;
@@ -88,25 +100,13 @@ struct asoc_sdw_codec_info {
 
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
 
@@ -235,7 +235,7 @@ int asoc_sdw_es9356_amp_init(struct snd_soc_card *card,
 int asoc_sdw_es9356_exit(struct snd_soc_card *card, struct snd_soc_dai_link *dai_link);
 
 /* CS AMP support */
-int asoc_sdw_bridge_cs35l56_count_sidecar(struct snd_soc_card *card,
+int asoc_sdw_bridge_cs35l56_count_sidecar(struct asoc_sdw_mc_private *ctx,
 					  int *num_dais, int *num_devs);
 int asoc_sdw_bridge_cs35l56_add_sidecar(struct snd_soc_card *card,
 					struct snd_soc_dai_link **dai_links,
diff --git a/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c b/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
index e0e32a279787c..129a437ae397e 100644
--- a/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
+++ b/sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c
@@ -99,11 +99,9 @@ static const struct snd_soc_dai_link bridge_dai_template = {
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
index ce2a9c28fe1a5..982be8a286133 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -2045,7 +2045,7 @@ int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
 			ctx->ignore_internal_dmic |= codec_info->ignore_internal_dmic;
 
 			if (codec_info->count_sidecar && codec_info->add_sidecar) {
-				ret = codec_info->count_sidecar(card, &num_dais, num_devs);
+				ret = codec_info->count_sidecar(ctx, &num_dais, num_devs);
 				if (ret)
 					return ret;
 
-- 
2.53.0



