Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A08AFC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF2AC433D2;
	Mon, 15 May 2023 17:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172210;
	bh=J/TKn7cB8RbSwew906heIl+5+mzMHJ6evydX3hEhffY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCJFG568IL7kNMII3HTu9fQo+7JO1WZVE4Az2F5fDBzQy2rweFRmEGgpuRFTq0MAw
	 sxaU+6ipOR/HADvRkT2MiGe9eDakboGOyHYPk+JBcGLMgg/fNH5r249EKmxdFzQKtB
	 KQ17ARlAIW3NTSEF8paH3cP6UwwrTKN4XKifGTbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Polimera <quic_vpolimer@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/381] drm/msm/disp/dpu: check for crtc enable rather than crtc active to release shared resources
Date: Mon, 15 May 2023 18:25:31 +0200
Message-Id: <20230515161740.425836325@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vinod Polimera <quic_vpolimer@quicinc.com>

[ Upstream commit b6975693846b562c4d3e0e60cc884affc5bdac00 ]

According to KMS documentation, The driver must not release any shared
resources if active is set to false but enable still true.

Fixes: ccc862b957c6 ("drm/msm/dpu: Fix reservation failures in modeset")
Signed-off-by: Vinod Polimera <quic_vpolimer@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/524726/
Link: https://lore.kernel.org/r/1677774797-31063-5-git-send-email-quic_vpolimer@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index a0274fcfe9c9d..408fc6c8a6df8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -634,7 +634,7 @@ static int dpu_encoder_virt_atomic_check(
 		if (drm_atomic_crtc_needs_modeset(crtc_state)) {
 			dpu_rm_release(global_state, drm_enc);
 
-			if (!crtc_state->active_changed || crtc_state->active)
+			if (!crtc_state->active_changed || crtc_state->enable)
 				ret = dpu_rm_reserve(&dpu_kms->rm, global_state,
 						drm_enc, crtc_state, topology);
 		}
-- 
2.39.2



