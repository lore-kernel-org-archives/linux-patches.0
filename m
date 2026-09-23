Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DEA53F6A1;
	Wed, 23 Sep 2026 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174667; cv=none; b=kAA/8WeYz7VZkiQrO5xFP9Sg3rVabnzrLy8sbnvrSVVar4dvo3wsl0Ifu9VYhVO092qSnlxWXAjQNZCdhVx5X6hoixaj8PjzWY/s9zrTxb5vp8ApKz/Fx1db+fjkWrt4fqa/GCedlvKo5V5lcBwlHV4AHRIR8+P0ZOZyRZpGanE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174667; c=relaxed/simple;
	bh=IfSiO7E3AdpKJmmiwBepdAxY3nbDuRywLhrGKe8noGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct3+cVoup8VRNyhw4s2wADxQ0+0VYkSzlknmQQwZy6AAlQe3C/kY+ZzzrikYM7guLHGX+XXpep4GdXjKiYKikdcJhQNI16J0MxkKuIjdha70qDDecBaLFCAwyhywHgGmu0hMa2YnR5kuMo8D/FPlZm+AVejhk7WXIMLnCPlt7zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx5HD6YT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx5HD6YT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6951F0089B;
	Wed, 23 Sep 2026 14:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174665;
	bh=wgomWhRUCRnkE42hOwGHeww9jN+b+NORCjI8TSdV++M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hx5HD6YTk5i4FR73Xa/+pwP8e7+WMjJG0PrUXzjCtToczbl1TbgFEmZFDCDQhn6vi
	 NMwSJVzntuhWz0ulqZ2GfMBztS3j4WmCEiVTFCpeJvBzt1BG8kRxC1YsW8C1F70l90
	 CIp1hdhOpFXO7ZXlQqoxClx9zXifu2iWbV0MIRpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/398] ASoC: intel: sof_sdw: Add ability to have auxiliary devices
Date: Wed, 23 Sep 2026 16:04:04 +0200
Message-ID: <20260923140647.842088249@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit c66297d09e1a5813eb743bae8cda4e115b8a5c56 ]

Currently the sof_sdw machine driver assumes that all devices involved
in the sound card are connected through a DAI link. However for SDCA
devices we still want the HID (Human Interface Device, used for jack
buttons) to be part of the sound card, but it contains no DAI links.

Add support into the machine driver to specify a list of auxiliary
devices to merged into the card.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251127163426.2500633-6-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0b7d55d3a912 ("ASoC: amd: acp: refactor codec config count in SOF SoundWire machine driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc_sdw_utils.h           | 11 ++++++++++-
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 12 ++++++++++--
 sound/soc/amd/acp/acp-sdw-sof-mach.c    | 12 ++++++++++--
 sound/soc/intel/boards/sof_sdw.c        | 14 ++++++++++++--
 sound/soc/sdw_utils/soc_sdw_utils.c     | 23 ++++++++++++++++++++---
 5 files changed, 62 insertions(+), 10 deletions(-)

diff --git a/include/sound/soc_sdw_utils.h b/include/sound/soc_sdw_utils.h
index 3c5e9b2af7f1a..7badbd1d32319 100644
--- a/include/sound/soc_sdw_utils.h
+++ b/include/sound/soc_sdw_utils.h
@@ -13,6 +13,7 @@
 #include <sound/soc-acpi.h>
 
 #define SOC_SDW_MAX_DAI_NUM             8
+#define SOC_SDW_MAX_AUX_NUM		2
 #define SOC_SDW_MAX_NO_PROPS		2
 #define SOC_SDW_JACK_JDSRC(quirk)	((quirk) & GENMASK(3, 0))
 
@@ -64,6 +65,10 @@ struct asoc_sdw_dai_info {
 	bool quirk_exclude;
 };
 
+struct asoc_sdw_aux_info {
+	const char *codec_name;
+};
+
 struct asoc_sdw_codec_info {
 	const int part_id;
 	const int version_id;
@@ -74,6 +79,8 @@ struct asoc_sdw_codec_info {
 	const struct snd_soc_ops *ops;
 	struct asoc_sdw_dai_info dais[SOC_SDW_MAX_DAI_NUM];
 	const int dai_num;
+	struct asoc_sdw_aux_info auxs[SOC_SDW_MAX_AUX_NUM];
+	const int aux_num;
 
 	int (*codec_card_late_probe)(struct snd_soc_card *card);
 
@@ -164,12 +171,14 @@ int asoc_sdw_init_simple_dai_link(struct device *dev, struct snd_soc_dai_link *d
 				  int no_pcm, int (*init)(struct snd_soc_pcm_runtime *rtd),
 				  const struct snd_soc_ops *ops);
 
-int asoc_sdw_count_sdw_endpoints(struct snd_soc_card *card, int *num_devs, int *num_ends);
+int asoc_sdw_count_sdw_endpoints(struct snd_soc_card *card,
+				 int *num_devs, int *num_ends, int *num_aux);
 
 struct asoc_sdw_dailink *asoc_sdw_find_dailink(struct asoc_sdw_dailink *dailinks,
 					       const struct snd_soc_acpi_endpoint *new);
 
 int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
+				 struct snd_soc_aux_dev *soc_aux,
 				 struct asoc_sdw_dailink *soc_dais,
 				 struct asoc_sdw_endpoint *soc_ends,
 				 int *num_devs);
diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index b8a509bbf99a6..5a62e4a116311 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -395,16 +395,18 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	struct snd_soc_acpi_mach_params *mach_params = &mach->mach_params;
 	struct asoc_sdw_endpoint *soc_ends __free(kfree) = NULL;
 	struct asoc_sdw_dailink *soc_dais __free(kfree) = NULL;
+	struct snd_soc_aux_dev *soc_aux;
 	struct snd_soc_codec_conf *codec_conf;
 	struct snd_soc_dai_link *dai_links;
 	int num_devs = 0;
 	int num_ends = 0;
+	int num_aux = 0;
 	int num_confs;
 	int num_links;
 	int be_id = 0;
 	int ret;
 
-	ret = asoc_sdw_count_sdw_endpoints(card, &num_devs, &num_ends);
+	ret = asoc_sdw_count_sdw_endpoints(card, &num_devs, &num_ends, &num_aux);
 	if (ret < 0) {
 		dev_err(dev, "failed to count devices/endpoints: %d\n", ret);
 		return ret;
@@ -422,7 +424,11 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	if (!soc_ends)
 		return -ENOMEM;
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, soc_dais, soc_ends, &num_confs);
+	soc_aux = devm_kcalloc(dev, num_aux, sizeof(*soc_aux), GFP_KERNEL);
+	if (!soc_aux)
+		return -ENOMEM;
+
+	ret = asoc_sdw_parse_sdw_endpoints(card, soc_aux, soc_dais, soc_ends, &num_confs);
 	if (ret < 0)
 		return ret;
 
@@ -448,6 +454,8 @@ static int soc_card_dai_links_create(struct snd_soc_card *card)
 	card->num_configs = num_confs;
 	card->dai_link = dai_links;
 	card->num_links = num_links;
+	card->aux_dev = soc_aux;
+	card->num_aux_devs = num_aux;
 
 	/* SDW */
 	if (sdw_be_num) {
diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index d365c51bb99c1..9213f2b1208cb 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -282,15 +282,17 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	struct snd_soc_acpi_mach_params *mach_params = &mach->mach_params;
 	struct asoc_sdw_endpoint *sof_ends __free(kfree) = NULL;
 	struct asoc_sdw_dailink *sof_dais __free(kfree) = NULL;
+	struct snd_soc_aux_dev *sof_aux;
 	struct snd_soc_codec_conf *codec_conf;
 	struct snd_soc_dai_link *dai_links;
 	int num_devs = 0;
 	int num_ends = 0;
+	int num_aux = 0;
 	int num_links;
 	int be_id = 0;
 	int ret;
 
-	ret = asoc_sdw_count_sdw_endpoints(card, &num_devs, &num_ends);
+	ret = asoc_sdw_count_sdw_endpoints(card, &num_devs, &num_ends, &num_aux);
 	if (ret < 0) {
 		dev_err(dev, "failed to count devices/endpoints: %d\n", ret);
 		return ret;
@@ -306,7 +308,11 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	if (!sof_ends)
 		return -ENOMEM;
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, sof_dais, sof_ends, &num_devs);
+	sof_aux = devm_kcalloc(dev, num_aux, sizeof(*sof_aux), GFP_KERNEL);
+	if (!sof_aux)
+		return -ENOMEM;
+
+	ret = asoc_sdw_parse_sdw_endpoints(card, sof_aux, sof_dais, sof_ends, &num_devs);
 	if (ret < 0)
 		return ret;
 
@@ -332,6 +338,8 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	card->num_configs = num_devs;
 	card->dai_link = dai_links;
 	card->num_links = num_links;
+	card->aux_dev = sof_aux;
+	card->num_aux_devs = num_aux;
 
 	/* SDW */
 	if (sdw_be_num) {
diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 4c2d6a5ede3ff..0be07ea03f512 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -1166,8 +1166,10 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	struct asoc_sdw_codec_info *ssp_info;
 	struct asoc_sdw_endpoint *sof_ends;
 	struct asoc_sdw_dailink *sof_dais;
+	struct snd_soc_aux_dev *sof_aux;
 	int num_devs = 0;
 	int num_ends = 0;
+	int num_aux = 0;
 	int num_confs;
 	struct snd_soc_dai_link *dai_links;
 	int num_links;
@@ -1176,7 +1178,7 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	unsigned long ssp_mask;
 	int ret;
 
-	ret = asoc_sdw_count_sdw_endpoints(card, &num_devs, &num_ends);
+	ret = asoc_sdw_count_sdw_endpoints(card, &num_devs, &num_ends, &num_aux);
 	if (ret < 0) {
 		dev_err(dev, "failed to count devices/endpoints: %d\n", ret);
 		return ret;
@@ -1200,7 +1202,13 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 		goto err_dai;
 	}
 
-	ret = asoc_sdw_parse_sdw_endpoints(card, sof_dais, sof_ends, &num_confs);
+	sof_aux = devm_kcalloc(dev, num_aux, sizeof(*sof_aux), GFP_KERNEL);
+	if (!sof_aux) {
+		ret = -ENOMEM;
+		goto err_dai;
+	}
+
+	ret = asoc_sdw_parse_sdw_endpoints(card, sof_aux, sof_dais, sof_ends, &num_confs);
 	if (ret < 0)
 		goto err_end;
 
@@ -1266,6 +1274,8 @@ static int sof_card_dai_links_create(struct snd_soc_card *card)
 	card->num_configs = num_confs;
 	card->dai_link = dai_links;
 	card->num_links = num_links;
+	card->aux_dev = sof_aux;
+	card->num_aux_devs = num_aux;
 
 	/* SDW */
 	if (sdw_be_num) {
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 9dac810ccc611..80f24a2296f03 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1196,7 +1196,8 @@ int asoc_sdw_init_simple_dai_link(struct device *dev, struct snd_soc_dai_link *d
 }
 EXPORT_SYMBOL_NS(asoc_sdw_init_simple_dai_link, "SND_SOC_SDW_UTILS");
 
-int asoc_sdw_count_sdw_endpoints(struct snd_soc_card *card, int *num_devs, int *num_ends)
+int asoc_sdw_count_sdw_endpoints(struct snd_soc_card *card,
+				 int *num_devs, int *num_ends, int *num_aux)
 {
 	struct device *dev = card->dev;
 	struct snd_soc_acpi_mach *mach = dev_get_platdata(dev);
@@ -1207,8 +1208,18 @@ int asoc_sdw_count_sdw_endpoints(struct snd_soc_card *card, int *num_devs, int *
 	for (adr_link = mach_params->links; adr_link->num_adr; adr_link++) {
 		*num_devs += adr_link->num_adr;
 
-		for (i = 0; i < adr_link->num_adr; i++)
-			*num_ends += adr_link->adr_d[i].num_endpoints;
+		for (i = 0; i < adr_link->num_adr; i++) {
+			const struct snd_soc_acpi_adr_device *adr_dev = &adr_link->adr_d[i];
+			struct asoc_sdw_codec_info *codec_info;
+
+			*num_ends += adr_dev->num_endpoints;
+
+			codec_info = asoc_sdw_find_codec_info_part(adr_dev->adr);
+			if (!codec_info)
+				return -EINVAL;
+
+			*num_aux += codec_info->aux_num;
+		}
 	}
 
 	dev_dbg(dev, "Found %d devices with %d endpoints\n", *num_devs, *num_ends);
@@ -1346,6 +1357,7 @@ static int is_sdca_endpoint_present(struct device *dev,
 }
 
 int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
+				 struct snd_soc_aux_dev *soc_aux,
 				 struct asoc_sdw_dailink *soc_dais,
 				 struct asoc_sdw_endpoint *soc_ends,
 				 int *num_devs)
@@ -1385,6 +1397,11 @@ int asoc_sdw_parse_sdw_endpoints(struct snd_soc_card *card,
 			if (!codec_info)
 				return -EINVAL;
 
+			for (j = 0; j < codec_info->aux_num; j++) {
+				soc_aux->dlc.name = codec_info->auxs[j].codec_name;
+				soc_aux++;
+			}
+
 			ctx->ignore_internal_dmic |= codec_info->ignore_internal_dmic;
 
 			if (codec_info->count_sidecar && codec_info->add_sidecar) {
-- 
2.53.0



