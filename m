Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47A518E025;
	Tue, 17 Jun 2025 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176065; cv=none; b=Npoc7kAYKX5aMmVcHvR/Nm0ncn9o6EPduz4geK6wyqgeZvbhUU7qyJ0NUYFXBAXH+QdanJxGYESS8wW/J1qacL59kygbzqFiQcgHVQsNm1i7cFxcG4XEqT/+jiASFqTvlH/ITPH+/LOBWIbe/kQFQrjg2xidJebu4+EQwevfrDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176065; c=relaxed/simple;
	bh=eZOkdBp2F5xffS9zKoS5tbm0kQuQK6SX9Php+SlwVsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV0YrVSftuFN9VgG9RfpXYDq/CtEqgOP8zIfI6W18CL7LjLPbgsA8pCg3ERpMkvMJvTHIEYNIcZ+QyoSo3yALq/y86JtyHnzshVBV/Sm8W2RdA8lFSudBgeeXNnk4+gyBLlgtNSI1J5rvF+GhNjXWGag6Kvh755xg7YWr/oPSFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7CiFn8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7CiFn8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A28C4CEE3;
	Tue, 17 Jun 2025 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176065;
	bh=eZOkdBp2F5xffS9zKoS5tbm0kQuQK6SX9Php+SlwVsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7CiFn8Nrt6Dm0aVVwCY4BIXBka++YHmGzTTOHFnub8b6RHrc2ha+N0Wogx2AvpVC
	 2ENOYGhGNVOobY96PxCjWLU+TTAYuvBFmZTIVNveBwBg/lb20mtMnn3bDyTfwwWO+x
	 x2hoFqd0II5NautA6cYvugIQFsEcbRV5bz5Mp2lo=
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
Subject: [PATCH 6.15 148/780] drm/msm/dp: Prepare for link training per-segment for LTTPRs
Date: Tue, 17 Jun 2025 17:17:36 +0200
Message-ID: <20250617152457.533128995@linuxfoundation.org>
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

[ Upstream commit 7513ccb8840b54e35579f3c2cce08c3443a6e2d4 ]

Per-segment link training requires knowing the number of LTTPRs
(if any) present. Store the count during LTTPRs' initialization.

Fixes: 72d0af4accd9 ("drm/msm/dp: Add support for LTTPR handling")
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Tested-by: Jessica Zhang <quic_jesszhan@quicinc.com> # SA8775P
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Rob Clark <robdclark@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/652306/
Link: https://lore.kernel.org/r/20250507230113.14270-4-alex.vinarskis@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 17 +++++++++++------
 drivers/gpu/drm/msm/dp/dp_link.h    |  1 +
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 5c57c1d7ac601..ab8c1f19dcb42 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -367,16 +367,21 @@ static int msm_dp_display_send_hpd_notification(struct msm_dp_display_private *d
 	return 0;
 }
 
-static void msm_dp_display_lttpr_init(struct msm_dp_display_private *dp, u8 *dpcd)
+static int msm_dp_display_lttpr_init(struct msm_dp_display_private *dp, u8 *dpcd)
 {
-	int rc;
+	int rc, lttpr_count;
 
 	if (drm_dp_read_lttpr_common_caps(dp->aux, dpcd, dp->link->lttpr_common_caps))
-		return;
+		return 0;
 
-	rc = drm_dp_lttpr_init(dp->aux, drm_dp_lttpr_count(dp->link->lttpr_common_caps));
-	if (rc)
+	lttpr_count = drm_dp_lttpr_count(dp->link->lttpr_common_caps);
+	rc = drm_dp_lttpr_init(dp->aux, lttpr_count);
+	if (rc) {
 		DRM_ERROR("failed to set LTTPRs transparency mode, rc=%d\n", rc);
+		return 0;
+	}
+
+	return lttpr_count;
 }
 
 static int msm_dp_display_process_hpd_high(struct msm_dp_display_private *dp)
@@ -390,7 +395,7 @@ static int msm_dp_display_process_hpd_high(struct msm_dp_display_private *dp)
 	if (rc)
 		goto end;
 
-	msm_dp_display_lttpr_init(dp, dpcd);
+	dp->link->lttpr_count = msm_dp_display_lttpr_init(dp, dpcd);
 
 	rc = msm_dp_panel_read_sink_caps(dp->panel, connector);
 	if (rc)
diff --git a/drivers/gpu/drm/msm/dp/dp_link.h b/drivers/gpu/drm/msm/dp/dp_link.h
index c47d75cfc720c..ba47c6d19fbfa 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.h
+++ b/drivers/gpu/drm/msm/dp/dp_link.h
@@ -62,6 +62,7 @@ struct msm_dp_link_phy_params {
 
 struct msm_dp_link {
 	u8 lttpr_common_caps[DP_LTTPR_COMMON_CAP_SIZE];
+	int lttpr_count;
 
 	u32 sink_request;
 	u32 test_response;
-- 
2.39.5



