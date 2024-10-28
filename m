Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0318E020;
	Mon, 28 Oct 2024 06:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097380; cv=none; b=QdXfMOhY3hAeyNNF5QKZVWcsS+gg2LHHutmz78r7S6ud8WW/+LyfusZJ7zB/p8sQyzWekrvGpQe8ZZu+HO9Cd+AYnR8L0zbjOV6uQyMtKxvGKw8fOTSN/Jd6499lx80cOOSsyNHO7WPoS6w+ptCNu6JGvFedYZxl2dMlJqU0XsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097380; c=relaxed/simple;
	bh=WSdh1xix/A0LF8GLemrcs2ZqA6G2PFO7eyCWXanD2QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uHVqYHTdNt7Ldm7y/ZkFnSyxBb6EMF9FfxQfFgBskKQbnPK91EUYu2m7f7BsyZ0IGlngktu76IJuf2w8+U4fCZQ6dtBSnilvxBnv4xt7TqNAXK6sEzFo/3Sy9+WfrkRji6JlPf+9g34ZjLVSstPHq6ouw/UZXBR8/USA5lgaINg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTUQ+ntc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTUQ+ntc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2783AC4CEC3;
	Mon, 28 Oct 2024 06:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097380;
	bh=WSdh1xix/A0LF8GLemrcs2ZqA6G2PFO7eyCWXanD2QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTUQ+ntcIt6O1k3rjSvhh8Q6fOR4u7Bbo9XD34puzeYO8JrBV+I75rkQrn+mmHHNd
	 8fF1PJLY6eldJXTsxKP/sBkVtCoA10EhsmPsl0rYtFYiVOzhDq79hWXUfsW+6FolJJ
	 iXcgrEW2/1mR+rzegOpZy7frvuqzaSPiTD65yzOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/137] serial: Make uart_handle_cts_change() status param bool active
Date: Mon, 28 Oct 2024 07:25:06 +0100
Message-ID: <20241028062300.667333867@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 968d64578ec92968e8c79d766eb966efd1f68d7e ]

Convert uart_handle_cts_change() to bool which is more appropriate
than unsigned int.

Rename status to active to better describe what the parameter means.
While at it, make the comment about the active parameter easier to
parse.

Cleanup callsites from operations that are not necessary with bool.

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230117090358.4796-10-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 40d7903386df ("serial: imx: Update mctrl old_status on RTSD interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c         | 2 +-
 drivers/tty/serial/max3100.c     | 2 +-
 drivers/tty/serial/max310x.c     | 3 +--
 drivers/tty/serial/serial_core.c | 8 ++++----
 include/linux/serial_core.h      | 3 +--
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 5acbab0512b82..bba54ad0d434d 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -801,7 +801,7 @@ static irqreturn_t __imx_uart_rtsint(int irq, void *dev_id)
 
 	imx_uart_writel(sport, USR1_RTSD, USR1);
 	usr1 = imx_uart_readl(sport, USR1) & USR1_RTSS;
-	uart_handle_cts_change(&sport->port, !!usr1);
+	uart_handle_cts_change(&sport->port, usr1);
 	wake_up_interruptible(&sport->port.state->port.delta_msr_wait);
 
 	return IRQ_HANDLED;
diff --git a/drivers/tty/serial/max3100.c b/drivers/tty/serial/max3100.c
index 5d8660fed081e..67803242a70c2 100644
--- a/drivers/tty/serial/max3100.c
+++ b/drivers/tty/serial/max3100.c
@@ -250,7 +250,7 @@ static int max3100_handlerx_unlocked(struct max3100_port *s, u16 rx)
 	cts = (rx & MAX3100_CTS) > 0;
 	if (s->cts != cts) {
 		s->cts = cts;
-		uart_handle_cts_change(&s->port, cts ? TIOCM_CTS : 0);
+		uart_handle_cts_change(&s->port, cts);
 	}
 
 	return ret;
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index d409ef3887212..4eb8d372f619f 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -843,8 +843,7 @@ static irqreturn_t max310x_port_irq(struct max310x_port *s, int portno)
 
 		if (ists & MAX310X_IRQ_CTS_BIT) {
 			lsr = max310x_port_read(port, MAX310X_LSR_IRQSTS_REG);
-			uart_handle_cts_change(port,
-					       !!(lsr & MAX310X_LSR_CTS_BIT));
+			uart_handle_cts_change(port, lsr & MAX310X_LSR_CTS_BIT);
 		}
 		if (rxlen)
 			max310x_handle_rx(port, rxlen);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index e6994f40974ed..c91e3195dc207 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3325,11 +3325,11 @@ EXPORT_SYMBOL_GPL(uart_handle_dcd_change);
 /**
  * uart_handle_cts_change - handle a change of clear-to-send state
  * @uport: uart_port structure for the open port
- * @status: new clear to send status, nonzero if active
+ * @active: new clear-to-send status
  *
  * Caller must hold uport->lock.
  */
-void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
+void uart_handle_cts_change(struct uart_port *uport, bool active)
 {
 	lockdep_assert_held_once(&uport->lock);
 
@@ -3337,13 +3337,13 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
 
 	if (uart_softcts_mode(uport)) {
 		if (uport->hw_stopped) {
-			if (status) {
+			if (active) {
 				uport->hw_stopped = 0;
 				uport->ops->start_tx(uport);
 				uart_write_wakeup(uport);
 			}
 		} else {
-			if (!status) {
+			if (!active) {
 				uport->hw_stopped = 1;
 				uport->ops->stop_tx(uport);
 			}
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 9b6d91430d3b3..5a83db0ac7639 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -891,8 +891,7 @@ static inline bool uart_softcts_mode(struct uart_port *uport)
  */
 
 extern void uart_handle_dcd_change(struct uart_port *uport, bool active);
-extern void uart_handle_cts_change(struct uart_port *uport,
-		unsigned int status);
+extern void uart_handle_cts_change(struct uart_port *uport, bool active);
 
 extern void uart_insert_char(struct uart_port *port, unsigned int status,
 		 unsigned int overrun, unsigned int ch, unsigned int flag);
-- 
2.43.0



