Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEDD1170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E048BC433C8;
	Mon, 11 Sep 2023 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441482;
	bh=XjLynAFD1tL8tC49l+AyDhesGfp5tnnXrb+f4RWzW9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIdpVOGsMU2TV2S4YzpM7Xrremdk8YX7A+L8k2dFwPovyxJxQVs52uV6wwcyzvL0d
	 n5ecPvizrUTbNXGKdgfhaaWxaRQhYLdXcn4XWWF3s8PHIoEqzEmZxBOFQDHyH3WFrl
	 5YGUa7bNHxfsFX0ohOgQUCyyMRgiiqEzZr2r7xz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 401/739] clk: qcom: gcc-sm6350: Fix gcc_sdcc2_apps_clk_src
Date: Mon, 11 Sep 2023 15:43:20 +0200
Message-ID: <20230911134702.381311220@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit df04d166d1f346dbf740bbea64a3bed3e7f14c8d ]

GPLL7 is not on by default, which causes a "gcc_sdcc2_apps_clk_src: rcg
didn't update its configuration" error when booting. Set .flags =
CLK_OPS_PARENT_ENABLE to fix the error.

Fixes: 131abae905df ("clk: qcom: Add SM6350 GCC driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230804-sm6350-sdcc2-v1-1-3d946927d37d@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm6350.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-sm6350.c b/drivers/clk/qcom/gcc-sm6350.c
index 9b4e4bb059635..cf4a7b6e0b23a 100644
--- a/drivers/clk/qcom/gcc-sm6350.c
+++ b/drivers/clk/qcom/gcc-sm6350.c
@@ -641,6 +641,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_8,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_8),
+		.flags = CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_rcg2_floor_ops,
 	},
 };
-- 
2.40.1



