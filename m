Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624729;
	b=hMcvIQrdxtnZnWjXjL1o7DYeio4amKUGLFctFrkbw/g1IJC4lRObxZdVaDc9fL/gNT7A
	 1Y6Tuk/lTKQ83nzYezaAWyW52ErNkPjT64aPVwtNgyWnyIQqV28fsGjUREm1lM7ZX5ZXJ
	 V6lH5yI9pa864HedTp2n7OPmpxO0ExsdoMCm2PPcycE9o/ixNZ6lzJOHDmt7DPnJb7Cb9
	 C+oLflbyB3eWH1uL//4e+MX9pewORO1q7m1XkyHxOfCNjEZhAchNab1gdIzMiDesmaa3H
	 +9nKf23SRVMNvYTWCy9UB5qE9BG7xvIgE/jg1+PIqXo2CXgMkA525wzMT18eTouRGXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hk7egymihGUlj74KtIiFWAo1rcOfQceCIdkVTt19vqI=;
	b=kAPhYBwVnZ2/fRG4QDIL7FWgBTnX1jE6NqmhxQUnZoK/0NIaVxQ3mXmbCkZpKbcyU8kv
	 pAxMfuIBIN6aRAKdwc3Wrl1sNIgihKYhpriip2XMHn31jxeA7qkkQ0TNO0YpzLkjB7NuQ
	 aZ1E/aFXeN6+UTe8xaiGyJSrhOQ1ZWAGwcVNiPtEbcUq/lU/9dqBsgb0VVsb/Vnwyi14V
	 XnPsXI3oRKx5itqf/Ry0ObDID0uHf7YhSxuiL+IcXIzgBGmX9nrCD8eh8MVI8eZ4DBdUt
	 cM7QAddOG41MmcnLPdHj+veWRxpZpYgwdkXnzBM3VTZpvZDscpjSMMG8opUcY3xr2gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoC3doUA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1A4606A686;
	Wed, 25 Nov 2026 16:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qoC3doUA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108AC1F000D3;
	Wed, 25 Nov 2026 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624728;
	bh=hk7egymihGUlj74KtIiFWAo1rcOfQceCIdkVTt19vqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoC3doUAFtMKNrdfW+88LGHucV9w6DD/apoRlRMypt+AW64r2WrZJUB29RqOln+hW
	 ia3iZoro8U9fz6U6/8MSbWnEb/q97C6p7hyEOh7cDRmT8RZmKGB2Y2mS5C9VWVdw7o
	 ODqv64TUwVc7+iHa4y3SCQAlfhkJxqerHwwTERGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/816] ASoC: SOF: amd: add soundwire wake irq handling
Date: Wed, 25 Nov 2026 15:30:37 +0100
Message-ID: <20261125143855.896718072@linuxfoundation.org>
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

[ Upstream commit 1f41bf67bfe3721a4d4d36695302801cf70b5a70 ]

Add SoundWire wake interrupt handling for ACP7.0 & ACP7.1
platforms.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250502154445.3008598-9-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 34ea81a7f284 ("ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp-dsp-offset.h |  4 ++
 sound/soc/sof/amd/acp.c            | 73 +++++++++++++++++++++++++++++-
 sound/soc/sof/amd/acp.h            |  4 ++
 3 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/amd/acp-dsp-offset.h b/sound/soc/sof/amd/acp-dsp-offset.h
index e77554f74c20d..08583a91afbc4 100644
--- a/sound/soc/sof/amd/acp-dsp-offset.h
+++ b/sound/soc/sof/amd/acp-dsp-offset.h
@@ -135,5 +135,9 @@
 #define ACP70_SW0_WAKE_EN			0x1458
 #define ACP70_SW1_WAKE_EN			0x1460
 #define ACP70_SDW_HOST_WAKE_MASK		0x0C00000
+#define ACP70_SDW0_HOST_WAKE_STAT		BIT(24)
+#define ACP70_SDW1_HOST_WAKE_STAT		BIT(25)
+#define ACP70_SDW0_PME_STAT			BIT(26)
+#define ACP70_SDW1_PME_STAT			BIT(27)
 
 #endif
diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 244a9e0a8665e..33eb03051a7b2 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -398,6 +398,69 @@ static int acp_memory_init(struct snd_sof_dev *sdev)
 	return 0;
 }
 
+static void amd_sof_handle_acp70_sdw_wake_event(struct acp_dev_data *adata)
+{
+	struct amd_sdw_manager *amd_manager;
+
+	if (adata->acp70_sdw0_wake_event) {
+		amd_manager = dev_get_drvdata(&adata->sdw->pdev[0]->dev);
+		if (amd_manager)
+			pm_request_resume(amd_manager->dev);
+		adata->acp70_sdw0_wake_event = 0;
+	}
+
+	if (adata->acp70_sdw1_wake_event) {
+		amd_manager = dev_get_drvdata(&adata->sdw->pdev[1]->dev);
+		if (amd_manager)
+			pm_request_resume(amd_manager->dev);
+		adata->acp70_sdw1_wake_event = 0;
+	}
+}
+
+static int amd_sof_check_and_handle_acp70_sdw_wake_irq(struct snd_sof_dev *sdev)
+{
+	const struct sof_amd_acp_desc *desc = get_chip_info(sdev->pdata);
+	struct acp_dev_data *adata = sdev->pdata->hw_pdata;
+	u32 ext_intr_stat1;
+	int irq_flag = 0;
+	bool sdw_wake_irq = false;
+
+	ext_intr_stat1 = snd_sof_dsp_read(sdev, ACP_DSP_BAR, desc->ext_intr_stat1);
+	if (ext_intr_stat1 & ACP70_SDW0_HOST_WAKE_STAT) {
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->ext_intr_stat1,
+				  ACP70_SDW0_HOST_WAKE_STAT);
+		adata->acp70_sdw0_wake_event = true;
+		sdw_wake_irq = true;
+	}
+
+	if (ext_intr_stat1 & ACP70_SDW1_HOST_WAKE_STAT) {
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->ext_intr_stat1,
+				  ACP70_SDW1_HOST_WAKE_STAT);
+		adata->acp70_sdw1_wake_event = true;
+		sdw_wake_irq = true;
+	}
+
+	if (ext_intr_stat1 & ACP70_SDW0_PME_STAT) {
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP70_SW0_WAKE_EN, 0);
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->ext_intr_stat1, ACP70_SDW0_PME_STAT);
+		adata->acp70_sdw0_wake_event = true;
+		sdw_wake_irq = true;
+	}
+
+	if (ext_intr_stat1 & ACP70_SDW1_PME_STAT) {
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP70_SW1_WAKE_EN, 0);
+		snd_sof_dsp_write(sdev, ACP_DSP_BAR, desc->ext_intr_stat1, ACP70_SDW1_PME_STAT);
+		adata->acp70_sdw1_wake_event = true;
+		sdw_wake_irq = true;
+	}
+
+	if (sdw_wake_irq) {
+		amd_sof_handle_acp70_sdw_wake_event(adata);
+		irq_flag = 1;
+	}
+	return irq_flag;
+}
+
 static irqreturn_t acp_irq_thread(int irq, void *context)
 {
 	struct snd_sof_dev *sdev = context;
@@ -430,7 +493,7 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
 	struct acp_dev_data *adata = sdev->pdata->hw_pdata;
 	unsigned int base = desc->dsp_intr_base;
 	unsigned int val;
-	int irq_flag = 0;
+	int irq_flag = 0, wake_irq_flag = 0;
 
 	val = snd_sof_dsp_read(sdev, ACP_DSP_BAR, base + DSP_SW_INTR_STAT_OFFSET);
 	if (val & ACP_DSP_TO_HOST_IRQ) {
@@ -468,8 +531,14 @@ static irqreturn_t acp_irq_handler(int irq, void *dev_id)
 				schedule_work(&amd_manager->amd_sdw_irq_thread);
 			irq_flag = 1;
 		}
+		switch (adata->pci_rev) {
+		case ACP70_PCI_ID:
+		case ACP71_PCI_ID:
+			wake_irq_flag = amd_sof_check_and_handle_acp70_sdw_wake_irq(sdev);
+			break;
+		}
 	}
-	if (irq_flag)
+	if (irq_flag || wake_irq_flag)
 		return IRQ_HANDLED;
 	else
 		return IRQ_NONE;
diff --git a/sound/soc/sof/amd/acp.h b/sound/soc/sof/amd/acp.h
index dde04ecadbd85..3380a761dcf67 100644
--- a/sound/soc/sof/amd/acp.h
+++ b/sound/soc/sof/amd/acp.h
@@ -263,6 +263,10 @@ struct acp_dev_data {
 	bool is_dram_in_use;
 	bool is_sram_in_use;
 	bool sdw_en_stat;
+	/* acp70_sdw0_wake_event flag set to true when wake irq asserted for SW0 instance */
+	bool acp70_sdw0_wake_event;
+	/* acp70_sdw1_wake_event flag set to true when wake irq asserted for SW1 instance */
+	bool acp70_sdw1_wake_event;
 	unsigned int pci_rev;
 };
 
-- 
2.53.0



