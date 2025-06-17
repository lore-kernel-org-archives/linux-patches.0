Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033DA2ECE84;
	Tue, 17 Jun 2025 16:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176055; cv=none; b=S/xF9ipiRH6DFdAy4DGWMi4801GH38NwZiJdvuihHwXcaILc7T97VOzOETs3EDy5IfvovQDHgzRc/t1wKg6cx9w1Fl88v6F+W7bQqPsACENScXIJsD67V2ed0G4caqH5Iiuwygljt4Z+Cp5g7pq+vZMIC/WEQ9LvlFJJBQr0+hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176055; c=relaxed/simple;
	bh=EzVQSnisQG8lcDrug676GcQucIWBD+nu5Zlus4Jnnuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiUNuqGidBOmevXpCRIhDjonFYs0UzY+yeUwQz5dhWnUYDjcZkWRr4sTSu17HUcGNjzstn4Thoj6L5DEqE3ilWWW3tvv9ZAKPsgcM1VqEDDDNX/H51k4ygQeofsxoesdFILPJUw0ByCoeFycLGVcNssldmRoDi9AJn6K7myJ4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpW61dN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpW61dN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673BBC4CEE3;
	Tue, 17 Jun 2025 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176054;
	bh=EzVQSnisQG8lcDrug676GcQucIWBD+nu5Zlus4Jnnuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpW61dN8uToUcbHt/8RASs2d5PWhTGF6aNSLmAeGAq1HuEKTdofSle+0eLAxME4jn
	 2vjyCvGoexRhumXYhk5I/gASCDXPAOo0tUP03RFdqWYRxkolS3AfK/LZQnCY9cfVpc
	 GhCE5Ask8r7p4w/8l3x3JA6qzqZkOAwDhFoceW4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Rob Clark <robdclark@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>
Subject: [PATCH 6.15 147/780] drm/msm/dp: Account for LTTPRs capabilities
Date: Tue, 17 Jun 2025 17:17:35 +0200
Message-ID: <20250617152457.493124604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

[ Upstream commit c156fe2dd46774321c8eaaff9a6f04b64e6b9742 ]

Take into account LTTPR capabilities when selecting maximum allowed
link rate, number of data lines.

Fixes: 72d0af4accd9 ("drm/msm/dp: Add support for LTTPR handling")
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Tested-by: Jessica Zhang <quic_jesszhan@quicinc.com> # SA8775P
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Rob Clark <robdclark@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/652302/
Link: https://lore.kernel.org/r/20250507230113.14270-3-alex.vinarskis@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c |  5 ++---
 drivers/gpu/drm/msm/dp/dp_link.h    |  3 +++
 drivers/gpu/drm/msm/dp/dp_panel.c   | 12 +++++++++++-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index fc07cce68382a..5c57c1d7ac601 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -369,13 +369,12 @@ static int msm_dp_display_send_hpd_notification(struct msm_dp_display_private *d
 
 static void msm_dp_display_lttpr_init(struct msm_dp_display_private *dp, u8 *dpcd)
 {
-	u8 lttpr_caps[DP_LTTPR_COMMON_CAP_SIZE];
 	int rc;
 
-	if (drm_dp_read_lttpr_common_caps(dp->aux, dpcd, lttpr_caps))
+	if (drm_dp_read_lttpr_common_caps(dp->aux, dpcd, dp->link->lttpr_common_caps))
 		return;
 
-	rc = drm_dp_lttpr_init(dp->aux, drm_dp_lttpr_count(lttpr_caps));
+	rc = drm_dp_lttpr_init(dp->aux, drm_dp_lttpr_count(dp->link->lttpr_common_caps));
 	if (rc)
 		DRM_ERROR("failed to set LTTPRs transparency mode, rc=%d\n", rc);
 }
diff --git a/drivers/gpu/drm/msm/dp/dp_link.h b/drivers/gpu/drm/msm/dp/dp_link.h
index 8db5d5698a97c..c47d75cfc720c 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.h
+++ b/drivers/gpu/drm/msm/dp/dp_link.h
@@ -7,6 +7,7 @@
 #define _DP_LINK_H_
 
 #include "dp_aux.h"
+#include <drm/display/drm_dp_helper.h>
 
 #define DS_PORT_STATUS_CHANGED 0x200
 #define DP_TEST_BIT_DEPTH_UNKNOWN 0xFFFFFFFF
@@ -60,6 +61,8 @@ struct msm_dp_link_phy_params {
 };
 
 struct msm_dp_link {
+	u8 lttpr_common_caps[DP_LTTPR_COMMON_CAP_SIZE];
+
 	u32 sink_request;
 	u32 test_response;
 
diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 92415bf8aa166..4e8ab75c771b1 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -47,7 +47,7 @@ static void msm_dp_panel_read_psr_cap(struct msm_dp_panel_private *panel)
 
 static int msm_dp_panel_read_dpcd(struct msm_dp_panel *msm_dp_panel)
 {
-	int rc;
+	int rc, max_lttpr_lanes, max_lttpr_rate;
 	struct msm_dp_panel_private *panel;
 	struct msm_dp_link_info *link_info;
 	u8 *dpcd, major, minor;
@@ -75,6 +75,16 @@ static int msm_dp_panel_read_dpcd(struct msm_dp_panel *msm_dp_panel)
 	if (link_info->rate > msm_dp_panel->max_dp_link_rate)
 		link_info->rate = msm_dp_panel->max_dp_link_rate;
 
+	/* Limit data lanes from LTTPR capabilities, if any */
+	max_lttpr_lanes = drm_dp_lttpr_max_lane_count(panel->link->lttpr_common_caps);
+	if (max_lttpr_lanes && max_lttpr_lanes < link_info->num_lanes)
+		link_info->num_lanes = max_lttpr_lanes;
+
+	/* Limit link rate from LTTPR capabilities, if any */
+	max_lttpr_rate = drm_dp_lttpr_max_link_rate(panel->link->lttpr_common_caps);
+	if (max_lttpr_rate && max_lttpr_rate < link_info->rate)
+		link_info->rate = max_lttpr_rate;
+
 	drm_dbg_dp(panel->drm_dev, "version: %d.%d\n", major, minor);
 	drm_dbg_dp(panel->drm_dev, "link_rate=%d\n", link_info->rate);
 	drm_dbg_dp(panel->drm_dev, "lane_count=%d\n", link_info->num_lanes);
-- 
2.39.5



