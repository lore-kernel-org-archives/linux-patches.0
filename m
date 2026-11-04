Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831310;
	b=PKG8JyN5Q9vakvNbCH5nXj1ZEKybg3QatKTIJ78WwLbSzICs8gRrfYBaLEcF7Yvodroa
	 QzuDGty1khVPZ0udng8gaUOTFIoUoo+T6d0zyxqyOMG1KyYcJYG0vAG0pL/jjAPX93XpM
	 /l7Mn1q+GTZZPsfSuq/xu7BmeUWna0mUbwm9UL7jAs0gMhpREBnWXqXNaXqW/4s1O024c
	 WWSyRuWLi2mgkacYJ5885bpG2cF71AZcFaQG4YGU26wQoqBziuX0O2jdHBlOmQyvF1Qjf
	 I76aouq1RZL/Yu0Wu0JoF4BcLyn8DEhW75R0HXX4sxtGpXhJD+cuwkyJD2IxeoLeB4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=31/Yvkr4k42SY+LKft/NS19AZhms1xZKfoRkam+TLlo=;
	b=khAW4dldcG9vycDaUu1kIPYl9eTQaikielRmmoSAtWL8hGn5TEHX54RdxYTdHVanFO7K
	 JmbciSiplXaJGKK7DYIPdPNGMbsHyek2WGNSxTyFI9t/vsxz5n4dx6JzZQmQ9XO75fJLi
	 C2EujRSXCaUP6Hg6RuixcwlXY841DYJTUvX7XfiwSW9qyBpECB80Va6aQnuWmjxIbkT2C
	 Ael0lH7kDm0PpyHoZQKKVYIXkIeq2fvBSiidXEIaOiJCuAfh6OcEklVJ/ZXLjTuQCjUyU
	 RtKf8rCI9eu1uy0FcqIQyis0Cxlj74lR2vp4PoMujbl75WG6LbEuOlWcMO3VmqU2SUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpYj98m3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70000606B2F8;
	Wed,  4 Nov 2026 22:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpYj98m3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA641F00919;
	Wed,  4 Nov 2026 22:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831310;
	bh=31/Yvkr4k42SY+LKft/NS19AZhms1xZKfoRkam+TLlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpYj98m3SjWA0hIJXdrequQzyxNoh9DUTYOMreCmATyLBIeTYfjmSOg0vH4WQwnc7
	 u25lbOgIA/fkpbP1qfh/FJXEmnFLFCzF7+RhWIls3P0hi9YvxKJr7pBIfYPYSSmkm2
	 Fx8XhBq1AFK2IKgCviaTJlv7Jhl63UeV4QIMF6YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hengyu Liang <hengyul@cs.unc.edu>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0625/1005] serial: core: fix TIOCSSERIAL and TIOCSERCONFIG on uninitialised ports
Date: Wed,  4 Nov 2026 16:05:58 -0500
Message-ID: <20261104211101.312952653@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 80d1a1b0ba9c1..c12402effafe8 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -899,7 +899,11 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
 	upf_t old_flags, new_flags;
 	int retval;
 
-	if (!uport || tty_io_error(tty))
+	/*
+	 * TTY_IO_ERROR is also set on a port that could not be started, and
+	 * this is how such a port is configured. Only refuse a hung up port.
+	 */
+	if (!uport || !tty_port_active(port))
 		return -EIO;
 
 	new_port = new_info->port;
@@ -1151,7 +1155,8 @@ static int uart_do_autoconfig(struct tty_struct *tty, struct uart_state *state)
 	 */
 	scoped_cond_guard(mutex_intr, return -ERESTARTSYS, &port->mutex) {
 		uport = uart_port_check(state);
-		if (!uport || tty_io_error(tty))
+		/* As in uart_set_info(), only refuse a hung up port. */
+		if (!uport || !tty_port_active(port))
 			return -EIO;
 
 		if (tty_port_users(port) != 1)
-- 
2.53.0



