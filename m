Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5D52566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EF1C433EF;
	Tue, 18 Apr 2023 12:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820728;
	bh=iSlH1YU6NyrpxL5h9pF5bYMmIuS5fZQQjseBFeXDF+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOXaFQpAv1wek+8BbqWzYL9uH2NgEUY5N+m/9WGX8ZZ9j2+FO5ESj+3VPROhCxd/V
	 nNGM5LtdJ+zq4Wz/Rq4RSvTfm/tB+3Wm1zbcKcSbPC+E1oSY5NDpJMTlfqF0TJ1Axa
	 WhC2ZnLHKCTjOUEia9u8x81xqp1fcW5TSiZoHzB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandeep Singh <Sandeep.Singh@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Nehal Shah <Nehal-bakulchandra.Shah@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/57] pinctrl: Added IRQF_SHARED flag for amd-pinctrl driver
Date: Tue, 18 Apr 2023 14:21:01 +0200
Message-Id: <20230418120258.773778655@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sandeep Singh <sandeep.singh@amd.com>

[ Upstream commit 279ffafaf39d60b3c37cb3f0f7de310d0dd834ad ]

Some of the AMD reference boards used single GPIO line for
multiple devices. So added IRQF_SHARED flag in amd pinctrl driver.

Signed-off-by: Sandeep Singh <Sandeep.Singh@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
cc: Nehal Shah <Nehal-bakulchandra.Shah@amd.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: b26cd9325be4 ("pinctrl: amd: Disable and mask interrupts on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 66b9c5826ec03..d76e50bc9d85c 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -943,8 +943,8 @@ static int amd_gpio_probe(struct platform_device *pdev)
 		goto out2;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq_base, amd_gpio_irq_handler, 0,
-			       KBUILD_MODNAME, gpio_dev);
+	ret = devm_request_irq(&pdev->dev, irq_base, amd_gpio_irq_handler,
+			       IRQF_SHARED, KBUILD_MODNAME, gpio_dev);
 	if (ret)
 		goto out2;
 
-- 
2.39.2



