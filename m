Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5AF171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE76C4339B;
	Mon, 22 May 2023 19:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783764;
	bh=yfea5tKOm05WmfOGTqjQ107T+J0lAzc2rUNQI/M3Mlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=admypEHsiq+SKHUSnETSjltpf7JN/NIBJGhYsoHd6HMkkWcmWILatjhCKThI+06z0
	 jAZW457MJV/UEuYCL30ytKw8J1iJZXMUS71zXB1diCjeZe0aYtqv8F5nwnq5TBGxMI
	 WbvuRmkRT1ZjadZuJqXcM2kUh7HGDEmPTE0nhIqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/292] drm/msm/dpu: Move non-MDP_TOP INTF_INTR offsets out of hwio header
Date: Mon, 22 May 2023 20:08:32 +0100
Message-Id: <20230522190409.836898928@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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

[ Upstream commit e9d9ce5462fecdeefec87953de71df4d025cbc72 ]

These offsets do not fall under the MDP TOP block and do not fit the
comment right above.  Move them to dpu_hw_interrupts.c next to the
repsective MDP_INTF_x_OFF interrupt block offsets.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/534203/
Link: https://lore.kernel.org/r/20230411-dpu-intf-te-v4-3-27ce1a5ab5c6@somainline.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c | 5 ++++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hwio.h          | 3 ---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
index cf1b6d84c18a3..75e1b89c9eacf 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c
@@ -15,7 +15,7 @@
 
 /*
  * Register offsets in MDSS register file for the interrupt registers
- * w.r.t. to the MDP base
+ * w.r.t. the MDP base
  */
 #define MDP_SSPP_TOP0_OFF		0x0
 #define MDP_INTF_0_OFF			0x6A000
@@ -24,6 +24,9 @@
 #define MDP_INTF_3_OFF			0x6B800
 #define MDP_INTF_4_OFF			0x6C000
 #define MDP_INTF_5_OFF			0x6C800
+#define INTF_INTR_EN			0x1c0
+#define INTF_INTR_STATUS		0x1c4
+#define INTF_INTR_CLEAR			0x1c8
 #define MDP_AD4_0_OFF			0x7C000
 #define MDP_AD4_1_OFF			0x7D000
 #define MDP_AD4_INTR_EN_OFF		0x41c
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hwio.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hwio.h
index c8156ed4b7fb8..93081e82c6d74 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hwio.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hwio.h
@@ -20,9 +20,6 @@
 #define HIST_INTR_EN                    0x01c
 #define HIST_INTR_STATUS                0x020
 #define HIST_INTR_CLEAR                 0x024
-#define INTF_INTR_EN                    0x1C0
-#define INTF_INTR_STATUS                0x1C4
-#define INTF_INTR_CLEAR                 0x1C8
 #define SPLIT_DISPLAY_EN                0x2F4
 #define SPLIT_DISPLAY_UPPER_PIPE_CTRL   0x2F8
 #define DSPP_IGC_COLOR0_RAM_LUTN        0x300
-- 
2.39.2



