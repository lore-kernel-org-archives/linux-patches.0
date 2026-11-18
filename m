Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025200;
	b=cg4unwVXnMMAaXdcZDMPQcTufog55L0IAi9u+g0ySw8ZP0/sacvVitHUE04lw8JXmuea
	 8PkxXBREJAPQvTlT763qm7qyhq73lpXQSrOFAos/BQOS6eecraBg7HUOW1mzDeLnOrcVn
	 VmQHz7gQI/rbRkPKWJ3PWfxe3BTwxuNlfCP3wYAsvT6x2eOhnC1V49ZUhHsv+IEBtXcpU
	 plu2hd4r1Kh/PZnpwI+1DEwsr/y93nf0p++aviBgF0C6ckfLgkHCQn0mFSVd25pxUl7PR
	 XCt5YfrhWYjQFELXYE1a+M8036x6Ep6FtXe5iQKgUAluvQe1ZFJgLNxx9EH0Eiu1XhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M1Ftcb0Cnl6rRB1RvyXCBNHx+j58dRx2TBwH7swZfqg=;
	b=Fs3sj+xehp5FSOziBIY/5t4rDE/NPdbO80ef4xo7jYNRKWUX5aXamNMG8dcovlPSTLwl
	 Nxt5/zDwLP8cSXsWcu5idiSt2WOX9kyhIqx4NeJTQtCYmoykvXISEIbrE1xtvq8LLPPMo
	 2TKLLmbjEcIxwZsnEggTqt+6TmNWQDzc9ZR+T02qVhus2n26C1DqDrPE/8NpaGr6ygomh
	 XSDwXK8Qpsx8kM3AeqLo7Thcz+Q+BpWQDX2NA/aFeSgEtUwtfG3UkNsFUF8z4pkgCCi/T
	 dJjdDfxw7vaVndwLgIvcf1peQ0Sksx8iTBbsEHcu7ZHkwWdL0eDMcdq6kY1j1Kopxnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UEJATs9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89554606A325;
	Wed, 18 Nov 2026 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UEJATs9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA88F1F000C4;
	Wed, 18 Nov 2026 18:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025200;
	bh=M1Ftcb0Cnl6rRB1RvyXCBNHx+j58dRx2TBwH7swZfqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEJATs9HzrT+RZPmqPhkuc91qrzLQX26fEvJeRi9c1KihLkvFfdX5jzNShJTrbS6h
	 Q5M3DUPUCqTMznxLFC8sFDSZOguXWTwhjI3e8xl0ulepVWx/Ynd+5tHJQinuIsPmgo
	 kFAr75w4qblqPQEZQNMmE19SCagHJQDR58oIsvpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.18 0995/2151] phy: rockchip: usbdp: Fix devm_clk_bulk_get_all check
Date: Wed, 18 Nov 2026 15:45:30 +0100
Message-ID: <20261118150158.693838231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit a2ddfc60a7d3ba0f571f037371b261642f8ed208 ]

If devm_clk_bulk_get_all() returns -EPROBE_DEFER, it is replaced with
-ENODEV, permanently failing the driver probe instead of allowing it to
defer. Avoid masking the error code to fix the issue.

This effectively drops returning -ENODEV in case no clocks are being
described in DT. This special case will now be handled by the follow-up
check searching for "refclk" and exit with -EINVAL.

None of this will be hit in practice, since the driver is only used by
RK3588 and RK3576 - on these platforms the DT is validated to contain
the clocks and the clock driver is force probed early. Thus there is
no need to backport this.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612164107.C7DB21F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-phy/20260612164107.C7DB21F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-4-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 12dfdd470a782..2845a012eafcc 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -427,8 +427,8 @@ static int rk_udphy_clk_init(struct rk_udphy *udphy, struct device *dev)
 	int i;
 
 	udphy->num_clks = devm_clk_bulk_get_all(dev, &udphy->clks);
-	if (udphy->num_clks < 1)
-		return -ENODEV;
+	if (udphy->num_clks < 0)
+		return udphy->num_clks;
 
 	/* used for configure phy reference clock frequency */
 	for (i = 0; i < udphy->num_clks; i++) {
-- 
2.53.0



