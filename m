Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620484;
	b=cfT0oAqsAgqJo8yhEGf2AYzhyhM27ZxnXD3XDb+G41Kd1WdC+kY/dIXWaoKyhZP1sz7U
	 MnHzMLxCzxSHzfqtVPfSvw7TdlAPB3AOLR/vXtm/QuH2N/S2YMo1wbz6aCn6UxwOakq6F
	 OTSlcXwnC47wfVewFb5fBLqpQQTJU+vSb0Eq7S2V8Fh0TYr20GPadKcjlVzWAtxRltoi7
	 wtk7Wk6QpQrlAYpPfj2qsI96SZ/w5teBoIoac9NDnTe9R3Fll7FEQhZSmQcmW0iF6tx9S
	 aoZzsUDeL1pWwPnNiDPvxZYbJOmt6KoZZquQv9c4BybxO/k1akq/r5EoWy8d5l51MPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B31Rud1CstPPDyOmd2BohAnms3L5oIlpEtlyqy1X0B0=;
	b=O7v7Z1/OSJNxE8TyNN36w2ZITJnH2kUz06IRVOEmgJE9cfRTozHLsW3qLCvEVCSgl2Ej
	 FQvqgQ9XbVu3W4Ix7FODAonR62CUb2rFjedXTDKssza1kDqV/urvx1TAfXfrjqS8CSau/
	 1J7B88vzZRzTBYrxYG4CKks4I6FV8XIptx7kVCmqrI0244JNtViBp0uicoqD4QKCvj5YQ
	 1+2hCCGEAVidbi+g6tqKPUFid+7hHSOglSQ+45iyzsFP/UmADXtvns+gBQxJpFgLjELx3
	 /D/0m4oPDqdmzOpaV3Uy7nD2OBTibAl+Aj+2OVEt3K1jfdEg7vVYXaTgzflPu5Toaqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRWzXAFu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48A7606A32A;
	Wed, 25 Nov 2026 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRWzXAFu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DC81F000C6;
	Wed, 25 Nov 2026 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620483;
	bh=B31Rud1CstPPDyOmd2BohAnms3L5oIlpEtlyqy1X0B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRWzXAFuHvlNPnC4ZfHYiniq/UQV9pbocuvGfwjf6jCBOC9psx1X+SxfAkJXQyU0k
	 U7vhwJY2O5vjANWVmRa7WnNPe9SJ3fkt56qVsAmxYAxuGVey1oCRbfXfsfoTa+uTrt
	 RuRuLyHHHlFrgiQaNg+zrHQlXyUvWRCht5FD7g/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	syzbot@syzkaller.appspotmail.com,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	syzbot+bca09f5d8b843bbf7571@syzkaller.appspotmail.com
Subject: [PATCH 7.3 0931/1005] usb: gadget: u_serial: pin ports while TTYs are installed
Date: Wed, 25 Nov 2026 15:37:49 +0100
Message-ID: <20261125143843.493521053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

commit 1981b53c2b52a00f0f4b9eb87183c9aedc8dac5d upstream.

A slab-use-after-free can occur when gserial_free_line() frees struct
gs_port while it is still reachable through an installed TTY. The
port->port.count value tracks successful opens, but it is zero before
gs_open() and again after gs_close(), before TTY cleanup has finished.
Teardown can therefore free gs_port while tty_init_dev() or release_tty()
still accesses its tty_port.

Manage gs_port lifetime with tty_port references. Take a reference in
gs_install(), drop it in gs_cleanup(), and move the final free to
gs_port_destruct(). Unregister the TTY device before dropping the owner
reference.

Keep each minor reserved until the old port is destroyed so an installed
TTY for one generation cannot overlap a replacement at the same minor.
Publish the new port before device registration so the cdev and add uevent
never expose a TTY before gs_install() can pin it. Since commit
8df07fe93573 ("tty: fix saved termios reset race"), u_serial registration
no longer frees saved termios. On registration failure, unpublish the port
before dropping its owner reference.

Check in gs_open() that the installed port is still the published
generation. Track failures after a successful install so close callbacks
issued by the TTY core do not decrement port->port.count for opens that
never incremented it.

Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
Link: https://syzkaller.appspot.com/ai_job?id=ec789387-2e7b-4a8f-a7a1-a47bf7fa57f5
Cc: stable <stable@kernel.org>
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Tested-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Reported-by: syzbot+bca09f5d8b843bbf7571@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bca09f5d8b843bbf7571
Link: https://patch.msgid.link/20261022091359.1187468-1-krystianmkaniewski@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_serial.c |  167 ++++++++++++++++++++++++++-------
 1 file changed, 134 insertions(+), 33 deletions(-)

--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -70,10 +70,28 @@
  *	gserial->ioport == usb_ep->driver_data ... gs_port
  *	gs_port->port_usb ... gserial
  *
- * gs_port <---> tty_struct ... links will be null when the TTY file
- * isn't opened; managed by gs_open()/gs_close()
- *	gserial->port_tty ... tty_struct
- *	tty_struct->driver_data ... gserial
+ * gs_port <---> tty_struct:
+ *	tty->driver_data refers to gs_port from install through cleanup,
+ *	pinning the port via tty_port reference counting.
+ *	gs_port->port.tty exists only while the port is open.
+ *
+ * Each entry in ports[] is guarded by ports[i].lock and models three states:
+ *   - Free:      !port && !reserved
+ *   - Published:  port &&  reserved
+ *   - Retiring:   !port &&  reserved
+ *
+ * A minor remains reserved until gs_port_destruct() runs upon final tty_port
+ * release, preventing minor reuse while cleanup of the installed TTY is still
+ * underway. The owner reference is retained through device unregister so the
+ * destructor releases the reservation only after device teardown is complete.
+ *
+ * open_close_failures tracks failed gs_open() calls where port->port.count
+ * was not incremented. The TTY core calls gs_close() on open failure to tear
+ * down the tty; tracking failures as aggregate credits allows gs_close() to
+ * consume a credit and exit without decrementing port->port.count. Credits
+ * are aggregate rather than paired with individual files (another gs_close()
+ * can consume a failed open's credit before that file's own close runs).
+ * It is protected by tty_lock.
  */
 
 /* RX and TX queues can buffer QUEUE_SIZE packets before they hit the
@@ -128,6 +146,7 @@ struct gs_port {
 	wait_queue_head_t	close_wait;
 	bool			suspended;	/* port suspended */
 	bool			start_delayed;	/* delay start when suspended */
+	unsigned int		open_close_failures; /* protected by tty_lock */
 	struct async_icount	icount;
 
 	/* REVISIT this state ... */
@@ -135,8 +154,9 @@ struct gs_port {
 };
 
 static struct portmaster {
-	struct mutex	lock;			/* protect open/close */
+	struct mutex	lock;			/* protect open/close and port slot */
 	struct gs_port	*port;
+	bool		reserved;
 } ports[MAX_U_SERIAL_PORTS];
 
 #define GS_CLOSE_TIMEOUT		15		/* seconds */
@@ -603,22 +623,60 @@ static int gserial_wakeup_host(struct gs
 
 /* TTY Driver */
 
+static int gs_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct gs_port *port;
+	struct tty_port *tport;
+	int ret;
+
+	mutex_lock(&ports[tty->index].lock);
+	port = ports[tty->index].port;
+	if (!port) {
+		mutex_unlock(&ports[tty->index].lock);
+		return -ENODEV;
+	}
+
+	tport = tty_port_get(&port->port);
+	if (!tport) {
+		mutex_unlock(&ports[tty->index].lock);
+		return -ENODEV;
+	}
+
+	ret = tty_port_install(tport, driver, tty);
+	if (ret) {
+		mutex_unlock(&ports[tty->index].lock);
+		tty_port_put(tport);
+		return ret;
+	}
+
+	tty->driver_data = port;
+	mutex_unlock(&ports[tty->index].lock);
+
+	return 0;
+}
+
+static void gs_cleanup(struct tty_struct *tty)
+{
+	tty_port_put(tty->port);
+}
+
 /*
- * gs_open sets up the link between a gs_port and its associated TTY.
- * That link is broken *only* by TTY close(), and all driver methods
- * know that.
+ * gs_open associates an open TTY with its gs_port.
+ *
+ * There are two TTY-to-port relationships: port->port.tty exists from the
+ * first successful open until final close, while tty->driver_data is assigned
+ * during gs_install() and remains valid through gs_cleanup().
  */
 static int gs_open(struct tty_struct *tty, struct file *file)
 {
 	int		port_num = tty->index;
-	struct gs_port	*port;
+	struct gs_port	*port = tty->driver_data;
 	int		status = 0;
 
 	mutex_lock(&ports[port_num].lock);
-	port = ports[port_num].port;
-	if (!port) {
+	if (ports[port_num].port != port) {
 		status = -ENODEV;
-		goto out;
+		goto fail_unlock;
 	}
 
 	spin_lock_irq(&port->port_lock);
@@ -638,7 +696,7 @@ static int gs_open(struct tty_struct *tt
 		if (status) {
 			pr_debug("gs_open: ttyGS%d (%p,%p) no buffer\n",
 				 port_num, tty, file);
-			goto out;
+			goto fail_unlock;
 		}
 
 		spin_lock_irq(&port->port_lock);
@@ -648,7 +706,6 @@ static int gs_open(struct tty_struct *tt
 	if (port->port.count++)
 		goto exit_unlock_port;
 
-	tty->driver_data = port;
 	port->port.tty = tty;
 
 	/* if connected, start the I/O stream */
@@ -672,7 +729,11 @@ static int gs_open(struct tty_struct *tt
 
 exit_unlock_port:
 	spin_unlock_irq(&port->port_lock);
-out:
+	mutex_unlock(&ports[port_num].lock);
+	return status;
+
+fail_unlock:
+	port->open_close_failures++;
 	mutex_unlock(&ports[port_num].lock);
 	return status;
 }
@@ -698,6 +759,11 @@ static void gs_close(struct tty_struct *
 	if (!port)
 		return;
 
+	if (port->open_close_failures > 0) {
+		port->open_close_failures--;
+		return;
+	}
+
 	spin_lock_irq(&port->port_lock);
 
 	if (port->port.count != 1) {
@@ -912,8 +978,10 @@ static int gs_get_icount(struct tty_stru
 }
 
 static const struct tty_operations gs_tty_ops = {
+	.install =		gs_install,
 	.open =			gs_open,
 	.close =		gs_close,
+	.cleanup =		gs_cleanup,
 	.write =		gs_write,
 	.put_char =		gs_put_char,
 	.flush_chars =		gs_flush_chars,
@@ -1206,14 +1274,41 @@ static void gs_console_exit(struct gs_po
 
 #endif
 
-static int
+static void gs_port_destruct(struct tty_port *tport)
+{
+	struct gs_port *port = container_of(tport, struct gs_port, port);
+	unsigned int port_num = port->port_num;
+
+	mutex_lock(&ports[port_num].lock);
+	if (WARN_ON(ports[port_num].port))
+		ports[port_num].port = NULL;
+	WARN_ON(!ports[port_num].reserved);
+	if (gs_tty_driver)
+		gs_tty_driver->ports[port_num] = NULL;
+	ports[port_num].reserved = false;
+	mutex_unlock(&ports[port_num].lock);
+
+	kfifo_free(&port->port_write_buf);
+	kfree(port);
+}
+
+static const struct tty_port_operations gs_port_ops = {
+	.destruct = gs_port_destruct,
+};
+
+static struct gs_port *
 gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
 {
 	struct gs_port	*port;
 	int		ret = 0;
 
 	mutex_lock(&ports[port_num].lock);
-	if (ports[port_num].port) {
+	if (WARN_ON_ONCE(ports[port_num].port && !ports[port_num].reserved)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (ports[port_num].reserved) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1225,6 +1320,7 @@ gs_port_alloc(unsigned port_num, struct
 	}
 
 	tty_port_init(&port->port);
+	port->port.ops = &gs_port_ops;
 	spin_lock_init(&port->port_lock);
 	init_waitqueue_head(&port->drain_wait);
 	init_waitqueue_head(&port->close_wait);
@@ -1238,10 +1334,14 @@ gs_port_alloc(unsigned port_num, struct
 	port->port_num = port_num;
 	port->port_line_coding = *coding;
 
+	ports[port_num].reserved = true;
 	ports[port_num].port = port;
+	mutex_unlock(&ports[port_num].lock);
+	return port;
+
 out:
 	mutex_unlock(&ports[port_num].lock);
-	return ret;
+	return ERR_PTR(ret);
 }
 
 static int gs_closed(struct gs_port *port)
@@ -1261,8 +1361,7 @@ static void gserial_free_port(struct gs_
 	/* wait for old opens to finish */
 	wait_event(port->close_wait, gs_closed(port));
 	WARN_ON(port->port_usb != NULL);
-	tty_port_destroy(&port->port);
-	kfree(port);
+	tty_port_put(&port->port);
 }
 
 void gserial_free_line(unsigned char port_num)
@@ -1279,15 +1378,15 @@ void gserial_free_line(unsigned char por
 	ports[port_num].port = NULL;
 	mutex_unlock(&ports[port_num].lock);
 
-	gserial_free_port(port);
 	tty_unregister_device(gs_tty_driver, port_num);
+	gserial_free_port(port);
 }
 EXPORT_SYMBOL_GPL(gserial_free_line);
 
 int gserial_alloc_line_no_console(unsigned char *line_num)
 {
 	struct usb_cdc_line_coding	coding;
-	struct gs_port			*port;
+	struct gs_port			*port = ERR_PTR(-EBUSY);
 	struct device			*tty_dev;
 	int				ret;
 	int				port_num;
@@ -1298,19 +1397,20 @@ int gserial_alloc_line_no_console(unsign
 	coding.bDataBits = USB_CDC_1_STOP_BITS;
 
 	for (port_num = 0; port_num < MAX_U_SERIAL_PORTS; port_num++) {
-		ret = gs_port_alloc(port_num, &coding);
-		if (ret == -EBUSY)
-			continue;
-		if (ret)
+		port = gs_port_alloc(port_num, &coding);
+		if (IS_ERR(port)) {
+			ret = PTR_ERR(port);
+			if (ret == -EBUSY)
+				continue;
 			return ret;
+		}
 		break;
 	}
-	if (ret)
-		return ret;
+	if (IS_ERR(port))
+		return PTR_ERR(port);
 
 	/* ... and sysfs class devices, so mdev/udev make /dev/ttyGS* */
 
-	port = ports[port_num].port;
 	tty_dev = tty_port_register_device(&port->port,
 			gs_tty_driver, port_num, NULL);
 	if (IS_ERR(tty_dev)) {
@@ -1319,14 +1419,15 @@ int gserial_alloc_line_no_console(unsign
 
 		ret = PTR_ERR(tty_dev);
 		mutex_lock(&ports[port_num].lock);
+		WARN_ON(ports[port_num].port != port);
 		ports[port_num].port = NULL;
 		mutex_unlock(&ports[port_num].lock);
-		gserial_free_port(port);
-		goto err;
+		tty_port_put(&port->port);
+		return ret;
 	}
+
 	*line_num = port_num;
-err:
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gserial_alloc_line_no_console);
 


