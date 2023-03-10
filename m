Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98738821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFBFC4339C;
	Fri, 10 Mar 2023 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459971;
	bh=4nk1RLPlCUfRSZiH4m3uyta3EiBTFHkW7f5lXOV2rec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyqAs4GFt5SCKQSw6D1CM7WogIEeKjeU0IYGL2nrN96m5MYs0A5i5vL2U9PGXbcgq
	 KVOZK0kOG02uqbSuBUbd53lUOEBKcW2V6QC+J8kWxoE+terh7OGBVC3DK6aoDkNtZF
	 X/Gx2rG/x9rK34QCzM9kJaEOBNBFp3yvP5SV3i98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/529] drm/msm/dpu: Add check for pstates
Date: Fri, 10 Mar 2023 14:35:22 +0100
Message-Id: <20230310133813.237711932@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index d6e9efed8b6a3..5afb3c544653c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -834,6 +834,8 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	struct drm_rect crtc_rect = { 0 };
 
 	pstates = kzalloc(sizeof(*pstates) * DPU_STAGE_MAX * 4, GFP_KERNEL);
+	if (!pstates)
+		return -ENOMEM;
 
 	if (!state->enable || !state->active) {
 		DPU_DEBUG("crtc%d -> enable %d, active %d, skip atomic_check\n",
-- 
2.39.2



