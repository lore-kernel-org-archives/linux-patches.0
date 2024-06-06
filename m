Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8BB1B0104;
	Thu,  6 Jun 2024 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683352; cv=none; b=Vvdm+SCUcbpxDUOl9G3Hr5YiB6CBHt6XfbZbBjKVnvn1/2hC5/FKTzBJlt/WfuzrC/3GPEPVLxj6QJZOrZ8YAlOPgTJ/8Ok02LwU0E50ybCnpY7hY4M2AYx3vIrFWFrgae64F7K7D0AYcH8ZsPz0YD2DKRj76TWnLY+hWD6XScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683352; c=relaxed/simple;
	bh=Ri1XBI0R9DQRR+40SvgRMKf5G36/L+w34BRMC132A/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GY2AgIY9iOwCIG1/NBzrujK2Jq+omFasgjD3O8rU4f7pQ/S3nxu9H6om0YNja1xKaIFKDH62qYObthmY3uxrCLfD/oEf1JgrE17O19DJOynXTClcLX4USFpy/VsFX6ZcUQ7hHSPHykcGe67gNYwMSEZKSe94niUCtAP9/Hk07wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riTiOeg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riTiOeg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB86FC2BD10;
	Thu,  6 Jun 2024 14:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683351;
	bh=Ri1XBI0R9DQRR+40SvgRMKf5G36/L+w34BRMC132A/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riTiOeg/XQt2yqxBbwUvFsPHEZhcDHk+4+giX9V9tB73tzZ89nIGpyHXSQBksDvzk
	 +9wMO3hXIvdKSNKCcbXTytltFjvETKHvfRmhGeexo/RX3ZC9+ykfXh6gQzbHN0i3tN
	 +6TrTBz2iSnuJeNTKD3cBQYswjOiIx+dcwxPwYQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/744] ASoC: SOF: Intel: pci-mtl: fix ARL-S definitions
Date: Thu,  6 Jun 2024 15:59:24 +0200
Message-ID: <20240606131741.774132920@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a00be6dc9bb80796244196033aa5eb258b6af47a ]

The initial copy/paste from MTL was incorrect, the hardware is
different and requires different descriptors along with a dedicated
firmware binary.

Fixes: 3851831f529e ("ASoC: SOF: Intel: pci-mtl: use ARL specific firmware definitions")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231204212710.185976-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 1f1b820dc3c6 ("ASoC: SOF: Intel: mtl: Correct rom_status_reg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.h     |  1 +
 sound/soc/sof/intel/mtl.c     | 28 ++++++++++++++++++++++++++++
 sound/soc/sof/intel/pci-mtl.c | 12 ++++++------
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index 5c517ec57d4a2..0f0cfd0f85a3f 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -876,6 +876,7 @@ extern const struct sof_intel_dsp_desc ehl_chip_info;
 extern const struct sof_intel_dsp_desc jsl_chip_info;
 extern const struct sof_intel_dsp_desc adls_chip_info;
 extern const struct sof_intel_dsp_desc mtl_chip_info;
+extern const struct sof_intel_dsp_desc arl_s_chip_info;
 extern const struct sof_intel_dsp_desc lnl_chip_info;
 
 /* Probes support */
diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index f9412517eaf29..e45a6cef63916 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -743,3 +743,31 @@ const struct sof_intel_dsp_desc mtl_chip_info = {
 	.hw_ip_version = SOF_INTEL_ACE_1_0,
 };
 EXPORT_SYMBOL_NS(mtl_chip_info, SND_SOC_SOF_INTEL_HDA_COMMON);
+
+const struct sof_intel_dsp_desc arl_s_chip_info = {
+	.cores_num = 2,
+	.init_core_mask = BIT(0),
+	.host_managed_cores_mask = BIT(0),
+	.ipc_req = MTL_DSP_REG_HFIPCXIDR,
+	.ipc_req_mask = MTL_DSP_REG_HFIPCXIDR_BUSY,
+	.ipc_ack = MTL_DSP_REG_HFIPCXIDA,
+	.ipc_ack_mask = MTL_DSP_REG_HFIPCXIDA_DONE,
+	.ipc_ctl = MTL_DSP_REG_HFIPCXCTL,
+	.rom_status_reg = MTL_DSP_ROM_STS,
+	.rom_init_timeout	= 300,
+	.ssp_count = MTL_SSP_COUNT,
+	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
+	.sdw_shim_base = SDW_SHIM_BASE_ACE,
+	.sdw_alh_base = SDW_ALH_BASE_ACE,
+	.d0i3_offset = MTL_HDA_VS_D0I3C,
+	.read_sdw_lcount =  hda_sdw_check_lcount_common,
+	.enable_sdw_irq = mtl_enable_sdw_irq,
+	.check_sdw_irq = mtl_dsp_check_sdw_irq,
+	.check_sdw_wakeen_irq = hda_sdw_check_wakeen_irq_common,
+	.check_ipc_irq = mtl_dsp_check_ipc_irq,
+	.cl_init = mtl_dsp_cl_init,
+	.power_down_dsp = mtl_power_down_dsp,
+	.disable_interrupts = mtl_dsp_disable_interrupts,
+	.hw_ip_version = SOF_INTEL_ACE_1_0,
+};
+EXPORT_SYMBOL_NS(arl_s_chip_info, SND_SOC_SOF_INTEL_HDA_COMMON);
diff --git a/sound/soc/sof/intel/pci-mtl.c b/sound/soc/sof/intel/pci-mtl.c
index 42a8b85d0f4a9..7d00e469f58ce 100644
--- a/sound/soc/sof/intel/pci-mtl.c
+++ b/sound/soc/sof/intel/pci-mtl.c
@@ -50,7 +50,7 @@ static const struct sof_dev_desc mtl_desc = {
 	.ops_free = hda_ops_free,
 };
 
-static const struct sof_dev_desc arl_desc = {
+static const struct sof_dev_desc arl_s_desc = {
 	.use_acpi_target_states = true,
 	.machines               = snd_soc_acpi_intel_arl_machines,
 	.alt_machines           = snd_soc_acpi_intel_arl_sdw_machines,
@@ -58,21 +58,21 @@ static const struct sof_dev_desc arl_desc = {
 	.resindex_pcicfg_base   = -1,
 	.resindex_imr_base      = -1,
 	.irqindex_host_ipc      = -1,
-	.chip_info = &mtl_chip_info,
+	.chip_info = &arl_s_chip_info,
 	.ipc_supported_mask     = BIT(SOF_IPC_TYPE_4),
 	.ipc_default            = SOF_IPC_TYPE_4,
 	.dspless_mode_supported = true,         /* Only supported for HDaudio */
 	.default_fw_path = {
-		[SOF_IPC_TYPE_4] = "intel/sof-ipc4/arl",
+		[SOF_IPC_TYPE_4] = "intel/sof-ipc4/arl-s",
 	},
 	.default_lib_path = {
-		[SOF_IPC_TYPE_4] = "intel/sof-ipc4-lib/arl",
+		[SOF_IPC_TYPE_4] = "intel/sof-ipc4-lib/arl-s",
 	},
 	.default_tplg_path = {
 		[SOF_IPC_TYPE_4] = "intel/sof-ace-tplg",
 	},
 	.default_fw_filename = {
-		[SOF_IPC_TYPE_4] = "sof-arl.ri",
+		[SOF_IPC_TYPE_4] = "sof-arl-s.ri",
 	},
 	.nocodec_tplg_filename = "sof-arl-nocodec.tplg",
 	.ops = &sof_mtl_ops,
@@ -83,7 +83,7 @@ static const struct sof_dev_desc arl_desc = {
 /* PCI IDs */
 static const struct pci_device_id sof_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, HDA_MTL, &mtl_desc) },
-	{ PCI_DEVICE_DATA(INTEL, HDA_ARL_S, &arl_desc) },
+	{ PCI_DEVICE_DATA(INTEL, HDA_ARL_S, &arl_s_desc) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, sof_pci_ids);
-- 
2.43.0



