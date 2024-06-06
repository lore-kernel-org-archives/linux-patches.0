Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9AD19AD93;
	Thu,  6 Jun 2024 14:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683354; cv=none; b=OHztKXwHTeVPXNZMQlW+xihcR49ZDauPPVLdi5hAXPQ++2O9HP5cjAq36MC7be4z+piyCszaaO1xFjIKfJt7keb08Dt1t35YOi8Le/OQl+6XSgivbRaoBQR4bshHLHsD6I4GBI1hBSIBRLo+KxsIk5eyXXzJEbou++FB90zh42E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683354; c=relaxed/simple;
	bh=wo8hgLVWYcWWWnKzewFS43v2s54GX0IHHXxjRZ2h+2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1N/gBt4t8gTWokuidwsw0Oy2cKUHXhCc0Hp+KPYHuvf6B/bwDPjDf/1vZ7W3G72ZTuvlSQW/6BS5DOzxDOQSYVZtx3jBru4987h73IhwspstmC56pi0hvMsCPqvmBup3bgz7ympAy0DETpwDr26Z/EO951UoudWjvlfEPVdgLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRDyy2Eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRDyy2Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF798C2BD10;
	Thu,  6 Jun 2024 14:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683353;
	bh=wo8hgLVWYcWWWnKzewFS43v2s54GX0IHHXxjRZ2h+2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRDyy2EuHYrBXZfxUrsx10gU+Wl0JlTVDFAmfqbyH+D5L2SvSdu1ys9DPhimXLTVz
	 84yhno+CxpKrMmvECo3ZbsQ7FSlxuysMs0KwWejQw4HVv0H8nCTomTqYXvGUjVcwKd
	 T0SnbozWd9GbQ1V/7kHeKMVY9gMdU+JGOBXwtsWw=
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
Subject: [PATCH 6.6 294/744] ASoC: SOF: Intel: lnl: Correct rom_status_reg
Date: Thu,  6 Jun 2024 15:59:26 +0200
Message-ID: <20240606131741.831884904@linuxfoundation.org>
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
index db94b45e53af8..822f857723208 100644
--- a/sound/soc/sof/intel/lnl.c
+++ b/sound/soc/sof/intel/lnl.c
@@ -16,6 +16,7 @@
 #include "hda-ipc.h"
 #include "../sof-audio.h"
 #include "mtl.h"
+#include "lnl.h"
 #include <sound/hda-mlink.h>
 
 /* LunarLake ops */
@@ -172,7 +173,7 @@ const struct sof_intel_dsp_desc lnl_chip_info = {
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



