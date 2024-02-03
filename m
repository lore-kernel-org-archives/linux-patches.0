Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58730F9F5;
	Sat,  3 Feb 2024 04:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933412; cv=none; b=m0MQQx+De9SvZsf/wbnLx6CwGnsSwpmxcvuJWkRYgD+oJkzsw7Hbh1EHBst1aP5c9zR0lCmOorP2Viqqe4ocxvM84+ozTSl2/k+s+a0J+UgC77L+68ZjL5pcNn8Fz0dQNW9T/plG1YvUD3fX4t3/BkUFAwwMprGrSxAELoG/dsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933412; c=relaxed/simple;
	bh=WhV96/YS8c/Y9CqBcpTjgBCwuzclECn/SL1rHBtKEQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrBLDA/Ik3WqtOfdCZwLDFnhgpUuaWLuiCgfHWsATaZnTsAQftT1yV5LDBm9jz49PtWIIIhKUOQ0/G8dWDM62JoqIoO25heLEdVhITkmW2/rjUeuX1DXA4lkQIK0COaTni07wSRerAMrHDwDMbDlS3NyHiShJ2KWrC+C7AIcFAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RL92yXhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RL92yXhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20364C433C7;
	Sat,  3 Feb 2024 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933412;
	bh=WhV96/YS8c/Y9CqBcpTjgBCwuzclECn/SL1rHBtKEQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RL92yXhNYK3TX8bs8ivwsGzOwuuLSymFWSKtCZLf7kVNbZvyzE5PtN9UMMKrvAz06
	 6Rqrbi8Fme02YiiuRRZODQAjlyQmFtCFBPyrzTXf31M6ZGoA/hQKcDFrD4zZeV1VvS
	 o5ZQXvzQeKfsZklpd15/PXaWa64kcmc2XyTxLcok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/219] drm/msm/dpu: fix writeback programming for YUV cases
Date: Fri,  2 Feb 2024 20:05:07 -0800
Message-ID: <20240203035336.256717617@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 79caf2f2202b9eaad3a5a726e4b33807f67d0f1b ]

For YUV cases, setting the required format bits was missed
out in the register programming. Lets fix it now in preparation
of adding YUV formats support for writeback.

changes in v2:
    - dropped the fixes tag as its not a fix but adding
      new functionality

Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/571814/
Link: https://lore.kernel.org/r/20231212205254.12422-4-quic_abhinavk@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
index a3e413d27717..63dc2ee446d4 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
@@ -105,6 +105,9 @@ static void dpu_hw_wb_setup_format(struct dpu_hw_wb *ctx,
 			dst_format |= BIT(14); /* DST_ALPHA_X */
 	}
 
+	if (DPU_FORMAT_IS_YUV(fmt))
+		dst_format |= BIT(15);
+
 	pattern = (fmt->element[3] << 24) |
 		(fmt->element[2] << 16) |
 		(fmt->element[1] << 8)  |
-- 
2.43.0



