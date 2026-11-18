Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052047;
	b=ZvNfc0J+DVgVhT2bd417kGqEcQsnFi58HzJrAomDZlW1yIBG63Wcn4FpDmM8eHZ2DlMR
	 zX9dhxE6YrlL1okIjLnz9bPxzpR4Ym3T/+VYEFYRnPdVCzIUbgR8EAyc5us5pZquz5QR6
	 tGcU8wGuXmT5eJ992aH3ps4KVTCB1N2a5/uxYVeoR0GZBCYOClIuZsa2QWye8rsoCjRIX
	 TP4Mim3ru62cp1mLiI+qp1cfnsIX7dP7pP7jz2J2OPJHOCq8Q4g8Ws4N3bmMpYPti7oFo
	 JTBI0El6BGvidUEY5wOQ4Ui+T14RbRWcwAwMyGcxvvjuuwWm9MrfkCvUkFiwUjFSX/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zw7GO6Qn79vrXmcyVVXqt8JkciUibo/tZpe1w5CzvS0=;
	b=K+VWAs6J89D+vDygTRLhM2x94cSgM9hPiSCBJnIoAuwQgd/+MpyPj2KwLJW59FAs25e2
	 +lo8WqvBa0sguV90etAyguzF0oOQwJ3vZUo9b2CW2dMZAL7csmXTEBelF2eCejl0t2dyU
	 vmWdTkrCZz+cP8GvxSxwZKkBk5cG5wpAAXe5o09++MWOsC+Mn4MgLmO2MzglJUGP4hmUA
	 kHJsbBEt4UukPE0GgN/VGlUemJUyTZnEoY2e9kYMbXTVNDudkUeZSn3oLNoSyC65znZAc
	 zUx7FYbwu6oqSD9FFyhkIodePQTn0kDPdwKG5V2fO6FxWxO+wCbroy0lI85Jud99GFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7JIiTf5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2C5606A31C;
	Thu, 19 Nov 2026 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7JIiTf5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A321F000C4;
	Thu, 19 Nov 2026 01:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052047;
	bh=zw7GO6Qn79vrXmcyVVXqt8JkciUibo/tZpe1w5CzvS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7JIiTf5kUgPfLqdrGrKaVKaM9IFmwpvYds0Px3NkVVHyrcyp2DpMMV62jvEy4lGR
	 sXQIS5D5yvVpZTM0ndfUbGIbVYK0lUCrleO6MfirwMg8oSAquLJUn6oPbceqK1IWY5
	 lyAChEwZP5zoNgkb8pTA0pbFGhpO1Kpf9noyO35A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Igor Putko <igorpetindev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0426/2214] serial: core: shut down initialized port on removal
Date: Wed, 18 Nov 2026 15:35:02 +0100
Message-ID: <20261118150027.935726693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Putko <igorpetindev@gmail.com>

[ Upstream commit 810d467c11f0c85107874d08dfdd11acba6aa0c0 ]

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
[ sashal: Replaced scoped_guard() with explicit mutex_lock() and mutex_unlock() for GNU89 compatibility. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a52e88a750f9e..3fc3b33cadc51 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3071,6 +3071,13 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	if (uart_console(uport))
 		unregister_console(uport->cons);
 
+	mutex_lock(&port->mutex);
+	port->console = false;
+
+	if (tty_port_initialized(port))
+		uart_shutdown(NULL, state);
+	mutex_unlock(&port->mutex);
+
 	/*
 	 * Free the port IO and memory resources, if any.
 	 */
-- 
2.53.0



