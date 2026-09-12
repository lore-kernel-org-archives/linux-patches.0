Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120EC3B71DA;
	Sat, 12 Sep 2026 10:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209198; cv=none; b=QmaK1dAjR98yghwZ39BqukNzAkzACthlUe7lEQnL+QzwOZTPRcHXB3o2eD7oghCUihrvAH6Blg6OlxsJmr17wZy9fwGhfb8yRgZw8y2E6kRHfsYAdwgkr6exR4MHPiJHjYxQz7rzMKJ2hUD0lehWnjIbBTgfxV0/uGUUGJQjPM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209198; c=relaxed/simple;
	bh=HAHRL2ZnREJM9QXF+EqSt2t9GksqGlAH5aZJjxxE/aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dC9rNxfC9ZiPF+8cE7TaJn+wji/YFbJIx7uSWbCdJrs3Cyl7tWMuFR9C7KxR0VirWZEr/ylu+0Wujz1q9jjn6WGj8Xi5e+kLcVQLtS7jDAUNMtjU3dsaQUqxCl78GtFHcrP0zR6uDQbExEJBzsvc3mbUOzCL6xzgBy9ZXmGwTIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3U/31ZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3U/31ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45AF1F000FF;
	Sat, 12 Sep 2026 10:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209196;
	bh=AwW4+NjMjfqJcnJw8FysINsiMY8yjt7fx2eEj2Bt7Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3U/31ZK2fZpVfdMld8Q4RzyxOGeQpu8+MPrcp3Mr8lxFvXWkP8lMXwG9T5WjtEvJ
	 JwTZGuufDsWv0BBnIoNgzp+xv5F/OjyX2LfWWxnjwjz5lIKepxs49+pPXyxtqsBV7/
	 nktjpotzBDpNLizt6csq09hyaRcdjsGLsO/ba5v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0771/1518] drm/msm/dp: Drop dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:49:00 +0200
Message-ID: <20260912065640.875717260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit cebfa9909e27ec7b7cbaec25ee5516cf886baa39 ]

dev_pm_opp_set_rate(0) removes the vote specified in required-opps but
does not actually park the clock, making it run without the necessary
power backing. Drop the explicit calls to it.

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/742781/
Link: https://lore.kernel.org/r/20260728-topic-dpu_power-v1-2-e7783b859a70@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 38ed4de8313e3..2ff7db77a82b6 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1941,13 +1941,12 @@ static int msm_dp_ctrl_reinitialize_mainlink(struct msm_dp_ctrl_private *ctrl)
 	msm_dp_ctrl_mainlink_disable(ctrl);
 	ctrl->phy_opts.dp.lanes = ctrl->link->link_params.num_lanes;
 	phy_configure(phy, &ctrl->phy_opts);
+
 	/*
 	 * Disable and re-enable the mainlink clock since the
 	 * link clock might have been adjusted as part of the
 	 * link maintenance.
 	 */
-	dev_pm_opp_set_rate(ctrl->dev, 0);
-
 	msm_dp_ctrl_link_clk_disable(&ctrl->msm_dp_ctrl);
 
 	phy_power_off(phy);
@@ -1973,7 +1972,6 @@ static int msm_dp_ctrl_deinitialize_mainlink(struct msm_dp_ctrl_private *ctrl)
 
 	msm_dp_ctrl_reset(&ctrl->msm_dp_ctrl);
 
-	dev_pm_opp_set_rate(ctrl->dev, 0);
 	msm_dp_ctrl_link_clk_disable(&ctrl->msm_dp_ctrl);
 
 	phy_power_off(phy);
@@ -2620,7 +2618,6 @@ void msm_dp_ctrl_off(struct msm_dp_ctrl *msm_dp_ctrl)
 		ctrl->stream_clks_on = false;
 	}
 
-	dev_pm_opp_set_rate(ctrl->dev, 0);
 	msm_dp_ctrl_link_clk_disable(&ctrl->msm_dp_ctrl);
 
 	phy_power_off(phy);
-- 
2.53.0



