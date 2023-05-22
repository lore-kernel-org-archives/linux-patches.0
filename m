Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B835E171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3380EC4339E;
	Mon, 22 May 2023 19:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783760;
	bh=Z24HX7WCxDnwX4J6yU6RFgP+QN3agI2JPu0wTMgqjLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjBjlbEViJ4+uRcD7Xaa7oy2JCtbll1QrZqxxwAeWIu9ilpQS6XrHo53gc/JpWoln
	 h8Et9Vfo+CXsjXLk68obwU/Rt5uESZDHN17kK7PeOVg99AWhmZWlmC3yl5TjN1+VlC
	 Zp9DCHZ7/3GmPvyH4Pby0unLeUWMamJljeY1TIT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/292] drm/msm/dpu: Assign missing writeback log_mask
Date: Mon, 22 May 2023 20:08:31 +0100
Message-Id: <20230522190409.811809415@linuxfoundation.org>
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

[ Upstream commit a432fc31f03db2546a48bcf5dd69ca28ceb732bf ]

The WB debug log mask ended up never being assigned, leading to writes
to this block to never be logged even if the mask is enabled in
dpu_hw_util_log_mask via debugfs.

Fixes: 84a33d0fd921 ("drm/msm/dpu: add dpu_hw_wb abstraction for writeback blocks")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/533860/
Link: https://lore.kernel.org/r/20230418-dpu-drop-useless-for-lookup-v3-1-e8d869eea455@somainline.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
index 2d28afdf860ef..a3e413d277175 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
@@ -61,6 +61,7 @@ static const struct dpu_wb_cfg *_wb_offset(enum dpu_wb wb,
 	for (i = 0; i < m->wb_count; i++) {
 		if (wb == m->wb[i].id) {
 			b->blk_addr = addr + m->wb[i].base;
+			b->log_mask = DPU_DBG_MASK_WB;
 			return &m->wb[i];
 		}
 	}
-- 
2.39.2



