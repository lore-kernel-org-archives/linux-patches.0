Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623544;
	b=QdssWueXO4r0q5/CrFDcrJ79rlczPpCbTAkx0TfysGs7ZRpftjN/CIrjV/j9FFZ56/9m
	 2fDnMsNoXSKwc6e/EbPK17junJ4xqITQ/m5DE85wAs/KL3+DwU/c1RuWflAqgCEB2LdAf
	 TwPKEIOVMglfwtZskIUyydi+Es+/LbdCYOPIKeMOikaqa4soB/bS670T2UYDFvHPdf4ko
	 2MrcR1LMCHcg/Z0kSWaR9sV0mNnnH1rimlnWLwcKCXdWK/FKUcWyLfjvwFUAaiVa3ylLC
	 euKr0hqUUPGr4WVoyw1nYFJuUZXEAqh3BtfoIybb85DX+Bttv4+wwGo5DjG53WurWjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tjgj5IxDv2iO6LRGxQMOaRrizACFWbCE15KGz3L5mvs=;
	b=osrhH7Haky1nwCoZmyKfo/5XnZE7loHbbT9UXYt0vl8pEq8aXHTLFPLnB4n7W+/PCbfU
	 taBw+BH3fCFuRBpteBCIIyxJ/YHg1Sjgr7FvdakrTYV9tyxJFXUJDTFKPDTHrtdamos3i
	 WhWUEyJIGOzHFUeeR4BfulQCH0KQQJuy1aW6tEEyg5kLR3mazm+XH1aLnrPPXJlldmXxU
	 Mb6GuhonNJLOtHOcig5we+RDbelMqGnzgL3A/gCY3xS+Knq0ehKzOocfx5vCM3NETl1Lt
	 0o3uyLhYkbGtHUasLgICfzGbqzqbyS94skvFbWAMM/9fTDavhzObPp1FNFfrqNF20bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkx86yCu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A52606A326;
	Wed, 25 Nov 2026 16:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkx86yCu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010D91F000C6;
	Wed, 25 Nov 2026 16:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623543;
	bh=tjgj5IxDv2iO6LRGxQMOaRrizACFWbCE15KGz3L5mvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkx86yCu+ikV3lTC8EXGJdd8rc/LjTHkl9dXonwQ+XiT17M+5zTt1X0QUu5FF6JRU
	 lqqsRmY7Z3RKMoIrWOg2f5ARTNNwsnvtJ4vlCBQ7BdBFkBZ20A4t7V03fmerO4OFaQ
	 dNk9moTKS2FRK9873S/i19t9vaLtxbiv6HBHnb6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Johan Hovold <johan@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	John Ogness <john.ogness@linutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 895/990] serial: core: respect runtime PM when sending x_char
Date: Wed, 25 Nov 2026 15:37:42 +0100
Message-ID: <20261125143842.975793715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 84da8238f7bd3025fc16da32c4cd9992c95a783b upstream.

__uart_start() calls the start_tx operation only if the port is runtime
active.  Otherwise it asks for a resume, and
serial_port_runtime_resume() starts the transmitter.

uart_send_xchar() calls start_tx at once, under the port lock, whatever
the state of the device.  With 8250_omap, serial8250_start_tx() then
calls pm_runtime_get_sync() for a suspended device: that sleeps, and
omap8250_runtime_resume() takes the port lock again.  A tcflow(TCIOFF)
on an idle port is enough, if autosuspend has been enabled.  It was
allowed as long as that driver used pm_runtime_irq_safe().

Share the part of __uart_start() that deals with runtime PM.  A stopped
transmission still does not hold up an XON or XOFF character.  Let a
pending x_char count as work for serial_port_runtime_resume(), and keep
the port from being suspended with it.

Fixes: 8700a7ea5519 ("serial: 8250_omap: Drop pm_runtime_irq_safe()")
Cc: stable <stable@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: "Uwe Kleine-König (The Capable Hub)" <u.kleine-koenig@baylibre.com>
Cc: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-2-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   25 +++++++++++++++----------
 drivers/tty/serial/serial_port.c |    4 ++--
 2 files changed, 17 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -135,17 +135,11 @@ static void uart_stop(struct tty_struct
 	uart_port_unlock_deref(port, flags);
 }
 
-static void __uart_start(struct uart_state *state)
+static void uart_port_start_tx(struct uart_port *port)
 {
-	struct uart_port *port = state->uart_port;
-	struct serial_port_device *port_dev;
+	struct serial_port_device *port_dev = port->port_dev;
 	int err;
 
-	if (!port || port->flags & UPF_DEAD || uart_tx_stopped(port))
-		return;
-
-	port_dev = port->port_dev;
-
 	/* Increment the runtime PM usage count for the active check below */
 	err = pm_runtime_get(&port_dev->dev);
 	if (err < 0 && err != -EINPROGRESS) {
@@ -164,6 +158,16 @@ static void __uart_start(struct uart_sta
 	pm_runtime_put_autosuspend(&port_dev->dev);
 }
 
+static void __uart_start(struct uart_state *state)
+{
+	struct uart_port *port = state->uart_port;
+
+	if (!port || port->flags & UPF_DEAD || uart_tx_stopped(port))
+		return;
+
+	uart_port_start_tx(port);
+}
+
 static void uart_start(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
@@ -722,8 +726,9 @@ static void uart_send_xchar(struct tty_s
 	else {
 		guard(uart_port_lock_irqsave)(port);
 		port->x_char = ch;
-		if (ch)
-			port->ops->start_tx(port);
+		/* It goes out even if the transmission is stopped */
+		if (ch && !(port->flags & UPF_DEAD))
+			uart_port_start_tx(port);
 	}
 	uart_port_deref(port);
 }
--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -23,8 +23,8 @@
 /* Only considers pending TX for now. Caller must take care of locking */
 static int __serial_port_busy(struct uart_port *port)
 {
-	return !uart_tx_stopped(port) &&
-		!kfifo_is_empty(&port->state->port.xmit_fifo);
+	return port->x_char || (!uart_tx_stopped(port) &&
+		!kfifo_is_empty(&port->state->port.xmit_fifo));
 }
 
 static int serial_port_runtime_resume(struct device *dev)


