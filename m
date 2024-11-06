Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56B41F8190;
	Wed,  6 Nov 2024 13:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898185; cv=none; b=Xj9ZXa2vQ8k+s2S0DXiA/xLml9FzhAKyzBHxWiMmlGet/lSmT/rIF6/vOPa2rnlEjT3k29ElbFMntV79+N9kZK+yQ7IowLZ/fB5fCqWs4UVlJp0AnosSxFegtRjDreIcCVtSVuDHatiG9shj0WUDPG3WTkZ+gas8w5UvNphcLUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898185; c=relaxed/simple;
	bh=DyhRqVHzrJnKc94Qx+BZ0tvn6R1/5Mxm/n2k9PL71B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUGKqftt08uB/s8G83qbR9SdFOaLpuMT5yW1BN3wkPOyy/ZeBc1p+u2PD9QBlOX08Rkm/2BBvRF7H0pGo8B1tAcnonPDUWBGUBkT0+pbTu19bT8CEIY+PhoshgOBIvHt7MQuesdtbwnUpYSS0EWgeqnjtfwjsHuHgrPzhWQy3So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouKsxdri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouKsxdri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAFEC4CECD;
	Wed,  6 Nov 2024 13:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898185;
	bh=DyhRqVHzrJnKc94Qx+BZ0tvn6R1/5Mxm/n2k9PL71B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouKsxdriknPIxec/DsfYXrm0x9p6ksh/3x2O1J+24SsnSlGSNNvN6qeFuVg6klizT
	 kX7ZuEao0BFtPInPT91KdFN3cwWJ4bSyNZPgqku1WkyIgN/Dgf0dB/NVwff0Hmn3R9
	 LaMi4VkffUA8wOcTqeYgXeYf1U9keDHyFX536Uy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/462] pinctrl: mvebu: Use devm_platform_get_and_ioremap_resource()
Date: Wed,  6 Nov 2024 13:00:09 +0100
Message-ID: <20241106120334.371754206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 2d357f25663ddfef47ffe26da21155302153d168 ]

Convert platform_get_resource(), devm_ioremap_resource() to a single
call to devm_platform_get_and_ioremap_resource(), as this is exactly
what this function does.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Link: https://lore.kernel.org/r/20230704124742.9596-2-frank.li@vivo.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c25478419f6f ("pinctrl: mvebu: Fix devinit_dove_pinctrl_probe function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 545486d98532d..bd74daa9ed666 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -784,8 +784,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	mpp_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, mpp_res);
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-- 
2.43.0



