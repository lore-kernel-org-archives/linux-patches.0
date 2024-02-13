Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0755FDD6;
	Tue, 13 Feb 2024 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845641; cv=none; b=YQZN4ABWgxTYVbY0KmQlV6mzZEHNpDsESHBIyy7LMf2VpNN04m55uJxPS5AHZVn9eVPncz6SKh+5vsE4iYkGElXrVu9kNNdnjCFeaEgDBqnceX5ViKpMUVJ7VO+RAKuWctgY/wQ3MGajFZhdMYjTKeNrP45DWrh3lIFK3aXs6qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845641; c=relaxed/simple;
	bh=ObmzF+Ivd/NzvZeA8/Zbs+JDtyWivto3vWbDwD81Z8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k83czTSOtnys+ldUQXGMvcfreCdv3JPJa7vqfNdXy+wHVhp/U3dTHLHoWBKb8rDcEhkiJdyt6RT1haZnAIGgG0rEcYhEYfDtph/5wWT65Q1yM4b335UrHEyA7keAqKgzRtpRmzk3qoL7teh+bDtKpQI0L4uzmg56G7HgCoee+N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPDz5UJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPDz5UJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B29C433F1;
	Tue, 13 Feb 2024 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845640;
	bh=ObmzF+Ivd/NzvZeA8/Zbs+JDtyWivto3vWbDwD81Z8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPDz5UJHLa+A9oTw6teN6ljhL2uHOF+r83V8Z6pS7MqvNFkNob5/lF0Vk5FUBWycI
	 nf+s3BlRO3dnqbl8q6A6nKpE/enVNyjZaQyNnyKhZ2nMgcXoog6uTeJwDAfaEj/uo0
	 ojgEpvVlu74wMeeK5F82YxojR1Oux6c0pKSQVkNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 017/124] drm/msm/dp: return correct Colorimetry for DP_TEST_DYNAMIC_RANGE_CEA case
Date: Tue, 13 Feb 2024 18:20:39 +0100
Message-ID: <20240213171854.236272178@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index a0015b9e79eb..49dfac1fd1ef 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -7,6 +7,7 @@
 
 #include <drm/drm_print.h>
 
+#include "dp_reg.h"
 #include "dp_link.h"
 #include "dp_panel.h"
 
@@ -1082,7 +1083,7 @@ int dp_link_process_request(struct dp_link *dp_link)
 
 int dp_link_get_colorimetry_config(struct dp_link *dp_link)
 {
-	u32 cc;
+	u32 cc = DP_MISC0_COLORIMERY_CFG_LEGACY_RGB;
 	struct dp_link_private *link;
 
 	if (!dp_link) {
@@ -1096,10 +1097,11 @@ int dp_link_get_colorimetry_config(struct dp_link *dp_link)
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
index ea85a691e72b..78785ed4b40c 100644
--- a/drivers/gpu/drm/msm/dp/dp_reg.h
+++ b/drivers/gpu/drm/msm/dp/dp_reg.h
@@ -143,6 +143,9 @@
 #define DP_MISC0_COLORIMETRY_CFG_SHIFT		(0x00000001)
 #define DP_MISC0_TEST_BITS_DEPTH_SHIFT		(0x00000005)
 
+#define DP_MISC0_COLORIMERY_CFG_LEGACY_RGB	(0)
+#define DP_MISC0_COLORIMERY_CFG_CEA_RGB		(0x04)
+
 #define REG_DP_VALID_BOUNDARY			(0x00000030)
 #define REG_DP_VALID_BOUNDARY_2			(0x00000034)
 
-- 
2.43.0



