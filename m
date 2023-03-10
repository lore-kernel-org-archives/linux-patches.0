Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F288489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FD8C433EF;
	Fri, 10 Mar 2023 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457848;
	bh=5WZ5RctwR5TbiDK2E+JioZ+Fw4OovhhiKSKDdinu3mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9wAfjvy34ccutazSgHEkYtQYspAz9GVwvUR6f44B7xxTjitILRkUvN7sqWfilj1s
	 DbpFWMor/jx3YFyXDYQvPi64Xeob+tc+f/h3gtpJNzJmPhTiJ8XtApnZ5PLqktCyZa
	 1SYTRwLRnLO8ofOhjd/hqmTdWe4Tvw3aW+PZhLVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/252] drm/msm/dpu: Add check for pstates
Date: Fri, 10 Mar 2023 14:37:28 +0100
Message-Id: <20230310133721.188595087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
index 3c3b7f7013e87..2efdc3c9f2916 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1477,6 +1477,8 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	}
 
 	pstates = kzalloc(sizeof(*pstates) * DPU_STAGE_MAX * 4, GFP_KERNEL);
+	if (!pstates)
+		return -ENOMEM;
 
 	dpu_crtc = to_dpu_crtc(crtc);
 	cstate = to_dpu_crtc_state(state);
-- 
2.39.2



