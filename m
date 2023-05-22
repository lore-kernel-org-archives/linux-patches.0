Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73361171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF214C4339B;
	Mon, 22 May 2023 19:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784820;
	bh=6GbWtGmzbcMcnB/aZ2+KdHHZjSJyaqwYgo3gkI9WLwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCEHQmSEQZnKibj9BPpOPf8MxffrsdzYLd5lIgmTBzgY1WAfYVQYL3t8cbag/1ec4
	 mTyO5zKjVhndgXFRNaLiWB69+AcAfMSRCVCnhlhF06ygEM6uYpjmG6PnSUb5pUJQ7+
	 0Wo09LbZA8wCuLzOqlfriuICxNE20lNiXHAs87jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 213/364] drm/msm/dpu: Remove duplicate register defines from INTF
Date: Mon, 22 May 2023 20:08:38 +0100
Message-Id: <20230522190418.044732811@linuxfoundation.org>
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

[ Upstream commit 202c044203ac5860e3025169105368d99f9bc6a2 ]

The INTF_FRAME_LINE_COUNT_EN, INTF_FRAME_COUNT and INTF_LINE_COUNT
registers are already defined higher up, in the right place when sorted
numerically.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/534231/
Link: https://lore.kernel.org/r/20230411-dpu-intf-te-v4-8-27ce1a5ab5c6@somainline.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
index 7ce66bf3f4c8d..b2a94b9a3e987 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
@@ -56,11 +56,6 @@
 #define   INTF_TPG_RGB_MAPPING          0x11C
 #define   INTF_PROG_FETCH_START         0x170
 #define   INTF_PROG_ROT_START           0x174
-
-#define   INTF_FRAME_LINE_COUNT_EN      0x0A8
-#define   INTF_FRAME_COUNT              0x0AC
-#define   INTF_LINE_COUNT               0x0B0
-
 #define   INTF_MUX                      0x25C
 
 #define INTF_CFG_ACTIVE_H_EN	BIT(29)
-- 
2.39.2



