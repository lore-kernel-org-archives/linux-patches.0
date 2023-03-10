Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D916846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDBEC433D2;
	Fri, 10 Mar 2023 14:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458681;
	bh=oqrqsASdeRUYV/mpQ11zTQl9e+xYzmR1buiruzbiio4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPqcGRLBFYYKk6B9J7o5evePOmQBIRHitPVHBDdcyy/qzQQptd7aecLqYHTy30tej
	 F22ZWluGxJZkF5T9wz3xibXHixUzSaV5BWwPsCZKx/l3EnFyCJn56hS5kE9yp31azm
	 1Y3x3KWV4f6q+8AGBaY3ouQcuHZDXRjdNt/qr39U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/357] drm/msm/dpu: Add check for pstates
Date: Fri, 10 Mar 2023 14:36:38 +0100
Message-Id: <20230310133739.458424684@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 93340e10b9c5fc86730d149636e0aa8b47bb5a34 ]

As kzalloc may fail and return NULL pointer,
it should be better to check pstates
in order to avoid the NULL pointer dereference.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/514160/
Link: https://lore.kernel.org/r/20221206080236.43687-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index d61c3855670dd..2e28db60f4d2f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -836,6 +836,8 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	}
 
 	pstates = kzalloc(sizeof(*pstates) * DPU_STAGE_MAX * 4, GFP_KERNEL);
+	if (!pstates)
+		return -ENOMEM;
 
 	dpu_crtc = to_dpu_crtc(crtc);
 	cstate = to_dpu_crtc_state(state);
-- 
2.39.2



