Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD83D11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F36AC433C8;
	Mon, 11 Sep 2023 14:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443545;
	bh=CRVQlkBuc+PzznrLnPBmU5vntMsuqilIQ5XYOqpoh4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5qoq0nbUGrVDasBHe/Y7bgunz5A4IxteImIndBBRtrbXskbhaRI4m+H2DvfbllVU
	 XD7DU48OxI2t0MJG4KZnYXKBerEWVQxIh5CBFyKt4I2uGZ7m3o5NELIgyUKR+43wQr
	 tT3qPdf5Jf5RVmQhctrnwqBeO3jbiG1+zQwFtN1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alibek Omarov <a1ba.omarov@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 415/737] clk: rockchip: rk3568: Fix PLL rate setting for 78.75MHz
Date: Mon, 11 Sep 2023 15:44:34 +0200
Message-ID: <20230911134702.206290166@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alibek Omarov <a1ba.omarov@gmail.com>

[ Upstream commit dafebd0f9a4f56b10d7fbda0bff1f540d16a2ea4 ]

PLL rate on RK356x is calculated through the simple formula:
((24000000 / _refdiv) * _fbdiv) / (_postdiv1 * _postdiv2)

The PLL rate setting for 78.75MHz seems to be copied from 96MHz
so this patch fixes it and configures it properly.

Signed-off-by: Alibek Omarov <a1ba.omarov@gmail.com>
Fixes: 842f4cb72639 ("clk: rockchip: Add more PLL rates for rk3568")
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20230614134750.1056293-1-a1ba.omarov@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3568.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3568.c b/drivers/clk/rockchip/clk-rk3568.c
index f85902e2590c7..2f54f630c8b65 100644
--- a/drivers/clk/rockchip/clk-rk3568.c
+++ b/drivers/clk/rockchip/clk-rk3568.c
@@ -81,7 +81,7 @@ static struct rockchip_pll_rate_table rk3568_pll_rates[] = {
 	RK3036_PLL_RATE(108000000, 2, 45, 5, 1, 1, 0),
 	RK3036_PLL_RATE(100000000, 1, 150, 6, 6, 1, 0),
 	RK3036_PLL_RATE(96000000, 1, 96, 6, 4, 1, 0),
-	RK3036_PLL_RATE(78750000, 1, 96, 6, 4, 1, 0),
+	RK3036_PLL_RATE(78750000, 4, 315, 6, 4, 1, 0),
 	RK3036_PLL_RATE(74250000, 2, 99, 4, 4, 1, 0),
 	{ /* sentinel */ },
 };
-- 
2.40.1



