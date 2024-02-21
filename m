Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAF67F7F1;
	Wed, 21 Feb 2024 14:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524558; cv=none; b=Gw+1nCKVCxiCpk6ddAxhKDTvgG8jD6cRl0X4/5W5EBD6rb0mTHO+xvwIGmUEG4xZtqDrId7FMCSx0hE+L//Hj8GDuzLV9Ddm3mqdvOdSlzWcyGYuWIKdodSyDcAteGbPbiijLIBUAPVs0QmoHhN7c/Cmm3kgyEgMILWa0PhG1Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524558; c=relaxed/simple;
	bh=xJDbo8/nGslHvQrO4DfDS4B5fr/GTVPwrOGh2vEWf5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIjudngWy95Yri6PWvGo/kPeWs70DjnVUNf7pfPSsW/7iGdDl5oVyb01c5kPx7L6NWnJoWfkUeVrAz9cgc0pJQ4EC6CSTe+Ptmag/+P1QSFwlgT3LTPO4zEJZXTE4YOvVbBdM7mcLib4uQXKYs70arU391A6+4vim2AlsT0uQa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vl4R3A8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vl4R3A8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2699EC433F1;
	Wed, 21 Feb 2024 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524557;
	bh=xJDbo8/nGslHvQrO4DfDS4B5fr/GTVPwrOGh2vEWf5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vl4R3A8f3MJea/uIwBeITZFGDSRxzXOcHDDkR2cyJCrs6IUTC+wa0Qraqt6ysjFef
	 /bHNp83BX4sjlbkefysf8Ce0ivBU/E/kjm66E/CKUalxkijBdM3gDkTIwU2fvWionk
	 4qT+mfoUMpSwax4tFLbstA33JE3xCsjPqZzySIVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/379] drm/msm/dp: return correct Colorimetry for DP_TEST_DYNAMIC_RANGE_CEA case
Date: Wed, 21 Feb 2024 14:07:12 +0100
Message-ID: <20240221130002.401957997@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index be986da78c4a..172a33e8fd8f 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -7,6 +7,7 @@
 
 #include <drm/drm_print.h>
 
+#include "dp_reg.h"
 #include "dp_link.h"
 #include "dp_panel.h"
 
@@ -1078,7 +1079,7 @@ int dp_link_process_request(struct dp_link *dp_link)
 
 int dp_link_get_colorimetry_config(struct dp_link *dp_link)
 {
-	u32 cc;
+	u32 cc = DP_MISC0_COLORIMERY_CFG_LEGACY_RGB;
 	struct dp_link_private *link;
 
 	if (!dp_link) {
@@ -1092,10 +1093,11 @@ int dp_link_get_colorimetry_config(struct dp_link *dp_link)
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



