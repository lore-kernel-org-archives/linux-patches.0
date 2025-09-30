Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F395327C872;
	Tue, 30 Sep 2025 15:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244602; cv=none; b=VA8llEd0tPyiUhnpOsUoNBqeNMsDKFVMtwsfKOrJcQRzGgP608xyLRMWkcNvnv75ZzuKnptCp/u0RdNGfteim8GhPKXUscirK5R9C2nKie7vAR5RFZzBCCRJGJ9ESZduUXzpXOLIc0j3h/TL2NGJUc3Q1B53qJFMvmQD1ouRr18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244602; c=relaxed/simple;
	bh=fIMvwjogKBvHo8d5yph9HcZmBAohQtuZXd+IfRS16tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awVHyqa00BrfgkQwSVDWaJijTTHOrJs+4OlxRIDKo7XUwjzfAlL6YhKxdMr3BKaKLZLOD9U/Sf15XWswQFeAgxDmqJseQxcTkDcuG7ru1AQrtaDxUfBKTd8e8XD4j7d8+J4uQRr5D0kTNR9B9Wb0ZMUG2OaFZJQ1oWexTzPs01E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2joNX6AH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2joNX6AH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77867C4CEF0;
	Tue, 30 Sep 2025 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244601;
	bh=fIMvwjogKBvHo8d5yph9HcZmBAohQtuZXd+IfRS16tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2joNX6AHyWwiznpz/6viWDJlOeIXFxWDwkm/imxSrMiTx5BYvVHfigWfTk9iXJaHf
	 ls8d9rnT5xdjWlwueEwIf+LDsKK/nFqjml8tQSTU+UHfH5+4974b2fKK3ErvwHlss+
	 sGLLtqcFQiMGx8k/bMbBBjDeHLsr0J4gJtrVrQoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamurugan C <balamurugan.c@intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 026/143] ASoC: Intel: soc-acpi: Add entry for sof_es8336 in PTL match table.
Date: Tue, 30 Sep 2025 16:45:50 +0200
Message-ID: <20250930143832.284639082@linuxfoundation.org>
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

[ Upstream commit 2813f535b5847771d9e56df678c523a7e64f860e ]

Adding ES83x6 I2S codec support for PTL platforms and entry in match table.

Signed-off-by: Balamurugan C <balamurugan.c@intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250708080030.1257790-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 03aa2ed9e187 ("ASoC: Intel: sof_rt5682: Add HDMI-In capture with rt5682 support for PTL.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-ptl-match.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
index eae75f3f0fa40..ff4f2fbf9271d 100644
--- a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
@@ -21,6 +21,11 @@ static const struct snd_soc_acpi_codecs ptl_rt5682_rt5682s_hp = {
 	.codecs = {RT5682_ACPI_HID, RT5682S_ACPI_HID},
 };
 
+static const struct snd_soc_acpi_codecs ptl_essx_83x6 = {
+	.num_codecs = 3,
+	.codecs = { "ESSX8316", "ESSX8326", "ESSX8336"},
+};
+
 struct snd_soc_acpi_mach snd_soc_acpi_intel_ptl_machines[] = {
 	{
 		.comp_ids = &ptl_rt5682_rt5682s_hp,
@@ -29,6 +34,14 @@ struct snd_soc_acpi_mach snd_soc_acpi_intel_ptl_machines[] = {
 		.tplg_quirk_mask = SND_SOC_ACPI_TPLG_INTEL_AMP_NAME |
 					SND_SOC_ACPI_TPLG_INTEL_CODEC_NAME,
 	},
+	{
+		.comp_ids = &ptl_essx_83x6,
+		.drv_name = "sof-essx8336",
+		.sof_tplg_filename = "sof-ptl-es8336", /* the tplg suffix is added at run time */
+		.tplg_quirk_mask = SND_SOC_ACPI_TPLG_INTEL_SSP_NUMBER |
+					SND_SOC_ACPI_TPLG_INTEL_SSP_MSB |
+					SND_SOC_ACPI_TPLG_INTEL_DMIC_NUMBER,
+	},
 	{},
 };
 EXPORT_SYMBOL_GPL(snd_soc_acpi_intel_ptl_machines);
-- 
2.51.0



