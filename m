Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044429;
	b=J3DNx7J0/76aSu53Hqk8o0UuaPI47CP2g59rxx/VZMLpKZfazBQFTg6yXIggu7C/mtbZ
	 GgziFju2B8PDpuUI6gNbRt7jhhwHNeUfrFJeGq8ShoaFlhghAE9gJYmrlAFiTFjVYhSp9
	 uxIX+z5VjeCfn0Gbc+esGI7FOtiD1NDVmra1W88W7y5c6fmv2+46xaKenadYKSnpPnSfC
	 OAzCDq8w8bR5gW070Mjo6/a4axUSxUYFArgjPO3IZxOz+HMW6SuchhsuS9HNc7BtqLKdR
	 cDIHj3CTLIs5i9tGRuYLpHQt6gEHE/WPs4brjSzdp7OAREaV3aKdFlF6B5+xv33EbRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Np4SPUj4sx3nESLs5CSKCLQDYYCcKdJ1Wd0Z6/Jr7ZI=;
	b=uH5l3RA9yJuPtWk32wFKlGJR8YSqvTYjNmBU3iWgLWoeunB+WxyAG2o0BDyuZvCECKMh
	 ICyyIYkUcP2B7vgqerDbLJXiguPrgBADGTBFVO3yBfoIHcrX+aZRrc7shZ3mqngR0TPpe
	 QjOZFa9rn95x9jlrgJvfiVoLuLz2zQF/H0XkH8P8+SBVqEqn4tKoWojBer0Mkoa5bY0fS
	 iDL2gz6cacXHN6t7Kj4xsAJO/rh/AghAz0rP40VHdOZheglFK3fEuRXTgPvG5NBi8IlD9
	 RmkKyuGD3N8JSS7fPX7tvqO5E/5LGZi3mUPQ0KZqaYXnxzK06gYm/aTPfFKfFeGy3tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXgUyD0L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A22606A32A;
	Wed, 18 Nov 2026 23:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uXgUyD0L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3F21F000C4;
	Wed, 18 Nov 2026 23:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044428;
	bh=Np4SPUj4sx3nESLs5CSKCLQDYYCcKdJ1Wd0Z6/Jr7ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXgUyD0Lvdd76Scrqc+RAJkL3yeakBUTbZJjxilmVtvNGK0QgeMDYd4QLZpEU26FN
	 LrZv0+Lb0Qs+7VohQ3wnomO2fg6Z16cey+xNrIp084qfBNwEblwrAJAgQhRLKVeXVj
	 SyLU1VEUhCvZLOE52rautKrEhl/ON8d2/CW0rsPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 6.1 0562/2857] serial: core: shut down initialized port on removal
Date: Wed, 18 Nov 2026 15:26:36 +0100
Message-ID: <20261118150221.727665217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -3263,6 +3263,13 @@ void uart_remove_one_port(struct uart_dr
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


