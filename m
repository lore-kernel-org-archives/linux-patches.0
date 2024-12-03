Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4CB1F6691;
	Tue,  3 Dec 2024 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236622; cv=none; b=bO16DzUb8hEwwhUvkCvKvURQZ4oWv4bxKEI/BxjJQZz8nN4iMJLRGuMJq27jN9mVktD3o+9XXdJ3VhE6DSeT/18y6h4J1B26hckVWTaI1PLqQGmTeosuCmH0yCr3+5irv8T7LG5+oxnsvaLTnDIu+LzgHd5FS28gqFvjoQZy5Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236622; c=relaxed/simple;
	bh=3+Hn0F48ju6dEl0zjFtpB4C7/hJaWweqFzq/yZ7eI7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYWDLBM+ZuZoF3t6JGeiqZlfxYydwxmzApDiurbjy6ZjYxBYJJWq4hiY1j5rvaKb4zIWpO+4kssOf5ioq0bmeKooQ32tCNiRWF6u5g3+di/UzxNk3irptj16sm+prw+J5ZqiXi9jHBUTMCxkRbu9PRR3UKhGKoz4XgwzWjm6+vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nrtaX5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nrtaX5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAACC4CECF;
	Tue,  3 Dec 2024 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236622;
	bh=3+Hn0F48ju6dEl0zjFtpB4C7/hJaWweqFzq/yZ7eI7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nrtaX5oFnP/0wIUojMwBqdkGUvQD2ckMIlv9QszmkySc3wiXD9+UoqbvbZFLt6Rn
	 ZAEU8cSr52LneVkGVtWmhI+rTRKIYXBa2mdFThV+Zcc78Aqv1nhYLdr1StvfdGBUgh
	 eutnhV8XS6EQq/ihjBxl4qWWlPTy+CKlIk6J+PuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/138] clk: axi-clkgen: use devm_platform_ioremap_resource() short-hand
Date: Tue,  3 Dec 2024 15:31:43 +0100
Message-ID: <20241203141926.395960755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 6ba7ea7630fb03c1ce01508bdf89f5bb39b38e54 ]

No major functional change. Noticed while checking the driver code that
this could be used.
Saves two lines.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20210201151245.21845-5-alexandru.ardelean@analog.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: c64ef7e4851d ("clk: clk-axi-clkgen: make sure to enable the AXI bus clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-axi-clkgen.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index 48d11f2598e84..7289da51b74f1 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -414,7 +414,6 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	struct clk_init_data init;
 	const char *parent_names[2];
 	const char *clk_name;
-	struct resource *mem;
 	unsigned int i;
 	int ret;
 
@@ -429,8 +428,7 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	if (!axi_clkgen)
 		return -ENOMEM;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	axi_clkgen->base = devm_ioremap_resource(&pdev->dev, mem);
+	axi_clkgen->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(axi_clkgen->base))
 		return PTR_ERR(axi_clkgen->base);
 
-- 
2.43.0



