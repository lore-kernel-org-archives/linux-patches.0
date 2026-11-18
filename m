Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058034;
	b=kh7JL+d9zK+F5n2Uq8YmRozWZ7uL6qaubQ1YnevRxTLQYSB0GIZ2ays1Zl2/RhcGSGqP
	 /O1NYhT8nBLevdbwdNfaZC9ebaCo3l3OldwkliXPPXEinuJR1I3tOpgv7ofkp7KrvSQrl
	 V9GCsix2oSAtyGlLoHHjqy4KXT9yAZoY3pc9ZR81pXQyHAqr49UPwr0bYlj9DD5xJNyfJ
	 LGR9a1gUy/s4FZbklAjKqyIOWgpfmPr+ukhmrY+yaNocC+qPcfRbyPyFeNvRLLZTzJ3xn
	 NK9iBGMntY5j+0PE+CT4vttTsQxGrZ1v/ke3VhvrDTfS6QBZyugs/FjwaIgQJL4dBkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xh2YKI/xQtalzlx7SLVyyc8QJi7yT6TcGKigwY7v2yI=;
	b=S+JHbGbF/rBdKzg+l+HyJGmHd44IN11Wje4WrYWe3BVQMtUwDDmRYpkpIPZ4JwDUlOZD
	 prW0QfpHRZ+/erK/pznLaTVW0bwMWcY2xvm1sy1uaN5UKjY1Uya5B5rR0qhJCPCdOdLIJ
	 FzlV3MaSODUPWLmMK/YaFhI+cGECT3Zpf3CZWC0qYPHm97y0rrQZLwAqcWJN+LNCrMYei
	 NIhkj5wTSNjxHaCva/P4QP1MHQs4CGnAVjDZJ6nE/xZijX4FxaaevjpltbbOs9Zq+21RL
	 jyv0Fmp/ydBqPKnSBAviCDfTti6o5mgGIkK6XcrOub/Mgsdq2VZZQ98Ttt7SBWpJcQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NvaVf/lw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A8B606A31C;
	Thu, 19 Nov 2026 03:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvaVf/lw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A611F000C4;
	Thu, 19 Nov 2026 03:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058034;
	bh=Xh2YKI/xQtalzlx7SLVyyc8QJi7yT6TcGKigwY7v2yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvaVf/lwJPcvjMyePbcRlwgvbtfppIqZmC5sUBQfT/7XsPk4tpAHijohYdTBivyu5
	 N7QtRTVHjZTYW9gjj9dTePIuWjfKJ2BdMOVG3VQityR6WmMDQwDk7BVZHGWWRzQQNi
	 zwqIEbtMI6qyG+tJzwV57ND7y4vv1YQ4QOlDmu7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Igor Putko <igorpetindev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0341/1848] serial: core: shut down initialized port on removal
Date: Wed, 18 Nov 2026 15:39:39 +0100
Message-ID: <20261118145926.779725061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced scoped_guard() with explicit mutex_lock() and mutex_unlock() calls for GNU89 compatibility. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 4ffa682203166..ada412490668e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3090,6 +3090,13 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
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



