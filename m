Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA473C481
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBHH7N4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5F1C433C7;
	Wed, 15 Nov 2023 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077260;
	bh=iKPNuT/JE/WqZpMfwtlWVz/1NlP/Yr1H0uuP19Dgu8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBHH7N4tCif4ijPb+JOv8x9avYCu0Fvw9D2ddnAAlTEtrr7njS6pcrMdPGy1lMXdZ
	 18EbMwLby9tFvc9ibBa2PlniTWhzE096LL7lh/MZlO0QFn5khRXDP5JrjqlD7hMdiC
	 0eBBgzhrmTwOsbfC8c39f5smS7S0gHWdrJEnzbk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Kathiravan T <quic_kathirav@quicinc.com>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/603] clk: qcom: apss-ipq-pll: Use stromer plus ops for stromer plus pll
Date: Wed, 15 Nov 2023 14:12:19 -0500
Message-ID: <20231115191626.676895053@linuxfoundation.org>
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

[ Upstream commit 267e29198436a8cb6770213471f72502c895096a ]

The set rate and determine rate operations are different between
Stromer and Stromer Plus PLLs. Since the programming sequence is
different, the PLLs dont get configured properly and random,
inexplicable crash/freeze is seen. Hence, use stromer plus ops
for ipq_pll_stromer_plus.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Fixes: c7ef7fbb1ccf ("clk: qcom: apss-ipq-pll: add support for IPQ5332")
Signed-off-by: Kathiravan T <quic_kathirav@quicinc.com>
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Link: https://lore.kernel.org/r/c86ecaa23dc4f39650bcf4a3bd54a617a932e4fd.1697781921.git.quic_varada@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/apss-ipq-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/apss-ipq-pll.c b/drivers/clk/qcom/apss-ipq-pll.c
index e170331858cc1..18c4ffe153d6c 100644
--- a/drivers/clk/qcom/apss-ipq-pll.c
+++ b/drivers/clk/qcom/apss-ipq-pll.c
@@ -68,7 +68,7 @@ static struct clk_alpha_pll ipq_pll_stromer_plus = {
 				.fw_name = "xo",
 			},
 			.num_parents = 1,
-			.ops = &clk_alpha_pll_stromer_ops,
+			.ops = &clk_alpha_pll_stromer_plus_ops,
 		},
 	},
 };
-- 
2.42.0



