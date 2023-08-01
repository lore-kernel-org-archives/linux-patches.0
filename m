Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8082E1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04038C433C7;
	Tue,  1 Aug 2023 09:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883060;
	bh=o1PLOFq1u0PP3no77mByY2wqS1YzCALke5uYTffGATk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxuCItEq2KiM86hUrvVkA5SDKb0wPp/swavzVGMrtPkMCwzuXESj0VOxVLD5bmOXR
	 h+6gmj2PIsvywYtcmOkD5tbVWTBfxnZgzROH1z/44gch2FI+Dz2DxFFNsEG0BISv8P
	 Novioqj0mi9scWxNnoi6GLfAPNQx5oN+k2W5+/jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.4 101/239] drm/msm/dpu: add missing flush and fetch bits for DMA4/DMA5 planes
Date: Tue,  1 Aug 2023 11:19:25 +0200
Message-ID: <20230801091929.356915882@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit ba7a94ea73120e3f72c4a9b7ed6fd5598d29c069 ]

Note that with this, DMA4/DMA5 are still non-functional, but at least
display *something* in modetest instead of nothing or underflow.

Fixes: efcd0107727c ("drm/msm/dpu: add support for SM8550")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Patchwork: https://patchwork.freedesktop.org/patch/545548/
Link: https://lore.kernel.org/r/20230704160106.26055-1-jonathan@marek.ca
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
index f6270b7a0b140..5afbc16ec5bbb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -51,7 +51,7 @@
 
 static const u32 fetch_tbl[SSPP_MAX] = {CTL_INVALID_BIT, 16, 17, 18, 19,
 	CTL_INVALID_BIT, CTL_INVALID_BIT, CTL_INVALID_BIT, CTL_INVALID_BIT, 0,
-	1, 2, 3, CTL_INVALID_BIT, CTL_INVALID_BIT};
+	1, 2, 3, 4, 5};
 
 static const struct dpu_ctl_cfg *_ctl_offset(enum dpu_ctl ctl,
 		const struct dpu_mdss_cfg *m,
@@ -209,6 +209,12 @@ static void dpu_hw_ctl_update_pending_flush_sspp(struct dpu_hw_ctl *ctx,
 	case SSPP_DMA3:
 		ctx->pending_flush_mask |= BIT(25);
 		break;
+	case SSPP_DMA4:
+		ctx->pending_flush_mask |= BIT(13);
+		break;
+	case SSPP_DMA5:
+		ctx->pending_flush_mask |= BIT(14);
+		break;
 	case SSPP_CURSOR0:
 		ctx->pending_flush_mask |= BIT(22);
 		break;
-- 
2.40.1



