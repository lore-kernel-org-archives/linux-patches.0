Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F41A1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Olf2jvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12316C433CA;
	Wed,  4 Oct 2023 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443328;
	bh=0+FuRGuZ5SxK6shwrQdog0XsY5lQEyRmPAHCwI+pafA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Olf2jvA7O40oECnOf3CuWQ0Xa659B6r+eae2mNlksbR/8mpqC02X06bXE5dzhRE7
	 2wPpbm3qGs95eM1L169PkzS/MYkDHwvU++yOPS2fpr1DUgxTVgmJlAE2Nj6apPEJEo
	 WxlJPcl3cG7UEwJljMg9uCsvjq+1YWkiagbf23xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhifeng Tang <zhifeng.tang@unisoc.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/259] clk: sprd: Fix thm_parents incorrect configuration
Date: Wed,  4 Oct 2023 19:54:50 +0200
Message-ID: <20231004175222.726430863@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhifeng Tang <zhifeng.tang@unisoc.com>

[ Upstream commit b7b20cfe6f849c2682c5f7d3f50ede6321a5d04c ]

The thm*_clk have two clock sources 32k and 250k,excluding 32m.

Fixes: af3bd36573e3 ("clk: sprd: Add clocks support for UMS512")
Signed-off-by: Zhifeng Tang <zhifeng.tang@unisoc.com>
Acked-by: Chunyan Zhang <zhang.lyra@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230824092624.20020-1-zhifeng.tang@unisoc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/ums512-clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sprd/ums512-clk.c b/drivers/clk/sprd/ums512-clk.c
index fc25bdd85e4ea..f43bb10bd5ae2 100644
--- a/drivers/clk/sprd/ums512-clk.c
+++ b/drivers/clk/sprd/ums512-clk.c
@@ -800,7 +800,7 @@ static SPRD_MUX_CLK_DATA(uart1_clk, "uart1-clk", uart_parents,
 			 0x250, 0, 3, UMS512_MUX_FLAG);
 
 static const struct clk_parent_data thm_parents[] = {
-	{ .fw_name = "ext-32m" },
+	{ .fw_name = "ext-32k" },
 	{ .hw = &clk_250k.hw  },
 };
 static SPRD_MUX_CLK_DATA(thm0_clk, "thm0-clk", thm_parents,
-- 
2.40.1



