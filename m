Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20A419AD8C;
	Thu,  6 Jun 2024 14:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683353; cv=none; b=aiPmvKkqGBVjN1Q3pd9+XO/477UGeypd1fSNOufasKT5RRD6e2koSGIkB1zH9eT1Z/63vYob3GU2vtVL6KdgwFe4tKg3RMhysUElgM7yYUOP0uFhwWORv6ghzkvajvaFKwp1XSdC6xlXNDSQWpuV2si/C62JNBVQSp9F64Bl3N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683353; c=relaxed/simple;
	bh=5sIWibTgJEINBwqC8e6LHh5NOOO5IGa4+w5lmZL7V1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBy8i4V6SsAFR80LhyEb/LEAvvdDMS8RTcKXGEeJ0BxTkUCksy9Zw++mm2JZE4i08XbFtFrb58M6qUpHrQeudxsxNJMlmE6bn3moB5/AE+HOlr8MnY0M4nGtNvckFOFLcupOA/FMs8So6vPr6tBW8jK+/uqrFxZEzbUSzBG3iuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlKvbgFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlKvbgFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16E1C2BD10;
	Thu,  6 Jun 2024 14:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683352;
	bh=5sIWibTgJEINBwqC8e6LHh5NOOO5IGa4+w5lmZL7V1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlKvbgFRM635cmQ69xZVG2bCxaJaaywlsgdpAfO2A8B0C/J67uwhfIRsz8XMV1hU7
	 bLHRvbx2r4ZXZ8jMblp+JL8awsaUCCWe/JhzE5UWLRhb8YJbZFsCd5wiGGF9ZxyrTm
	 9/LS0qLY6kmsgJnxBJtKOxv0U3RiF5AR3w4T990k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/744] ASoC: SOF: Intel: mtl: Correct rom_status_reg
Date: Thu,  6 Jun 2024 15:59:25 +0200
Message-ID: <20240606131741.804794014@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 1f1b820dc3c65b6883da3130ba3b8624dcbf87db ]

ACE1 architecture changed the place where the ROM updates the status code
from the shared SRAM window to HFFLGP1QW0 register for the status and
HFFLGP1QW0 + 4 for the error code.

The rom_status_reg is not used on MTL because it was wrongly assigned based
on older platform convention (SRAM window) and it was giving inconsistent
readings.

Fixes: 064520e8aeaa ("ASoC: SOF: Intel: Add support for MeteorLake (MTL)")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://msgid.link/r/20240403105210.17949-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/mtl.c | 4 ++--
 sound/soc/sof/intel/mtl.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index e45a6cef63916..834eb31cd9332 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -725,7 +725,7 @@ const struct sof_intel_dsp_desc mtl_chip_info = {
 	.ipc_ack = MTL_DSP_REG_HFIPCXIDA,
 	.ipc_ack_mask = MTL_DSP_REG_HFIPCXIDA_DONE,
 	.ipc_ctl = MTL_DSP_REG_HFIPCXCTL,
-	.rom_status_reg = MTL_DSP_ROM_STS,
+	.rom_status_reg = MTL_DSP_REG_HFFLGPXQWY,
 	.rom_init_timeout	= 300,
 	.ssp_count = MTL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
@@ -753,7 +753,7 @@ const struct sof_intel_dsp_desc arl_s_chip_info = {
 	.ipc_ack = MTL_DSP_REG_HFIPCXIDA,
 	.ipc_ack_mask = MTL_DSP_REG_HFIPCXIDA_DONE,
 	.ipc_ctl = MTL_DSP_REG_HFIPCXCTL,
-	.rom_status_reg = MTL_DSP_ROM_STS,
+	.rom_status_reg = MTL_DSP_REG_HFFLGPXQWY,
 	.rom_init_timeout	= 300,
 	.ssp_count = MTL_SSP_COUNT,
 	.ssp_base_offset = CNL_SSP_BASE_OFFSET,
diff --git a/sound/soc/sof/intel/mtl.h b/sound/soc/sof/intel/mtl.h
index 95696b3d7c4cf..fab28d5f68915 100644
--- a/sound/soc/sof/intel/mtl.h
+++ b/sound/soc/sof/intel/mtl.h
@@ -76,8 +76,8 @@
 #define MTL_DSP_ROM_STS			MTL_SRAM_WINDOW_OFFSET(0) /* ROM status */
 #define MTL_DSP_ROM_ERROR		(MTL_SRAM_WINDOW_OFFSET(0) + 0x4) /* ROM error code */
 
-#define MTL_DSP_REG_HFFLGPXQWY		0x163200 /* ROM debug status */
-#define MTL_DSP_REG_HFFLGPXQWY_ERROR	0x163204 /* ROM debug error code */
+#define MTL_DSP_REG_HFFLGPXQWY		0x163200 /* DSP core0 status */
+#define MTL_DSP_REG_HFFLGPXQWY_ERROR	0x163204 /* DSP core0 error */
 #define MTL_DSP_REG_HfIMRIS1		0x162088
 #define MTL_DSP_REG_HfIMRIS1_IU_MASK	BIT(0)
 
-- 
2.43.0



