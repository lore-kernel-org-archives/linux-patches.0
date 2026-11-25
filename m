Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624719;
	b=xSFGxnncZqIP5Y0aOQmokLVJeXNEH3ozDKwUQnYrNsGo7cOe+0/zcfwhac7+Ku5aY75t
	 2piKlXyLn94/ZBUL9qiAm71YIgi4ZShTW2XpauANerULJbL8Jyp75s3hHTIktKPs+FW9M
	 wvvG4/OvOF5wfK6v1QPkhCdg/VsCQmCR3r8UbHKi0goKXIdLznB7lwORUIBCNxqj99Ub3
	 vfDJkR2IgvKOBGl6dqybvr8EEh7npvLd4AuPD2btj9NMdGSIWwhmGqBu9fn1WlG32jvDo
	 0gYQnklDiEXHPnLxnlvlm+J6S/d02JxJ4GAUY8n2NCiLYGgucWJwHug7jJvWnkcz2SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hGgJZfQqf9KUWrUDUFB3KdrTOF4WHhzrgB0hhC1UTzk=;
	b=R93J8DKWtu88dt7EPkLiEMLPf/47YXhORJpaD97bm811jgofriEwOtQH72EzjQlqNZZe
	 z5SAKSgaVdVCSaDjWYyUSBykU9/J25o4juxELoFLUCUmJ/09O7wy9ZE+2uQLnH6ClPlwC
	 cRy84L10B6Iv+ZZe6QcmiLyGWO/osloyTglA8EKuwQIcY0gkSJ6dLh/seKxJ85r76pSfL
	 AWa9pWBmlTSz0ygemraask5IsCw01m3qOYpp0VDS30zmULn1tEMRm4ANrF6Mn7kSgesUR
	 Mx+1o8xYaWc73X68h3l671tLwRUT6R5LQOKF7dQ0ZbgBxm6lxKEhCv/2MT2YqFsJ9uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iS6M+bra;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC28606A33B;
	Wed, 25 Nov 2026 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iS6M+bra
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1DC1F000C4;
	Wed, 25 Nov 2026 16:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624719;
	bh=hGgJZfQqf9KUWrUDUFB3KdrTOF4WHhzrgB0hhC1UTzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iS6M+braPPTPnfzgwZUgqa8j7bqmCGxXHtl3lXTW6GHJlOAUNHLBmBSwNRNGJN/Ve
	 74JcF2Uw4EJlzu4N3IQGMOxLhmjgE8YTWGMwjCowzWbyQgT8SP6RmeGgb6ItoohFQg
	 11oj0USUa6VE6zUcr7KBQutqGfVCly+vDzkAAOV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/816] ASoC: SOF: amd: add ACP7.1 platform support
Date: Wed, 25 Nov 2026 15:30:34 +0100
Message-ID: <20261125143855.826705115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 451bd0e7b91c83f817b741557c9be0f133d3836d ]

Add SOF support for ACP7.1 platform.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250502154445.3008598-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 34ea81a7f284 ("ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/Kconfig     |  6 +++---
 sound/soc/sof/amd/acp.c       | 10 +++++++++-
 sound/soc/sof/amd/acp.h       |  1 +
 sound/soc/sof/amd/pci-acp70.c |  7 ++++++-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/amd/Kconfig b/sound/soc/sof/amd/Kconfig
index f4cafe8010178..12e9492d21429 100644
--- a/sound/soc/sof/amd/Kconfig
+++ b/sound/soc/sof/amd/Kconfig
@@ -90,12 +90,12 @@ config SND_SOC_SOF_AMD_ACP63
 	  If unsure select "N".
 
 config SND_SOC_SOF_AMD_ACP70
-	tristate "SOF support for ACP7.0 platform"
+	tristate "SOF support for ACP7.0/ACP7.1 platforms"
 	depends on SND_SOC_SOF_PCI
 	select SND_SOC_SOF_AMD_COMMON
 	help
 	  Select this option for SOF support on
-	  AMD ACP7.0 version based platforms.
-	  Say Y if you want to enable SOF on ACP7.0 based platform.
+	  AMD ACP7.0/ACP7.1 version based platforms.
+	  Say Y if you want to enable SOF on ACP7.0/ACP7.1 based platforms.
 
 endif
diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 7f8ee9f356452..64f7562c5486a 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -74,6 +74,7 @@ static void init_dma_descriptor(struct acp_dev_data *adata)
 
 	switch (acp_data->pci_rev) {
 	case ACP70_PCI_ID:
+	case ACP71_PCI_ID:
 		acp_dma_desc_base_addr = ACP70_DMA_DESC_BASE_ADDR;
 		acp_dma_desc_max_num_dscr = ACP70_DMA_DESC_MAX_NUM_DSCR;
 		break;
@@ -113,6 +114,7 @@ static int config_dma_channel(struct acp_dev_data *adata, unsigned int ch,
 
 	switch (acp_data->pci_rev) {
 	case ACP70_PCI_ID:
+	case ACP71_PCI_ID:
 		acp_dma_cntl_0 = ACP70_DMA_CNTL_0;
 		acp_dma_ch_rst_sts = ACP70_DMA_CH_RST_STS;
 		acp_dma_dscr_err_sts_0 = ACP70_DMA_ERR_STS_0;
@@ -348,6 +350,7 @@ int acp_dma_status(struct acp_dev_data *adata, unsigned char ch)
 
 	switch (adata->pci_rev) {
 	case ACP70_PCI_ID:
+	case ACP71_PCI_ID:
 		acp_dma_ch_sts = ACP70_DMA_CH_STS;
 		break;
 	default:
@@ -498,6 +501,7 @@ static int acp_power_on(struct snd_sof_dev *sdev)
 		acp_pgfsm_cntl_mask = ACP6X_PGFSM_CNTL_POWER_ON_MASK;
 		break;
 	case ACP70_PCI_ID:
+	case ACP71_PCI_ID:
 		acp_pgfsm_status_mask = ACP70_PGFSM_STATUS_MASK;
 		acp_pgfsm_cntl_mask = ACP70_PGFSM_CNTL_POWER_ON_MASK;
 		break;
@@ -628,8 +632,12 @@ int amd_sof_acp_suspend(struct snd_sof_dev *sdev, u32 target_state)
 		dev_err(sdev->dev, "ACP Reset failed\n");
 		return ret;
 	}
-	if (acp_data->pci_rev == ACP70_PCI_ID)
+	switch (acp_data->pci_rev) {
+	case ACP70_PCI_ID:
+	case ACP71_PCI_ID:
 		enable = true;
+		break;
+	}
 	snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP_CONTROL, enable);
 
 	return 0;
diff --git a/sound/soc/sof/amd/acp.h b/sound/soc/sof/amd/acp.h
index 2a19d82d62002..dde04ecadbd85 100644
--- a/sound/soc/sof/amd/acp.h
+++ b/sound/soc/sof/amd/acp.h
@@ -74,6 +74,7 @@
 #define ACP_RMB_PCI_ID				0x6F
 #define ACP63_PCI_ID				0x63
 #define ACP70_PCI_ID				0x70
+#define ACP71_PCI_ID				0x71
 
 #define HOST_BRIDGE_CZN				0x1630
 #define HOST_BRIDGE_VGH				0x1645
diff --git a/sound/soc/sof/amd/pci-acp70.c b/sound/soc/sof/amd/pci-acp70.c
index fe2ad0395f5d3..2b1ca22130e62 100644
--- a/sound/soc/sof/amd/pci-acp70.c
+++ b/sound/soc/sof/amd/pci-acp70.c
@@ -72,8 +72,13 @@ static int acp70_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_
 {
 	unsigned int flag;
 
-	if (pci->revision != ACP70_PCI_ID)
+	switch (pci->revision) {
+	case ACP70_PCI_ID:
+	case ACP71_PCI_ID:
+			break;
+	default:
 		return -ENODEV;
+	}
 
 	flag = snd_amd_acp_find_config(pci);
 	if (flag != FLAG_AMD_SOF && flag != FLAG_AMD_SOF_ONLY_DMIC)
-- 
2.53.0



