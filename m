Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD155FDD6;
	Tue, 13 Feb 2024 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845637; cv=none; b=r4HxFK6JbtY6QJGtSsWKnlT8DxJ0sNuu52YWmr8LVv+TV2TZcZlO14ZZB+WJxWNZgCdSdX1gUvDY+uV3K0VYelK2n2u9R5zt7jtpwaQMJVlxd/yZFhCTVpAKRNLwB5bLueMxA0ryj5qXF0/AEndX6eLlcJ4UylpmFy9WdgFTyw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845637; c=relaxed/simple;
	bh=XlhZphAPXgfrQ+GZeYKpGNp4VDHeb/eZFwMmRk1gx6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhDEQ9BYbOkKHpr17qG1vHpeuqol+qJFI+VtaBuNX/RpwIB3a2m0QwH7N9vmkHDXEXwHPvTdj1UJHPZvU1c9tTyA9Pq65+pR4rAgWEB8JGvleRiqmMowij7Oeja0hLDismlOABOh0YU2QjBhHK7APMw2laJXB1zlQ/UPnRPZV0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3AGHIEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3AGHIEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250F2C433C7;
	Tue, 13 Feb 2024 17:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845637;
	bh=XlhZphAPXgfrQ+GZeYKpGNp4VDHeb/eZFwMmRk1gx6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3AGHIEZllCc//bqMMvLayASmtuxuju2LhJyDuqw1OQSSkmnomBNW2/mCIaaKMcB4
	 j2wWXx8OObnjswGX0AFUaOJk/Y00kXwM7gaZ+T4u3cP9KkXMBiM3OEPD/nANq4nAPs
	 3AP0vXg+GGcVX1X4jXe2WGOpt23EcYvyeGzNMLc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 016/124] drm/msms/dp: fixed link clock divider bits be over written in BPC unknown case
Date: Tue, 13 Feb 2024 18:20:38 +0100
Message-ID: <20240213171854.207951674@linuxfoundation.org>
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

[ Upstream commit 77e8aad5519e04f6c1e132aaec1c5f8faf41844f ]

Since the value of DP_TEST_BIT_DEPTH_8 is already left shifted, in the
BPC unknown case, the additional shift causes spill over to the other
bits of the [DP_CONFIGURATION_CTRL] register.
Fix this by changing the return value of dp_link_get_test_bits_depth()
in the BPC unknown case to (DP_TEST_BIT_DEPTH_8 >> DP_TEST_BIT_DEPTH_SHIFT).

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/573989/
Link: https://lore.kernel.org/r/1704917931-30133-1-git-send-email-quic_khsieh@quicinc.com
[quic_abhinavk@quicinc.com: fix minor checkpatch warning to align with opening braces]
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c |  5 -----
 drivers/gpu/drm/msm/dp/dp_link.c | 10 +++++++---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 77a8d9366ed7..fb588fde298a 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -135,11 +135,6 @@ static void dp_ctrl_config_ctrl(struct dp_ctrl_private *ctrl)
 	tbd = dp_link_get_test_bits_depth(ctrl->link,
 			ctrl->panel->dp_mode.bpp);
 
-	if (tbd == DP_TEST_BIT_DEPTH_UNKNOWN) {
-		pr_debug("BIT_DEPTH not set. Configure default\n");
-		tbd = DP_TEST_BIT_DEPTH_8;
-	}
-
 	config |= tbd << DP_CONFIGURATION_CTRL_BPC_SHIFT;
 
 	/* Num of Lanes */
diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
index 98427d45e9a7..a0015b9e79eb 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -1179,6 +1179,9 @@ void dp_link_reset_phy_params_vx_px(struct dp_link *dp_link)
 u32 dp_link_get_test_bits_depth(struct dp_link *dp_link, u32 bpp)
 {
 	u32 tbd;
+	struct dp_link_private *link;
+
+	link = container_of(dp_link, struct dp_link_private, dp_link);
 
 	/*
 	 * Few simplistic rules and assumptions made here:
@@ -1196,12 +1199,13 @@ u32 dp_link_get_test_bits_depth(struct dp_link *dp_link, u32 bpp)
 		tbd = DP_TEST_BIT_DEPTH_10;
 		break;
 	default:
-		tbd = DP_TEST_BIT_DEPTH_UNKNOWN;
+		drm_dbg_dp(link->drm_dev, "bpp=%d not supported, use bpc=8\n",
+			   bpp);
+		tbd = DP_TEST_BIT_DEPTH_8;
 		break;
 	}
 
-	if (tbd != DP_TEST_BIT_DEPTH_UNKNOWN)
-		tbd = (tbd >> DP_TEST_BIT_DEPTH_SHIFT);
+	tbd = (tbd >> DP_TEST_BIT_DEPTH_SHIFT);
 
 	return tbd;
 }
-- 
2.43.0



