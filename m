Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68631094C
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0683AC433D2;
	Mon,  8 May 2023 11:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545070;
	bh=4/r6S3nk3nNQWbXQ8F8pRY6MCg4DY4sR9acxwIW4fDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OS4NTv+KgAvaPzR3xWJew5HantRaBuv9xuuANpJrxijY+KK68AhW1tZx/fDZno+g
	 ayW50OUKasiP4QRsPgT0/3skqeytcI09TObcOKvGET8zFxh/TECZ9kmX0rB+be7G2L
	 3pMgtZL0B1Jrl2sSa9+9fZS/IIunqra+GUw7DAxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 583/694] clk: qcom: gcc-qcm2290: Fix up gcc_sdcc2_apps_clk_src
Date: Mon,  8 May 2023 11:46:58 +0200
Message-Id: <20230508094453.912275530@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 1bf088a9f0e50acd175ba8deef0db11c099fa26e ]

Add the PARENT_ENABLE flag to prevent  the clock from getting stuck
at boot and use floor_ops to avoid SDHCI overclocking.

Fixes: 496d1a13d405 ("clk: qcom: Add Global Clock Controller driver for QCM2290")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230315173048.3497655-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcm2290.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-qcm2290.c b/drivers/clk/qcom/gcc-qcm2290.c
index 7792b8f237047..096deff2ba257 100644
--- a/drivers/clk/qcom/gcc-qcm2290.c
+++ b/drivers/clk/qcom/gcc-qcm2290.c
@@ -1243,7 +1243,8 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parents_12,
 		.num_parents = ARRAY_SIZE(gcc_parents_12),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
+		.flags = CLK_OPS_PARENT_ENABLE,
 	},
 };
 
-- 
2.39.2



