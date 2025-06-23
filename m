Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944E41E5B71;
	Mon, 23 Jun 2025 21:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714135; cv=none; b=NiKMKlbZzqHSchXACnoz/VhdBOGzZF+rJTNwU3D++ViyvlZ5Esj3ZZ32qGwfb+N85jHPwY5na883cmPZ6cb31kgduZo70QyIRJxacmMJER7snSs7slkiaGFweF4G5Ln5oi/BtkJEqYKzLt4b10R2XqIZ/WnPZD+xMzAWa9oqe3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714135; c=relaxed/simple;
	bh=smVLp9JTW0WXDYW5J+TquPK5Ara2yVkbVzpdOCZPC3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=shLsDclLLVhXssFCjkBcZsVOYMWuLUgpU6wsIzOt8ZEO4pVN3DhXljm6KIJnVKGOt137MEX8hFywrOPWRiPJvkwS84YLCZ09ZjWg53mN8/VJi1UFq3F+Mjix9ZxSLYHceh5Db+ohsIja+Cy/afnFKhQiDT+hXrRJUBKtJ1QEKqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOTKXWmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOTKXWmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E886C4CEEA;
	Mon, 23 Jun 2025 21:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714135;
	bh=smVLp9JTW0WXDYW5J+TquPK5Ara2yVkbVzpdOCZPC3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOTKXWmU2p7yfhE2wfZtHrbY99IKlmtCZp9O2Qwv9WXadA5S5Tqel8hZcTrtWx1A4
	 dZK1nActv17YncTK3wbB044cRzGYJDNU3w9Lfay/JHstq25RCPvg/nY2ZCB4mLEJkl
	 rOPjHqGDOH+CMjHfwxCgURs/ofKRzqhrRyMlcpJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/508] spi: bcm63xx-hsspi: fix shared reset
Date: Mon, 23 Jun 2025 15:03:39 +0200
Message-ID: <20250623130649.555345259@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 3d6d84c8f2f66d3fd6a43a1e2ce8e6b54c573960 ]

Some bmips SoCs (bcm6362, bcm63268) share the same SPI reset for both SPI
and HSSPI controllers, so reset shouldn't be exclusive.

Fixes: 0eeadddbf09a ("spi: bcm63xx-hsspi: add reset support")
Reported-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250529130915.2519590-3-noltari@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 02f56fc001b47..7d8e5c66f6d17 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -357,7 +357,7 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 
-	reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	reset = devm_reset_control_get_optional_shared(dev, NULL);
 	if (IS_ERR(reset))
 		return PTR_ERR(reset);
 
-- 
2.39.5



