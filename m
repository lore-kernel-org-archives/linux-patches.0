Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093021E4AB;
	Tue, 23 Jan 2024 00:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969518; cv=none; b=C7Nr5bs0HeyWj7sD9ST0vaLT6xUkR5PorJVrRlIh3xA4yKw9y1RqQJx/QlgZIkpUz6F+ajVvLNVy0otwJoOjZtRpk5ptbNyho/302//MVEQMqPIGhiso9wi0dF+zZLIpNmwQsH9QOmJ0Aly7m9pqWqU6YcxG72XWpv21RSNKxZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969518; c=relaxed/simple;
	bh=xMjOU2WRJ4z8wXENuyBaIMFzsizVeoX4ZYcsbirmc1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ks/ujm2PzLVEs4QLymD9VpzpYlfyFmL0cLGNi0HN6Tjj6ca92lDs7lx3un7xk2jUouXWfJ/enjOrBQKtS3q5yhHGmz9E4Z/c1S7jFs+r5p+Cqp8LWElqadie9y0zcbOrfYJR6wllc+H888m2kZTsKKTgD/wyDslytzq4RpIks10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeeZDGui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeeZDGui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8B5C433A6;
	Tue, 23 Jan 2024 00:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969517;
	bh=xMjOU2WRJ4z8wXENuyBaIMFzsizVeoX4ZYcsbirmc1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeeZDGuiLxsap153pfViD7yeCBYNmrRrYTwo3bkgN97EVy39tBvQyte76x/h2QYpb
	 5rvt3jBETLQbEOcf7eKyNvrgrXQuS4yy266+ofd0/Ua5vtgqTQ2FytwI+2/wZgtvyx
	 4+VDNR+Gz8t04ZPXUR/CeFk00q6xlpmCXOmxqOHA=
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
Subject: [PATCH 6.7 300/641] ASoC: SOF: Intel: pci-mtl: fix ARL-S definitions
Date: Mon, 22 Jan 2024 15:53:24 -0800
Message-ID: <20240122235827.293843803@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.h     |  1 +
 sound/soc/sof/intel/mtl.c     | 28 ++++++++++++++++++++++++++++
 sound/soc/sof/intel/pci-mtl.c | 12 ++++++------
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sof/intel/hda.h b/sound/soc/sof/intel/hda.h
index d628d6a3a7e5..1592e27bc14d 100644
--- a/sound/soc/sof/intel/hda.h
+++ b/sound/soc/sof/intel/hda.h
@@ -882,6 +882,7 @@ extern const struct sof_intel_dsp_desc ehl_chip_info;
 extern const struct sof_intel_dsp_desc jsl_chip_info;
 extern const struct sof_intel_dsp_desc adls_chip_info;
 extern const struct sof_intel_dsp_desc mtl_chip_info;
+extern const struct sof_intel_dsp_desc arl_s_chip_info;
 extern const struct sof_intel_dsp_desc lnl_chip_info;
 
 /* Probes support */
diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index 254dbbeac1d0..7946110e7adf 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -746,3 +746,31 @@ const struct sof_intel_dsp_desc mtl_chip_info = {
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
index 0f378f45486d..60d5e73cdad2 100644
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



