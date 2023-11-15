Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC54364D4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K84jl2su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AC6C433C7;
	Wed, 15 Nov 2023 22:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085746;
	bh=ZX8dZ/yme8nh//R79DXrq0/1tS/ksbnRLlFR4kXQZi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K84jl2suosN3CMfgWiM1rx4cJoS4B8qGcqq4xCTz0jM8eE7I+KTIO/kSJ9OcypFcT
	 AYEAuWYfQs7wkrkEAoko8IZUjE7ah2r1tyiGWswMvKA6/b06I1MGwH0eD23hxw0XdJ
	 zACXQyaDAazA38ggsp6DooRs0VOSId7rIKo/0u1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Velikanov <adomerlee@gmail.com>,
	Danila Tikhonov <danila@jiaxyga.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/119] clk: qcom: gcc-sm8150: Fix gcc_sdcc2_apps_clk_src
Date: Wed, 15 Nov 2023 17:00:16 -0500
Message-ID: <20231115220133.441074493@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Tikhonov <danila@jiaxyga.com>

[ Upstream commit 7138c244fb293f24ce8ab782961022eff00a10c4 ]

Set .flags = CLK_OPS_PARENT_ENABLE to fix "gcc_sdcc2_apps_clk_src: rcg
didn't update its configuration" error.

Fixes: 2a1d7eb854bb ("clk: qcom: gcc: Add global clock controller driver for SM8150")
Tested-by: Arseniy Velikanov <adomerlee@gmail.com>
Signed-off-by: Danila Tikhonov <danila@jiaxyga.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230913175612.8685-1-danila@jiaxyga.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
index f18502cdc46e0..68ea6a846a154 100644
--- a/drivers/clk/qcom/gcc-sm8150.c
+++ b/drivers/clk/qcom/gcc-sm8150.c
@@ -801,7 +801,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parents_6,
 		.num_parents = ARRAY_SIZE(gcc_parents_6),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_rcg2_floor_ops,
 	},
 };
-- 
2.42.0



