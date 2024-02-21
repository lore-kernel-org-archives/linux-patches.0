Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D965173161;
	Wed, 21 Feb 2024 13:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523064; cv=none; b=Bh4s6d+5VSNaDU9PSl3n1AAKGYffRJCjfOAxJHEUAJSQ/3m+09MpLQ7+0qb/wdlpAI1DmFEA55fQz2vMnTjsz8Vvce+sMGGFFfaXnOcX/80QNsOW7cJOCMpPH7F1qyfUXcKMLRxiJEYUe1J1/abDqfaXNBH+eitsw/Uff203Rpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523064; c=relaxed/simple;
	bh=7qzgHFcr6JVsg2RDmqO9DhskZHlBzAy2hp6f5t+4BRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVxTfoK/W7Td4jIbTlymwfoIJtanTBhRfMcf9pmU5AZcWzugXBCH3zQjU1rbat557VSJWBGqNmXG373qZEmCSPgyGjk5xTNJ1NSc7fMIh+F7iYcNsFz/vip0r+11BtBqNana0/NRejw9qOBR3lC2xGGDvcu9g1Ov3YUIi6bAk2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sjp5Z8E2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sjp5Z8E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690C8C433C7;
	Wed, 21 Feb 2024 13:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523063;
	bh=7qzgHFcr6JVsg2RDmqO9DhskZHlBzAy2hp6f5t+4BRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sjp5Z8E224ViFd5+AnXaS59VFZ5x0bn/H7vfNhwU5mF4N6qxckLQSSpTDIlJX6LKP
	 lwv0uTUPfYJkusEBJICvRHNgNqJUEV/w0IxSX3MvacFM9tvw5B/Xq16RrO/oyH3C5r
	 xvn2pRHfc/YJUvofiOW43aC9zobyPkX1YfZvTAh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/476] drm/msm/dp: return correct Colorimetry for DP_TEST_DYNAMIC_RANGE_CEA case
Date: Wed, 21 Feb 2024 14:05:54 +0100
Message-ID: <20240221130019.198854875@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d4d31e5bda07..0b4539be0685 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -7,6 +7,7 @@
 
 #include <drm/drm_print.h>
 
+#include "dp_reg.h"
 #include "dp_link.h"
 #include "dp_panel.h"
 
@@ -1064,7 +1065,7 @@ int dp_link_process_request(struct dp_link *dp_link)
 
 int dp_link_get_colorimetry_config(struct dp_link *dp_link)
 {
-	u32 cc;
+	u32 cc = DP_MISC0_COLORIMERY_CFG_LEGACY_RGB;
 	struct dp_link_private *link;
 
 	if (!dp_link) {
@@ -1078,10 +1079,11 @@ int dp_link_get_colorimetry_config(struct dp_link *dp_link)
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



