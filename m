Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FE34431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F145C433D2;
	Wed, 15 Mar 2023 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884015;
	bh=TKgu6FVYSQdUVPlBrQVe67ZlQuSVFm7aTrLFfLhlk3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzUUqEP4BA+moO/CswqhuTFCWPPdK3i5f0wf3vtwxvPGT67keWUR8eYzNANMQ5JEX
	 Knl1Eordv3/2HUoWIYBJw2FlgMgb4tXL2ctdek+kl6S9Bgu6LNc7Hz9KqdOwf0vvcg
	 ByDsMlgZw6X1NzB4WIqDd4xGoFymd8lEn9EBHe0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 075/141] drm/msm/dpu: drop DPU_DIM_LAYER from MIXER_MSM8998_MASK
Date: Wed, 15 Mar 2023 13:12:58 +0100
Message-Id: <20230315115742.254173288@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a5045b00a68171de11603812f4304179ef608e60 ]

The msm8998 doesn't seem to support DIM_LAYER, so drop it from
the supported features mask.

Fixes: 2d8a4edb672d ("drm/msm/dpu: use feature bit for LM combined alpha check")
Fixes: 94391a14fc27 ("drm/msm/dpu1: Add MSM8998 to hw catalog")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/522231/
Link: https://lore.kernel.org/r/20230211231259.1308718-12-dmitry.baryshkov@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index e03db98ebe997..a6288f29f0035 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -52,7 +52,7 @@
 	(DMA_MSM8998_MASK | BIT(DPU_SSPP_CURSOR))
 
 #define MIXER_MSM8998_MASK \
-	(BIT(DPU_MIXER_SOURCESPLIT) | BIT(DPU_DIM_LAYER))
+	(BIT(DPU_MIXER_SOURCESPLIT))
 
 #define MIXER_SDM845_MASK \
 	(BIT(DPU_MIXER_SOURCESPLIT) | BIT(DPU_DIM_LAYER) | BIT(DPU_MIXER_COMBINED_ALPHA))
-- 
2.39.2



