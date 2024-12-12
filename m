Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0A520967D;
	Thu, 12 Dec 2024 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024196; cv=none; b=NwNFN/9GqVQ1Zhi5T1dDbfUwj2ZVlDYU79Xjz9xX5agXJsovUSixxLti6Dsxv2dfIWPpSHUAPHZ0j6/2oiOW/xbkjduKAcG4F/hKccIFkcYPViYpkoQqFJvRmDf8gYtalBwL+/TBw5SjAfgjenRcUxDmCGet+pz3HqGoK7YIbro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024196; c=relaxed/simple;
	bh=92ipmAz2kaG4MkcZ5ke5K31otMbZkYFUTJwNbs4Rt7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m70CYNYyyG9oDb0Hk5qMh4utvapQWiIICJImkRqKSD46Wh2cRdJY5Bi4q2MTtyl/LMr122XePOnYk7wI4hRZmO5MBLiVSbgvVlFxtBC/9kW3V0K2ZFdtezuZ4v+35p/jdwAZ/yEQ0rgjgR+PuZVZSE4RKLsrgUUmoW9GJUJjPpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd92fBZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd92fBZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2022C4CED0;
	Thu, 12 Dec 2024 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024196;
	bh=92ipmAz2kaG4MkcZ5ke5K31otMbZkYFUTJwNbs4Rt7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bd92fBZCloiY2JGgMmBZP3xKo40Vgtafh5GbMjxcejBfYzw/JsX1Wa0iEu7vBOelN
	 20MiHt1G4TcA6E8VkeA75A2cCINqctCVhg2jPFFlENZeIv6VyR2p84ztT9wsdWmp51
	 zOt3EGlL1uewxMCC/2vbpnbtGaICz51Wc3tppPJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/459] clk: axi-clkgen: use devm_platform_ioremap_resource() short-hand
Date: Thu, 12 Dec 2024 15:58:46 +0100
Message-ID: <20241212144300.984725123@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 14d803e6af623..1aa3d9fd8d0ac 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -497,7 +497,6 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	struct clk_init_data init;
 	const char *parent_names[2];
 	const char *clk_name;
-	struct resource *mem;
 	unsigned int i;
 	int ret;
 
@@ -512,8 +511,7 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	if (!axi_clkgen)
 		return -ENOMEM;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	axi_clkgen->base = devm_ioremap_resource(&pdev->dev, mem);
+	axi_clkgen->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(axi_clkgen->base))
 		return PTR_ERR(axi_clkgen->base);
 
-- 
2.43.0



