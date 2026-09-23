Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19F749891A;
	Wed, 23 Sep 2026 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173296; cv=none; b=NCVP2obgWXg16GKnwTsCJw1C6Cn0kmTLJ3j56sm5ut1Hs33T5PKkKCLvQTFGh7t5vfRnIFs1jQ9yVGs8IwOktSnGvzRxM8oKzNB+orXMZO1ZzWmqDVnoP1+lge8+sKv53dqIRcFsLL2+iGXRi0MzajFt1Stm07CkxJB/plCkzy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173296; c=relaxed/simple;
	bh=U6LjRR+soQUVq6iHppzmDOea8MIPSeizzbq35uWzxvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXMquSVyCRsIZnspmcg+1V+21c5L8GTpdnaz78gkmjDajBw8f/pTeUETzB8oj+zxv9TTFUy+Lt4LrRoh+XAfyAJmlHCmF6XYtiz+LwXCm28Chm98jrJXXgmV3VUuHNLQ0H96nnoAwDNH8zSMXxtwXmKyrXGIyo0+lTm9FDmd0R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+J3uxVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+J3uxVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1901B1F000FF;
	Wed, 23 Sep 2026 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173294;
	bh=jWoIca9d5pDus1QHiDs9r4KM1+SiE0e5a161u9N7SE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+J3uxVuzTg04ITPf3J0lB6Xdq56R8bEyo2rEKlRy8lY9XL2rMPBYxGcr9lnlZgQy
	 F4gGRr4J8HTBa+0iPZmuhhbsflm6U3wIO1WdRfWXkbW6Ie0Ue/MQDUTdFsWxYGgPmy
	 gR39Hd9rnjA0UqofU1PAJIEXnACV252Pwm7APPPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 202/438] ASoC: sdw_utils: tidyup asoc_sdw_parse_sdw_endpoints()
Date: Wed, 23 Sep 2026 16:03:43 +0200
Message-ID: <20260923140650.000783496@linuxfoundation.org>
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
index 443d63dc6ea37..9b28e9aef4f1d 100644
--- a/include/sound/soc_sdw_utils.h
+++ b/include/sound/soc_sdw_utils.h
@@ -182,7 +182,8 @@ struct asoc_sdw_dailink *asoc_sdw_find_dailink(struct asoc_sdw_dailink *dailinks
 					       const struct snd_soc_acpi_endpoint *new);
 int asoc_sdw_get_dai_type(u32 type);
 
-int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
+int asoc_sdw_parse_sdw_endpoints(struct device *dev,
+				 struct asoc_sdw_mc_private *ctx,
 				 struct snd_soc_aux_dev *soc_aux,
 				 struct asoc_sdw_dailink *soc_dais,
 				 struct asoc_sdw_endpoint *soc_ends,
diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 1a6be664be279..fa31bb848d9df 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -442,7 +442,7 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	if (!soc_aux)
 		return -ENOMEM;
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, soc_aux, soc_dais, soc_ends, &num_confs);
+	ret = asoc_sdw_parse_sdw_endpoints(dev, ctx, soc_aux, soc_dais, soc_ends, &num_confs);
 	if (ret < 0)
 		return ret;
 
diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index f66228435984a..5d0818ca918a0 100644
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
index c527d575d1ed6..1013e07052a37 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -1288,7 +1288,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		goto err_dai;
 	}
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, sof_aux, sof_dais, sof_ends, &num_confs);
+	ret = asoc_sdw_parse_sdw_endpoints(dev, ctx, sof_aux, sof_dais, sof_ends, &num_confs);
 	if (ret < 0)
 		goto err_end;
 
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 982be8a286133..befcad08135e7 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1976,14 +1976,13 @@ static int is_sdca_endpoint_present(struct device *dev,
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



