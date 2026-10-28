Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213130;
	b=V4MwvKX8X6zWQZovlGE/Crt02WTVOWnDIwW90epviIQNhZlLTb0MfpoRRGYNLnBFinpu
	 J3lpG52WG7iGfNtrA5OGqyTiKZ4hqs5suKa71sc0Eh9Hh6L5lNkp9E2012jYlAgvQ4Jd+
	 8tMYLEyQcOIvOrePvzIHdkHfpjPt8psFPaQajjIQNP4lQe8o7sIWQcyaYc5EqxX9+ETec
	 B3FzTjprv8ZiNwXBUdUcgFAI5mYq9iLhgv1dqtzaNQ17X8c2L7jKICIho0ALV7AqZ08ZM
	 s0KqScCxIIl2rvvHHRp6YBXLk+RQ8j4WGDwCzXuvevKV/+YRLi/+AbyNbwH280E15Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JbR3etUdOQCotXKrxe/7m28+KYixzJ1a3jJTsnK62yw=;
	b=oWQDgIQoRPAibk04FlQ9yY9TzaD3mCtHcWgnm263TlYrCu95C9X2BCV/nmFR8NoUK9QK
	 acDfmn15ZbxbuvVl8/EYTMu6wfO5TmkytS3Ax/xfYgXuy5Q2GNTffzc5ktYKk75uJBlJA
	 s02aY86RH4mFIBwyR/xYrABjMMnPqnNqL+QfpV38qltf0FIcBToVkdl+oeuq484YrFzi9
	 vHjWSXReFRxUDvWeH6eQsH7AG2E67syPhOFcmFfepzhbzzsRAcd584cKYUxbVg7CUSAkh
	 Y3y0bO+HopW9MA2qSYR6U5dM/BJptwVpfVFeQ1UKPCUYTuiAQhK0n6ihpys9KPnMf1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbonBk9I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2C4606A31C;
	Wed, 28 Oct 2026 18:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbonBk9I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1A91F01825;
	Wed, 28 Oct 2026 18:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213129;
	bh=JbR3etUdOQCotXKrxe/7m28+KYixzJ1a3jJTsnK62yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbonBk9IrTFsxzBDFUVzG8YNNHENed4THX+0juhydsboiA13JmIdi7KFShZ3Xm5F4
	 FHCFX2AmFOVWIkI3bYKStvhvk6kiEW+lt7kq/u63TXiG6kX94OvVZMWwOEDBq+tN1X
	 ObCXSntpK51UYUxoIpSGYbnveqq3rAkK8ZDeOYIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Bowler <nbowler@draconx.ca>,
	syzbot+473d7477c523b41d4046@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0398/1887] USB: serial: fix ioctl hangup race
Date: Wed, 28 Oct 2026 17:41:34 +0100
Message-ID: <20261028170508.290314410@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit ae0e61d95677efa778379853e495d748e6efbf95 ]

The tty ioctls can race with hangup and end up calling into a tty driver
for a device that is already gone or powered down.

Serialise the callbacks using the tty port mutex and add the missing
checks to make sure the port has not been hung up before accessing port
driver data or hardware.

This specifically avoids dereferencing a NULL-pointer if a device is
disconnected during lengthy break signalling.

Note that TIOCGICOUNT and TIOCMIWAIT do not access port driver data or
hardware and are therefore not affected by the race.

Fixes: f34d7a5b7010 ("tty: The big operations rework")
Reported-by: Nick Bowler <nbowler@draconx.ca>
Link: https://lore.kernel.org/all/CADyTPExB2kYOOwkO0JqGhKaYVDqO9uS9WCw0J=MCTdVhcGOogA@mail.gmail.com/
Reported-by: syzbot+473d7477c523b41d4046@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a9087a4.4d659fcc.734b4.0013.GAE@google.com
Cc: stable@vger.kernel.org	# 2.6.26
Signed-off-by: Johan Hovold <johan@kernel.org>
[ sashal: Omitted XR driver hunks because the RS-485 ioctl helpers are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/generic.c    | 10 +++-
 drivers/usb/serial/usb-serial.c | 94 ++++++++++++++++++++++++++-------
 2 files changed, 83 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 15b6dee3a8e50..64890f6d78e03 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -268,6 +268,7 @@ EXPORT_SYMBOL_GPL(usb_serial_generic_chars_in_buffer);
 void usb_serial_generic_wait_until_sent(struct tty_struct *tty, long timeout)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 	unsigned int bps;
 	unsigned long period;
 	unsigned long expire;
@@ -287,7 +288,14 @@ void usb_serial_generic_wait_until_sent(struct tty_struct *tty, long timeout)
 					__func__, jiffies_to_msecs(timeout),
 					jiffies_to_msecs(period));
 	expire = jiffies + timeout;
-	while (!port->serial->type->tx_empty(port)) {
+	for (;;) {
+		mutex_lock(&tport->mutex);
+		if (tty_io_error(tty) || port->serial->type->tx_empty(port)) {
+			mutex_unlock(&tport->mutex);
+			break;
+		}
+		mutex_unlock(&tport->mutex);
+
 		schedule_timeout_interruptible(period);
 		if (signal_pending(current))
 			break;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 9ecc108c2d275..9c6e6618e1694 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -403,17 +403,13 @@ static unsigned int serial_chars_in_buffer(struct tty_struct *tty)
 static void serial_wait_until_sent(struct tty_struct *tty, int timeout)
 {
 	struct usb_serial_port *port = tty->driver_data;
-	struct usb_serial *serial = port->serial;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
 	if (!port->serial->type->wait_until_sent)
 		return;
 
-	mutex_lock(&serial->disc_mutex);
-	if (!serial->disconnected)
-		port->serial->type->wait_until_sent(tty, timeout);
-	mutex_unlock(&serial->disc_mutex);
+	port->serial->type->wait_until_sent(tty, timeout);
 }
 
 static void serial_throttle(struct tty_struct *tty)
@@ -441,8 +437,13 @@ static int serial_get_serial(struct tty_struct *tty, struct serial_struct *ss)
 	struct usb_serial_port *port = tty->driver_data;
 	struct tty_port *tport = &port->port;
 	unsigned int close_delay, closing_wait;
+	int ret = 0;
 
 	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
 
 	close_delay = jiffies_to_msecs(tport->close_delay) / 10;
 	closing_wait = tport->closing_wait;
@@ -455,10 +456,10 @@ static int serial_get_serial(struct tty_struct *tty, struct serial_struct *ss)
 
 	if (port->serial->type->get_serial)
 		port->serial->type->get_serial(tty, ss);
-
+out_unlock:
 	mutex_unlock(&tport->mutex);
 
-	return 0;
+	return ret;
 }
 
 static int serial_set_serial(struct tty_struct *tty, struct serial_struct *ss)
@@ -474,6 +475,10 @@ static int serial_set_serial(struct tty_struct *tty, struct serial_struct *ss)
 		closing_wait = msecs_to_jiffies(closing_wait * 10);
 
 	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (close_delay != tport->close_delay ||
@@ -501,6 +506,7 @@ static int serial_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 	int retval = -ENOIOCTLCMD;
 
 	dev_dbg(&port->dev, "%s - cmd 0x%04x\n", __func__, cmd);
@@ -511,8 +517,21 @@ static int serial_ioctl(struct tty_struct *tty,
 			retval = port->serial->type->tiocmiwait(tty, arg);
 		break;
 	default:
-		if (port->serial->type->ioctl)
+		if (!port->serial->type->ioctl)
+			break;
+
+		if (cmd == TIOCSRS485)
+			down_write(&tty->termios_rwsem);
+
+		mutex_lock(&tport->mutex);
+		if (tty_io_error(tty))
+			retval = -EIO;
+		else
 			retval = port->serial->type->ioctl(tty, cmd, arg);
+		mutex_unlock(&tport->mutex);
+
+		if (cmd == TIOCSRS485)
+			up_write(&tty->termios_rwsem);
 	}
 
 	return retval;
@@ -522,25 +541,40 @@ static void serial_set_termios(struct tty_struct *tty,
 		               const struct ktermios *old)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->type->set_termios)
-		port->serial->type->set_termios(tty, port, old);
-	else
+	if (!port->serial->type->set_termios) {
 		tty_termios_copy_hw(&tty->termios, old);
+		return;
+	}
+
+	mutex_lock(&tport->mutex);
+	if (!tty_io_error(tty))
+		port->serial->type->set_termios(tty, port, old);
+	mutex_unlock(&tport->mutex);
 }
 
 static int serial_break(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->type->break_ctl)
-		return port->serial->type->break_ctl(tty, break_state);
+	if (!port->serial->type->break_ctl)
+		return -ENOTTY;
 
-	return -ENOTTY;
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
+		ret = port->serial->type->break_ctl(tty, break_state);
+	mutex_unlock(&tport->mutex);
+
+	return ret;
 }
 
 static int serial_proc_show(struct seq_file *m, void *v)
@@ -581,24 +615,44 @@ static int serial_proc_show(struct seq_file *m, void *v)
 static int serial_tiocmget(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->type->tiocmget)
-		return port->serial->type->tiocmget(tty);
-	return -ENOTTY;
+	if (!port->serial->type->tiocmget)
+		return -ENOTTY;
+
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
+		ret = port->serial->type->tiocmget(tty);
+	mutex_unlock(&tport->mutex);
+
+	return ret;
 }
 
 static int serial_tiocmset(struct tty_struct *tty,
 			    unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
+	struct tty_port *tport = &port->port;
+	int ret;
 
 	dev_dbg(&port->dev, "%s\n", __func__);
 
-	if (port->serial->type->tiocmset)
-		return port->serial->type->tiocmset(tty, set, clear);
-	return -ENOTTY;
+	if (!port->serial->type->tiocmset)
+		return -ENOTTY;
+
+	mutex_lock(&tport->mutex);
+	if (tty_io_error(tty))
+		ret = -EIO;
+	else
+		ret = port->serial->type->tiocmset(tty, set, clear);
+	mutex_unlock(&tport->mutex);
+
+	return ret;
 }
 
 static int serial_get_icount(struct tty_struct *tty,
-- 
2.53.0



