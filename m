Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB87171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0D7C433D2;
	Mon, 22 May 2023 19:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784796;
	bh=vVI4l1jEKf0hdl0946p8RtNGxMbIhnaC/dSkh03R8xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qITQVN+TwM7acE0zVllIVJPF3X6rx6TwQvLKE+s18kziarML8BtpVpSUbgWcQYeu9
	 9nUKUjeyS9xJJVCWraHahmC9Fgbbz0QgrAAMzjKRykmKxOy1B91b5degJsM8oezNgZ
	 h2HS1m+24qs+m/naH9mdJ3epY726HMBERHIuLSCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 205/364] drm/msm/dpu: Reindent REV_7xxx interrupt masks with tabs
Date: Mon, 22 May 2023 20:08:30 +0100
Message-Id: <20230522190417.850473291@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 85340c0256f9b85b47c5867e411df37d76df5858 ]

Use tabs for consistency with the other interrupt register definitions,
rather than spaces.

Fixes: ed6154a136e4 ("drm/msm/disp/dpu1: add intf offsets for SC7280 target")
Fixes: 89688e2119b2 ("drm/msm/dpu: Add more of the INTF interrupt regions")
Fixes: 4a352c2fc15a ("drm/msm/dpu: Introduce SC8280XP")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/534212/
Link: https://lore.kernel.org/r/20230411-dpu-intf-te-v4-4-27ce1a5ab5c6@somainline.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
index 85c0bda3ff90e..17f3e7e4f1941 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -32,15 +32,15 @@
 #define MDP_AD4_INTR_EN_OFF		0x41c
 #define MDP_AD4_INTR_CLEAR_OFF		0x424
 #define MDP_AD4_INTR_STATUS_OFF		0x420
-#define MDP_INTF_0_OFF_REV_7xxx             0x34000
-#define MDP_INTF_1_OFF_REV_7xxx             0x35000
-#define MDP_INTF_2_OFF_REV_7xxx             0x36000
-#define MDP_INTF_3_OFF_REV_7xxx             0x37000
-#define MDP_INTF_4_OFF_REV_7xxx             0x38000
-#define MDP_INTF_5_OFF_REV_7xxx             0x39000
-#define MDP_INTF_6_OFF_REV_7xxx             0x3a000
-#define MDP_INTF_7_OFF_REV_7xxx             0x3b000
-#define MDP_INTF_8_OFF_REV_7xxx             0x3c000
+#define MDP_INTF_0_OFF_REV_7xxx		0x34000
+#define MDP_INTF_1_OFF_REV_7xxx		0x35000
+#define MDP_INTF_2_OFF_REV_7xxx		0x36000
+#define MDP_INTF_3_OFF_REV_7xxx		0x37000
+#define MDP_INTF_4_OFF_REV_7xxx		0x38000
+#define MDP_INTF_5_OFF_REV_7xxx		0x39000
+#define MDP_INTF_6_OFF_REV_7xxx		0x3a000
+#define MDP_INTF_7_OFF_REV_7xxx		0x3b000
+#define MDP_INTF_8_OFF_REV_7xxx		0x3c000
 
 /**
  * struct dpu_intr_reg - array of DPU register sets
-- 
2.39.2



