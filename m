Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19351118E;
	Sat,  3 Feb 2024 04:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933872; cv=none; b=YVzMQxt//0DkWcfaWdENpOxgBoxY8/B30wPGOcWkL2+b8GR6W3ZUK7LImKez1CDuwSVfZ/Ljf9A03gC1JBDLsg01uMJlJxEWjsUCtj7A8qvNWvAYGV+cxvbrD6l4Bmd2yBiMtzGXgFO0NpZMGFLzq5MrD+CGZqJwLXvSQ/ct/aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933872; c=relaxed/simple;
	bh=htWv1Uj36s9SIfWHOBb2IHkL5UmCEVrM00bosLPjiqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1OZ0bl7pcNww+FkJUL70NJWzhlW9c3L6T+oW77n5B+Kn2YcoK5p5n94kx/WhS86lKHx22AmdVuvd+t+vHeyIJryHxJNvOJp0+dcc87sevzhVuXbyPnmDj+hiUWccsdfmUsweNNMIaX/EkggS/ohssnE3ZC7ILMGIlTFyUTLV4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hASgn5Uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hASgn5Uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CA3C43390;
	Sat,  3 Feb 2024 04:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933871;
	bh=htWv1Uj36s9SIfWHOBb2IHkL5UmCEVrM00bosLPjiqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hASgn5UzqPq1IRGud8//4TAuSgzZmnyf9ym9xtBvGW0KDGyV8s4XopsXeQu9ISpg8
	 m/E1/Z9qylChoyGO+wDz0IJsv/8cFAaJTQ//FIxiT8m0Fj0ox05+9BhGtuAgTne6kU
	 MDZZJyhaJl+Vcl6S4bv0yCPVhv1fRlANau/VkpBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 210/353] drm/msm/dpu: fix writeback programming for YUV cases
Date: Fri,  2 Feb 2024 20:05:28 -0800
Message-ID: <20240203035410.343647057@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 9668fb97c047..d49b3ef7689e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
@@ -87,6 +87,9 @@ static void dpu_hw_wb_setup_format(struct dpu_hw_wb *ctx,
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



