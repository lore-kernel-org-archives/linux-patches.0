Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8BC374178;
	Wed, 20 May 2026 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298802; cv=none; b=PoIDmBy5yoYzNwIvoh+10KjaW3/6e0OUXwjhUa44UKW40fezZJiv2o6q5d02URcoHsvA+bFeDZT8BV8MV2ZRSh8B3AC3rY/KymzfmAO1NOVRF11K9AqKG/DmCNH2QVvAy7CpwD5iux6oEQLkZo01mQiqyiXhEKgDR8t/uVtMAJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298802; c=relaxed/simple;
	bh=PFvelsstw8NhuIeM7NxxpQS8jDGkGtaCqqtO6BqxsrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n75k/RPGt7lgEyyf4i/3N0InmbSBHaXKPU+JLeoEtcyPjtWS8EuCXEZDh+5qsrj/Y0QoRCii3QHSwacI/duWoTUfIv0J+wgj2zm5yIbh3yLRE4rsAWVH/cY9+VynfBq9JiXII8HN/XXJRDC8LE9geWMhnxWSrm32v+2d+lZP5DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ioWACB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ioWACB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64E41F00893;
	Wed, 20 May 2026 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298801;
	bh=DUMLFA2u/aeo1bBVakPNT4u5ii4yd2+BpKet5VMU6QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ioWACB3gGTHJYWZXc72Hy1xmmdUCbo3Pfve/lqW877dUQRzdqydSkMfO2/Eo0/XM
	 a72nGIZWKDYxkkwt0eq1B8d+UF3ofbXHVBGKSgha3lDBAwGmDsgPoixSAJHexYV20i
	 gM+hlDDaGR8vtmsWs/hV/GqB2NlXiqkTFQbNVDvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 549/957] clk: qcom: dispcc-glymur: use RCG2 ops for DPTX1 AUX clock source
Date: Wed, 20 May 2026 18:17:12 +0200
Message-ID: <20260520162146.440543091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e7c8eb1646db5d967d77ee67793dd95a2c5ff451 ]

The clk_dp_ops are supposed to be used for DP-related clocks with a
proper MND divier. Use shared RCG2 ops for dptx1_aux_clk_src, the same
as all other DPTX AUX clocks in this driver.

Fixes: b4d15211c408 ("clk: qcom: dispcc-glymur: Add support for Display Clock Controller")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260112-dp-aux-clks-v1-1-456b0c11b069@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-glymur.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-glymur.c b/drivers/clk/qcom/dispcc-glymur.c
index 5203fa6383f6a..f352165bf56fc 100644
--- a/drivers/clk/qcom/dispcc-glymur.c
+++ b/drivers/clk/qcom/dispcc-glymur.c
@@ -417,7 +417,7 @@ static struct clk_rcg2 disp_cc_mdss_dptx1_aux_clk_src = {
 		.parent_data = disp_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_dp_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
-- 
2.53.0



