Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5291B2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC75CC433EF;
	Tue, 18 Apr 2023 12:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821140;
	bh=86JHRX4sGD9XQvqGo0Ax9UxRYq7n5oJ4tCOgitE4t/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7QbwrtZgsuj3PKCbXxFhVMcWR6riwYREEJj1fSp6RK8hVzfxYzNIdKmHP8llfNzz
	 pTqurW1JBv+hv7RmdiozE3M3lwFEr+2v+uaJdlivHCW9WNGIUCgem+IkOYG2Kn6POt
	 HV6oakGadypqfGMs9YUSqlQNwDpfmKo2qGYZoTeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/124] gpio: davinci: Add irq chip flag to skip set wake
Date: Tue, 18 Apr 2023 14:20:33 +0200
Message-Id: <20230418120310.147697780@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit 7b75c4703609a3ebaf67271813521bc0281e1ec1 ]

Add the IRQCHIP_SKIP_SET_WAKE flag since there are no special IRQ Wake
bits that can be set to enable wakeup IRQ.

Fixes: 3d9edf09d452 ("[ARM] 4457/2: davinci: GPIO support")
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 6f2138503726a..80597e90de9c6 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -326,7 +326,7 @@ static struct irq_chip gpio_irqchip = {
 	.irq_enable	= gpio_irq_enable,
 	.irq_disable	= gpio_irq_disable,
 	.irq_set_type	= gpio_irq_type,
-	.flags		= IRQCHIP_SET_TYPE_MASKED,
+	.flags		= IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };
 
 static void gpio_irq_handler(struct irq_desc *desc)
-- 
2.39.2



