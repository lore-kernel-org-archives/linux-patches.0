Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34F68F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2D2C433C8;
	Sun, 16 Jul 2023 20:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538850;
	bh=R7YhuNAAvshuejcLFVFLZf//fiL8d3wI/DJ0Wu47wxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeS4ttaKKGrWKT+ACAz5Dhj5rQV5QzoDdp9dESIqITKWm0dGmZDmCTfDwvriyXtYI
	 nV4R8bwyfzzvYvht8rOSrtLZ1uGeiDZXPrHbogb8tDfBlAzHs4PLa7EO2OB6QZn+6R
	 uS/X4HWAzgt773nv+RmQqN3UDKjpHZ5i3j9hI76Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan T <quic_kathirav@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 560/800] clk: qcom: gcc: ipq5332: Use floor ops for SDCC clocks
Date: Sun, 16 Jul 2023 21:46:53 +0200
Message-ID: <20230716195002.096499501@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kathiravan T <quic_kathirav@quicinc.com>

[ Upstream commit a30e62bf6bf4d3230fa9164c7e174e32b9be7ba5 ]

SDCC clocks must be rounded down to avoid overclocking the controller.

Fixes: 3d89d52970fd ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5332 SoC")
Signed-off-by: Kathiravan T <quic_kathirav@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230508163145.9678-1-quic_kathirav@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5332.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq5332.c b/drivers/clk/qcom/gcc-ipq5332.c
index bdb4a0a11d07b..1ad23aa8aa5a9 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -963,7 +963,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_9,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_9),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
-- 
2.39.2



