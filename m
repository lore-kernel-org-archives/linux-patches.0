Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31D04C8A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00099C433C7;
	Mon, 11 Sep 2023 14:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443653;
	bh=VEKOQ2XiSLKMTPr0yk3OKcyyapcwUTr2t7whCEG6pzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReUAQpD66S0oU+Y0C5gR8bQisiDr5j1HLkNw+HaDvIfLUQL8nHabtrpRsXU2+j46q
	 BDzHyptjfo/eXW/GcVqkRI5wqJ1FV9sSY7mvH2xAnCTwhk4LalfTiyHgceiCEy8AmY
	 Bt/9WuD8m4EFexF2Nw5uu1Pma85wIzxgHAH6zwtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wronek <davidwronek@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 424/737] clk: qcom: gcc-sc7180: Fix up gcc_sdcc2_apps_clk_src
Date: Mon, 11 Sep 2023 15:44:43 +0200
Message-ID: <20230911134702.445688410@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Wronek <davidwronek@gmail.com>

[ Upstream commit fd0b5ba87ad5709f0fd3d2bc4b7870494a75f96a ]

Set .flags = CLK_OPS_PARENT_ENABLE to fix "gcc_sdcc2_apps_clk_src: rcg
didn't update its configuration" error.

Fixes: 17269568f726 ("clk: qcom: Add Global Clock controller (GCC) driver for SC7180")
Signed-off-by: David Wronek <davidwronek@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230723190725.1619193-2-davidwronek@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7180.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-sc7180.c b/drivers/clk/qcom/gcc-sc7180.c
index cef3c77564cfd..49f36e1df4fa8 100644
--- a/drivers/clk/qcom/gcc-sc7180.c
+++ b/drivers/clk/qcom/gcc-sc7180.c
@@ -651,6 +651,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_5,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_5),
+		.flags = CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_rcg2_floor_ops,
 	},
 };
-- 
2.40.1



