Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214E4258F
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5FDC433EF;
	Thu, 23 Feb 2023 13:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157938;
	bh=Znq77NldJrO5mrL9Y1tVbdJWOciLYeWwe9GclaI+pJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8RUYphFKp0xtzVMqz0m63urHWHCITz8I02EY2ffYnQ3x5Ce9nj1WYPdLaP3gK9tR
	 VtcBWzsmOemz1mji54Xiz5ThZwhrTNxS+rYLi+d1yipTYKlbiYP211HCGLbVUklg02
	 WHpEg5W2HX4TkITYgZAncVK+68cichfE3YS433kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Rahul Tanwar <rtanwar@maxlinear.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/36] clk: mxl: syscon_node_to_regmap() returns error pointers
Date: Thu, 23 Feb 2023 14:06:45 +0100
Message-Id: <20230223130429.506184427@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit 7256d1f4618b40792d1e9b9b6cb1406a13cad2dd ]

Commit 036177310bac ("clk: mxl: Switch from direct readl/writel based IO
to regmap based IO") introduced code resulting in below warning issued
by the smatch static checker.

  drivers/clk/x86/clk-lgm.c:441 lgm_cgu_probe() warn: passing zero to 'PTR_ERR'

Fix the warning by replacing incorrect IS_ERR_OR_NULL() with IS_ERR().

Fixes: 036177310bac ("clk: mxl: Switch from direct readl/writel based IO to regmap based IO")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/49e339d4739e4ae4c92b00c1b2918af0755d4122.1666695221.git.rtanwar@maxlinear.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-lgm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/x86/clk-lgm.c b/drivers/clk/x86/clk-lgm.c
index 4de77b2c750d3..f69455dd1c980 100644
--- a/drivers/clk/x86/clk-lgm.c
+++ b/drivers/clk/x86/clk-lgm.c
@@ -436,7 +436,7 @@ static int lgm_cgu_probe(struct platform_device *pdev)
 	ctx->clk_data.num = CLK_NR_CLKS;
 
 	ctx->membase = syscon_node_to_regmap(np);
-	if (IS_ERR_OR_NULL(ctx->membase)) {
+	if (IS_ERR(ctx->membase)) {
 		dev_err(dev, "Failed to get clk CGU iomem\n");
 		return PTR_ERR(ctx->membase);
 	}
-- 
2.39.0



