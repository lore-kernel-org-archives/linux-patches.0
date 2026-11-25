Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622409;
	b=S5Fl6qfXxj2XJfE6o9T8Vl6zceY59BeF7gww8Iqd57Xr/aastjKZTahc0OAhKvZGuHh3
	 TGVBapg5V7Kpttt0UWihJ3fXTX6IgzGtiYcjEGgY7BFJoX0ytEHSn/ELFTM9axvNX/miZ
	 9SvEegvanGXDHsSeduXE49GHnGA9RzAXuGgkTbrOJAlbca65qsi47r9C+s0U7no6Fw41W
	 lAT67vOtfcacpjOrmqCatGUGTxG2GLwRRnKkRRMr3E24hWNn9rCDyy0KUis6bV2wYpaLm
	 w2ZZIft0qwRW5kjYEyZH8p1uReirmS/F1VTpQeY74syxp822zjIO42aPj94emD1Tvfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RIrwrhHTT++JUmE7jCA/1KRPwWT67w1r8M4U5Yd/P5Q=;
	b=fQGPypRha3aUjDEfEHMkGHSS8S67EVuhnpsgOctBpRip/AaTQ1uuc7Rk/2Mb6NWKMxfT
	 NeWXUHPw+y0hsWCBgOLjDz/zJJiO891r//cPpwnkKchijUbUu9dmNQmqZF74JFvmmS0NM
	 lYtRD6Ehg8SqtxfUYJn2LpW0klEFaucjQZK8aY4Av70ck7ozY5TmleDNnLh13yqx8CO4o
	 HDLIkC7Z2lq0X9qMar4QsqrVFEMO2FupH+mqt0D7sQlmYXZK1eRjNhZY0NKjD/t29Wn2L
	 27vCPdVhd6ocqicb2jjpjsTnjVdDC3UiOh8qcxwbBdfawSZXNOCs5m1FrAsFo1y8Y9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmZdhrz9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557CB606A331;
	Wed, 25 Nov 2026 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmZdhrz9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C911F000ED;
	Wed, 25 Nov 2026 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622408;
	bh=RIrwrhHTT++JUmE7jCA/1KRPwWT67w1r8M4U5Yd/P5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmZdhrz9VWkmi4FDC8TX8W3G0Uf0256cECZaGl5xlPJUMicgfCC7r3MX0fSd9yhm8
	 FQMOy/77AvmU8BMOeHzDfgHMm+c4ejKaJYC7kEoaqsatK28M71t1dq3NAkk3vkZqBI
	 ERAMrOWPEpAV1czzFPb55qQjFjTPUq/LpMY1cRdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tate Whiteberg <whiteberg@arista.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 527/990] serial: 8250: export and rename wait_for_xmitr()
Date: Wed, 25 Nov 2026 15:31:34 +0100
Message-ID: <20261125143834.437826332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Tate Whiteberg <whiteberg@arista.com>

[ Upstream commit 2c5942fd0300cb966339dd0366890be626b405e8 ]

Export wait_for_xmitr() and rename it to follow naming convention.

Signed-off-by: Tate Whiteberg <whiteberg@arista.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Link: https://patch.msgid.link/20260831165911.2029839-2-whiteberg@arista.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1c305d5f1daa ("serial: 8250_mid: wait for LSR tx empty before setting termios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250.h      |  1 +
 drivers/tty/serial/8250/8250_port.c | 13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 0076eb28661cb..e1feed8b4d510 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -188,6 +188,7 @@ static unsigned int __maybe_unused serial_icr_read(struct uart_8250_port *up,
 void serial8250_clear_fifos(struct uart_8250_port *p);
 void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p);
 void serial8250_fifo_wait_for_lsr_thre(struct uart_8250_port *up, unsigned int count);
+void serial8250_wait_for_xmitr(struct uart_8250_port *up, int bits);
 
 void serial8250_rpm_get(struct uart_8250_port *p);
 void serial8250_rpm_put(struct uart_8250_port *p);
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 455d55827ada1..4f50e83254f87 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1993,7 +1993,7 @@ static bool wait_for_lsr(struct uart_8250_port *up, int bits)
 }
 
 /* Wait for transmitter and holding register to empty with timeout */
-static void wait_for_xmitr(struct uart_8250_port *up, int bits)
+void serial8250_wait_for_xmitr(struct uart_8250_port *up, int bits)
 {
 	unsigned int tmout;
 
@@ -2017,6 +2017,7 @@ static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 		}
 	}
 }
+EXPORT_SYMBOL_NS_GPL(serial8250_wait_for_xmitr, "SERIAL_8250");
 
 #ifdef CONFIG_CONSOLE_POLL
 /*
@@ -2060,7 +2061,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	ier = serial_port_in(port, UART_IER);
 	serial8250_clear_IER(up);
 
-	wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
+	serial8250_wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
 	/*
 	 *	Send the character out.
 	 */
@@ -2070,7 +2071,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	 *	Finally, wait for transmitter to become empty
 	 *	and restore the IER
 	 */
-	wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
+	serial8250_wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
 	serial_port_out(port, UART_IER, ier);
 }
 
@@ -2185,7 +2186,7 @@ static void serial8250_THRE_test(struct uart_port *port)
 	 * Synchronize UART_IER access against the console.
 	 */
 	scoped_guard(uart_port_lock_irqsave, port) {
-		wait_for_xmitr(up, UART_LSR_THRE);
+		serial8250_wait_for_xmitr(up, UART_LSR_THRE);
 		serial_port_out_sync(port, UART_IER, UART_IER_THRI);
 		udelay(1); /* allow THRE to set */
 		iir_noint1 = serial_port_in(port, UART_IIR) & UART_IIR_NO_INT;
@@ -3245,7 +3246,7 @@ static void serial8250_console_wait_putchar(struct uart_port *port, unsigned cha
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 
-	wait_for_xmitr(up, UART_LSR_THRE);
+	serial8250_wait_for_xmitr(up, UART_LSR_THRE);
 	serial8250_console_putchar(port, ch);
 }
 
@@ -3386,7 +3387,7 @@ void serial8250_console_write(struct uart_8250_port *up, const char *s,
 	 *	Finally, wait for transmitter to become empty
 	 *	and restore the IER
 	 */
-	wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
+	serial8250_wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
 
 	if (em485) {
 		mdelay(port->rs485.delay_rts_after_send);
-- 
2.53.0



