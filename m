Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBE815B10D;
	Mon, 28 Oct 2024 06:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097378; cv=none; b=WOVYDiHVX6jTPXoL/Mke4fQH43w9dBn8kgb6GzUio9fwyYqdaAoNYrKVGAwhpMivnDx1Q9SYKs4/5IH2USnM1CE5PBEx+pxK6YMIyiIwAinln1sPZ2EBp+knorO2r+dbf7VFyre7xgeIzin60klQdvou7co3TW2OnBdR+OEAlis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097378; c=relaxed/simple;
	bh=cN4sYPa8hUgVdF1/VRTh+rqa2ID8sAboKJjkjMI5eg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XZMjNgTwwAH/Svoq50I9iO58kBk+cOi+G/FLL4WX/311BoUNhIePoKPsPuBIP/SDfNPgFZoJAxt22Mm55eevZTtiUqsqDWwL4ug3iRrToBX3D4zVw0uxlPXcIF0aMT9fUUwTGbEnywZ40P4MqKXCyukPocpu4pCDHVfbyzn0roQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVtxj/tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVtxj/tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5CEC4CEC3;
	Mon, 28 Oct 2024 06:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097378;
	bh=cN4sYPa8hUgVdF1/VRTh+rqa2ID8sAboKJjkjMI5eg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVtxj/tf418vH87ZNV9PNpop3R36sPJTeVJnO+z2U0YSLmF5LxtVmcm6QEk2Fj1ed
	 0T77WF2sdW4DIvCyfL+afQwOnEEsVLymxWd81h+WfYAZxw9qAoC30JzuawwSaqvH2U
	 zWxyu6Gd9P4yHcCUUfOs1rLz5OW7sjbINyoJVawA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodolfo Giometti <giometti@enneenne.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/137] tty/serial: Make ->dcd_change()+uart_handle_dcd_change() status bool active
Date: Mon, 28 Oct 2024 07:25:05 +0100
Message-ID: <20241028062300.638911047@linuxfoundation.org>
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

[ Upstream commit 0388a152fc5544be82e736343496f99c4eef8d62 ]

Convert status parameter for ->dcd_change() and
uart_handle_dcd_change() to bool which matches to how the parameter is
used.

Rename status to active to better describe what the parameter means.

Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230117090358.4796-9-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 40d7903386df ("serial: imx: Update mctrl old_status on RTSD interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps-ldisc.c  | 6 +++---
 drivers/tty/serial/serial_core.c | 8 ++++----
 drivers/tty/serial/sunhv.c       | 8 ++++----
 include/linux/serial_core.h      | 3 +--
 include/linux/tty_ldisc.h        | 4 ++--
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index d73c4c2ed4e13..443d6bae19d14 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -13,7 +13,7 @@
 #include <linux/pps_kernel.h>
 #include <linux/bug.h>
 
-static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status)
+static void pps_tty_dcd_change(struct tty_struct *tty, bool active)
 {
 	struct pps_device *pps;
 	struct pps_event_time ts;
@@ -29,11 +29,11 @@ static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status)
 		return;
 
 	/* Now do the PPS event report */
-	pps_event(pps, &ts, status ? PPS_CAPTUREASSERT :
+	pps_event(pps, &ts, active ? PPS_CAPTUREASSERT :
 			PPS_CAPTURECLEAR, NULL);
 
 	dev_dbg(pps->dev, "PPS %s at %lu\n",
-			status ? "assert" : "clear", jiffies);
+			active ? "assert" : "clear", jiffies);
 }
 
 static int (*alias_n_tty_open)(struct tty_struct *tty);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 58e857fb8deeb..e6994f40974ed 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3290,11 +3290,11 @@ EXPORT_SYMBOL(uart_match_port);
 /**
  * uart_handle_dcd_change - handle a change of carrier detect state
  * @uport: uart_port structure for the open port
- * @status: new carrier detect status, nonzero if active
+ * @active: new carrier detect status
  *
  * Caller must hold uport->lock.
  */
-void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
+void uart_handle_dcd_change(struct uart_port *uport, bool active)
 {
 	struct tty_port *port = &uport->state->port;
 	struct tty_struct *tty = port->tty;
@@ -3306,7 +3306,7 @@ void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 		ld = tty_ldisc_ref(tty);
 		if (ld) {
 			if (ld->ops->dcd_change)
-				ld->ops->dcd_change(tty, status);
+				ld->ops->dcd_change(tty, active);
 			tty_ldisc_deref(ld);
 		}
 	}
@@ -3314,7 +3314,7 @@ void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 	uport->icount.dcd++;
 
 	if (uart_dcd_enabled(uport)) {
-		if (status)
+		if (active)
 			wake_up_interruptible(&port->open_wait);
 		else if (tty)
 			tty_hangup(tty);
diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index 1938ba5e98c0e..f0408a4d91ecf 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -89,10 +89,10 @@ static int receive_chars_getchar(struct uart_port *port)
 
 		if (c == CON_HUP) {
 			hung_up = 1;
-			uart_handle_dcd_change(port, 0);
+			uart_handle_dcd_change(port, false);
 		} else if (hung_up) {
 			hung_up = 0;
-			uart_handle_dcd_change(port, 1);
+			uart_handle_dcd_change(port, true);
 		}
 
 		if (port->state == NULL) {
@@ -135,7 +135,7 @@ static int receive_chars_read(struct uart_port *port)
 				bytes_read = 1;
 			} else if (stat == CON_HUP) {
 				hung_up = 1;
-				uart_handle_dcd_change(port, 0);
+				uart_handle_dcd_change(port, false);
 				continue;
 			} else {
 				/* HV_EWOULDBLOCK, etc.  */
@@ -145,7 +145,7 @@ static int receive_chars_read(struct uart_port *port)
 
 		if (hung_up) {
 			hung_up = 0;
-			uart_handle_dcd_change(port, 1);
+			uart_handle_dcd_change(port, true);
 		}
 
 		if (port->sysrq != 0 &&  *con_read_page) {
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 1c9b3f27f2d36..9b6d91430d3b3 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -890,8 +890,7 @@ static inline bool uart_softcts_mode(struct uart_port *uport)
  * The following are helper functions for the low level drivers.
  */
 
-extern void uart_handle_dcd_change(struct uart_port *uport,
-		unsigned int status);
+extern void uart_handle_dcd_change(struct uart_port *uport, bool active);
 extern void uart_handle_cts_change(struct uart_port *uport,
 		unsigned int status);
 
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index dcb61ec11424a..49dc172dedc7f 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -170,7 +170,7 @@ int ldsem_down_write_nested(struct ld_semaphore *sem, int subclass,
  *	send, please arise a tasklet or workqueue to do the real data transfer.
  *	Do not send data in this hook, it may lead to a deadlock.
  *
- * @dcd_change: [DRV] ``void ()(struct tty_struct *tty, unsigned int status)``
+ * @dcd_change: [DRV] ``void ()(struct tty_struct *tty, bool active)``
  *
  *	Tells the discipline that the DCD pin has changed its status. Used
  *	exclusively by the %N_PPS (Pulse-Per-Second) line discipline.
@@ -238,7 +238,7 @@ struct tty_ldisc_ops {
 	void	(*receive_buf)(struct tty_struct *tty, const unsigned char *cp,
 			       const char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *tty);
-	void	(*dcd_change)(struct tty_struct *tty, unsigned int status);
+	void	(*dcd_change)(struct tty_struct *tty, bool active);
 	int	(*receive_buf2)(struct tty_struct *tty, const unsigned char *cp,
 				const char *fp, int count);
 	void	(*lookahead_buf)(struct tty_struct *tty, const unsigned char *cp,
-- 
2.43.0



