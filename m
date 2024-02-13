Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11A05FDB5;
	Tue, 13 Feb 2024 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707844975; cv=none; b=g2WTBl+uv5KlXqqOOO9aCDN/7JOWLH63s07Divs8O5u3xNNxdukA1vyyPkSA7TMebMsi5yDgAZwpKw6D8OEc5HrXYAaYyzGoBgV4EmkmT/ssjpFg+Ssq5WrQPaiMsi4Z0sWW18MOCOcUEuMW2N9IJ0iVkIR9riL6t4jf1cc4thM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707844975; c=relaxed/simple;
	bh=ggorJiLnHNfhONmO5V+lCLm/Uq1GkFOGmgn6tuDFUMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c97moWs/NsncrrdbUJqMLTYmStThLXmpN5x1LvAEdDSinQUAmlQVT1pxqlkwIKzKQXhRy30f+Uyt4iyIJ6xy6x6iZEL7NZg+NGQvTwYNUCgjxrDpTnkQ0jBTtRN0orpvjEis1XBs6PcQxZLvg53yGoFub/mB5TStT5qJjc0DaTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4SILU40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4SILU40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9813C433C7;
	Tue, 13 Feb 2024 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707844974;
	bh=ggorJiLnHNfhONmO5V+lCLm/Uq1GkFOGmgn6tuDFUMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4SILU40cELaTsvdAuMcn1nLG1b13JF080UNTX5IxqhXTYjki8dM7yswpuJKER06n
	 Ad7iKIvsWsskAaMi1moamBUi/43r+EUj20ttj0OI1tJzChp5hJOcoxkp5vKzUBEzLQ
	 FkUdl1JIPGxTAokv/NtToF1PJKatoxVrmYo3DSW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/64] drm/msm/dp: return correct Colorimetry for DP_TEST_DYNAMIC_RANGE_CEA case
Date: Tue, 13 Feb 2024 18:20:57 +0100
Message-ID: <20240213171845.084647237@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit fcccdafd91f8bdde568b86ff70848cf83f029add ]

MSA MISC0 bit 1 to 7 contains Colorimetry Indicator Field.
dp_link_get_colorimetry_config() returns wrong colorimetry value
in the DP_TEST_DYNAMIC_RANGE_CEA case in the current implementation.
Hence fix this problem by having dp_link_get_colorimetry_config()
return defined CEA RGB colorimetry value in the case of
DP_TEST_DYNAMIC_RANGE_CEA.

Changes in V2:
-- drop retrieving colorimetry from colorspace
-- drop dr = link->dp_link.test_video.test_dyn_range assignment

Changes in V3:
-- move defined MISCr0a Colorimetry vale to dp_reg.h
-- rewording commit title
-- rewording commit text to more precise describe this patch

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/574888/
Link: https://lore.kernel.org/r/1705526010-597-1-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_link.c | 12 +++++++-----
 drivers/gpu/drm/msm/dp/dp_reg.h  |  3 +++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index 3c7884c85f61..ceb382fa56d5 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -7,6 +7,7 @@
 
 #include <drm/drm_print.h>
 
+#include "dp_reg.h"
 #include "dp_link.h"
 #include "dp_panel.h"
 
@@ -1075,7 +1076,7 @@ int dp_link_process_request(struct dp_link *dp_link)
 
 int dp_link_get_colorimetry_config(struct dp_link *dp_link)
 {
-	u32 cc;
+	u32 cc = DP_MISC0_COLORIMERY_CFG_LEGACY_RGB;
 	struct dp_link_private *link;
 
 	if (!dp_link) {
@@ -1089,10 +1090,11 @@ int dp_link_get_colorimetry_config(struct dp_link *dp_link)
 	 * Unless a video pattern CTS test is ongoing, use RGB_VESA
 	 * Only RGB_VESA and RGB_CEA supported for now
 	 */
-	if (dp_link_is_video_pattern_requested(link))
-		cc = link->dp_link.test_video.test_dyn_range;
-	else
-		cc = DP_TEST_DYNAMIC_RANGE_VESA;
+	if (dp_link_is_video_pattern_requested(link)) {
+		if (link->dp_link.test_video.test_dyn_range &
+					DP_TEST_DYNAMIC_RANGE_CEA)
+			cc = DP_MISC0_COLORIMERY_CFG_CEA_RGB;
+	}
 
 	return cc;
 }
diff --git a/drivers/gpu/drm/msm/dp/dp_reg.h b/drivers/gpu/drm/msm/dp/dp_reg.h
index 268602803d9a..176a503ece9c 100644
--- a/drivers/gpu/drm/msm/dp/dp_reg.h
+++ b/drivers/gpu/drm/msm/dp/dp_reg.h
@@ -129,6 +129,9 @@
 #define DP_MISC0_COLORIMETRY_CFG_SHIFT		(0x00000001)
 #define DP_MISC0_TEST_BITS_DEPTH_SHIFT		(0x00000005)
 
+#define DP_MISC0_COLORIMERY_CFG_LEGACY_RGB	(0)
+#define DP_MISC0_COLORIMERY_CFG_CEA_RGB		(0x04)
+
 #define REG_DP_VALID_BOUNDARY			(0x00000030)
 #define REG_DP_VALID_BOUNDARY_2			(0x00000034)
 
-- 
2.43.0



