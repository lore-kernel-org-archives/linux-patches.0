Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A1D241F8
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGo9kbIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EC7C433C8;
	Mon, 16 Oct 2023 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697466348;
	bh=oewounC5tn8kx7cbd9qrQMdcFhqqp2R4EBXCbShujB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGo9kbIRxHdFMTpzLSocn9JsgbYhlb/i3xyefFip0D0iw1t6E06WiQj5H663d8adp
	 kwmpO86wKyjQpQ5dHpWV9ZiJIRNKa5jXLb3YIwQWMXu7TqeQmRIA8j6U0MYDfQKeNc
	 ka3/Cx/PnKTGe3cXjL+tdv4IMgzGPrPaS+zG6nJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamurugan C <balamurugan.c@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 034/191] ASoC: Intel: soc-acpi: Add entry for HDMI_In capture support in MTL match table
Date: Mon, 16 Oct 2023 10:40:19 +0200
Message-ID: <20231016084016.194227867@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balamurugan C <balamurugan.c@intel.com>

commit d1f67278d4b2de3bf544ea9bcd9f64d03584df87 upstream.

Adding HDMI-In capture via I2S feature support in MTL platform.

Signed-off-by: Balamurugan C <balamurugan.c@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20230919091136.1922253-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/sof_es8336.c               |   10 ++++++++++
 sound/soc/intel/common/soc-acpi-intel-mtl-match.c |   12 ++++++++++++
 2 files changed, 22 insertions(+)

--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -798,6 +798,16 @@ static const struct platform_device_id b
 					SOF_ES8336_SPEAKERS_EN_GPIO1_QUIRK |
 					SOF_ES8336_JD_INVERTED),
 	},
+	{
+		.name = "mtl_es83x6_c1_h02",
+		.driver_data = (kernel_ulong_t)(SOF_ES8336_SSP_CODEC(1) |
+					SOF_NO_OF_HDMI_CAPTURE_SSP(2) |
+					SOF_HDMI_CAPTURE_1_SSP(0) |
+					SOF_HDMI_CAPTURE_2_SSP(2) |
+					SOF_SSP_HDMI_CAPTURE_PRESENT |
+					SOF_ES8336_SPEAKERS_EN_GPIO1_QUIRK |
+					SOF_ES8336_JD_INVERTED),
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(platform, board_ids);
--- a/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-mtl-match.c
@@ -30,6 +30,11 @@ static const struct snd_soc_acpi_codecs
 	.codecs = {"10EC5682", "RTL5682"},
 };
 
+static const struct snd_soc_acpi_codecs mtl_lt6911_hdmi = {
+	.num_codecs = 1,
+	.codecs = {"INTC10B0"}
+};
+
 struct snd_soc_acpi_mach snd_soc_acpi_intel_mtl_machines[] = {
 	{
 		.comp_ids = &mtl_rt5682_rt5682s_hp,
@@ -46,6 +51,13 @@ struct snd_soc_acpi_mach snd_soc_acpi_in
 		.sof_tplg_filename = "sof-mtl-max98360a-rt5682.tplg",
 	},
 	{
+		.comp_ids = &mtl_essx_83x6,
+		.drv_name = "mtl_es83x6_c1_h02",
+		.machine_quirk = snd_soc_acpi_codec_list,
+		.quirk_data = &mtl_lt6911_hdmi,
+		.sof_tplg_filename = "sof-mtl-es83x6-ssp1-hdmi-ssp02.tplg",
+	},
+	{
 		.comp_ids = &mtl_rt5682_rt5682s_hp,
 		.drv_name = "mtl_rt1019_rt5682",
 		.machine_quirk = snd_soc_acpi_codec_list,


