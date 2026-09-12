Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C628638F259;
	Sat, 12 Sep 2026 08:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201117; cv=none; b=V5uRiDwZmD/GRslbek3V62mbxZoZf/MJV18SR+vBIoq0+nnxOCC8Yl96Cfa5y9gATWKem7H2VVGPq2H4kUgyRqLyP9Z8h0ltzH92e/Akdl9O/+LruhtU6nPI6oNjILgW6gTfr1nY+CVvMRJXnxR6qkxtVyINRe16lzhnyk0wVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201117; c=relaxed/simple;
	bh=Wq4/414Sl0HzzHIVVDZlUYbR03VDuHhCOrJgvzeTjiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRieZNYh5SRJrBvfPGZkO6QU2wrU8WIsWoTeJeg9zb6NWk/pALGGcYZ+7KSgITUlFb8g60rhg/WeHn6DDL7Jwe1R5SJmNBDZJtRvKTaevR9LFXgPyKSFv3Fr8Cby3Yd3fE8Q8YRV3aC3JppkZ4nDXP5TG0jKmybe3xrA46fezqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1j6Vdzno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1j6Vdzno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0D51F000FF;
	Sat, 12 Sep 2026 08:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201116;
	bh=+hiC74SyxWBDT1gevcxPdOCyorwou2WvMCkloFsp/I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1j6VdznoDRgTOKQtse/Fi48l96qp2rJ0nTYWedyfeLfUmIE5wSimTXetfWn4zgb5Y
	 RgkpjujEj/CAD88WhDHg2dVSUdOV4zKIMjoZTCNN9Yycs1mE5zZaGgNE1U29XvUtLb
	 fsKURQkMK8YqjRZohMkyOXT5sKIBTcsinwUAu1Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0913/1815] drm/msm/dp: Drop dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:44:23 +0200
Message-ID: <20260912065710.355509734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 86ef8c89ad443..9024abdc2c569 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1950,13 +1950,12 @@ static int msm_dp_ctrl_reinitialize_mainlink(struct msm_dp_ctrl_private *ctrl)
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
@@ -1982,7 +1981,6 @@ static int msm_dp_ctrl_deinitialize_mainlink(struct msm_dp_ctrl_private *ctrl)
 
 	msm_dp_ctrl_reset(&ctrl->msm_dp_ctrl);
 
-	dev_pm_opp_set_rate(ctrl->dev, 0);
 	msm_dp_ctrl_link_clk_disable(&ctrl->msm_dp_ctrl);
 
 	phy_power_off(phy);
@@ -2602,7 +2600,6 @@ void msm_dp_ctrl_off(struct msm_dp_ctrl *msm_dp_ctrl)
 		ctrl->stream_clks_on = false;
 	}
 
-	dev_pm_opp_set_rate(ctrl->dev, 0);
 	msm_dp_ctrl_link_clk_disable(&ctrl->msm_dp_ctrl);
 
 	phy_power_off(phy);
-- 
2.53.0



