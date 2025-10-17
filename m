Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CC1337109;
	Fri, 17 Oct 2025 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714071; cv=none; b=umbyrxnoIoUX0bUE5fLXHDBnTIXZcbJEcjdkcRtQBbYnu8ToPsQvwhptcpREWG9Eb5378HCApLAp7pYmLAP0ozdUMVXw8tgq8oMYreL0z1pH2tK1ReaTvKhw9ywy2WaK3qcpz63LeAnaYJxUk7GaO/hMo/VJdkrSxoxOa/rqdjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714071; c=relaxed/simple;
	bh=ElAQBsbhrFchuyneKsBJ7eXnvkM7kXvHrCwh2ZuLPvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ls7YDV7z+WfqibFhQDqciEDFPu0gR7kYxzERmeoL+JrjgABen2nbe71EDG8THfHRawA4hA/Rzz3PKHK4A0N6+weKdomTDdAIk0LtNrMbBzNkUzzGR0NwP3VP3YAa9lSIvD9NzEZYOD+6nJq/zqVdwtqpxvmr3bPikJ7RBStWkgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLKm18rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLKm18rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1F4C4CEE7;
	Fri, 17 Oct 2025 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714071;
	bh=ElAQBsbhrFchuyneKsBJ7eXnvkM7kXvHrCwh2ZuLPvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLKm18rwWzMPtcasmcKuhaaBaBEdzV5flXPVfVVPAYRtEzWqBaO+Y+O1m8Ert8BgZ
	 buvpv58MgThoeCzqU4pCr7/qCZ6kYhK8WBmmn+gfhmP7NTlUdBvBqEDaqKccDcK4xT
	 LRTydqgZpXzlPYKzsCnJgEi+g/sya5Szp1KhbMvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/277] clk: qcom: common: Fix NULL vs IS_ERR() check in qcom_cc_icc_register()
Date: Fri, 17 Oct 2025 16:50:24 +0200
Message-ID: <20251017145147.778050933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1e50f5c9965252ed6657b8692cd7366784d60616 ]

The devm_clk_hw_get_clk() function doesn't return NULL, it returns error
pointers.  Update the checking to match.

Fixes: 8737ec830ee3 ("clk: qcom: common: Add interconnect clocks support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/aLaPwL2gFS85WsfD@stanley.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/common.c b/drivers/clk/qcom/common.c
index 33cc1f73c69d1..cab2dbb7a8d49 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -273,8 +273,8 @@ static int qcom_cc_icc_register(struct device *dev,
 		icd[i].slave_id = desc->icc_hws[i].slave_id;
 		hws = &desc->clks[desc->icc_hws[i].clk_id]->hw;
 		icd[i].clk = devm_clk_hw_get_clk(dev, hws, "icc");
-		if (!icd[i].clk)
-			return dev_err_probe(dev, -ENOENT,
+		if (IS_ERR(icd[i].clk))
+			return dev_err_probe(dev, PTR_ERR(icd[i].clk),
 					     "(%d) clock entry is null\n", i);
 		icd[i].name = clk_hw_get_name(hws);
 	}
-- 
2.51.0



