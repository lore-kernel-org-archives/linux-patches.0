Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83AF32BF21;
	Fri,  9 Jan 2026 12:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963189; cv=none; b=hM/MNZvaQ/48O5EWQ17Cdtd9D9k8d6aafBNLYOdBXkg8blzF9WwIpiCHS/jyppy9UlxpS/CgIFvIXJz/kHWGZgqLqa+F9loIheDsFDcDKEPLpIiMlihuXv+3wUSnq4EG6TWrl8OvsE38gVhMZyVybyY/RVh45yJxDEzHCyaoQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963189; c=relaxed/simple;
	bh=uK6ina17OTw/6aFSJhJq274+LurH+IgvY/YYW6JoM0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ccWLoNfcplkgs+v7q2vnx9tX9yAP6FHe7OzhDs57fLc2eXeFcp3HEPN5TiaEwBeESBHfE0Z5GqUqpuhcRmk1x0RzuTr+8PguiLN6IvT9J2UlRr8qL3+LwvbxPtK5GwKpsQAmc8cUpokwHzv60nsSnuSi4t4Gn0510WxmwU7M24Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xXdieh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xXdieh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572F4C4CEF1;
	Fri,  9 Jan 2026 12:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963189;
	bh=uK6ina17OTw/6aFSJhJq274+LurH+IgvY/YYW6JoM0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xXdieh6RiltOkeaiMnhKrrEJ2IjRmL7hpIkQy2iZPS7zYWgq/wSkiIV6AUJGUpPf
	 GYI47bK1txnJgGOL+oT0M6kMEe4UcouJunGZCT3qpSeXNXh7pEePYyrciUx2Ts3wMC
	 6xxxhYaDoJKlOYRUsgaeKHdJja2bgv4i6cupVEXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 596/634] serial: Make uart_remove_one_port() return void
Date: Fri,  9 Jan 2026 12:44:34 +0100
Message-ID: <20260109112140.054132473@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit d5b3d02d0b107345f2a6ecb5b06f98356f5c97ab ]

The return value is only ever used as a return value for remove callbacks
of platform drivers. This return value is ignored by the driver core.
(The only effect is an error message, but uart_remove_one_port() already
emitted one in this case.)

So the return value isn't used at all and uart_remove_one_port() can be
changed to return void without any loss. Also this better matches the
Linux device model as remove functions are not supposed to fail.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230512173810.131447-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 74098cc06e75 ("xhci: dbgtty: fix device unregister: fixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c           |    5 ++---
 drivers/tty/serial/clps711x.c               |    4 +++-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    5 ++++-
 drivers/tty/serial/imx.c                    |    4 +++-
 drivers/tty/serial/lantiq.c                 |    4 +++-
 drivers/tty/serial/serial_core.c            |    6 +-----
 drivers/tty/serial/st-asc.c                 |    4 +++-
 drivers/tty/serial/uartlite.c               |   12 ++++--------
 drivers/tty/serial/xilinx_uartps.c          |    5 ++---
 include/linux/serial_core.h                 |    2 +-
 10 files changed, 26 insertions(+), 25 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -3022,14 +3022,13 @@ static int atmel_serial_remove(struct pl
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
-	int ret = 0;
 
 	tasklet_kill(&atmel_port->tasklet_rx);
 	tasklet_kill(&atmel_port->tasklet_tx);
 
 	device_init_wakeup(&pdev->dev, 0);
 
-	ret = uart_remove_one_port(&atmel_uart, port);
+	uart_remove_one_port(&atmel_uart, port);
 
 	kfree(atmel_port->rx_ring.buf);
 
@@ -3039,7 +3038,7 @@ static int atmel_serial_remove(struct pl
 
 	pdev->dev.of_node = NULL;
 
-	return ret;
+	return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(atmel_serial_pm_ops, atmel_serial_suspend,
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -515,7 +515,9 @@ static int uart_clps711x_remove(struct p
 {
 	struct clps711x_port *s = platform_get_drvdata(pdev);
 
-	return uart_remove_one_port(&clps711x_uart, &s->port);
+	uart_remove_one_port(&clps711x_uart, &s->port);
+
+	return 0;
 }
 
 static const struct of_device_id __maybe_unused clps711x_uart_dt_ids[] = {
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1428,7 +1428,10 @@ static int cpm_uart_probe(struct platfor
 static int cpm_uart_remove(struct platform_device *ofdev)
 {
 	struct uart_cpm_port *pinfo = platform_get_drvdata(ofdev);
-	return uart_remove_one_port(&cpm_reg, &pinfo->port);
+
+	uart_remove_one_port(&cpm_reg, &pinfo->port);
+
+	return 0;
 }
 
 static const struct of_device_id cpm_uart_match[] = {
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2538,7 +2538,9 @@ static int imx_uart_remove(struct platfo
 {
 	struct imx_port *sport = platform_get_drvdata(pdev);
 
-	return uart_remove_one_port(&imx_uart_uart_driver, &sport->port);
+	uart_remove_one_port(&imx_uart_uart_driver, &sport->port);
+
+	return 0;
 }
 
 static void imx_uart_restore_context(struct imx_port *sport)
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -918,7 +918,9 @@ static int lqasc_remove(struct platform_
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
 
-	return uart_remove_one_port(&lqasc_reg, port);
+	uart_remove_one_port(&lqasc_reg, port);
+
+	return 0;
 }
 
 static const struct ltq_soc_data soc_data_lantiq = {
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3186,13 +3186,12 @@ EXPORT_SYMBOL(uart_add_one_port);
  * This unhooks (and hangs up) the specified port structure from the core
  * driver. No further calls will be made to the low-level code for this port.
  */
-int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
+void uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 {
 	struct uart_state *state = drv->state + uport->line;
 	struct tty_port *port = &state->port;
 	struct uart_port *uart_port;
 	struct tty_struct *tty;
-	int ret = 0;
 
 	mutex_lock(&port_mutex);
 
@@ -3208,7 +3207,6 @@ int uart_remove_one_port(struct uart_dri
 
 	if (!uart_port) {
 		mutex_unlock(&port->mutex);
-		ret = -EINVAL;
 		goto out;
 	}
 	uport->flags |= UPF_DEAD;
@@ -3251,8 +3249,6 @@ int uart_remove_one_port(struct uart_dri
 	mutex_unlock(&port->mutex);
 out:
 	mutex_unlock(&port_mutex);
-
-	return ret;
 }
 EXPORT_SYMBOL(uart_remove_one_port);
 
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -834,7 +834,9 @@ static int asc_serial_remove(struct plat
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
 
-	return uart_remove_one_port(&asc_uart_driver, port);
+	uart_remove_one_port(&asc_uart_driver, port);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -686,18 +686,15 @@ static int ulite_assign(struct device *d
  *
  * @dev: pointer to device structure
  */
-static int ulite_release(struct device *dev)
+static void ulite_release(struct device *dev)
 {
 	struct uart_port *port = dev_get_drvdata(dev);
-	int rc = 0;
 
 	if (port) {
-		rc = uart_remove_one_port(&ulite_uart_driver, port);
+		uart_remove_one_port(&ulite_uart_driver, port);
 		dev_set_drvdata(dev, NULL);
 		port->mapbase = 0;
 	}
-
-	return rc;
 }
 
 /**
@@ -891,14 +888,13 @@ static int ulite_remove(struct platform_
 {
 	struct uart_port *port = dev_get_drvdata(&pdev->dev);
 	struct uartlite_data *pdata = port->private_data;
-	int rc;
 
 	clk_disable_unprepare(pdata->clk);
-	rc = ulite_release(&pdev->dev);
+	ulite_release(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	return rc;
+	return 0;
 }
 
 /* work with hotplug and coldplug */
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1670,14 +1670,13 @@ static int cdns_uart_remove(struct platf
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct cdns_uart *cdns_uart_data = port->private_data;
-	int rc;
 
 	/* Remove the cdns_uart port from the serial core */
 #ifdef CONFIG_COMMON_CLK
 	clk_notifier_unregister(cdns_uart_data->uartclk,
 			&cdns_uart_data->clk_rate_change_nb);
 #endif
-	rc = uart_remove_one_port(cdns_uart_data->cdns_uart_driver, port);
+	uart_remove_one_port(cdns_uart_data->cdns_uart_driver, port);
 	port->mapbase = 0;
 	clk_disable_unprepare(cdns_uart_data->uartclk);
 	clk_disable_unprepare(cdns_uart_data->pclk);
@@ -1693,7 +1692,7 @@ static int cdns_uart_remove(struct platf
 
 	if (!--instances)
 		uart_unregister_driver(cdns_uart_data->cdns_uart_driver);
-	return rc;
+	return 0;
 }
 
 static struct platform_driver cdns_uart_platform_driver = {
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -847,7 +847,7 @@ void uart_console_write(struct uart_port
 int uart_register_driver(struct uart_driver *uart);
 void uart_unregister_driver(struct uart_driver *uart);
 int uart_add_one_port(struct uart_driver *reg, struct uart_port *port);
-int uart_remove_one_port(struct uart_driver *reg, struct uart_port *port);
+void uart_remove_one_port(struct uart_driver *reg, struct uart_port *port);
 bool uart_match_port(const struct uart_port *port1,
 		const struct uart_port *port2);
 


