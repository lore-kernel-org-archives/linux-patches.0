Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208957;
	b=IhoSgneZx6LWCYNdSIy+K+xjLiNvxyWIAnBUZYx1eKSeDw+oBlZ1lhzzwtJXld8SKUWJ
	 IoidsGJIGPMrWL5jFmRrMDCMIyRpATTM9kP2r5LSo73dtXjC0dImED6UKhqAOH7RkSCNp
	 oF4wQiIKhr7C4W9iLbh/yHdqDATs4tE7w4bEc/LRQXwaudl++I1tx4uKdAchE/fmRug1m
	 lJGt8XhLkIvLfRHgFYMxYoxe5UMRU3pKLUn8hYrCZz/O++iWGa47XS7JU1rg6sp00FF8s
	 QzpXiqeRmfyxRb1evJC+8NpVcQezhReD8zSDEC5tKcApftiImwsZ09EJ9XSrBRz6xKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ixn7V7SYRi/9rX02CJLwBTP3PIf2/0NkueAPuZAkAPw=;
	b=bJ5LLAfPReWDQKFQUJVnDnyjolkwHlUYFXVd6xYZpbMjgASRg9Qzsy/Rx46SthdVAm33
	 M8jmb7UWW1epzUrQK8r05MYW0tJ6SPeHKi2RPFxZ1LmMU4VLmLlitWighZIeKM0sK1KUL
	 oHWouVvoHtuWikedydPfQ80E3HRLut+B3594AL2wtbVQFAPI1YtIvCx/N6GyAfl194RgT
	 jZ7lXH3ZHt+llUzlPUY3mvPtX96A6i2adS+gmkgvXzWrdFIsUzp44iA2bHaUu/2/nQA2f
	 SCqtzg47ju14ZigbocJ8Ckj9tJM0HLySgb6W7eLSUKeEQJEdEJUH1BCN3Nos29AQc6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qcbP1DzN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EB3606A322;
	Wed, 28 Oct 2026 17:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qcbP1DzN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A823E1F01825;
	Wed, 28 Oct 2026 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208957;
	bh=Ixn7V7SYRi/9rX02CJLwBTP3PIf2/0NkueAPuZAkAPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qcbP1DzNB3v0irXpUHYnusNC+l/IOmu+RsnEdrSFZedzKQr83E7g230NtRzGEfn6V
	 Y3dkDzfyDDyXF1SjggoyIbeVqGJRYvSuMNRMzydBfSuBMT9Or9RgZeeaUOJW7Fy+s7
	 tLZdxBrpYuUiySANNolnUXFY1Pk6PVlT0sP3pAxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Karsten Keil <isdn@linux-pingi.de>,
	David Lin <dtwlin@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Alex Elder <elder@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Ting-Han Hou <ue081723@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/516] tty: introduce and use tty_port_tty_vhangup() helper
Date: Wed, 28 Oct 2026 17:57:34 +0100
Message-ID: <20261028170010.644936622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 2b5eac0f8c6e79bc152c8804f9f88d16717013ab ]

This code (tty_get -> vhangup -> tty_put) is repeated on few places.
Introduce a helper similar to tty_port_tty_hangup() (asynchronous) to
handle even vhangup (synchronous).

And use it on those places.

In fact, reuse the tty_port_tty_hangup()'s code and call tty_vhangup()
depending on a new bool parameter.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: David Lin <dtwlin@gmail.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20250611100319.186924-2-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Ting-Han: adjust context in uart_remove_one_port(), which is still
  called that and keeps its "ret" variable in this version; the tty_port
  prototypes live in include/linux/tty.h here, so add the inline helpers
  there instead of include/linux/tty_port.h ]
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/capi/capi.c         |  8 +-------
 drivers/staging/greybus/uart.c   |  7 +------
 drivers/tty/serial/serial_core.c |  7 +------
 drivers/tty/tty_port.c           | 12 ++++++++----
 drivers/usb/class/cdc-acm.c      |  7 +------
 drivers/usb/serial/usb-serial.c  |  7 +------
 include/linux/tty.h              | 13 ++++++++++++-
 net/bluetooth/rfcomm/tty.c       |  7 +------
 8 files changed, 26 insertions(+), 42 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 85767f52fe3c7..e893c151bfa0d 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -303,15 +303,9 @@ static void capincci_alloc_minor(struct capidev *cdev, struct capincci *np)
 static void capincci_free_minor(struct capincci *np)
 {
 	struct capiminor *mp = np->minorp;
-	struct tty_struct *tty;
 
 	if (mp) {
-		tty = tty_port_tty_get(&mp->port);
-		if (tty) {
-			tty_vhangup(tty);
-			tty_kref_put(tty);
-		}
-
+		tty_port_tty_vhangup(&mp->port);
 		capiminor_free(mp);
 	}
 }
diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 2a88314058a86..4895029bb39f2 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -929,7 +929,6 @@ static void gb_uart_remove(struct gbphy_device *gbphy_dev)
 {
 	struct gb_tty *gb_tty = gb_gbphy_get_data(gbphy_dev);
 	struct gb_connection *connection = gb_tty->connection;
-	struct tty_struct *tty;
 	int ret;
 
 	ret = gbphy_runtime_get_sync(gbphy_dev);
@@ -942,11 +941,7 @@ static void gb_uart_remove(struct gbphy_device *gbphy_dev)
 	wake_up_all(&gb_tty->wioctl);
 	mutex_unlock(&gb_tty->mutex);
 
-	tty = tty_port_tty_get(&gb_tty->port);
-	if (tty) {
-		tty_vhangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_vhangup(&gb_tty->port);
 
 	gb_connection_disable_rx(connection);
 	tty_unregister_device(gb_tty_driver, gb_tty->minor);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 7e4cab742321c..4ffa682203166 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3053,7 +3053,6 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	struct uart_state *state = drv->state + uport->line;
 	struct tty_port *port = &state->port;
 	struct uart_port *uart_port;
-	struct tty_struct *tty;
 	int ret = 0;
 
 	BUG_ON(in_interrupt());
@@ -3083,11 +3082,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 */
 	tty_port_unregister_device(port, drv->tty_driver, uport->line);
 
-	tty = tty_port_tty_get(port);
-	if (tty) {
-		tty_vhangup(port->tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_vhangup(port);
 
 	/*
 	 * If the port is used as a console, unregister it
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 77e28059ad982..296ba1e6e48cb 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -369,15 +369,19 @@ EXPORT_SYMBOL(tty_port_hangup);
  * @port: tty port
  * @check_clocal: hang only ttys with CLOCAL unset?
  */
-void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
+void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal, bool async)
 {
 	struct tty_struct *tty = tty_port_tty_get(port);
 
-	if (tty && (!check_clocal || !C_CLOCAL(tty)))
-		tty_hangup(tty);
+	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
+		if (async)
+			tty_hangup(tty);
+		else
+			tty_vhangup(tty);
+	}
 	tty_kref_put(tty);
 }
-EXPORT_SYMBOL_GPL(tty_port_tty_hangup);
+EXPORT_SYMBOL_GPL(__tty_port_tty_hangup);
 
 /**
  * tty_port_tty_wakeup - helper to wake up a tty
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index b49b25d055a5a..e3049f31b891a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1578,7 +1578,6 @@ static int acm_probe(struct usb_interface *intf,
 static void acm_disconnect(struct usb_interface *intf)
 {
 	struct acm *acm = usb_get_intfdata(intf);
-	struct tty_struct *tty;
 	int i;
 
 	/* sibling interface is already cleaning up */
@@ -1605,11 +1604,7 @@ static void acm_disconnect(struct usb_interface *intf)
 	usb_set_intfdata(acm->data, NULL);
 	mutex_unlock(&acm->mutex);
 
-	tty = tty_port_tty_get(&acm->port);
-	if (tty) {
-		tty_vhangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_vhangup(&acm->port);
 
 	cancel_delayed_work_sync(&acm->dwork);
 
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index bc3ec34f9f913..5ef62ff3ba9a2 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1144,7 +1144,6 @@ static void usb_serial_disconnect(struct usb_interface *interface)
 	struct usb_serial *serial = usb_get_intfdata(interface);
 	struct device *dev = &interface->dev;
 	struct usb_serial_port *port;
-	struct tty_struct *tty;
 
 	usb_serial_console_disconnect(serial);
 
@@ -1155,11 +1154,7 @@ static void usb_serial_disconnect(struct usb_interface *interface)
 
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
-		tty = tty_port_tty_get(&port->port);
-		if (tty) {
-			tty_vhangup(tty);
-			tty_kref_put(tty);
-		}
+		tty_port_tty_vhangup(&port->port);
 		usb_serial_port_poison_urbs(port);
 		wake_up_interruptible(&port->port.delta_msr_wait);
 		cancel_work_sync(&port->work);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 12a841779552d..6a7854c3e54ab 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -623,7 +623,8 @@ extern int tty_port_carrier_raised(struct tty_port *port);
 extern void tty_port_raise_dtr_rts(struct tty_port *port);
 extern void tty_port_lower_dtr_rts(struct tty_port *port);
 extern void tty_port_hangup(struct tty_port *port);
-extern void tty_port_tty_hangup(struct tty_port *port, bool check_clocal);
+extern void __tty_port_tty_hangup(struct tty_port *port, bool check_clocal,
+				  bool async);
 extern void tty_port_tty_wakeup(struct tty_port *port);
 extern int tty_port_block_til_ready(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
@@ -641,6 +642,16 @@ static inline int tty_port_users(struct tty_port *port)
 	return port->count + port->blocked_open;
 }
 
+static inline void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
+{
+	__tty_port_tty_hangup(port, check_clocal, true);
+}
+
+static inline void tty_port_tty_vhangup(struct tty_port *port)
+{
+	__tty_port_tty_hangup(port, false, false);
+}
+
 extern int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc);
 extern int tty_unregister_ldisc(int disc);
 extern int tty_set_ldisc(struct tty_struct *tty, int disc);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 886abe4d64eb4..bc3e597c7dacb 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -437,7 +437,6 @@ static int __rfcomm_release_dev(void __user *arg)
 {
 	struct rfcomm_dev_req req;
 	struct rfcomm_dev *dev;
-	struct tty_struct *tty;
 
 	if (copy_from_user(&req, arg, sizeof(req)))
 		return -EFAULT;
@@ -463,11 +462,7 @@ static int __rfcomm_release_dev(void __user *arg)
 		rfcomm_dlc_close(dev->dlc, 0);
 
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
-	tty = tty_port_tty_get(&dev->port);
-	if (tty) {
-		tty_vhangup(tty);
-		tty_kref_put(tty);
-	}
+	tty_port_tty_vhangup(&dev->port);
 
 	if (!test_and_set_bit(RFCOMM_TTY_OWNED, &dev->status))
 		tty_port_put(&dev->port);
-- 
2.53.0



