Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA641DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="El25d7yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E050BC433CA;
	Wed,  4 Oct 2023 18:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444086;
	bh=3AzEj1xDRT/wG16i9mVpb8V47tw7Tbwl8y4/jRh5bJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=El25d7yulyovHn36mjZpz9H+a/lgKLvIAwp0R45gi+mMqNjFuMnRyIarLsQklsFoD
	 Emzw+yfZEoJn/BWbFix5jRHFjMb9aGA32ojoC0F21cS5LMWXiHGcKMbw3QQLqcKYJ5
	 hfNkWxctB24nU3HFKWO4ji4tWpOjoPP1tHDuI5wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhifeng Tang <zhifeng.tang@unisoc.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 126/321] clk: sprd: Fix thm_parents incorrect configuration
Date: Wed,  4 Oct 2023 19:54:31 +0200
Message-ID: <20231004175235.083947012@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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



