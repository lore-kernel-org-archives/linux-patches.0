Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A72F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10673C433F1;
	Mon, 16 Jan 2023 17:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888956;
	bh=RnIOD5BCXzKk9040UUeviWUtHgOoAnz0jaHrZgNKLso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMCxUdiBl3r9tpT/CceewLVrTID4PUw+Tos4Jlitjv4lwEoU6gbzJGSdQPwvMY2jN
	 0enAtbcv4YOmRZrLYSQBUctPx7rqEhxGcK/JzubBP6oYhZFrbdIPTgja6GIO+9WNHt
	 AIsFGCd04LfGPj7S+HL+y6Xz533eCgYEhdRQqmCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 203/338] rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()
Date: Mon, 16 Jan 2023 16:51:16 +0100
Message-Id: <20230116154829.835299525@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 5fb733d7bd6949e90028efdce8bd528c6ab7cf1e ]

The clk_disable_unprepare() should be called in the error handling
of clk_get_rate(), fix it.

Fixes: b5b2bdfc2893 ("rtc: st: Add new driver for ST's LPC RTC")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221123014805.1993052-1-cuigaosheng1@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-st-lpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-st-lpc.c b/drivers/rtc/rtc-st-lpc.c
index 82b0af159a28..6f33e705928f 100644
--- a/drivers/rtc/rtc-st-lpc.c
+++ b/drivers/rtc/rtc-st-lpc.c
@@ -246,6 +246,7 @@ static int st_rtc_probe(struct platform_device *pdev)
 
 	rtc->clkrate = clk_get_rate(rtc->clk);
 	if (!rtc->clkrate) {
+		clk_disable_unprepare(rtc->clk);
 		dev_err(&pdev->dev, "Unable to fetch clock rate\n");
 		return -EINVAL;
 	}
-- 
2.35.1



