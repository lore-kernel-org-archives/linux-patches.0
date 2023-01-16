Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D569B46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE66C433D2;
	Mon, 16 Jan 2023 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885858;
	bh=MUyBCoF4EUSkIHgsegItBGB/Fe++aR/mkRhb7NvgJE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdGC++HErXiCyiXxqZ2AVeKHfnyIIOpvQWeijPfhYKqvV6INY+fBK0pk3f0rMN/vF
	 62UyXZyCBG6V6cv4E4lljDh2Or5BVORpAsJ51C7aNFrn6OY68o5/mgMbu/VLVaiUub
	 TLKvNGfIXDlMiz70fKIly4NJR1f+kDqvthNp9kk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-clk@vger.kernel.org,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/658] clk: socfpga: clk-pll: Remove unused variable rc
Date: Mon, 16 Jan 2023 16:44:58 +0100
Message-Id: <20230116154919.054153174@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 75fddccbca32349570b2d53955982b4117fa5515 ]

Fixes the following W=1 kernel build warning(s):

 drivers/clk/socfpga/clk-pll.c: In function ‘__socfpga_pll_init’:
 drivers/clk/socfpga/clk-pll.c:83:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]

Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20210120093040.1719407-8-lee.jones@linaro.org
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 0b8ba891ad4d ("clk: socfpga: Fix memory leak in socfpga_gate_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-pll.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/socfpga/clk-pll.c b/drivers/clk/socfpga/clk-pll.c
index dc65cc0fd3bd..444f3948fff4 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -80,7 +80,6 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
 	struct clk_init_data init;
 	struct device_node *clkmgr_np;
-	int rc;
 
 	of_property_read_u32(node, "reg", &reg);
 
@@ -113,7 +112,7 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 		kfree(pll_clk);
 		return NULL;
 	}
-	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
 	return clk;
 }
 
-- 
2.35.1



