Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2A37469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE096C433C8;
	Sun, 17 Sep 2023 20:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982277;
	bh=XKQ/b/TAPXuTyojafXV69nbvYoDl21ImZT/Ub3tGj5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2VFMTuq2N+wCYZF+UWw/qT01gLHqL3cpSw299QAlSA9nYIY22jjjBu+uovHGAnkI
	 4Dhp6qYNDi3CW26r1O3AzUv1DM/PQmiY8YvOeupCbugkCqaTUXxMvIrLSmCkiFOwCU
	 jpHEaVdeUvzHnC2cO+PrW1GpCbdqVFRFX1cIpA2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/511] clk: qcom: gcc-sm6350: Fix gcc_sdcc2_apps_clk_src
Date: Sun, 17 Sep 2023 21:10:30 +0200
Message-ID: <20230917191118.727339086@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3236706771b11..e32ad7499285f 100644
--- a/drivers/clk/qcom/gcc-sm6350.c
+++ b/drivers/clk/qcom/gcc-sm6350.c
@@ -640,6 +640,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_8,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_8),
+		.flags = CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_rcg2_floor_ops,
 	},
 };
-- 
2.40.1



