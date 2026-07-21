Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E65472F71;
	Tue, 21 Jul 2026 17:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656147; cv=none; b=Xz0hNjA21RUj71UEynawYmPLR0wGoy6tLsrBA0qn9sY9XmRduqDEeRrIrIrd+oMYtL+sYDnE+7IgVOkHRsoXwqyz0fKmKL+vhXst2AnDH9EfztBnVJxQ6cN/UiKn8E0XLOWt6v6P+MnzWrHhP+/tueEWobXDSyyrHvgxbNJiDPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656147; c=relaxed/simple;
	bh=Xv+6+IM8r/ISED9RQueE6TYiMpG6POjpFgOcQhitkKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj4JhTehtzh1qNPBB//m9p2clDqzJwLltLV6L2WXLrKG6escEngiIyxmoLZvpmTCSSXRneHI/3Jfb+q+TnLxS94RSAd9+UDnh+HenKWUPHIvj2BbM80KLcI1hMVYkaVMynYfYMuC2SlrAjE7in6SbexrFAy5FiMLuoWWtNZrqDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/6O8Q6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/6O8Q6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043FF1F000E9;
	Tue, 21 Jul 2026 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656146;
	bh=lgjKjy1jsF8X/V34n6U2xMLJF/058X3Sk22wSiojAxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/6O8Q6a5EQoOviqj1VFRJBX4ccXp+6H/xHWBKvsGnwREzrgHFVVLlQ1dV3cURuny
	 yv8ItLDGHS20ealSKLCRbC+vXjYsEt8inDKKHR58ZkXFMk57SniooPhIWCMImXjBYw
	 TMNE1yp3B40kSK1Ru4o7EuQm6LJnqRnD8m4qopto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0275/1611] Revert "media: venus: hfi_platform: Correct supported codecs for sc7280"
Date: Tue, 21 Jul 2026 17:06:31 +0200
Message-ID: <20260721152521.238722631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



