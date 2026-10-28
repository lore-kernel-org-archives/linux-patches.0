Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216940;
	b=agCdAj3d/0aX0XjfbB7X/1ruNGEF/+SFOuJB+yUlu1riedUe06bxUsFs8rZAA0dx9UJ9
	 iEpEY7vqgrqOdpTbPjl5uB07jDyjKv2ppGJNjpzQbENd0JXoZOOyoDPuAH5SSeGWgtRU3
	 oPRuMCIwgrUEx/7pPTJ9TX8BovsE2/K2P9QHKsJ/oG5TXTe4BB/WNk0jFYXWAN5eus6oK
	 QSE5WdVBcom0C13lbGtkabxY25PYsw3qMc+B6Psw7OVYl651vx51/JFhaYb7YPgV0miJe
	 rAu7NliD1bWasPwmXtxS5JLET3/tLuHJcUeUhq76s1UnmVr6OTd8Os4NXxJkxj+x17w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MbIqIUPRwu2vCOyRM1Nx6lw0d2oVUMP/EFDNEe8CIEY=;
	b=uNH2po4/BVLSU+sfc0IKUL1Pr81blFNWYhipACrqIRaysTAxAhxttUsg2nws1NUVgZJE
	 mO+mv/IzCmqOjxeIMgJhoy1B/jHRe1ZgRZ/ZxGJ9zGZ/xypBHm37HOelnXzUviPnsb0sV
	 +4CtW0pLSK+hlT9VnLEG5x5+fvbb32rBH7JsmmLBKxKkkUj38hyHaCkHrXktciGYcpiiG
	 CRZ6t8xdU+3IPDlmsXtC6RqcxIW+oXMrGSAZuXwPTUuGSfFrlnL6WX/nn2erHF8qero4Y
	 zmja1RPYdcmR/24qCzm2RM4c322hXiOhSKWztcLDX14y5rDxMI5Vsklu4/TPM3pzzlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQm7RCJa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71C3606A324;
	Wed, 28 Oct 2026 19:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQm7RCJa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A901F01825;
	Wed, 28 Oct 2026 19:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216939;
	bh=MbIqIUPRwu2vCOyRM1Nx6lw0d2oVUMP/EFDNEe8CIEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQm7RCJacR6tVO9z+856V4wRnze1bQ7oO+x2ZPDNSA+mWyeSavi4xTL/wPHdYupXv
	 ee6RLBTShtUH9pQftR/mGX98yNZcyYQFpqun2cqazOdj/8hLhaJvNFPCzX4roxavkp
	 488A2SRa3VdX3a3P6ZJu25xFORgfqhxs8d0uNXWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1730/1887] gpio: mxc: fix wakeup_pads bit operations
Date: Wed, 28 Oct 2026 18:03:46 +0100
Message-ID: <20261028170538.823529571@linuxfoundation.org>
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

[ Upstream commit 170aeff46fb54f41545c85a72aec525aebc79d44 ]

gpio_set_wake_irq() can be called concurrently for different pins on
the same port. The writer-vs-writer race is the concern: two concurrent
gpio_set_wake_irq() calls for different pins on the same port both do
a non-atomic read-modify-write on the same wakeup_pads word. The old
|= and &= compile to separate load/modify/store instructions that can
interleave, losing one CPU's update.

assign_bit() uses an atomic RMW instruction, so concurrent writers to
different bits in the same word are safe.

The reader side (for_each_set_bit in noirq_suspend, wakeup_pads > 0)
runs in noirq context where no concurrent writer can execute, so
reader atomicity is not needed.

wakeup_pads is a u32, while assign_bit() operates on unsigned long
pointers. On 64-bit platforms, this causes an 8-byte read-modify-write
on a 4-byte field, corrupting the adjacent is_pad_wakeup. So change
wakeup_pads to unsigned long and reorder to avoid wasting words.

And fix the enable/disable path unconditionally sets/clears the
wakeup_pads bit even when enable_irq_wake()/disable_irq_wake() fails.
Only update the bit on success.

Fixes: f60c9eac54af ("gpio: mxc: enable pad wakeup on i.MX8x platforms")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20261013-gpio-mxc-cleanup-v7-3-c4d769587d3e@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index c6e8c0d35723e..36dcd082ef893 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -70,8 +70,8 @@ struct mxc_gpio_port {
 	unsigned long both_edges;
 	struct mxc_gpio_reg_saved gpio_saved_reg;
 	bool power_off;
-	u32 wakeup_pads;
 	bool is_pad_wakeup;
+	unsigned long wakeup_pads;
 	u32 pad_type[32];
 	const struct mxc_gpio_hwdata *hwdata;
 };
@@ -329,16 +329,18 @@ static int gpio_set_wake_irq(struct irq_data *d, u32 enable)
 			ret = enable_irq_wake(port->irq_high);
 		else
 			ret = enable_irq_wake(port->irq);
-		port->wakeup_pads |= BIT(gpio_idx);
 	} else {
 		if (port->irq_high && (gpio_idx >= 16))
 			ret = disable_irq_wake(port->irq_high);
 		else
 			ret = disable_irq_wake(port->irq);
-		port->wakeup_pads &= ~BIT(gpio_idx);
 	}
+	if (ret)
+		return ret;
 
-	return ret;
+	assign_bit(gpio_idx, &port->wakeup_pads, enable);
+
+	return 0;
 }
 
 static int mxc_gpio_init_gc(struct mxc_gpio_port *port, int irq_base)
-- 
2.53.0



