Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E15217F34;
	Tue, 17 Jun 2025 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174672; cv=none; b=NUl9K26qfalsVLXGFnhSlz+PiEQs1nMnL0VvMEfyZR4/ytlkMCuDm2w9QpAdnWjan6mCVotClLVwvrxmsLcGs7rjyIXRpUeCfV5qC5wb6bP53eNKal86Q5e/JYVpHBUOV62I/qd4m4PTbKWo5SVTIzeXPMaG8825JfdScn2Q2zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174672; c=relaxed/simple;
	bh=J0Bx9Gkq+I+PHBRuxt/7RBYCf3O7u6m/wckKGocDRQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is11Ub954mWj4+K7H4QCSXMScbNRCCiv8RsMKCxxGx0Q94Kr5iJ+LrCKvpJhH3XZ5dfkn7iE3aTDh3ZmDisMcMqmLnmJj16Jz74EV2d57SHeQtPaJwLEAKwQLoSMx9rwSbhlZZSlSFgcDY4FQx3gYgVe0LA1HM8k+ZSvohlnl8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCiafVp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCiafVp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC38DC4CEE3;
	Tue, 17 Jun 2025 15:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174672;
	bh=J0Bx9Gkq+I+PHBRuxt/7RBYCf3O7u6m/wckKGocDRQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCiafVp/55We3XFigs91BudMM8w3wqdx/arED5TbthV8PAkCFxy2dh2yVAQV8/j+M
	 B5Sp9okSdm5rLn+HGoYMjRLtN/vGpHPGmmA4MR7LNQutFnnB4ILY01k6hCTg23keFL
	 /WM+FoZT+aonP7qD9a1oFUuLbPMhNnLRlxKuO8QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/512] ASoC: SOF: amd: add missing acp descriptor field
Date: Tue, 17 Jun 2025 17:20:15 +0200
Message-ID: <20250617152421.522562230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a5d8b6a95a222..fe2ad0395f5d3 100644
--- a/sound/soc/sof/amd/pci-acp70.c
+++ b/sound/soc/sof/amd/pci-acp70.c
@@ -34,6 +34,7 @@ static const struct sof_amd_acp_desc acp70_chip_info = {
 	.ext_intr_cntl = ACP70_EXTERNAL_INTR_CNTL,
 	.ext_intr_stat	= ACP70_EXT_INTR_STAT,
 	.ext_intr_stat1	= ACP70_EXT_INTR_STAT1,
+	.acp_error_stat = ACP70_ERROR_STATUS,
 	.dsp_intr_base	= ACP70_DSP_SW_INTR_BASE,
 	.acp_sw0_i2s_err_reason = ACP7X_SW0_I2S_ERROR_REASON,
 	.sram_pte_offset = ACP70_SRAM_PTE_OFFSET,
-- 
2.39.5



