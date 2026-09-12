Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAB4373BF2;
	Sat, 12 Sep 2026 12:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216658; cv=none; b=jMZEWzE/EtmNPwhvMv1NG0OYv8/OJEGIjqpFYmNqu3SawHJhW4NQitQ0Zco2YHXUswqBNvYK6ElEy8kFZXeIAYnxs1wDYxdpmFKv4lZ8JryJvzGIBgWfqfgltYcCSyTNjmQ9ts287g6FkLZk5iGVuwVpRn2kyXpOqInZeTu8TI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216658; c=relaxed/simple;
	bh=n8igidwW/w8uW0z+nYmWf6JYajp3lC8tKjLyGWkRYTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNd511jSvsRDsDFd69bATTIPEH+fjPwpZhtCo9oVSvTx6RrBbrOFvFuk9aN0XCV2Lk8FOQKfbrov8zJGCyOgttpuHfo6s9P4dMa1oC7YIKyff2A1dxQsymMiFhefKIJQ6gpWyaBvsObuCnWGMPntLvVWsD3PgCMX9rPfC1OfQXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MN8ilKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MN8ilKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89331F000FF;
	Sat, 12 Sep 2026 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216656;
	bh=j6o3q8l20pTkPLh8Q7X4QXFwg4Bds8y0G1soGN8eeI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MN8ilKjdfYN6Ftn8rWAYQ1p6sy1tgKIm6jfACrgNR1OSTXHV4Q9U5+mxnyV9+XJ4
	 6ddFGYjeJqummnP/FAfX3XW6PWkgxpI60X/Vxb5Oa9ZCoDyMh/1Iwpln56RjI8CWA6
	 3FnYLFx99sBdkPos0/5+dIrIHYVQAxnwoL7dyqCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0780/1376] clk: qcom: gpucc-qcm2290: Park RCGs clk source at XO during disable
Date: Sat, 12 Sep 2026 08:53:26 +0200
Message-ID: <20260912065624.922589614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



