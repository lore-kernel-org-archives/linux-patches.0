Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620551;
	b=lhjCSMKcmOawjd4CiSp67SyQFAbbfpkcl/cTU9+VnFf52cWvvdqB5RtgI6Nm4uOkwlGA
	 yPlrOvMxOjNVmKXUG4PtrfwBPf3d++8fZ0pYZPGSsM0/RpMmbNcJqfkM9UX/4O9ZwksB5
	 0q+tCWkDDKKQlosyZlndajSVu4wy6OdRC8jPxxBD6ro0/goU3Oji580YcWkPnkbpmvOLB
	 BEdN+iiy6YfHU/SGBIQwsPU/hI0L0P3X4lrRygfdxpfEekIRJtD5NDuxyWwx1NYsJQrFZ
	 o8Tny3Ua3i7oVLHhPBP/6GYe8i0kUV47+Ekr4uGG255oZPcbo6/LVcE4YDc90xAiUOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2lTPu8EL3m8AlkXwrSJQpQyOPpYeDhZTMLkzadDT9cQ=;
	b=JDrKnIqHcZOzQs7sD7Leqm+D7ZEhNwmw1K+u8IFcBLg/ClsXEoaoHYyEIhkAx81XRp28
	 4F3b/cXGKGImbQnarlpMb8ATNoovK9d0UWhyKLh06vl3K8QUl6Q6iWPmtTHwPMRDO/WA8
	 7eCi/np79FgGjkwd+g9wYw7gt8qxIyZ4j7R3atShzDi7RneFErPW8fL/0qIt7d1ED003C
	 aZYLZZKMV4mxadl527XTsBsnBr1TSfkTM2Qg2aiLFjakzHae2OqlR/Wwe9QyO974XVPvL
	 dUXafCGw9RCbPkjflA6KcKrHpLFvJF2cAHNGzj2uw8yvWUqAQoSaBYKm9HNam8aGP8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxoYxaKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39260606A321;
	Wed, 25 Nov 2026 15:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxoYxaKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EE91F000C0;
	Wed, 25 Nov 2026 15:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620551;
	bh=2lTPu8EL3m8AlkXwrSJQpQyOPpYeDhZTMLkzadDT9cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxoYxaKjPbewmMUlyUl9BLhKWK8Xwp2WUYqIBG2BqxP84DD407N+nozrmx35Ez9ik
	 5//+USfHSMVLDze3smwGLgK2wSZLl8i8+7h8l5WbznbSUC1qJ06QBCLO82LZPRRTFe
	 gyp/H4C45RP9ze2d4z+kvSeNQE+0ivvGlKAWnYpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksim Salau <maksim.salau@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.3 0955/1005] USB: serial: upd78f0730: fix NULL-deref on hangup
Date: Wed, 25 Nov 2026 15:38:13 +0100
Message-ID: <20261125143844.043094770@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 0e0b1fcfb80c0490bda7f7eb633ebb5e431c2e16 upstream.

The port tty pointer is cleared on hangup before deasserting the modem
control signals and should not be used in the dtr_rts() callback.

Factor out a new upd78f0730_port_tiocmset() helper that can be used in
upd78f0730_dtr_rts() to avoid dereferencing a NULL-pointer on hangup
(e.g. on disconnect).

This issue was flagged by an LLM.

Fixes: ea534e0b4047 ("USB: serial: add uPD78F0730 USB to Serial Adaptor Driver")
Cc: stable@vger.kernel.org	# 4.11
Cc: Maksim Salau <maksim.salau@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/upd78f0730.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/upd78f0730.c
+++ b/drivers/usb/serial/upd78f0730.c
@@ -201,10 +201,9 @@ static int upd78f0730_tiocmget(struct tt
 	return res;
 }
 
-static int upd78f0730_tiocmset(struct tty_struct *tty,
+static int upd78f0730_port_tiocmset(struct usb_serial_port *port,
 			unsigned int set, unsigned int clear)
 {
-	struct usb_serial_port *port = tty->driver_data;
 	struct upd78f0730_port_private *private;
 	struct upd78f0730_set_dtr_rts request;
 	struct device *dev = &port->dev;
@@ -238,6 +237,13 @@ static int upd78f0730_tiocmset(struct tt
 	return res;
 }
 
+static int upd78f0730_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
+{
+	struct usb_serial_port *port = tty->driver_data;
+
+	return upd78f0730_port_tiocmset(port, set, clear);
+}
+
 static int upd78f0730_break_ctl(struct tty_struct *tty, int break_state)
 {
 	struct upd78f0730_port_private *private;
@@ -267,7 +273,6 @@ static int upd78f0730_break_ctl(struct t
 
 static void upd78f0730_dtr_rts(struct usb_serial_port *port, int on)
 {
-	struct tty_struct *tty = port->port.tty;
 	unsigned int set = 0;
 	unsigned int clear = 0;
 
@@ -276,7 +281,7 @@ static void upd78f0730_dtr_rts(struct us
 	else
 		clear = TIOCM_DTR | TIOCM_RTS;
 
-	upd78f0730_tiocmset(tty, set, clear);
+	upd78f0730_port_tiocmset(port, set, clear);
 }
 
 static speed_t upd78f0730_get_baud_rate(struct tty_struct *tty)


