Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831325;
	b=Wb0azO/TxIkZHnppj7hbDvHPxGJai5hAC8ybWVcEtu0EGwZFphsVdSDGBingATz4+lTA
	 sevgFWTLGWCdkN4INF8wNbPJovyrEZjxW263XrgrFJxJ8+svbkwnpioipxDFzKtn2itmV
	 +u3ZEn6X8wmQmqfGaHlcQ+X81i0BzZGPsIXbnW0AtvrtAUvVC9cocsVMygcGWR57Gn1tU
	 SmANor/DPwi77WhjV/tTG/EC01npVk7BMjfuvtEg0QRG5XlReZUfB93JU4wWqaxHx6Jzx
	 TNEF3DFTbcazG7Wuig6tlAEFQWb0gHtvZRADpnLTEJ2oNcsj81BWua6AI1wQV8uEaVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1V2k14NY4HEgpES8f+csF4nFrB78c3bkRL1aIEh/So=;
	b=UvmFiSG7XcHrqrJAQ5JNuX7ZuanBiN1AnFWQxZLxEM+wR3qRXruE6dNkrRG4clwHMnH+
	 4ZXufqggXP8larwDlKUDFMLM44lBkHQqpBts1BLKXVUGLgRsNJS7164aic7AChGIas9RG
	 4UzjddHulT3b1OVRPzKGBfJPoHtmGap3ieS1TjvbTT37rxBNBZ3YKe0CRJXlnllBl6R44
	 JskJZM8ToAwIa3KA8gbekO0FDcdIdB3kgvIRdTTBWkXRM8rBdCPKeWAn0OxvPG4XKz1e7
	 G8Lt/QQb2bO1tKmcgFj3zoZ0ZDbwd2c+sQXNrvDTf8BzuDRSWvcjMy1ZMwOU2qr7n/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0/YdOxWM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8C8606A33A;
	Wed,  4 Nov 2026 22:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0/YdOxWM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2D21F000C1;
	Wed,  4 Nov 2026 22:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831324;
	bh=N1V2k14NY4HEgpES8f+csF4nFrB78c3bkRL1aIEh/So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/YdOxWMmeeQaHntrd1V4G2SrTK9cNPd0+XSZpmxHNqjzyuiztpVFcVJ5IhVwYLfT
	 dtttHmMv6owU2jDni6s6Zt/CGDxImu//v77VBXl8pRGqhqtdpLnUGteUen/1TLtkmy
	 oWg+QURxwGlP1U8unJCwuqAsGUcjLt4iX0Gl/O7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0596/1005] serial: serial_core: simplify uart_ioctl() returns
Date: Wed,  4 Nov 2026 16:05:29 -0500
Message-ID: <20261104211100.553208280@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit f374a33e90e6cc17b05629636e68a012dc8347ed ]

Neither uart_do_autoconfig(), nor uart_wait_modem_status() can return
-ENOIOCTLCMD. The ENOIOCTLCMD checks are there to check if 'cmd' matched
against TIOCSERCONFIG, and TIOCMIWAIT respectively. (With 0 or error in
'ret', it does not matter.)

Therefore, the code can simply return from the TIOCSERCONFIG and
TIOCMIWAIT spots immediately.

To be more explicit, use 'if' instead of switch-case for those single
values.

And return without jumping to the 'out' label -- it can be removed too.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://patch.msgid.link/20251119100140.830761-10-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8ca59f7baee7 ("serial: fix ioctl hangup race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 35 ++++++++------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 593f15213b72c..5b6d4d67beabe 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1564,37 +1564,20 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 	void __user *uarg = (void __user *)arg;
 	int ret = -ENOIOCTLCMD;
 
-
-	/*
-	 * These ioctls don't rely on the hardware to be present.
-	 */
-	switch (cmd) {
-	case TIOCSERCONFIG:
+	/* This ioctl doesn't rely on the hardware to be present. */
+	if (cmd == TIOCSERCONFIG) {
 		down_write(&tty->termios_rwsem);
 		ret = uart_do_autoconfig(tty, state);
 		up_write(&tty->termios_rwsem);
-		break;
-	}
-
-	if (ret != -ENOIOCTLCMD)
-		goto out;
-
-	if (tty_io_error(tty)) {
-		ret = -EIO;
-		goto out;
+		return ret;
 	}
 
-	/*
-	 * The following should only be used when hardware is present.
-	 */
-	switch (cmd) {
-	case TIOCMIWAIT:
-		ret = uart_wait_modem_status(state, arg);
-		break;
-	}
+	if (tty_io_error(tty))
+		return -EIO;
 
-	if (ret != -ENOIOCTLCMD)
-		goto out;
+	/* This should only be used when the hardware is present. */
+	if (cmd == TIOCMIWAIT)
+		return uart_wait_modem_status(state, arg);
 
 	/* rs485_config requires more locking than others */
 	if (cmd == TIOCSRS485)
@@ -1642,7 +1625,7 @@ uart_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 	mutex_unlock(&port->mutex);
 	if (cmd == TIOCSRS485)
 		up_write(&tty->termios_rwsem);
-out:
+
 	return ret;
 }
 
-- 
2.53.0



