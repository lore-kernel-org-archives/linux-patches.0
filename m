Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4CD24CEEA;
	Sat, 12 Sep 2026 10:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208868; cv=none; b=CyXEgEc7fvA1ycnx6JJkniB6HoE8xZRvZrFnwxsRCBNS9WGhJvGx009tFNIoBI4WzFCh8+TZQ63lJfF2IRii416/S+4c79RV40efSNlqu72eQK4ARJbSyueoMRxYSpNTyHyaLoy7m5XvQO8vk4MSWcJdOIMBTUZfmbeojSSEXmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208868; c=relaxed/simple;
	bh=NE/M19JwUPiy35OjezCA+kTy/pU9O+urNk6BG81x3g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb5zjPv5zmVGs2XXbzvHSdR8Ocm2WX9IT/X7Qe2xujiexp6cF15l1KuAoWF3GeNfXzpUbyy4dJZ6scbTK7HMk02f8JtYq2dX29GHtNw+wl2YXO+5Wn0UtpPy9oJZmQBGtVZY7C9F2BGiVICQJ5sj0Bj3tMceXImDp3pEJXr/eag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNInq/4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNInq/4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCA91F000FF;
	Sat, 12 Sep 2026 10:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208867;
	bh=NKTzLOsl6Wj1kjy22r7fxQD4m6i4KjofmTKOm/rOucs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNInq/4BcMcXbYYoYVrVL7uyh+imxTTYViwn6CYF6M4kUxJJa/VmK6FzNx/5rsb+9
	 Ebbknz7XwllJBohRaAzynLL6vI6QZXyAsS/IpHGTUbHeyJnlzsmYlD8jUCmWis7gXH
	 T11Rd6jyaAidtNwSF+eUxItYloJtH/3O5ulzupDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0706/1518] clk: qcom: gpucc-qcm2290: Park RCGs clk source at XO during disable
Date: Sat, 12 Sep 2026 08:47:55 +0200
Message-ID: <20260912065639.404234514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit ab46b5fb668b8b9b848a8f036fc4c06ce86b7e3b ]

The RCG's clk src has to be parked at XO while disabling as per hardware
team's recommendation, hence use clk_rcg2_shared_ops to achieve the same.

Fixes: 8cab033628b1 ("clk: qcom: Add QCM2290 GPU clock controller driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260718-shikra-dispcc-gpucc-v6-11-62703e05ef0f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-qcm2290.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gpucc-qcm2290.c b/drivers/clk/qcom/gpucc-qcm2290.c
index dc369dff882e6..3ccab8f3b4e0f 100644
--- a/drivers/clk/qcom/gpucc-qcm2290.c
+++ b/drivers/clk/qcom/gpucc-qcm2290.c
@@ -144,7 +144,7 @@ static struct clk_rcg2 gpu_cc_gx_gfx3d_clk_src = {
 		.parent_data = gpu_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
-- 
2.53.0



