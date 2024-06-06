Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8E4196DB4;
	Thu,  6 Jun 2024 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683351; cv=none; b=TxIz9Y4/KZZEzS8MLBhpIThqDcDfEKYIc2NJH/xLmY51LjvmGN9UuRQVKYmmAoqwupO5caE3cU/lOXMLBMqRn+whSRARwXfDhs6JA3djVu29AUFzjNln5Tq+7NOnwhyBc5qPooLh8pPAYL1bQfxjoDElQMbQ12PKBg30Fi5gPUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683351; c=relaxed/simple;
	bh=x7ZtG9YQQLojpy4jAsIyJPxBeGQDIGMowtUcbN9q/JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Isy+vDW/dxteasaTUGv0zIt4tEXumklCi41Nre2kKM17ALeb1Bouedgs0yuxBlHp6e2xySHjjLfOatYhhOoFwj5gYWoZOTenIJJFx9mt//zONjuTmIcUwPT4RnJ+RHGzQyVBjSyJxn3TeL6GL7HVIsaQgRp8zk01oEZq4CRED6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+EXM1Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+EXM1Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4015C2BD10;
	Thu,  6 Jun 2024 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683350;
	bh=x7ZtG9YQQLojpy4jAsIyJPxBeGQDIGMowtUcbN9q/JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+EXM1DtZf7u+XZgdn1UM+kjsu7pmsMl3ghn35pKm2XRGOlEyCGpU8f1yPw5aC9Z/
	 nAAsu4f6cXmRbQixk8OfJgjxJSO3KAXnvCBN9U0DNsZH0Ah80upcuaLWgsKgHE3Ylh
	 GQ6OIj+ah4FYHnI/+0J98XGMXt9ryy1Dl6Ne7tUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Arun T <arun.t@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/744] ASoC: SOF: Intel: pci-mtl: use ARL specific firmware definitions
Date: Thu,  6 Jun 2024 15:59:23 +0200
Message-ID: <20240606131741.738168852@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun T <arun.t@intel.com>

[ Upstream commit 3851831f529ec3d7b2c7708b2579bfc00d43733c ]

Split out firmware definitions for Intel Arrow Lake platforms.

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Arun T <arun.t@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231012191850.147140-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1f1b820dc3c6 ("ASoC: SOF: Intel: mtl: Correct rom_status_reg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-mtl.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/sound/soc/sof/intel/pci-mtl.c b/sound/soc/sof/intel/pci-mtl.c
index 7868b0827e844..42a8b85d0f4a9 100644
--- a/sound/soc/sof/intel/pci-mtl.c
+++ b/sound/soc/sof/intel/pci-mtl.c
@@ -50,9 +50,40 @@ static const struct sof_dev_desc mtl_desc = {
 	.ops_free = hda_ops_free,
 };
 
+static const struct sof_dev_desc arl_desc = {
+	.use_acpi_target_states = true,
+	.machines               = snd_soc_acpi_intel_arl_machines,
+	.alt_machines           = snd_soc_acpi_intel_arl_sdw_machines,
+	.resindex_lpe_base      = 0,
+	.resindex_pcicfg_base   = -1,
+	.resindex_imr_base      = -1,
+	.irqindex_host_ipc      = -1,
+	.chip_info = &mtl_chip_info,
+	.ipc_supported_mask     = BIT(SOF_IPC_TYPE_4),
+	.ipc_default            = SOF_IPC_TYPE_4,
+	.dspless_mode_supported = true,         /* Only supported for HDaudio */
+	.default_fw_path = {
+		[SOF_IPC_TYPE_4] = "intel/sof-ipc4/arl",
+	},
+	.default_lib_path = {
+		[SOF_IPC_TYPE_4] = "intel/sof-ipc4-lib/arl",
+	},
+	.default_tplg_path = {
+		[SOF_IPC_TYPE_4] = "intel/sof-ace-tplg",
+	},
+	.default_fw_filename = {
+		[SOF_IPC_TYPE_4] = "sof-arl.ri",
+	},
+	.nocodec_tplg_filename = "sof-arl-nocodec.tplg",
+	.ops = &sof_mtl_ops,
+	.ops_init = sof_mtl_ops_init,
+	.ops_free = hda_ops_free,
+};
+
 /* PCI IDs */
 static const struct pci_device_id sof_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, HDA_MTL, &mtl_desc) },
+	{ PCI_DEVICE_DATA(INTEL, HDA_ARL_S, &arl_desc) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, sof_pci_ids);
-- 
2.43.0



