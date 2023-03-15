Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213234431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C57DC433D2;
	Wed, 15 Mar 2023 12:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883740;
	bh=zOkZ0Qt3ypqKG3Ynxn0s+Eno8eY4IY2xUM6CsyMOplk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4VX1zxAyL6MEdkgwArKWb8MkonBo09s8HDGXqLawkp+LqP+fGtV9QPf5dzUUftcu
	 INHpSkzxNxx1oAanRAs30HOug3gKrozS0U8NBuuQ4JGLATUXumJFENQF1wwV2OvQ8n
	 4JLpqyrQzi2SJqNBdcIe7n2wMlfgknRi2ktYOdPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalyan Thota <quic_kalyant@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/143] drm/msm/dpu: clear DSPP reservations in rm release
Date: Wed, 15 Mar 2023 13:12:50 +0100
Message-Id: <20230315115743.088302327@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kalyan Thota <quic_kalyant@quicinc.com>

[ Upstream commit 5ec498ba86550909f2611b07087d57a71a78c336 ]

Clear DSPP reservations from the global state during
rm release

Fixes: e47616df008b ("drm/msm/dpu: add support for color processing blocks in dpu driver")
Signed-off-by: Kalyan Thota <quic_kalyant@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/522443/
Link: https://lore.kernel.org/r/1676286704-818-2-git-send-email-quic_kalyant@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
index 7ada957adbbb8..58abf5fe97e20 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
@@ -572,6 +572,8 @@ void dpu_rm_release(struct dpu_global_state *global_state,
 		ARRAY_SIZE(global_state->ctl_to_enc_id), enc->base.id);
 	_dpu_rm_clear_mapping(global_state->dsc_to_enc_id,
 		ARRAY_SIZE(global_state->dsc_to_enc_id), enc->base.id);
+	_dpu_rm_clear_mapping(global_state->dspp_to_enc_id,
+		ARRAY_SIZE(global_state->dspp_to_enc_id), enc->base.id);
 }
 
 int dpu_rm_reserve(
-- 
2.39.2



