Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1DB28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1011FC433EF;
	Mon, 30 Jan 2023 14:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087673;
	bh=4OOrnXhC3gFehwLim97Sm4bqSJRqTDMDLTsw0xaiRxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4ma0H1RmDEbj6U1CWZLyu1ioUuu/g/ia0T++/FdQ4RdlKH1BAC/D7NxnqCfoQ62A
	 +AOS3+wCrdUQNuZVBz5JIjaBnyTeHboyMFtoC7HGUZ/mzklkwrQ0ciseoP5t51X+R9
	 e0U8mJjyaXm+jTk63egSx0L62fpOrayHxmiaKs6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <nikita.shubin@maquefel.me>,
	Arnd Bergmann <arnd@arndb.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/313] gpio: ep93xx: Fix port F hwirq numbers in handler
Date: Mon, 30 Jan 2023 14:52:01 +0100
Message-Id: <20230130134350.046763290@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Shubin <nikita.shubin@maquefel.me>

[ Upstream commit 0f04cdbdb210000a97c773b28b598fa8ac3aafa4 ]

Fix wrong translation of irq numbers in port F handler, as ep93xx hwirqs
increased by 1, we should simply decrease them by 1 in translation.

Fixes: 482c27273f52 ("ARM: ep93xx: renumber interrupts")
Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-ep93xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 2e1779709113..7edcdc575080 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -148,7 +148,7 @@ static void ep93xx_gpio_f_irq_handler(struct irq_desc *desc)
 	 */
 	struct irq_chip *irqchip = irq_desc_get_chip(desc);
 	unsigned int irq = irq_desc_get_irq(desc);
-	int port_f_idx = ((irq + 1) & 7) ^ 4; /* {19..22,47..50} -> {0..7} */
+	int port_f_idx = (irq & 7) ^ 4; /* {20..23,48..51} -> {0..7} */
 	int gpio_irq = EP93XX_GPIO_F_IRQ_BASE + port_f_idx;
 
 	chained_irq_enter(irqchip, desc);
-- 
2.39.0



