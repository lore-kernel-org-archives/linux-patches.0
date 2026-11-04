Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831483;
	b=MkLFx/6M0vC7TU33TcLHwp5GCmOpY3Qy+WDFkziY8PPL4RC5TLt+dJue5GQT8/dCeOLg
	 bY7oF7KmwuvRqX59QXDto+ELDGyC8IZK74kpYiiCGh+bZRK2Ri5B26UuCozTRLscBw5jj
	 hloHLEBFYrpnjPWIhPRDysbtBocZcbRiWlNXOdKQBl/g3licuJiyKshmCOW5WFR+Kms63
	 RiOmg4tCCzoW9sm6AvRYdeLNTFVPcPBGqHobADs6dhSB/S6EgWUDeEwVprOyyhpuaojVM
	 7vg3Baq0uCxPbj2PS7W7AVO/mUObntKtF7w0TpWfXjsUHy53KJ/dnxyHD19Awa3y+OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n8iVgZAevvweEdO5BourY0rdlk1njVixN6iwp2X7H4o=;
	b=CgwVspjPYEv/Ob52ho/sgJxtK0H/0LvzhFy4Ij4LKHRBVgejIs2MB9+m43aaFO7WFDfK
	 Mk7PUj/1hP3ryp8/mcshb8I8hLkzNpPJjruzM78ixHvDu1CJE5cc34SbNaNl93lEinT3d
	 b6e8Th1i0hIqM6Q7HB93mOP9g/XCL105Y07Lqrh1euUKPz/3PWcF6mWJh09GGCl2zz2iG
	 M+mbMiXCAPF1mN9WbRlfXHxnLa2xk7aFuuBXGbzm4K04Hyy61BI17VIEty44/B4Vl476b
	 +6Z/HH/jwUUrIAVKMhHNvy1ET0jJ5D4dlEEQogdDKrLwpDud/Q0QndUJy55ibOK4qkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhXtNWxM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE56606AC2A;
	Wed,  4 Nov 2026 22:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhXtNWxM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E581F000C1;
	Wed,  4 Nov 2026 22:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831483;
	bh=n8iVgZAevvweEdO5BourY0rdlk1njVixN6iwp2X7H4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EhXtNWxM2JoPm18xwJ9eSbJ9BHti38jst03fXSItUmH7WZcRa3esK8iP6QgKv/0y8
	 uWAm6MD2v0dYvEiNRekN0Ud0PJmorkKSkuPUGzjmm1ven5ae+IXPoc2XpgU6vcjrEh
	 m+wLAsCjoCRXCmb3iNVbOCCNSGMnug+E1Jkm15Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 6.18 0732/1005] serial: core: shut down initialized port on removal
Date: Wed,  4 Nov 2026 16:07:45 -0500
Message-ID: <20261104211103.999798555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3225,6 +3225,13 @@ static void serial_core_remove_one_port(
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


