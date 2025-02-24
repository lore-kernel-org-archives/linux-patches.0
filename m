Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C032A8D0;
	Mon, 24 Feb 2025 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408671; cv=none; b=Lw+h7ax7pnKhll0ZMJAkCvI2QTkh0JeyslpiAx37dpVMR+0oANbuFpFo4wx0WEdCva/EDujaCwcwgu7UpfvES+eVYZ5qvzNT8gdNLgitiodpJgzoBWmjoA6TIGqhk6EcmB02OTVEVUEhCLNF+nLLXhBzyEbqSWdNfVjN4nJA2ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408671; c=relaxed/simple;
	bh=xABUmeKrldANRz5XSDlK2dIuzrUvn2gGOhvVQBDxlWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7M1yjT3JpxhLq1utOsGuKpCXyTUTLfl+J2gcCjAnPfFC9lDLyjmldsXQQmLTuERooyp1j+o65Wdi2Nbzgdk3pLre5bxWTL0lOwQy7GJZjX7DatYoY/ZNHdQa4xjLqUSi2r+Blz6m53MeRF5kFwNIu2vTgFFgLMPGNRzcDQcJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9NH3S9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9NH3S9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2222C4CED6;
	Mon, 24 Feb 2025 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408671;
	bh=xABUmeKrldANRz5XSDlK2dIuzrUvn2gGOhvVQBDxlWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9NH3S9EHkx4SXqBnB6xU83VWVXS3SdjSKoRANsmAbfvJiM7qxRukElcUsUWkVZXf
	 SOs69XhnNuelso1K+tw7xQd8TTyPNwDGVx1Qqg4II26TtOJj80R486BO88xNNv5jWI
	 Z74052gmEse0IYCUBG2YH/+lgAjv8IwsJxMN7SjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/154] drm/msm/dpu: skip watchdog timer programming through TOP on >= SM8450
Date: Mon, 24 Feb 2025 15:34:53 +0100
Message-ID: <20250224142610.747406992@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 2f69e54584475ac85ea0e3407c9198ac7c6ea8ad ]

The SM8450 and later chips have DPU_MDP_PERIPH_0_REMOVED feature bit
set, which means that those platforms have dropped some of the
registers, including the WD TIMER-related ones. Stop providing the
callback to program WD timer on those platforms.

Fixes: 100d7ef6995d ("drm/msm/dpu: add support for SM8450")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/628874/
Link: https://lore.kernel.org/r/20241214-dpu-drop-features-v1-1-988f0662cb7e@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c
index 0f40eea7f5e24..2040bee8d512f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c
@@ -272,7 +272,7 @@ static void _setup_mdp_ops(struct dpu_hw_mdp_ops *ops,
 
 	if (cap & BIT(DPU_MDP_VSYNC_SEL))
 		ops->setup_vsync_source = dpu_hw_setup_vsync_sel;
-	else
+	else if (!(cap & BIT(DPU_MDP_PERIPH_0_REMOVED)))
 		ops->setup_vsync_source = dpu_hw_setup_wd_timer;
 
 	ops->get_safe_status = dpu_hw_get_safe_status;
-- 
2.39.5



