Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07DB2D739D;
	Tue, 17 Mar 2026 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768217; cv=none; b=hqimy7nWczDNlrpcZgx2udFXiG3M4AynREFBAKWO5dBJgG/dGPjpf6UfXhM01rpXFKumHQ9BCoC0mwfWgGavm20HHd0g5lGoDSv5Ewcmn7mqney77QM3ldBSbylZw06+yopbwr0wK2GA9X8ki8WlUDcelV0Sd+D8UlVgEEeYaf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768217; c=relaxed/simple;
	bh=mA6HIoCs5IlvLShF4NvVboifBuS7XTyq9vfwpLcCIGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnW+ioTpPVEq5vBQkLgDr4+UpVkepMk2d2KEN9MfOTCOMehBpWeg70bV+vdIthIppoKkmJrq04A5KWGi0R40dnOS011HFE0gWe5rkvut1lPqUK6giueUeqf48ihrJun33ZDI6RPhWUJ464PSZpEIMLJptl8BdGrb1C+cJzCx0Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d74W1OPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d74W1OPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5527EC4CEF7;
	Tue, 17 Mar 2026 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768217;
	bh=mA6HIoCs5IlvLShF4NvVboifBuS7XTyq9vfwpLcCIGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d74W1OPnXLMZAmf5cz/9b3x3N3qvLcebNFTbCb/Q9GXARV7bnWrUYY7MuLJaHBYYQ
	 JE+ZO3uT1n3UpE1MTiRiMvvApGt4893EdewJdVa2TfTe2awpd3oXidAhwA3Bj57FEQ
	 7niB3CTyqrZ8IRFisDHM9JK8dPRC6rR12DeZGbK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Yongxing Mou <yongxing.mou@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.18 260/333] drm/msm/dpu: Correct the SA8775P intr_underrun/intr_underrun index
Date: Tue, 17 Mar 2026 17:34:49 +0100
Message-ID: <20260317163009.011833421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

commit 4ce71cea574658f5c5c7412b1a3cc54efe4f9b50 upstream.

The intr_underrun and intr_vsync indices have been swapped, just simply
corrects them.

Cc: stable@vger.kernel.org
Fixes: b139c80d181c ("drm/msm/dpu: Add SA8775P support")
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Yongxing Mou <yongxing.mou@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/709209/
Link: https://lore.kernel.org/r/20260305-mdss_catalog-v5-2-06678ac39ac7@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_4_sa8775p.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_4_sa8775p.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_4_sa8775p.h
@@ -366,8 +366,8 @@ static const struct dpu_intf_cfg sa8775p
 		.type = INTF_NONE,
 		.controller_id = MSM_DP_CONTROLLER_0,	/* pair with intf_0 for DP MST */
 		.prog_fetch_lines_worst_case = 24,
-		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 17),
-		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 16),
+		.intr_underrun = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 16),
+		.intr_vsync = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 17),
 	}, {
 		.name = "intf_7", .id = INTF_7,
 		.base = 0x3b000, .len = 0x280,


