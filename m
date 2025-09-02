Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F99313E04;
	Tue,  2 Sep 2025 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820718; cv=none; b=YKGI1EYOuUra5OoQpe09KIvDobFxajPdo/4RQFwKhdHDiTTiTJzZOVhCUbR7PX1rJRFdfxbOcpediLtDNPX7zWKtBxGg2ntJtk9R/HQW1ll221AkSNIyTBD2+f05RapphRWIUjyKIt4EXDQIgXfJXAaRp3jpZDLsv0heFxitlZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820718; c=relaxed/simple;
	bh=o8+IxMjTOm+KPh/ZWLmaLAUmAAF1snULUXLUxlRP9rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=svTnddDfr8HhfHG0YMoGYT/akPahcdYb1m6+d+bVcWnHie2UvYgCwfCi4U0hTLxoRVJ/vkaTBnY9WAKi2/fPxaWUCOXl69BWCrJpdzSvQxFfAon8frYCbT2W+Uj8RihJT3N/Yb9q/taXYFxDblWnaBv8BHSms48mV1ssQVVD/Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5tyddgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5tyddgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D04CC4CEED;
	Tue,  2 Sep 2025 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820716;
	bh=o8+IxMjTOm+KPh/ZWLmaLAUmAAF1snULUXLUxlRP9rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5tyddgC6jvN76XgRcsOaSnSafwrCCbBDJ00RPV1FMNKk+Quf2TkKZv9H/IPUQAAf
	 jZ/HkGwwIAq36lStRRhf7WOmcd0/jzlUoZYvsM9Mb/nXb6RwF9R5TayWslQZnbIvce
	 vGtjBtqu+rnAD5hppEN3e7ZwoGjnUY/HASrwgcec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Paul Olaru <paul.olaru@oss.nxp.com>,
	Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Micha=C5=82=20G=C3=B3rny?= <mgorny@gentoo.org>
Subject: [PATCH 5.10 31/34] ASoC: Intel: sof_rt5682: shrink platform_id names below 20 characters
Date: Tue,  2 Sep 2025 15:21:57 +0200
Message-ID: <20250902131927.851507657@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 590cfb082837cc6c0c595adf1711330197c86a58 upstream.

Some Chromebooks machine driver aliases exceed 20 characters, which
leads to sparse warnings:

sound/soc/intel/boards/sof_rt5682.c:959:25: error: too long
initializer-string for array of char(no space for nul char)

sound/soc/intel/boards/sof_rt5682.c:989:25: error: too long
initializer-string for array of char(no space for nul char)

sound/soc/intel/boards/sof_rt5682.c:1039:25: error: too long
initializer-string for array of char(no space for nul char)

Fix by using the 'mx' shortcut for Maxim platforms (already used in
platform firmware)

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Paul Olaru <paul.olaru@oss.nxp.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Link: https://lore.kernel.org/r/20210621194057.21711-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Michał Górny <mgorny@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_rt5682.c               |   12 ++++++------
 sound/soc/intel/common/soc-acpi-intel-jsl-match.c |    2 +-
 sound/soc/intel/common/soc-acpi-intel-tgl-match.c |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -844,7 +844,7 @@ static const struct platform_device_id b
 		.name = "sof_rt5682",
 	},
 	{
-		.name = "tgl_max98357a_rt5682",
+		.name = "tgl_mx98357a_rt5682",
 		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
 					SOF_RT5682_SSP_CODEC(0) |
 					SOF_SPEAKER_AMP_PRESENT |
@@ -861,7 +861,7 @@ static const struct platform_device_id b
 					SOF_RT5682_SSP_AMP(1)),
 	},
 	{
-		.name = "tgl_max98373_rt5682",
+		.name = "tgl_mx98373_rt5682",
 		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
 					SOF_RT5682_SSP_CODEC(0) |
 					SOF_SPEAKER_AMP_PRESENT |
@@ -870,7 +870,7 @@ static const struct platform_device_id b
 					SOF_RT5682_NUM_HDMIDEV(4)),
 	},
 	{
-		.name = "jsl_rt5682_max98360a",
+		.name = "jsl_rt5682_mx98360a",
 		.driver_data = (kernel_ulong_t)(SOF_RT5682_MCLK_EN |
 					SOF_RT5682_MCLK_24MHZ |
 					SOF_RT5682_SSP_CODEC(0) |
@@ -898,7 +898,7 @@ MODULE_AUTHOR("Bard Liao <bard.liao@inte
 MODULE_AUTHOR("Sathya Prakash M R <sathya.prakash.m.r@intel.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:sof_rt5682");
-MODULE_ALIAS("platform:tgl_max98357a_rt5682");
+MODULE_ALIAS("platform:tgl_mx98357a_rt5682");
 MODULE_ALIAS("platform:jsl_rt5682_rt1015");
-MODULE_ALIAS("platform:tgl_max98373_rt5682");
-MODULE_ALIAS("platform:jsl_rt5682_max98360a");
+MODULE_ALIAS("platform:tgl_mx98373_rt5682");
+MODULE_ALIAS("platform:jsl_rt5682_mx98360a");
--- a/sound/soc/intel/common/soc-acpi-intel-jsl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-jsl-match.c
@@ -54,7 +54,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 	},
 	{
 		.id = "10EC5682",
-		.drv_name = "jsl_rt5682_max98360a",
+		.drv_name = "jsl_rt5682_mx98360a",
 		.sof_fw_filename = "sof-jsl.ri",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &mx98360a_spk,
--- a/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-tgl-match.c
@@ -321,7 +321,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 	},
 	{
 		.id = "10EC5682",
-		.drv_name = "tgl_max98357a_rt5682",
+		.drv_name = "tgl_mx98357a_rt5682",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &tgl_codecs,
 		.sof_fw_filename = "sof-tgl.ri",
@@ -329,7 +329,7 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 	},
 	{
 		.id = "10EC5682",
-		.drv_name = "tgl_max98373_rt5682",
+		.drv_name = "tgl_mx98373_rt5682",
 		.machine_quirk = snd_soc_acpi_codec_list,
 		.quirk_data = &tgl_max98373_amp,
 		.sof_fw_filename = "sof-tgl.ri",


