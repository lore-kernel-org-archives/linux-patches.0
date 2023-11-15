Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47483C477
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgcwVSEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D49C433C8;
	Wed, 15 Nov 2023 19:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077261;
	bh=2BiBUG7kuUTbNbr7/HaZPI+Wy4fmMrKsGidWVtpZT5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgcwVSEZ4eazSCgg6saGnYWgb7SnE5GK1kt40kYwoypkDatZOdatYuw10JMuDxPLK
	 XI4ryc7YzcxXagD+A0wV+wIOd49HqVp7swSFs4aDroF3+bW+r2lzYda+Vq7C8QBaek
	 Dd7W02OEp4RXuQZWYpTh0vP7KU6FWmBSzcE8HsfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Kathiravan T <quic_kathirav@quicinc.com>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/603] clk: qcom: apss-ipq-pll: Fix l value for ipq5332_pll_config
Date: Wed, 15 Nov 2023 14:12:20 -0500
Message-ID: <20231115191626.747724755@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varadarajan Narayanan <quic_varada@quicinc.com>

[ Upstream commit 5b7a4d3d2b33398330aef69e0ff5656273483587 ]

The earlier 'l' value of 0x3e is for 1.5GHz. Not all SKUs support
this frequency. Hence set it to 0x2d to get 1.1GHz which is
supported in all SKUs.

The frequency can still increase above this initial configuration
made here when the cpufreq driver picks a different OPP.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Fixes: c7ef7fbb1ccf ("clk: qcom: apss-ipq-pll: add support for IPQ5332")
Signed-off-by: Kathiravan T <quic_kathirav@quicinc.com>
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Link: https://lore.kernel.org/r/00e6be6cb9cee56628123a64ade118d0a752018b.1697781921.git.quic_varada@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/apss-ipq-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/apss-ipq-pll.c b/drivers/clk/qcom/apss-ipq-pll.c
index 18c4ffe153d6c..41279e5437a62 100644
--- a/drivers/clk/qcom/apss-ipq-pll.c
+++ b/drivers/clk/qcom/apss-ipq-pll.c
@@ -74,7 +74,7 @@ static struct clk_alpha_pll ipq_pll_stromer_plus = {
 };
 
 static const struct alpha_pll_config ipq5332_pll_config = {
-	.l = 0x3e,
+	.l = 0x2d,
 	.config_ctl_val = 0x4001075b,
 	.config_ctl_hi_val = 0x304,
 	.main_output_mask = BIT(0),
-- 
2.42.0



