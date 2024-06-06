Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3B51AC258;
	Thu,  6 Jun 2024 14:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683317; cv=none; b=jSZjJQDrU8OOVb2B8lM9QLky7uEeHMxeqXqHDbEZDf64C5LIEy4kdTB8aVRwMoVuEtuWVyPMyOgDWcVvCOatPFmAEmiM5qc4OshRhQEZmDNF5wIZeKYxJLSwhSHFea1JAWp3gGCvZQtrvqDALbfBB8YzlRKQRDhFD8MAZjN6204=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683317; c=relaxed/simple;
	bh=/KUzxslR0lTSpiFYvXywX8zr/1QN9ZozzSpIoVwUgxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/3OTpcicZoQaI6hgZUdfG3RgFfcBcE3V7rPg8eiFP5zNTUGg0MIJWNTswrZK4YE+aSKmpOw4YjCnSuvWeSzaCx5MNIwxhvQ7hmsXzJg6kKyJwLk4AD8K6JmZWm26/jQxG/2k19STC/NFrHTb0OFSoHI6j7jQBanriwX+xSyCsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHXO3NfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHXO3NfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CC0C2BD10;
	Thu,  6 Jun 2024 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683317;
	bh=/KUzxslR0lTSpiFYvXywX8zr/1QN9ZozzSpIoVwUgxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHXO3NfJtq6gNyklZbpi4FrHBewXYl9O1gZ+YtLzmOdJdzpTzzZbhkE88uM27zvex
	 3hzM/etvivYVkuxZPgkR0Xe+aroYD02htOqGBlxyr6STvQ3JxMaKQQ7UpYvWcN8rOd
	 K9Z+K2dAFKM32Xf0ZA218QrS5xuVLg3fEXdgf0y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/473] ASoC: Intel: Disable route checks for Skylake boards
Date: Thu,  6 Jun 2024 16:02:06 +0200
Message-ID: <20240606131706.457645389@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 0cb3b7fd530b8c107443218ce6db5cb6e7b5dbe1 ]

Topology files that are propagated to the world and utilized by the
skylake-driver carry shortcomings in their SectionGraphs.

Since commit daa480bde6b3 ("ASoC: soc-core: tidyup for
snd_soc_dapm_add_routes()") route checks are no longer permissive. Probe
failures for Intel boards have been partially addressed by commit
a22ae72b86a4 ("ASoC: soc-core: disable route checks for legacy devices")
and its follow up but only skl_nau88l25_ssm4567.c is patched. Fix the
problem for the rest of the boards.

Link: https://lore.kernel.org/all/20200309192744.18380-1-pierre-louis.bossart@linux.intel.com/
Fixes: daa480bde6b3 ("ASoC: soc-core: tidyup for snd_soc_dapm_add_routes()")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240308090502.2136760-2-cezary.rojewski@intel.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bxt_da7219_max98357a.c       | 1 +
 sound/soc/intel/boards/bxt_rt298.c                  | 1 +
 sound/soc/intel/boards/glk_rt5682_max98357a.c       | 2 ++
 sound/soc/intel/boards/kbl_da7219_max98357a.c       | 1 +
 sound/soc/intel/boards/kbl_da7219_max98927.c        | 4 ++++
 sound/soc/intel/boards/kbl_rt5660.c                 | 1 +
 sound/soc/intel/boards/kbl_rt5663_max98927.c        | 2 ++
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c | 1 +
 sound/soc/intel/boards/skl_hda_dsp_generic.c        | 2 ++
 sound/soc/intel/boards/skl_nau88l25_max98357a.c     | 1 +
 sound/soc/intel/boards/skl_rt286.c                  | 1 +
 11 files changed, 17 insertions(+)

diff --git a/sound/soc/intel/boards/bxt_da7219_max98357a.c b/sound/soc/intel/boards/bxt_da7219_max98357a.c
index 7c6c95e99ade2..420c8b2588c17 100644
--- a/sound/soc/intel/boards/bxt_da7219_max98357a.c
+++ b/sound/soc/intel/boards/bxt_da7219_max98357a.c
@@ -762,6 +762,7 @@ static struct snd_soc_card broxton_audio_card = {
 	.dapm_routes = audio_map,
 	.num_dapm_routes = ARRAY_SIZE(audio_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = bxt_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/bxt_rt298.c b/sound/soc/intel/boards/bxt_rt298.c
index 4bd93c3ba3777..ea45baaaaaed9 100644
--- a/sound/soc/intel/boards/bxt_rt298.c
+++ b/sound/soc/intel/boards/bxt_rt298.c
@@ -574,6 +574,7 @@ static struct snd_soc_card broxton_rt298 = {
 	.dapm_routes = broxton_rt298_map,
 	.num_dapm_routes = ARRAY_SIZE(broxton_rt298_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = bxt_card_late_probe,
 
 };
diff --git a/sound/soc/intel/boards/glk_rt5682_max98357a.c b/sound/soc/intel/boards/glk_rt5682_max98357a.c
index cf0f89db3e204..0f9bbb970b230 100644
--- a/sound/soc/intel/boards/glk_rt5682_max98357a.c
+++ b/sound/soc/intel/boards/glk_rt5682_max98357a.c
@@ -649,6 +649,8 @@ static int geminilake_audio_probe(struct platform_device *pdev)
 	card = &glk_audio_card_rt5682_m98357a;
 	card->dev = &pdev->dev;
 	snd_soc_card_set_drvdata(card, ctx);
+	if (!snd_soc_acpi_sof_parent(&pdev->dev))
+		card->disable_route_checks = true;
 
 	/* override platform name, if required */
 	mach = pdev->dev.platform_data;
diff --git a/sound/soc/intel/boards/kbl_da7219_max98357a.c b/sound/soc/intel/boards/kbl_da7219_max98357a.c
index 329457e3e3a22..c990baed8013b 100644
--- a/sound/soc/intel/boards/kbl_da7219_max98357a.c
+++ b/sound/soc/intel/boards/kbl_da7219_max98357a.c
@@ -633,6 +633,7 @@ static struct snd_soc_card kabylake_audio_card_da7219_m98357a = {
 	.dapm_routes = kabylake_map,
 	.num_dapm_routes = ARRAY_SIZE(kabylake_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/kbl_da7219_max98927.c b/sound/soc/intel/boards/kbl_da7219_max98927.c
index 362579f25835e..7ab80ba264cb5 100644
--- a/sound/soc/intel/boards/kbl_da7219_max98927.c
+++ b/sound/soc/intel/boards/kbl_da7219_max98927.c
@@ -1030,6 +1030,7 @@ static struct snd_soc_card kbl_audio_card_da7219_m98927 = {
 	.codec_conf = max98927_codec_conf,
 	.num_configs = ARRAY_SIZE(max98927_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
@@ -1048,6 +1049,7 @@ static struct snd_soc_card kbl_audio_card_max98927 = {
 	.codec_conf = max98927_codec_conf,
 	.num_configs = ARRAY_SIZE(max98927_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
@@ -1065,6 +1067,7 @@ static struct snd_soc_card kbl_audio_card_da7219_m98373 = {
 	.codec_conf = max98373_codec_conf,
 	.num_configs = ARRAY_SIZE(max98373_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
@@ -1082,6 +1085,7 @@ static struct snd_soc_card kbl_audio_card_max98373 = {
 	.codec_conf = max98373_codec_conf,
 	.num_configs = ARRAY_SIZE(max98373_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/kbl_rt5660.c b/sound/soc/intel/boards/kbl_rt5660.c
index 2c7a547f63c90..358d606228121 100644
--- a/sound/soc/intel/boards/kbl_rt5660.c
+++ b/sound/soc/intel/boards/kbl_rt5660.c
@@ -518,6 +518,7 @@ static struct snd_soc_card kabylake_audio_card_rt5660 = {
 	.dapm_routes = kabylake_rt5660_map,
 	.num_dapm_routes = ARRAY_SIZE(kabylake_rt5660_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/kbl_rt5663_max98927.c b/sound/soc/intel/boards/kbl_rt5663_max98927.c
index 2d4224c5b1520..d110ebd10bca2 100644
--- a/sound/soc/intel/boards/kbl_rt5663_max98927.c
+++ b/sound/soc/intel/boards/kbl_rt5663_max98927.c
@@ -966,6 +966,7 @@ static struct snd_soc_card kabylake_audio_card_rt5663_m98927 = {
 	.codec_conf = max98927_codec_conf,
 	.num_configs = ARRAY_SIZE(max98927_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
@@ -982,6 +983,7 @@ static struct snd_soc_card kabylake_audio_card_rt5663 = {
 	.dapm_routes = kabylake_5663_map,
 	.num_dapm_routes = ARRAY_SIZE(kabylake_5663_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
index 2c79fca57b19e..a15d2c30b6c46 100644
--- a/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
+++ b/sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c
@@ -791,6 +791,7 @@ static struct snd_soc_card kabylake_audio_card = {
 	.codec_conf = max98927_codec_conf,
 	.num_configs = ARRAY_SIZE(max98927_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/skl_hda_dsp_generic.c b/sound/soc/intel/boards/skl_hda_dsp_generic.c
index 463ffb85121d3..2e1c1e4013c3f 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -231,6 +231,8 @@ static int skl_hda_audio_probe(struct platform_device *pdev)
 	ctx->common_hdmi_codec_drv = mach->mach_params.common_hdmi_codec_drv;
 
 	hda_soc_card.dev = &pdev->dev;
+	if (!snd_soc_acpi_sof_parent(&pdev->dev))
+		hda_soc_card.disable_route_checks = true;
 
 	if (mach->mach_params.dmic_num > 0) {
 		snprintf(hda_soc_components, sizeof(hda_soc_components),
diff --git a/sound/soc/intel/boards/skl_nau88l25_max98357a.c b/sound/soc/intel/boards/skl_nau88l25_max98357a.c
index 8dceb0b025812..8180afb4505bc 100644
--- a/sound/soc/intel/boards/skl_nau88l25_max98357a.c
+++ b/sound/soc/intel/boards/skl_nau88l25_max98357a.c
@@ -654,6 +654,7 @@ static struct snd_soc_card skylake_audio_card = {
 	.dapm_routes = skylake_map,
 	.num_dapm_routes = ARRAY_SIZE(skylake_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = skylake_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/skl_rt286.c b/sound/soc/intel/boards/skl_rt286.c
index 4f3d655e2bfa8..0a4795a94a768 100644
--- a/sound/soc/intel/boards/skl_rt286.c
+++ b/sound/soc/intel/boards/skl_rt286.c
@@ -523,6 +523,7 @@ static struct snd_soc_card skylake_rt286 = {
 	.dapm_routes = skylake_rt286_map,
 	.num_dapm_routes = ARRAY_SIZE(skylake_rt286_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = skylake_card_late_probe,
 };
 
-- 
2.43.0



