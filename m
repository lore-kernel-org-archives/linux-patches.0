Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216931;
	b=JJHjb8+wypY8i6jIMy1U0sK81drmYGwxYfrJEJsDKcwvUdFeXpRBSgOW2fM/KIfhtXvf
	 j1sBvk7ug5TgV0/HVZUJZxnzhMYUNxoCUHB5QWyuIkHCjAdodNYRgj1UyjSNprFdYbPSv
	 y9jNAu2bC1HaxvAvWvTSo5NiXm3dVoeUVXkzeCIX2TVBxq2dSaRaBbVJZvMTfopuwahTh
	 F8bzfEkAWhG7A7hr5UZ3dTyHOmouh9YY5MZJ58nKhI2Jf4l8a/UU1WW8nJxQIacvIuKWT
	 rgBcQMCSUlMkGVpLd2wzwmzI3o6E9sSALJ1XZWTfWdtn0i570BUxGI9eA5StujmATsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Plr930Ce/7avlWWl1wHMnBag/NM61EFboXMq3A6CAm0=;
	b=H75Clj1Z7/ltCf/5005cELDGihyyTviuqImfCsE/HTPfJVOXqLgpm4Otnr2qSRi/eHOJ
	 7jHpPMFzfR+6m1iMY6/ghyyy5sjm9x5L+pghw5Lz6Zwu/6+k/o6L0wSLkD4/mtVEYEVfm
	 lstL035zUWr3RLjFRdVXQUav52JYv/sDUDGZUQ7bnIS0w1Cxon9AFl7LHBnZe8DE+qmcp
	 9FN8o/XdUftSsbSo27ZszQN5bBByJUttSKtbk3wiHVBGX7KtRtbdSy8mmpIpUHpdEwlnE
	 NgCZayc4E/tbMOy+Susb4Bze0AxM6i4hpKyOqOHGLQ5NzKutBr2KQx1YLpciqd9Ua9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R4QO+zrk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EBA606A31C;
	Wed, 28 Oct 2026 19:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R4QO+zrk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748FF1F01825;
	Wed, 28 Oct 2026 19:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216931;
	bh=Plr930Ce/7avlWWl1wHMnBag/NM61EFboXMq3A6CAm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4QO+zrknCgY8DyzpFdd3Pz/qjSQh4QQJqA/Wz6yisSKsO9bseT77F6W3ERfX0o7/
	 calWhTky4y74bN7NfnxJfgghRlNu2wdPYhSMOryibZKDAsJ0y0V5sb+ONen+45/3UF
	 1GVkQKQuWcdOc9GuR7yDcgdUpzTObD64TiFGZ3D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1728/1887] gpio: mxc: fix both_edges bit operations
Date: Wed, 28 Oct 2026 18:03:44 +0100
Message-ID: <20261028170538.778908948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit b7719c575dec69146f6d537fd616b27083c0cf45 ]

gpio_set_irq_type() can be called concurrently for different pins on
the same port.  The IRQ core serializes per irq descriptor, but
different pins have different descriptors, so on SMP systems two
concurrent gpio_set_irq_type() calls for pins on the same port run
without mutual exclusion.

The read-modify-write of port->both_edges is performed outside the
port-wide scoped_guard(gpio_generic_lock_irqsave) section, so
concurrent updates for different pins can overwrite each other,
causing missed interrupts or stuck IRQ lines on dual-edge triggered
pins.

The original uniprocessor MXC SoCs were not affected; the race
became reachable on multi-core i.MX7 and i.MX8 SoCs that reuse this
driver.

Convert both_edges from u32 to unsigned long and use set_bit(),
clear_bit(), and test_bit() to make the modifications atomic.

Fixes: 910862ec092c ("mxc: emulate GPIO interrupt on both-edges")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20261013-gpio-mxc-cleanup-v7-2-c4d769587d3e@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index b12d693cdd305..403aee6174034 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -7,6 +7,7 @@
 // Authors: Daniel Mack, Juergen Beisert.
 // Copyright (C) 2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
 
+#include <linux/bitops.h>
 #include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/err.h>
@@ -66,7 +67,7 @@ struct mxc_gpio_port {
 	struct irq_domain *domain;
 	struct gpio_chip gc;
 	struct device *dev;
-	u32 both_edges;
+	unsigned long both_edges;
 	struct mxc_gpio_reg_saved gpio_saved_reg;
 	bool power_off;
 	u32 wakeup_pads;
@@ -166,7 +167,7 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 	int edge;
 	void __iomem *reg = port->base;
 
-	port->both_edges &= ~(1 << gpio_idx);
+	clear_bit(gpio_idx, &port->both_edges);
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
 		edge = GPIO_INT_RISE_EDGE;
@@ -186,7 +187,7 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 				edge = GPIO_INT_HIGH_LEV;
 				pr_debug("mxc: set GPIO %d to high trigger\n", gpio_idx);
 			}
-			port->both_edges |= 1 << gpio_idx;
+			set_bit(gpio_idx, &port->both_edges);
 		}
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
@@ -257,7 +258,7 @@ static void mxc_gpio_irq_handler(struct mxc_gpio_port *port, u32 irq_stat)
 	while (irq_stat != 0) {
 		int irqoffset = fls(irq_stat) - 1;
 
-		if (port->both_edges & (1 << irqoffset))
+		if (test_bit(irqoffset, &port->both_edges))
 			mxc_flip_edge(port, irqoffset);
 
 		generic_handle_domain_irq(port->domain, irqoffset);
-- 
2.53.0



