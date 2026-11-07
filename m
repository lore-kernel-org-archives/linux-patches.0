Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061575;
	b=jbRsb1QrIavcez6IFs7oqV8T3cH3DqtYZGGWaBepoKCANKvfuiP9M529kwjYE368Or+T
	 XRysU8ND/U95Lj/yVYwEwY+gcjy8iOpRiGypyebw4rHVZpxyu/eUBR9Ssp5w8h0GU8jc0
	 iirgU5BVe4pc7giQPV09cjWehGlSEbCPhr8AKbioejfS02fUZCNjLN/msOTgWkAAB5YtE
	 sDGQMk1xmej5A8HpyxBiOd1zWTqNDvhI5T2ObwdjZ926RGPDSRQ2cktgvYh/nIOAYxCGF
	 cBPvwXxLmNyL98+Jp4d72mi7XWEd9MhyZC4h/ENSdEm78rTR2YNrrAbkiIXmBWNWKFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OimwYWRR9fWnPsp4kW01WPKNRFxWkSEFxzTYQUNkTL8=;
	b=Ejqr0rGZbqPijXh02zBxaLpST4Pq6MD8oqa1Wfud1FopM+wLrx/FYXREM99m4EbcMJr0
	 /WwE3tJNpq9idIN6wHizpPdsykyyViy362hXaopdM29uKJfviO/JbhVC62uwU3CX6ZZct
	 WSkKM7HAOWSQcgFixtPG9sF6PvLfJLAlvEVj00IW7sYJqXcmnvJs5Dvwf9IhSaHhKGzps
	 8HtHYwmJwKMAL46qHJLuEKtpUJpPCXVuRhp4XVRxi7UlP7i+veIAsdU7G7UjDNwvXxduh
	 CCYcQRwPMIfm/SWiwTGgUPA5uxaeWQIyQ6rPulz/Ot3Fqfshe5WirfZSYppbZd04y+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yvtCa/JM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E519606A32D;
	Sat,  7 Nov 2026 14:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvtCa/JM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D11F1F0089F;
	Sat,  7 Nov 2026 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061575;
	bh=OimwYWRR9fWnPsp4kW01WPKNRFxWkSEFxzTYQUNkTL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvtCa/JMSf9khHrrgOx0ijZvXkmW9MSzukZyrtVFMcqGwv2u0XUkp6tw8VMx50XGU
	 fz96fb5OtoJNSqpwYnww0zH+mrBebXwgrEKKxQcHSh7y7GIB4pP/+LLHsZyf99zhPo
	 T8oCTmeARhA35FuA69u18jlQbYXmVi9GOdcTvm68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+843bf2f48f4d12e6682e@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 6.12 0652/1536] serial: core: shut down initialized port on removal
Date: Sat,  7 Nov 2026 08:44:28 -0500
Message-ID: <20261107135015.839279060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3271,6 +3271,13 @@ static void serial_core_remove_one_port(
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


