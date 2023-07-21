Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AE127F34
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192B4C433C7;
	Fri, 21 Jul 2023 19:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966355;
	bh=anADLG2yJBjurdAhIA1aG+IL5b9z6R+xGSE+Q8Pugow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+fJ+I7gRtnWdJBh+Ztd/c5mI/e660gPXvg1nWtAWlXLAdIQ6n22lD86w1U8nxgi0
	 LZBDpDF0C2IsatlNMQw7cHJK6gomuaAIyRHwSpP0PR6PDMKFUk17lsz9TnfrU5X2RW
	 wa0EgyBwdqHjsL5G1M+KZCDlOrbXMct9eMvdoi/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/532] rtc: st-lpc: Release some resources in st_rtc_probe() in case of error
Date: Fri, 21 Jul 2023 18:03:37 +0200
Message-ID: <20230721160631.373608784@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 06c6e1b01d9261f03629cefd1f3553503291e6cf ]

If an error occurs after clk_get(), the corresponding resources should be
released.

Use devm_clk_get() to fix it.

Fixes: b5b2bdfc2893 ("rtc: st: Add new driver for ST's LPC RTC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/866af6adbc7454a7b4505eb6c28fbdc86ccff39e.1686251455.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-st-lpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-st-lpc.c b/drivers/rtc/rtc-st-lpc.c
index 0f8e4231098ef..d04d46f9cc65a 100644
--- a/drivers/rtc/rtc-st-lpc.c
+++ b/drivers/rtc/rtc-st-lpc.c
@@ -228,7 +228,7 @@ static int st_rtc_probe(struct platform_device *pdev)
 	enable_irq_wake(rtc->irq);
 	disable_irq(rtc->irq);
 
-	rtc->clk = clk_get(&pdev->dev, NULL);
+	rtc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rtc->clk)) {
 		dev_err(&pdev->dev, "Unable to request clock\n");
 		return PTR_ERR(rtc->clk);
-- 
2.39.2



