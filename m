Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F102745E;
	Fri, 17 Oct 2025 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714902; cv=none; b=KPeCSHHvveoJhphd2KNZ+refPxrJqwF3aOXnF29aYy9su3ycd7z69yVUe9Cr6uOqy0nkPaQPu2mcYspPkkDienexOaSH/a22S01jYi9kytn7fObjeaRyE1Y+lih1l7SEWEP14CBkxrvhir9kjr2NB/XG13CXoUj88UPhsmZKXes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714902; c=relaxed/simple;
	bh=fz1w7WldEuTez6ZhOi+Y4mgsqjwyrhRhXZcY64ezjxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5GSbCiNpJOdmsqO+TWv9djXLUdyEvzml5fUF0k9sNE1+2LR8/Ikv5QO1ErpqNIV5pmEGjMH4vCYzWzgXUk6Qngte+HSgwIngpZ6ZTgkm1Ln3sdAZTerSq2FA0lfnTnntLvR+mt0hrRV6UP5NFsy5ZKkkUjxE19SvSnuKJrNuxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcWuR2D1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcWuR2D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6C9C113D0;
	Fri, 17 Oct 2025 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714902;
	bh=fz1w7WldEuTez6ZhOi+Y4mgsqjwyrhRhXZcY64ezjxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcWuR2D13KjooxtBvo7rcfUwETAQ8JZzpV5nf9IYHyMUytUxMVNr6uKNyu4FeER6j
	 o/g7Qj6wP4eX62XhOV/li5EA6siG7UYtyVwf2S+pTSZSG7FnfOat+HrupLFZ3t4IBq
	 jo7q6AEJjTAKnHAvIMAoxm2/pn05pOMY/DTMdzu8=
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
Subject: [PATCH 6.17 029/371] clk: qcom: common: Fix NULL vs IS_ERR() check in qcom_cc_icc_register()
Date: Fri, 17 Oct 2025 16:50:04 +0200
Message-ID: <20251017145202.854009220@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 37c3008e6c1be..1215918867741 100644
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -277,8 +277,8 @@ static int qcom_cc_icc_register(struct device *dev,
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



