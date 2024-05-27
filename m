Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632991EEF7;
	Mon, 27 May 2024 19:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838355; cv=none; b=H2r0fbhEmNsRtq3HRxR+bLXEz1e1Z5uV9/Hybu69F4p9n5bQ0OnSh41nmswNHUhHlc+0k+KVJAdqoxH4QqKfY9NJrwQwO3QKL83NZt3dqfQ+Gmi/rNnYUcdrzvkv8US0/+fBThO8SY/8CfF0CrTW0KTsA55iUmyM7QFqntMYX74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838355; c=relaxed/simple;
	bh=N4XWH7NlM1c60ET62CW6kaI7JaWeW73mCh8b7+1u8AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIZuLbFGEutBqc1Cyht8wAYHnJXzICXnRW/aaDd4tYYQTVpHcKcbDXtB0Ih5ilSgVOdJZGy+H1O3gau1aaZ14GA7nGy4yFFIu8jR2y+q5zBT0P9oSK3soD4PkpOlf2FovNzWP5Vo+QnBlz2emAF+syaM0hrePljLs0blQs9oATw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBao7iBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBao7iBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0A8C2BBFC;
	Mon, 27 May 2024 19:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838355;
	bh=N4XWH7NlM1c60ET62CW6kaI7JaWeW73mCh8b7+1u8AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBao7iBINTvdm6C4tXub8vSMLPTrF0zrcayJLHydlVIwKOo8WNHz87k+x9aRdrvuJ
	 qo2YuE/4765wOyi1aBMtMeXqaeKIVn+hUmzzS6UdwcrUKuBId4vcjLh4aOqNbW1Jtm
	 8dbf7pzzJB3o5h/wOyf4eDynPnAGbETOrdv+WAXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 362/493] ASoC: Intel: Disable route checks for Skylake boards
Date: Mon, 27 May 2024 20:56:04 +0200
Message-ID: <20240527185642.118493975@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 540f7a29310a9..3fe3f38c6cb69 100644
--- a/sound/soc/intel/boards/bxt_da7219_max98357a.c
+++ b/sound/soc/intel/boards/bxt_da7219_max98357a.c
@@ -768,6 +768,7 @@ static struct snd_soc_card broxton_audio_card = {
 	.dapm_routes = audio_map,
 	.num_dapm_routes = ARRAY_SIZE(audio_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = bxt_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/bxt_rt298.c b/sound/soc/intel/boards/bxt_rt298.c
index c0eb65c14aa97..afc499be8db26 100644
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
index 657e4658234ce..4098b2d32f9bc 100644
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
index a5d8965303a88..9dbc15f9d1c9b 100644
--- a/sound/soc/intel/boards/kbl_da7219_max98357a.c
+++ b/sound/soc/intel/boards/kbl_da7219_max98357a.c
@@ -639,6 +639,7 @@ static struct snd_soc_card kabylake_audio_card_da7219_m98357a = {
 	.dapm_routes = kabylake_map,
 	.num_dapm_routes = ARRAY_SIZE(kabylake_map),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/kbl_da7219_max98927.c b/sound/soc/intel/boards/kbl_da7219_max98927.c
index 98c11ec0adc01..e662da5af83b5 100644
--- a/sound/soc/intel/boards/kbl_da7219_max98927.c
+++ b/sound/soc/intel/boards/kbl_da7219_max98927.c
@@ -1036,6 +1036,7 @@ static struct snd_soc_card kbl_audio_card_da7219_m98927 = {
 	.codec_conf = max98927_codec_conf,
 	.num_configs = ARRAY_SIZE(max98927_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
@@ -1054,6 +1055,7 @@ static struct snd_soc_card kbl_audio_card_max98927 = {
 	.codec_conf = max98927_codec_conf,
 	.num_configs = ARRAY_SIZE(max98927_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
@@ -1071,6 +1073,7 @@ static struct snd_soc_card kbl_audio_card_da7219_m98373 = {
 	.codec_conf = max98373_codec_conf,
 	.num_configs = ARRAY_SIZE(max98373_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
@@ -1088,6 +1091,7 @@ static struct snd_soc_card kbl_audio_card_max98373 = {
 	.codec_conf = max98373_codec_conf,
 	.num_configs = ARRAY_SIZE(max98373_codec_conf),
 	.fully_routed = true,
+	.disable_route_checks = true,
 	.late_probe = kabylake_card_late_probe,
 };
 
diff --git a/sound/soc/intel/boards/kbl_rt5660.c b/sound/soc/intel/boards/kbl_rt5660.c
index 30e0aca161cd5..894d127c482a3 100644
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
index 9071b1f1cbd00..646e8ff8e9619 100644
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
index 178fe9c37df62..924d5d1de03ac 100644
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
index 6e172719c9795..4aa7fd2a05e46 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -227,6 +227,8 @@ static int skl_hda_audio_probe(struct platform_device *pdev)
 	ctx->common_hdmi_codec_drv = mach->mach_params.common_hdmi_codec_drv;
 
 	hda_soc_card.dev = &pdev->dev;
+	if (!snd_soc_acpi_sof_parent(&pdev->dev))
+		hda_soc_card.disable_route_checks = true;
 
 	if (mach->mach_params.dmic_num > 0) {
 		snprintf(hda_soc_components, sizeof(hda_soc_components),
diff --git a/sound/soc/intel/boards/skl_nau88l25_max98357a.c b/sound/soc/intel/boards/skl_nau88l25_max98357a.c
index 0e7025834594a..e4630c33176e2 100644
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
index c59c60e280916..9a80442749081 100644
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



