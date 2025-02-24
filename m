Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A51824502A;
	Mon, 24 Feb 2025 14:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409006; cv=none; b=SFqmoFWRsG1vKY5/5nirWUY/cB+w2zEcA+JPhIe55rUdnikaAVqLm3xrXSrPyy0KsXHUpJbCPvJ+3IpjcBxTWQyfMQbUIqLvpPUtsrS3+xzT13HYLnDYQt26rLN5cVV1FAa8/VHqzm4r9sro5Ruby2YRs8j+aKTtZvhKNhCT9k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409006; c=relaxed/simple;
	bh=ytyYYd44ltk/qgYAUOoCYX64+QiumJVwj5yXSsFBpL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqL0ImqHVD1Tnn7NKZYee9chylBw8Hq4Iko21I5oybuyq4JK8A7NPbr6AlL80+i4kjgAa8fJV7KXZKRd1yZ7hys6jhMsp7zZ2bi0dGk1+b3BmFTBPJsaPl9Q+EQ77ghZjo6b9dGBcm281KPrg5lGQM6F714b8rJJjx5lkhmFqqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yF7e9ZUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yF7e9ZUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0621EC4CED6;
	Mon, 24 Feb 2025 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409006;
	bh=ytyYYd44ltk/qgYAUOoCYX64+QiumJVwj5yXSsFBpL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yF7e9ZUPUFpZGgap+bmHNDPTow074w9aEOmAvl2IE2/zw+OnkGAuGc12Sh5+4BVuT
	 RnB1t98pC7HQu9TlPbn6IPmOjEJUYn+y8RjA5QvZGxzN9NDG+LEDAsC4206blox/ZL
	 89JB9gNvN0YuhJaRPiKA4h73hHOMydG+ITLY7hQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 070/138] drm/msm/dpu: skip watchdog timer programming through TOP on >= SM8450
Date: Mon, 24 Feb 2025 15:35:00 +0100
Message-ID: <20250224142607.227188129@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index ad19330de61ab..562a3f4c5238a 100644
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



