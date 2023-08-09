Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7F41773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA976C433C8;
	Wed,  9 Aug 2023 11:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579744;
	bh=dvJZmvyo1H6AaegGuiBlfE7X/cckUiTVWq714Ro/3JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sew77MaRzqMudvk6K2FPgGjrEgMLGxw6dID/MwpP8XnWXW5uDw5SII/yCDw2J0tBs
	 u637pIKxpyY5ohQw6h85QX5TaAzx/dq/wmekwLJ/aoeBNFfuzi/B26Wt6HXk+apa9v
	 k1h+hqt3J4TvfzJ6+Y5mQZYH6C3ChHzzWQiAH9Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/323] rtc: st-lpc: Release some resources in st_rtc_probe() in case of error
Date: Wed,  9 Aug 2023 12:38:57 +0200
Message-ID: <20230809103702.589651280@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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
index e66439b6247a4..e8a8ca3545f00 100644
--- a/drivers/rtc/rtc-st-lpc.c
+++ b/drivers/rtc/rtc-st-lpc.c
@@ -239,7 +239,7 @@ static int st_rtc_probe(struct platform_device *pdev)
 	enable_irq_wake(rtc->irq);
 	disable_irq(rtc->irq);
 
-	rtc->clk = clk_get(&pdev->dev, NULL);
+	rtc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rtc->clk)) {
 		dev_err(&pdev->dev, "Unable to request clock\n");
 		return PTR_ERR(rtc->clk);
-- 
2.39.2



