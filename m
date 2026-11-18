Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044249;
	b=Q3hm1xZn9NjVdj6qhxc3vHZcUbLG1PzaDxgRKeYn4dfIX0jlKRubS9kzHWnyMmehdt/t
	 K1oCGO3G35Qrx0YSy29PC7vsWd3zJE0KfMeD8hzwYFS9TRAuvTzkRfdu6SOxlTjRWm7vx
	 ubtl/S3BrDimqf2t+r0cu/bL8ccGNt8+sB5Zx3CnhKAH52QK5jFF5aytZLSlHus8sJo8M
	 BNI5pqt6G4U/8I5ubZSoHgTv+mK0xDeV22KYTVN/m/o5KoSzxdq/L6OHQuypPB1GHWNVe
	 cxvvIwbHQ6avh4PCSZA+Oxq9zT6nyJ7klLms26l+ILkdHovDQpwtX5cmQwM7MUDASMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LxfxG2pOnhwQKH8m/t9oaFnKBX6qX1Nu+RoYvyh33z0=;
	b=5pS08Te+3QjOt9TbicDmncNNWWtb9u3EdTwTOITBJLCZMKsLDYb9wnABO5AOCCVF10ay
	 WvIcAO7lOvrZOUI1V5H9x5P+lg7f2UiSRrWBdrGL5tHWxvwOaPHCaBSprWtFsd2oJ8dbn
	 +RfnmbUNbg723FQ14Htu1y1W4UpFZvaz+h2+Ocw1MUQ944p0N7hasJxq8BIpW7xZAba8h
	 SfaxmrVlB1p83C7lx6jNFUjzGzLbnfzkse46U623xE8C6rlrfWAJacoTkji02DRVrXAh5
	 dUBGXfpWXqXfJAF38as0//g99liL1dfCo5DDWWxgrDBpJtEIb2zWkGqnFt2sXys/Opg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWLNVEUw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFD3606A320;
	Wed, 18 Nov 2026 23:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hWLNVEUw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2CC1F000C4;
	Wed, 18 Nov 2026 23:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044249;
	bh=LxfxG2pOnhwQKH8m/t9oaFnKBX6qX1Nu+RoYvyh33z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWLNVEUw/bYxag9TVOLbRxSkfui8xOXnbBaKgP7fjI6tX22iNkasj4bXVzyq4FfFk
	 HbuPihDgAo49++ggiE6SAqdd4pEVB07ST3i90O4e69wP+r7piQw6x1/xEKcxN1qYf7
	 f/UcY3+seW4204dMBuMKUHwCJfwwp9bIyMokaqBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0499/2857] serial: core: fix TIOCSSERIAL and TIOCSERCONFIG on uninitialised ports
Date: Wed, 18 Nov 2026 15:25:33 +0100
Message-ID: <20261118150219.421842413@linuxfoundation.org>
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

From: Hengyu Liang <hengyul@cs.unc.edu>

[ Upstream commit e1f46a09df93650288babb23de6e34bff73e80e6 ]

Commit 8ca59f7baee7 ("serial: fix ioctl hangup race") made
uart_set_info() and uart_do_autoconfig() return -EIO when TTY_IO_ERROR
is set, so that they do not run on a port that has been hung up.

However, TTY_IO_ERROR is also set on a port that could not be started,
for example because its type is unknown, and by uart_shutdown(), which
both functions call. As of now, setserial cannot configure a port that
the kernel did not detect, and an autoconfig that follows a port, irq or
type change in the same setserial call fails on any port.

The issue can be reproduced with setserial (busybox) on a port without
a detected UART, for example ttyS3 of a QEMU guest:

    setserial /dev/ttyS3 uart 16550A
    setserial -g /dev/ttyS3

Before commit 8ca59f7baee7 ("serial: fix ioctl hangup race"), the
result is:

    /dev/ttyS3, UART: 16550A, Port: 0x02e8, IRQ: 3

After that commit, the result is:

    setserial: can't set serial info: Input/output error
    /dev/ttyS3, UART: unknown, Port: 0x02e8, IRQ: 3

This patch will check tty_port_active() in these two functions instead.
uart_hangup() clears it under the port mutex, and it stays set on an
open port that could not be started.

Fixes: 8ca59f7baee7 ("serial: fix ioctl hangup race")
Cc: stable@kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Tested-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261010034616.3915864-1-hengyul@cs.unc.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Kept the old mutex_lock_interruptible()/goto out locking in uart_do_autoconfig() instead of upstream's scoped_cond_guard(mutex_intr, ...), applying only the !tty_port_active(port) check change. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index eda883862fcdf..485efa863f38d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -816,7 +816,11 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
 	upf_t old_flags, new_flags;
 	int retval = 0;
 
-	if (!uport || tty_io_error(tty))
+	/*
+	 * TTY_IO_ERROR is also set on a port that could not be started, and
+	 * this is how such a port is configured. Only refuse a hung up port.
+	 */
+	if (!uport || !tty_port_active(port))
 		return -EIO;
 
 	new_port = new_info->port;
@@ -1149,7 +1153,8 @@ static int uart_do_autoconfig(struct tty_struct *tty, struct uart_state *state)
 		return -ERESTARTSYS;
 
 	uport = uart_port_check(state);
-	if (!uport || tty_io_error(tty)) {
+	/* As in uart_set_info(), only refuse a hung up port. */
+	if (!uport || !tty_port_active(port)) {
 		ret = -EIO;
 		goto out;
 	}
-- 
2.53.0



