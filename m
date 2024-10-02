Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE931D1F74;
	Wed,  2 Oct 2024 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877919; cv=none; b=fO7W7TWBNZkPkQdTLuHY8JtXb1pV5g783tuJ+p83iBL1pnvDQ3dWg/foSsJnH9UPeRmh+hfy4hdNyWNyEsjrkmX5+2D/75JmYBx3BLv73lGG5X+ylEr/90Bc1xEjGYupJfrdKmAWm7uNqDSU2v9pigx5zstiQd7BMVqaDeeyzbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877919; c=relaxed/simple;
	bh=pnUxWqlhOS2Te6gO3uxsAypm8MBl8rv+eWbRTtdBrMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icYDp5g4aQhekc80YK/XmKBEdaF0b53V/4mr9zuaeY8X97Q3CRXSkJYGvGk+S+GV0v6x7WNguqVOy82iyd0av51qZvciAqQbwsB3I7P0yVffdqXyiFjJHkVfd/WW38VQq3IzHKYgiiOuBFaQ7S5PVteUAP/xKHUJ+nbtOyXwAWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbw/vGig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbw/vGig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87565C4CEC2;
	Wed,  2 Oct 2024 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877918;
	bh=pnUxWqlhOS2Te6gO3uxsAypm8MBl8rv+eWbRTtdBrMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbw/vGiga//BJzmcLnVWJs3gIu1wT7f5MhNCH0m02JbDlrK2MglTfs4VH+m1Y/gyx
	 oCb4/sFVPV8doBck6UsVuE171Rb2uVHUs12VXaB29yFDma30P23lduk4kqebmUkYad
	 KQjv59TpKDcM+17ODv37bzaSim268VgODWbPgFsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 208/634] drm/msm/dp: enable widebus on all relevant chipsets
Date: Wed,  2 Oct 2024 14:55:08 +0200
Message-ID: <20241002125819.315705262@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit c7c412202623951dcfc22316f5255fd84fd56186 ]

Hardware document indicates that widebus is recommended on DP on all
MDSS chipsets starting version 5.x.x and above.

Follow the guideline and mark widebus support on all relevant
chipsets for DP.

Fixes: 766f705204a0 ("drm/msm/dp: Remove now unused connector_type from desc")
Fixes: 1b2d98bdd7b7 ("drm/msm/dp: Add DisplayPort controller for SM8650")
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 757a2f36ab09 ("drm/msm/dp: enable widebus feature for display port")
Fixes: 1b2d98bdd7b7 ("drm/msm/dp: Add DisplayPort controller for SM8650")
Patchwork: https://patchwork.freedesktop.org/patch/606556/
Link: https://lore.kernel.org/r/20240730195012.2595980-1-quic_abhinavk@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 672a7ba52edad..9dc44ea85b7c6 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -119,7 +119,7 @@ struct msm_dp_desc {
 };
 
 static const struct msm_dp_desc sc7180_dp_descs[] = {
-	{ .io_start = 0x0ae90000, .id = MSM_DP_CONTROLLER_0 },
+	{ .io_start = 0x0ae90000, .id = MSM_DP_CONTROLLER_0, .wide_bus_supported = true },
 	{}
 };
 
@@ -130,9 +130,9 @@ static const struct msm_dp_desc sc7280_dp_descs[] = {
 };
 
 static const struct msm_dp_desc sc8180x_dp_descs[] = {
-	{ .io_start = 0x0ae90000, .id = MSM_DP_CONTROLLER_0 },
-	{ .io_start = 0x0ae98000, .id = MSM_DP_CONTROLLER_1 },
-	{ .io_start = 0x0ae9a000, .id = MSM_DP_CONTROLLER_2 },
+	{ .io_start = 0x0ae90000, .id = MSM_DP_CONTROLLER_0, .wide_bus_supported = true },
+	{ .io_start = 0x0ae98000, .id = MSM_DP_CONTROLLER_1, .wide_bus_supported = true },
+	{ .io_start = 0x0ae9a000, .id = MSM_DP_CONTROLLER_2, .wide_bus_supported = true },
 	{}
 };
 
@@ -149,7 +149,7 @@ static const struct msm_dp_desc sc8280xp_dp_descs[] = {
 };
 
 static const struct msm_dp_desc sm8650_dp_descs[] = {
-	{ .io_start = 0x0af54000, .id = MSM_DP_CONTROLLER_0 },
+	{ .io_start = 0x0af54000, .id = MSM_DP_CONTROLLER_0, .wide_bus_supported = true },
 	{}
 };
 
-- 
2.43.0



