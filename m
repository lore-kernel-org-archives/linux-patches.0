Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00E553C3D1;
	Wed, 23 Sep 2026 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174717; cv=none; b=GuCnzkn4bJpvgM9qypWdPiV8BjjZVWsaWFQdopSTNaq+Bx1wEF74JflTXGFxgPbyfpWc7reQ8DMIHcHCTldUOXxE2XMdpE79oxY+mZ4Hvow0QygfOKDlb8d6+9sux+KEW2wRAeOMLn8NeMbDfpwgzwxm18UlsdVykwb03fh5sXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174717; c=relaxed/simple;
	bh=QiloDyRurNobbmjNLbsTg7lhQSu0JzFZCOxFjQ4/Fvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0Tkg5SN4AC2L9M8DcOp/OpH1LRIhFNCx0eTzHY8QhQUI+3+JMqGjelPGt1X8UNxsBJwFSr/sr+xJtDgUAdR5IRjgGx9JYgHe4shoT9K6g1owymbF+JCKTVBWD8oAcz7Z3Avwk5VoynLV67d5WlSn9Wv1ZcNqACoN+P8l49WPMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY4tAUrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY4tAUrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57FD1F00893;
	Wed, 23 Sep 2026 14:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174716;
	bh=cUeKK0gaGGJ1cLGGfUCsbf702MlPC8r5Q6EX7fyFpCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BY4tAUrR1X1HRJw1tx5vBGeBG9SBcEtbQWL2dUFf1V7myEP4qH6LVE/MUGHrCG8Ax
	 1aGR48OkfEl61L/xRI/tw2U/ZGJh/eyQMMMdY5OWgoeOAnL2Oj2SbzTLs196X303AF
	 QmxCfLI8oZhEGqOkHZ6NDGrCsMg+U41R5E1fN7Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/398] ASoC: sdw_utils: tidyup asoc_sdw_parse_sdw_endpoints()
Date: Wed, 23 Sep 2026 16:04:06 +0200
Message-ID: <20260923140647.891933476@linuxfoundation.org>
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

[ Upstream commit a1332be2a07090cf422507ec812ce2b9ba0a558a ]

We can avoid to use *card. Tidyup it.

Current code makes old style / new style conversion difficult.
To make future conversions easier to understand, this patch clean up the
code a little. but no functional change.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/87ik75etxw.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0b7d55d3a912 ("ASoC: amd: acp: refactor codec config count in SOF SoundWire machine driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc_sdw_utils.h           | 3 ++-
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 2 +-
 sound/soc/amd/acp/acp-sdw-sof-mach.c    | 2 +-
 sound/soc/intel/boards/sof_sdw.c        | 2 +-
 sound/soc/sdw_utils/soc_sdw_utils.c     | 5 ++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/sound/soc_sdw_utils.h b/include/sound/soc_sdw_utils.h
index f27019f1b4e51..ea8b8adf33b7f 100644
--- a/include/sound/soc_sdw_utils.h
+++ b/include/sound/soc_sdw_utils.h
@@ -177,7 +177,8 @@ int asoc_sdw_count_sdw_endpoints(struct snd_soc_card *card,
 struct asoc_sdw_dailink *asoc_sdw_find_dailink(struct asoc_sdw_dailink *dailinks,
 					       const struct snd_soc_acpi_endpoint *new);
 
-int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
+int asoc_sdw_parse_sdw_endpoints(struct device *dev,
+				 struct asoc_sdw_mc_private *ctx,
 				 struct snd_soc_aux_dev *soc_aux,
 				 struct asoc_sdw_dailink *soc_dais,
 				 struct asoc_sdw_endpoint *soc_ends,
diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 5a62e4a116311..1eebdaa2f80b9 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -428,7 +428,7 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	if (!soc_aux)
 		return -ENOMEM;
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, soc_aux, soc_dais, soc_ends, &num_confs);
+	ret = asoc_sdw_parse_sdw_endpoints(dev, ctx, soc_aux, soc_dais, soc_ends, &num_confs);
 	if (ret < 0)
 		return ret;
 
diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index 9213f2b1208cb..616cf0f763529 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -312,7 +312,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	if (!sof_aux)
 		return -ENOMEM;
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, sof_aux, sof_dais, sof_ends, &num_devs);
+	ret = asoc_sdw_parse_sdw_endpoints(dev, ctx, sof_aux, sof_dais, sof_ends, &num_devs);
 	if (ret < 0)
 		return ret;
 
diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 0be07ea03f512..e27bfc0196d7b 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -1208,7 +1208,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		goto err_dai;
 	}
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, sof_aux, sof_dais, sof_ends, &num_confs);
+	ret = asoc_sdw_parse_sdw_endpoints(dev, ctx, sof_aux, sof_dais, sof_ends, &num_confs);
 	if (ret < 0)
 		goto err_end;
 
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 7336375cd386d..8729e00826959 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1356,14 +1356,13 @@ static int is_sdca_endpoint_present(struct device *dev,
 	return ret;
 }
 
-int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
+int asoc_sdw_parse_sdw_endpoints(struct device *dev,
+				 struct asoc_sdw_mc_private *ctx,
 				 struct snd_soc_aux_dev *soc_aux,
 				 struct asoc_sdw_dailink *soc_dais,
 				 struct asoc_sdw_endpoint *soc_ends,
 				 int *num_devs)
 {
-	struct device *dev = card->dev;
-	struct asoc_sdw_mc_private *ctx = snd_soc_card_get_drvdata(card);
 	struct snd_soc_acpi_mach *mach = dev_get_platdata(dev);
 	struct snd_soc_acpi_mach_params *mach_params = &mach->mach_params;
 	const struct snd_soc_acpi_link_adr *adr_link;
-- 
2.53.0



