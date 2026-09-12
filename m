Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E11C37F729;
	Sat, 12 Sep 2026 08:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200664; cv=none; b=o6zWl6crkEw2IoVMGzpEOxl9Ypu4k6f06uhMnMi2T8AjU5MsH2v023JpUlBVyQUN6YkYy4e1/n9K3KupuqJ/jqiqUKGpF79q8loWcjbuua2EOVL0BDNiKu9b7AZXBql3PGCwu5hJyJO7FNGAhzUSFx6rFa+/nFK0z5cu0OkkBFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200664; c=relaxed/simple;
	bh=s77qSLbeBKw50b3VeToE0S4AMYGK/UuWRWrknzyiHgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8QpuB3lA00IBoc6Q+HJAJ+pCiQa5A6/lZamaR2d/8RSHCoPhJzjV02Rtd3RqLLvqaSryZdRkOwfiDr1NZuh8b5Kq0Qt+z4A3ffkBEcKD0deHLl8a9tKqr7QuuvRUzUN45PSM23APoPL5Kv5Z07Xya3lBnDqtkokB3eaioYbH24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k15JTtgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k15JTtgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBFE1F000FF;
	Sat, 12 Sep 2026 08:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200661;
	bh=VFK+EoSQLLhNsT44ocheGCXjh/6D2B8PhIOuKaP1bck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k15JTtgrQHU94PlbQB5ZH30zbboswUs72IwqkNANXTFfW8ANXmxjuQ30RcE2vr9zv
	 fgzJQD51UqRCDlF7NxKTe+XnVaD29n3N/+znS4OcIYaeKTwr+P89vE9Nffk+lFrQRp
	 +ts2tcR5RO2ZGSpzmp2GDs0i+dvSTQ/nl1xE9SIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0837/1815] clk: qcom: gpucc-qcm2290: Park RCGs clk source at XO during disable
Date: Sat, 12 Sep 2026 08:43:07 +0200
Message-ID: <20260912065708.563031520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 78797b77d7c7b..fc33d82bcfb68 100644
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



