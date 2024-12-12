Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9A56F2FE;
	Thu, 12 Dec 2024 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025306; cv=none; b=F8bzChTSOqSy0J8IBbEwJxCDJqU6ltxj89vpdhSadwiyxqGEdtphzWiRm/aO7H4AvL58LJK3/kE67wOXJ3wqQV7xn9RPFPrd7+LiUNDoxAxGyRE5kPvzYIQpnFy5MFXeohLMZcis1YcqOGcCLBztLw5xACD4dFArzb3Gk/ZXC0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025306; c=relaxed/simple;
	bh=WE0qzHuGmwh+Pfvnto3FMVZBjRSlAHAB91EeLirn2xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRWk4w/HEOFcR73t+03lNf1EgJhfOVeX467BTw3Vla61VTN6EvCn2s4zMc20Dx2Dr+1MBNaAoq0dy2XabhtTLZizWohs9qCBNfCUYt8dS8MEKqisuFf3YSAoZxGbc+obI7CQTUy1vmmLwaVPx0ONL/0A/aCMZqJXTZLgKUNvCTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDbe0fEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDbe0fEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D36C4CECE;
	Thu, 12 Dec 2024 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025305;
	bh=WE0qzHuGmwh+Pfvnto3FMVZBjRSlAHAB91EeLirn2xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDbe0fEG8PlLQt4NJSnSZFvdXpATHCjvEPYdI0439Oe6rGUmbkzGEy7FDso4PTp3A
	 tM5xONM1boDYJx/KA9vvV7DmBsNLv1RFVEkdQhmyKs8FxiKqtnjfjlDKAm4XnxYnLY
	 GuHkls0y4Ey3lFcLx5/ucPAJWWSLyE3NgYgb5gdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/321] clk: axi-clkgen: use devm_platform_ioremap_resource() short-hand
Date: Thu, 12 Dec 2024 16:00:26 +0100
Message-ID: <20241212144234.253660726@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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
index 96f351785b41b..8d0c32e81e787 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -412,7 +412,6 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	struct clk_init_data init;
 	const char *parent_names[2];
 	const char *clk_name;
-	struct resource *mem;
 	unsigned int i;
 	int ret;
 
@@ -427,8 +426,7 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	if (!axi_clkgen)
 		return -ENOMEM;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	axi_clkgen->base = devm_ioremap_resource(&pdev->dev, mem);
+	axi_clkgen->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(axi_clkgen->base))
 		return PTR_ERR(axi_clkgen->base);
 
-- 
2.43.0



