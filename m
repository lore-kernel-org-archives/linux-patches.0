Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEFD1EE02F;
	Tue, 30 Sep 2025 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244605; cv=none; b=MMLMLFT2wChAS90JwC4JdvWzMcmRyGYIRdlBtJ6GZYHeezoasrCiri+zLNijHs/8pSch5gzDCeJC13StwaXY18RQ1w4hhtovf7larCF+Yv37WpUv7dcJKvuj3X+PzteAgaL3q54m7LldyF8I51X9Ir+ONLFw2MvbhcDcljMHO+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244605; c=relaxed/simple;
	bh=9DO1Uj1IlTI0QrCo2CbLr3ezWwVr4r3uttdGi2/E2tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnrmFgNBwDpw6JBG6RVPqjjrM4QFCVddPp0OdWQFUNT57cTmeG2NAuhLoeVsfimit11il7DCFHKT/8Owh+0RfMoyAp5X0HZ/yHYQHeQadhwHy/rFG5O8d++94CYYFv2tHP6Cn0utRk/y5aR+6l1axyhxrOIFW79m49aCy3QhfSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T338kGJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T338kGJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87202C4CEF0;
	Tue, 30 Sep 2025 15:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244604;
	bh=9DO1Uj1IlTI0QrCo2CbLr3ezWwVr4r3uttdGi2/E2tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T338kGJJDOHXZAp/Zi3Yd+d7YYRAirsqOJ2Ps5glQF1J6BJsNrMOiN1wcH7BS7lDL
	 c0qSaDUQoRFmiAvrkeEVFBzqcXwPswf8jmwc3eYTPMXodBwL+FDHKv3EhBNIaOEYPW
	 Tw4B6o12so/4CkXmfr5VHiiDiBnJEee6hjnKf15U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamurugan C <balamurugan.c@intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 027/143] ASoC: Intel: soc-acpi: Add entry for HDMI_In capture support in PTL match table
Date: Tue, 30 Sep 2025 16:45:51 +0200
Message-ID: <20250930143832.325884366@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balamurugan C <balamurugan.c@intel.com>

[ Upstream commit fb00ab1f39369e49d25c74f0d41e4c1ec2f12576 ]

Adding HDMI-In capture via I2S feature support in PTL platform.

Signed-off-by: Balamurugan C <balamurugan.c@intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250708080030.1257790-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 03aa2ed9e187 ("ASoC: Intel: sof_rt5682: Add HDMI-In capture with rt5682 support for PTL.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c               | 10 ++++++++++
 sound/soc/intel/common/soc-acpi-intel-ptl-match.c | 12 ++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index a0b3679b17b42..1211a2b8a2a2c 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -826,6 +826,16 @@ static const struct platform_device_id board_ids[] = {
 					SOF_ES8336_SPEAKERS_EN_GPIO1_QUIRK |
 					SOF_ES8336_JD_INVERTED),
 	},
+	{
+		.name = "ptl_es83x6_c1_h02",
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
diff --git a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
index ff4f2fbf9271d..67f1091483dce 100644
--- a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
@@ -26,6 +26,11 @@ static const struct snd_soc_acpi_codecs ptl_essx_83x6 = {
 	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
 };
 
+static const struct snd_soc_acpi_codecs ptl_lt6911_hdmi = {
+	.num_codecs = 1,
+	.codecs = {"INTC10B0"}
+};
+
 struct snd_soc_acpi_mach snd_soc_acpi_intel_ptl_machines[] = {
 	{
 		.comp_ids = &ptl_rt5682_rt5682s_hp,
@@ -34,6 +39,13 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_ptl_machines[] = {
 		.tplg_quirk_mask = SND_SOC_ACPI_TPLG_INTEL_AMP_NAME |
 					SND_SOC_ACPI_TPLG_INTEL_CODEC_NAME,
 	},
+	{
+		.comp_ids = &ptl_essx_83x6,
+		.drv_name = "ptl_es83x6_c1_h02",
+		.machine_quirk = snd_soc_acpi_codec_list,
+		.quirk_data = &ptl_lt6911_hdmi,
+		.sof_tplg_filename = "sof-ptl-es83x6-ssp1-hdmi-ssp02.tplg",
+	},
 	{
 		.comp_ids = &ptl_essx_83x6,
 		.drv_name = "sof-essx8336",
-- 
2.51.0



