Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096FD1F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB6AC433C8;
	Fri, 21 Jul 2023 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965978;
	bh=gsrvRbhrfVJpJm3TxdqVF6uzQ184AjAFY1ZL9/KRG0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ao6z6NwacZA3y3DJt8ILjrhpzPA3+FAXZvEXAyU0BDOR2cB6mT+dS8A2ADqXHb6S
	 fTMVZ7R8KiiDjxMStwWOG3rJEyH0z5+c/hnljOLB59HcXPwfWvxx58rUhuDhcoZpTJ
	 06GZ3jsNFyoKomaMnMRVHXrEOM/V1IQY7pTXLGoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/532] drm/msm/dpu: correct MERGE_3D length
Date: Fri, 21 Jul 2023 18:01:25 +0200
Message-ID: <20230721160624.195180809@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

[ Upstream commit 9a6c13b847d61b0c3796820ca6e976789df59cd8 ]

Each MERGE_3D block has just two registers. Correct the block length
accordingly.

Fixes: 4369c93cf36b ("drm/msm/dpu: initial support for merge3D hardware block")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/542177/
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20230613001004.3426676-3-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 951aa1aafa96a..272a3d7e1aef2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -808,7 +808,7 @@ static const struct dpu_pingpong_cfg sm8150_pp[] = {
 #define MERGE_3D_BLK(_name, _id, _base) \
 	{\
 	.name = _name, .id = _id, \
-	.base = _base, .len = 0x100, \
+	.base = _base, .len = 0x8, \
 	.features = MERGE_3D_SM8150_MASK, \
 	.sblk = NULL \
 	}
-- 
2.39.2



