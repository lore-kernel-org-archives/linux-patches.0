Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734023563C6;
	Wed,  3 Dec 2025 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778662; cv=none; b=JeL5EWP52DdBFP5n3fdZCDeqgzb81oZyJXvdz2atRiCOsnQUAwOokRtArUEsj6jXuJdKrzLdTOQnbSI2Bzh9NcsCVB+zFQRdISmVuTx0T78a0kXVXiaENVVebfRXRCQaJQPIzaozka9xFumFTPX+nVlgch5aJUOjrPh0vLXGlLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778662; c=relaxed/simple;
	bh=l8UMMvVfv573I8JVw8y1t6zCoIEZ2dYvCluhqJs38NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDIhl1cQ5qk0cBd4Jn/mxHm+qrQt87E59E0av3m1/kq6MxnkpudrOMndru46e+eWMxZDG20y99Fjnm//pzM0MDCXp2l6DNiSIf81KlsMV8TPmOObkYvtblO4qVYc8ghmuHjrb1PF5arUa9ig7NiPoa434hRvSh2OE+ziNU4hN7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJnCjlKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJnCjlKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A2AC4CEF5;
	Wed,  3 Dec 2025 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778662;
	bh=l8UMMvVfv573I8JVw8y1t6zCoIEZ2dYvCluhqJs38NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJnCjlKaB/sQwbhaXSfJ83Q0bQIhrGTU6kRF7oYiM3LP4HsFxa9FMgPxfWasVP7FE
	 GeM7MuTn35ocr3BZLoZwMYI4Vdo+WJFY+pP3yZ+ilhdOnpuiGxt8qiapPk2WJhwUhN
	 PuOig3Qmb6t7gBThpQZz3rGMjyQ4y1CgwgQht11E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/568] serial: sc16is7xx: reorder code to remove prototype declarations
Date: Wed,  3 Dec 2025 16:20:23 +0100
Message-ID: <20251203152441.439961744@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 2de8a1b46756b5a79d8447f99afdfe49e914225a ]

Move/reorder some functions to remove sc16is7xx_ier_set() and
sc16is7xx_stop_tx() prototypes declarations.

No functional change.

sc16is7xx_ier_set() was introduced in
commit cc4c1d05eb10 ("sc16is7xx: Properly resume TX after stop").

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-16-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c05bf6c0262 ("serial: sc16is7xx: remove useless enable of enhanced features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   75 +++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -355,9 +355,6 @@ static struct uart_driver sc16is7xx_uart
 	.nr		= SC16IS7XX_MAX_DEVS,
 };
 
-static void sc16is7xx_ier_set(struct uart_port *port, u8 bit);
-static void sc16is7xx_stop_tx(struct uart_port *port);
-
 #define to_sc16is7xx_one(p,e)	((container_of((p), struct sc16is7xx_one, e)))
 
 static u8 sc16is7xx_port_read(struct uart_port *port, u8 reg)
@@ -415,6 +412,42 @@ static void sc16is7xx_power(struct uart_
 			      on ? 0 : SC16IS7XX_IER_SLEEP_BIT);
 }
 
+static void sc16is7xx_ier_clear(struct uart_port *port, u8 bit)
+{
+	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
+
+	lockdep_assert_held_once(&port->lock);
+
+	one->config.flags |= SC16IS7XX_RECONF_IER;
+	one->config.ier_mask |= bit;
+	one->config.ier_val &= ~bit;
+	kthread_queue_work(&s->kworker, &one->reg_work);
+}
+
+static void sc16is7xx_ier_set(struct uart_port *port, u8 bit)
+{
+	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
+
+	lockdep_assert_held_once(&port->lock);
+
+	one->config.flags |= SC16IS7XX_RECONF_IER;
+	one->config.ier_mask |= bit;
+	one->config.ier_val |= bit;
+	kthread_queue_work(&s->kworker, &one->reg_work);
+}
+
+static void sc16is7xx_stop_tx(struct uart_port *port)
+{
+	sc16is7xx_ier_clear(port, SC16IS7XX_IER_THRI_BIT);
+}
+
+static void sc16is7xx_stop_rx(struct uart_port *port)
+{
+	sc16is7xx_ier_clear(port, SC16IS7XX_IER_RDI_BIT);
+}
+
 static const struct sc16is7xx_devtype sc16is74x_devtype = {
 	.name		= "SC16IS74X",
 	.nr_gpio	= 0,
@@ -891,42 +924,6 @@ static void sc16is7xx_reg_proc(struct kt
 		sc16is7xx_reconf_rs485(&one->port);
 }
 
-static void sc16is7xx_ier_clear(struct uart_port *port, u8 bit)
-{
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
-	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
-
-	lockdep_assert_held_once(&port->lock);
-
-	one->config.flags |= SC16IS7XX_RECONF_IER;
-	one->config.ier_mask |= bit;
-	one->config.ier_val &= ~bit;
-	kthread_queue_work(&s->kworker, &one->reg_work);
-}
-
-static void sc16is7xx_ier_set(struct uart_port *port, u8 bit)
-{
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
-	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
-
-	lockdep_assert_held_once(&port->lock);
-
-	one->config.flags |= SC16IS7XX_RECONF_IER;
-	one->config.ier_mask |= bit;
-	one->config.ier_val |= bit;
-	kthread_queue_work(&s->kworker, &one->reg_work);
-}
-
-static void sc16is7xx_stop_tx(struct uart_port *port)
-{
-	sc16is7xx_ier_clear(port, SC16IS7XX_IER_THRI_BIT);
-}
-
-static void sc16is7xx_stop_rx(struct uart_port *port)
-{
-	sc16is7xx_ier_clear(port, SC16IS7XX_IER_RDI_BIT);
-}
-
 static void sc16is7xx_ms_proc(struct kthread_work *ws)
 {
 	struct sc16is7xx_one *one = to_sc16is7xx_one(ws, ms_work.work);


