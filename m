Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7675546A5E3;
	Tue, 21 Jul 2026 15:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648932; cv=none; b=GIYPhNtvleqprLPOnMsFjwXLfU9rgR+VN0dzG9zEJ1t7e+NUlRhsmT6H9oFzEj1FigmkiUBeAreGG58jG78Jk+pbIXtBUMCuu3vPUkTWKAOhLhXFMWFgFP3pL5DyoafMh3BWlamPx7Pni6fRs5VmwCmnsDrSc0q+hgXYizSHAGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648932; c=relaxed/simple;
	bh=h8qBCsV9+5LKF5DQQPB5B30FogSAJs9g+viwE45TSoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icXQZPUDT5EJ7ZSU8JRem9QQL52wG3Gkedno7q74Dd/2H0CFBK53Yb+x18ZJLopdqmFK81LM7jlnUeaAc8+VQ3B2jnxocyZ1reExL78lp5V1Q0ZruDe7/L2dJL8QRHkxyf4QaaYDQwJDjZf5QnX2Je3bOkgr+zoQDSA4lJIvEow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTE78zw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTE78zw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9604D1F000E9;
	Tue, 21 Jul 2026 15:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648931;
	bh=nguWc0lYNpjLU1m+aXKphZlsOOYixHIk2kL30IJ+qJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTE78zw9gnxP6WpYRgdOE31pSZFrRCahsfPAdKDOcU2j+iyo2uXirhcag5FOWqnnd
	 M7J6gp1GwU0WD6GqerS/xd7pJLPUxfqFKObLh+zVb0JwHzXWT9zND5yy+4rU2/advN
	 RS3jFAPkCIVy0AG2WSkTfMzEbyv+L4PZKje9w21U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0386/2077] Revert "media: venus: hfi_platform: Correct supported codecs for sc7280"
Date: Tue, 21 Jul 2026 17:00:59 +0200
Message-ID: <20260721152601.804026492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 3eb9ba0da0ab73e135f93ffccf07381ba11f100e ]

This reverts commit c0ab2901fc68 ("media: venus: hfi_platform: Correct
supported codecs for sc7280"). The codecs might be deprecated, but they
still work (somewhat) perfectly and don't cause any issues with the rest
of the system. Reenable VP8 codecs by reverting the offending commit.

Tested with fluster:

|Test|FFmpeg-VP8-v4l2m2m|GStreamer-VP8-V4L2|
|TOTAL|50/61|50/61|
|TOTAL TIME|12.171s|11.824s|

Fixes: c0ab2901fc68 ("media: venus: hfi_platform: Correct supported codecs for sc7280")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/venus/hfi_parser.c    |  6 ++---
 .../media/platform/qcom/venus/hfi_platform.c  | 24 -------------------
 .../media/platform/qcom/venus/hfi_platform.h  |  2 --
 3 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
index 92765f9c88730a..c4cf6cd50a9a03 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -268,7 +268,6 @@ static int hfi_platform_parser(struct venus_core *core, struct venus_inst *inst)
 	const struct hfi_plat_caps *caps = NULL;
 	u32 enc_codecs, dec_codecs, count = 0;
 	unsigned int entries;
-	int ret;
 
 	plat = hfi_platform_get(core->res->hfi_version);
 	if (!plat)
@@ -277,9 +276,8 @@ static int hfi_platform_parser(struct venus_core *core, struct venus_inst *inst)
 	if (inst)
 		return 0;
 
-	ret = hfi_platform_get_codecs(core, &enc_codecs, &dec_codecs, &count);
-	if (ret)
-		return ret;
+	if (plat->codecs)
+		plat->codecs(core, &enc_codecs, &dec_codecs, &count);
 
 	if (plat->capabilities)
 		caps = plat->capabilities(core, &entries);
diff --git a/drivers/media/platform/qcom/venus/hfi_platform.c b/drivers/media/platform/qcom/venus/hfi_platform.c
index cde7f93045ac45..f19572ab1d1613 100644
--- a/drivers/media/platform/qcom/venus/hfi_platform.c
+++ b/drivers/media/platform/qcom/venus/hfi_platform.c
@@ -2,9 +2,7 @@
 /*
  * Copyright (c) 2020, The Linux Foundation. All rights reserved.
  */
-#include <linux/of.h>
 #include "hfi_platform.h"
-#include "core.h"
 
 const struct hfi_platform *hfi_platform_get(enum hfi_version version)
 {
@@ -73,25 +71,3 @@ hfi_platform_get_codec_lp_freq(struct venus_core *core,
 
 	return freq;
 }
-
-int
-hfi_platform_get_codecs(struct venus_core *core, u32 *enc_codecs,
-			u32 *dec_codecs, u32 *count)
-{
-	const struct hfi_platform *plat;
-
-	plat = hfi_platform_get(core->res->hfi_version);
-	if (!plat)
-		return -EINVAL;
-
-	if (plat->codecs)
-		plat->codecs(core, enc_codecs, dec_codecs, count);
-
-	if (IS_IRIS2_1(core)) {
-		*enc_codecs &= ~HFI_VIDEO_CODEC_VP8;
-		*dec_codecs &= ~HFI_VIDEO_CODEC_VP8;
-	}
-
-	return 0;
-}
-
diff --git a/drivers/media/platform/qcom/venus/hfi_platform.h b/drivers/media/platform/qcom/venus/hfi_platform.h
index 5e4f8013a6b1db..a0b6d19f3e1a04 100644
--- a/drivers/media/platform/qcom/venus/hfi_platform.h
+++ b/drivers/media/platform/qcom/venus/hfi_platform.h
@@ -74,6 +74,4 @@ unsigned long hfi_platform_get_codec_vsp_freq(struct venus_core *core,
 unsigned long hfi_platform_get_codec_lp_freq(struct venus_core *core,
 					     enum hfi_version version,
 					     u32 codec, u32 session_type);
-int hfi_platform_get_codecs(struct venus_core *core, u32 *enc_codecs,
-			    u32 *dec_codecs, u32 *count);
 #endif
-- 
2.53.0



