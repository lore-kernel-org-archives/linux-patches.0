Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75242EA176;
	Tue, 17 Jun 2025 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175296; cv=none; b=Ea5FVZaxihsF5l9YHtICZCni7UpA1pWoSyMl5xkv0Mi2mFoWX+NHc2TxqI8vYVk3cCeWFS7qmPBkTUQsXbml8cjI4l23CWcCVRivLFKnm0O4MMVrDih4rN7XTJNE4hrUUbPOIU0VlUKLmLjpod/P1XW2kzn8fJVRhSHW5viWSRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175296; c=relaxed/simple;
	bh=6hQvvdYL1LxQrOYmz8K8/3SQBhk5APkmby1odPgwovE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXI9UJYdn+T7Q6wKtyjMxGVrHF2T1U60b5yXppu3kp+Ykye9BIG+GCtzAHAG8n4l0hqhngof4uaP/JhvbmWsV/TFkcO3NQ6VKg/4E/u53xaTait8xO2XGc5K1aGvQjfinm2aob07SNsgDBkB/oPSck7ba+xSlP0K1NGiqCtzyq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDFldgg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDFldgg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D14C4CEF0;
	Tue, 17 Jun 2025 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175296;
	bh=6hQvvdYL1LxQrOYmz8K8/3SQBhk5APkmby1odPgwovE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDFldgg4crPc7OPCjoAsxoKgPHqkbNQJTvPnOa2TMMSOqvYnqTdg6UTuk1T7w3TjL
	 HlRGk1Ovz0MERqJyFnj4o463t+jTQzKJ9qcgq2utelgvch3CRg/jo2/x3d273POSCk
	 FxPhTM3we057qOz4krZL7Jz7SYD8RHk9pyPmD2vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 071/780] ASoC: SOF: amd: add missing acp descriptor field
Date: Tue, 17 Jun 2025 17:16:19 +0200
Message-ID: <20250617152454.407199803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 7c2bad7b95db5b4b978853cd4dd042ae3ec83e63 ]

Add missing acp descriptor field acp_error_stat for ACP7.0 platform.

Fixes: 490be7ba2a01 ("ASoC: SOF: amd: add support for acp7.0 based platform")

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250502154445.3008598-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/pci-acp70.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/amd/pci-acp70.c b/sound/soc/sof/amd/pci-acp70.c
index 8fa1170a2161e..9108f1139ff2d 100644
--- a/sound/soc/sof/amd/pci-acp70.c
+++ b/sound/soc/sof/amd/pci-acp70.c
@@ -33,6 +33,7 @@ static const struct sof_amd_acp_desc acp70_chip_info = {
 	.ext_intr_cntl = ACP70_EXTERNAL_INTR_CNTL,
 	.ext_intr_stat	= ACP70_EXT_INTR_STAT,
 	.ext_intr_stat1	= ACP70_EXT_INTR_STAT1,
+	.acp_error_stat = ACP70_ERROR_STATUS,
 	.dsp_intr_base	= ACP70_DSP_SW_INTR_BASE,
 	.acp_sw0_i2s_err_reason = ACP7X_SW0_I2S_ERROR_REASON,
 	.sram_pte_offset = ACP70_SRAM_PTE_OFFSET,
-- 
2.39.5



