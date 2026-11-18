Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035154;
	b=ifT8J01QRYavLVGw2LBw481v3uOJZuq/WS56KjYrgY/a4F3SYcTRmfIeGU7RAngQ+mIJ
	 matNj92t/hwaX1Axw5eJyLAHK5m74pTUBokcv3oUyhQiFM4/VyynCBWRneKIxb1KIXoNN
	 3sUBYhtgemUPEuniCILyrOOq7+BLkAQ6EwRhuyyqjP6nRPljq2bYfoYlCGvSFZIdt38YK
	 mHPuwCTmtjTmDibBd1e3DgIdcWkKkoHQNAD24nV2+5pjznYA7xlcL8c3JVE8kLCEIi+dQ
	 BSMjC5/NFNijhLHwwcD7+kOqzfCDddkIL4t1o+cnjt14YJMYsITFLKlKxtNtKWrSnSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+D2a2Vi+NrKzOtyrFydhgBWLOGyr2so/T9XcmQhWAX0=;
	b=vjVOTS2hqDNKN1R5g4ZUxU7U/xfxfS300pAbDKQwfbTDbhBp55HuC4AGFotVBz81nTL3
	 IjaP9gU0L5dhgP7GYaK/dQ0ZesRrBGrFxskA7udVo6S5163/Ty/4331sq8zlnW4Yz87hu
	 XPr0kPo6LS0PaNxv9w5DN43RNmArtpUUrCXQrxc63wamRFENpIxO6lu41BLLkcjUadtgo
	 2wEEold9BY/lZdCHwGs7ga/q0tRv1trEtHWDpnyrYGP0F2shBeJsHGZPdBKE1dIgFADj6
	 Vm3r1dwxKAyHLQHD+Nurph9e+J31rxVlT4shhxD6pb/C+NaAA45YPeNFHGjnhc5lUvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3eTs02N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DDB606A320;
	Wed, 18 Nov 2026 20:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3eTs02N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A2C1F000C4;
	Wed, 18 Nov 2026 20:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035154;
	bh=+D2a2Vi+NrKzOtyrFydhgBWLOGyr2so/T9XcmQhWAX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3eTs02N1lGRmQsKs4BlRWL77EQC5oogFpX00LBM7+Jw6VYZ4fBt5pG/6Y5kM6hj8
	 y59LkvMT5VvVaUdF7LM9xu6QNafR+37xY6QG0c5RUgWWFxXzQ3t4N9b7N6j845BJeS
	 WsPVt8s2ywZFKaIEoVwLp/gzjUJigHdhHgoQ10gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 6.6 0624/3318] serial: core: shut down initialized port on removal
Date: Wed, 18 Nov 2026 15:20:46 +0100
Message-ID: <20261118150336.567817852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Putko <igorpetindev@gmail.com>

commit 810d467c11f0c85107874d08dfdd11acba6aa0c0 upstream.

When a serial port configured as a console is opened and subsequently
closed, tty_port_shutdown() skips invoking port->ops->shutdown() because
port->console is true. As a result, tty_port_initialized() remains true
and the port's interrupt handler stays registered in the irq subsystem.

If the underlying device is later unbound or removed (e.g. via sysfs
driver unbind or device hot-unplug), serial_core_remove_one_port()
unregisters the console, frees uport->name via kfree(), and tears down
the port without shutting it down or freeing its IRQ. Consequently, the
irqaction descriptor remains registered in genirq with action->name
pointing to freed memory.

This triggers a use-after-free read whenever genirq accesses action->name,
such as when reading /proc/interrupts:

  BUG: KASAN: slab-use-after-free in string+0x476/0x570
  Call Trace:
   string+0x476/0x570
   vsnprintf+0x422/0x1300
   seq_printf+0x...
   show_interrupts+...

Fix this by acquiring port->mutex in serial_core_remove_one_port() after
console unregistration, clearing port->console under the mutex to prevent
data races with concurrent tty_port_shutdown(), and invoking
uart_shutdown(NULL, state) if the port remains initialized. This ensures
that port->ops->shutdown() is called and the IRQ is freed before
kfree(uport->name).

Reported-by: syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://syzkaller.appspot.com/bug?extid=843bf2f48f4d12e6682e
Fixes: 761ed4a94582 ("tty: serial_core: convert uart_close to use tty_port_close")
Fixes: f7048b15900f ("tty: serial_core: Add name field to uart_port struct")
Signed-off-by: Igor Putko <igorpetindev@gmail.com>
Link: https://patch.msgid.link/20261003163337.45577-1-igorpetindev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3282,6 +3282,13 @@ static void serial_core_remove_one_port(
 	if (uart_console(uport))
 		unregister_console(uport->cons);
 
+	scoped_guard(mutex, &port->mutex) {
+		port->console = false;
+
+		if (tty_port_initialized(port))
+			uart_shutdown(NULL, state);
+	}
+
 	/*
 	 * Free the port IO and memory resources, if any.
 	 */


