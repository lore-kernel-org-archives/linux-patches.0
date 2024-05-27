Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EB717E90E;
	Mon, 27 May 2024 19:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837081; cv=none; b=EaZR2okMVzX9ljbiSV5g5quzYsu9buQGqvjdifxsebG7byKqcDCNHsWXzP/blS34hG9axKq+bF6K4BfbbMn2wOMAXoxArLv5iOgEvlIPW44dXwsQa/nkhkbYqYw2tTjOX0D6sHcM6OTzP41xjHDEIIdlu0IiCYuLdBF4M32CTU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837081; c=relaxed/simple;
	bh=KHxhxAk+92v9MKOGAKYQ6C37is76YvdM8FxPBrv0mNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rY86E4+Kn4X8M/qlseUIZHegQC6KhPHeIINS2M8FcCh+qOC/dK2Qr32f9tHp9k1beiSCOwLOjj2IoCVjVCjaHuie7B9p+gj35gof4ynoNsLkjRmgYEBVI8SqznuUMPXUINcA2AQxlvS4LOyLMnBwqu6CeZl9iUtklzjyDKp5SMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/bN0daK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/bN0daK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0B3C2BBFC;
	Mon, 27 May 2024 19:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837081;
	bh=KHxhxAk+92v9MKOGAKYQ6C37is76YvdM8FxPBrv0mNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/bN0daK0YVCqkcEUmc8TgkfiXW/CR+QpN1if22AKeVAYPqlW4Uq6ujiWnnbuQf1Y
	 dBsjJungaBf/cfcBSdXMGSX7lEBBuA151zwAh8jRqDn3684Mdg8rhT6Qif+/WPU2EQ
	 2+jwLT5DvvG2UJL/pDfFrXJ4db9p4a0w5uRxYm6w=
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
Subject: [PATCH 6.9 302/427] ASoC: SOF: Intel: lnl: Correct rom_status_reg
Date: Mon, 27 May 2024 20:55:49 +0200
Message-ID: <20240527185630.336906679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit b852574c671a9983dd51c81582c8c5085f3dc382 ]

ACE2 architecture changed the place where the ROM updates the status code
from the shared SRAM window (and HFFLGP1QW0 in ACE1) to HFDSC register for
the status and HFDEC (HFDSC + 4) for the error code.

The rom_status_reg is not used on LNL because it was wrongly assigned based
on older platform convention (SRAM window) and it was giving inconsistent
readings.

Add new header file for lnl specific register definitions.

Fixes: 64a63d9914a5 ("ASoC: SOF: Intel: LNL: Add support for Lunarlake platform")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://msgid.link/r/20240403105210.17949-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/lnl.c |  3 ++-
 sound/soc/sof/intel/lnl.h | 15 +++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)
 create mode 100644 sound/soc/sof/intel/lnl.h

diff --git a/sound/soc/sof/intel/lnl.c b/sound/soc/sof/intel/lnl.c
index aeb4350cce6bb..6055a33bb4bf6 100644
--- a/sound/soc/sof/intel/lnl.c
+++ b/sound/soc/sof/intel/lnl.c
@@ -16,6 +16,7 @@
 #include "hda-ipc.h"
 #include "../sof-audio.h"
 #include "mtl.h"
+#include "lnl.h"
 #include <sound/hda-mlink.h>
 
 /* LunarLake ops */
@@ -208,7 +209,7 @@ const struct sof_intel_dsp_desc lnl_chip_info = {
 	.ipc_ack = MTL_DSP_REG_HFIPCXIDA,
 	.ipc_ack_mask = MTL_DSP_REG_HFIPCXIDA_DONE,
 	.ipc_ctl = MTL_DSP_REG_HFIPCXCTL,
-	.rom_status_reg = MTL_DSP_ROM_STS,
+	.rom_status_reg = LNL_DSP_REG_HFDSC,
 	.rom_init_timeout = 300,
 	.ssp_count = MTL_SSP_COUNT,
 	.d0i3_offset = MTL_HDA_VS_D0I3C,
diff --git a/sound/soc/sof/intel/lnl.h b/sound/soc/sof/intel/lnl.h
new file mode 100644
index 0000000000000..4f4734fe7e089
--- /dev/null
+++ b/sound/soc/sof/intel/lnl.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * Copyright(c) 2024 Intel Corporation. All rights reserved.
+ */
+
+#ifndef __SOF_INTEL_LNL_H
+#define __SOF_INTEL_LNL_H
+
+#define LNL_DSP_REG_HFDSC		0x160200 /* DSP core0 status */
+#define LNL_DSP_REG_HFDEC		0x160204 /* DSP core0 error */
+
+#endif /* __SOF_INTEL_LNL_H */
-- 
2.43.0



