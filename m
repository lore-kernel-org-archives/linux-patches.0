Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B375FDB5;
	Tue, 13 Feb 2024 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707844971; cv=none; b=fjERVr+4RThKeIBtosf6Wd61f1DdMbKyxUshEJaRglR2m3IB/qNUY/1hvxS7hXFr8MBP10VwIQC3EGOD0wtJUZMIfq7bukvWPVJZhaaRlTGEpr5Zomh5b5PDY0s7AobRfaM9aB+5u3sUo1q9WsC1cM9J4c0ESRvfGUDMrwcQRS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707844971; c=relaxed/simple;
	bh=bdLXMGvPlKF1CxIUjlGlMLxoLma9xb4ih6fspqDLDYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8D/Ac4EOnapNom1Gqpdf/cYQ4m9+DzzjCIGRiEzUeBB86TQMg4ODBtQi8D4KlhnlKy6blOxML0sH4/VHZ4nztzESvc8gQxsVbjz+HriabfZuARBz22XgC6ATdrJqHZJXGm9lrPMbRKr75tCY8bEaak54Pu3p5ewVtGttytdRPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIauKu3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIauKu3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F56C433F1;
	Tue, 13 Feb 2024 17:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707844970;
	bh=bdLXMGvPlKF1CxIUjlGlMLxoLma9xb4ih6fspqDLDYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIauKu3NaCt854rQ4h7btdkudUxcOulP+qAk6UbEVOZBcB8MHy0L7WuuieGYu+t3Z
	 ekVUO9t8dh+ZOaYfwQSUjfYiW9BBq7b0ay/iz6bflnjMFflF+jfuf6sRJ1XbBGJVL/
	 R7li4rWEoIbfpzFZOk0ugwlrol5LkSx4vqXAfNnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/64] drm/msms/dp: fixed link clock divider bits be over written in BPC unknown case
Date: Tue, 13 Feb 2024 18:20:56 +0100
Message-ID: <20240213171845.055023409@linuxfoundation.org>
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
index 103eef9f059a..b20701893e5b 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -133,11 +133,6 @@ static void dp_ctrl_config_ctrl(struct dp_ctrl_private *ctrl)
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
index cb66d1126ea9..3c7884c85f61 100644
--- a/drivers/gpu/drm/msm/dp/dp_link.c
+++ b/drivers/gpu/drm/msm/dp/dp_link.c
@@ -1172,6 +1172,9 @@ void dp_link_reset_phy_params_vx_px(struct dp_link *dp_link)
 u32 dp_link_get_test_bits_depth(struct dp_link *dp_link, u32 bpp)
 {
 	u32 tbd;
+	struct dp_link_private *link;
+
+	link = container_of(dp_link, struct dp_link_private, dp_link);
 
 	/*
 	 * Few simplistic rules and assumptions made here:
@@ -1189,12 +1192,13 @@ u32 dp_link_get_test_bits_depth(struct dp_link *dp_link, u32 bpp)
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



