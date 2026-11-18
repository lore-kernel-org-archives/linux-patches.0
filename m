Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017005;
	b=usf7O2dAHLYJiCqn9tmjRgzM29dRC+c0YZXuVVnsiCTbbH94qeHB3Sle8/YsABFC2Xmc
	 eG96bJF9QU7hEZ0JNTOzSEWyiIy1DkuP6ozeM23g6/qIQNQVjV3seMcNEyQYI9tKEgz1O
	 rQZXQqNHZhxBk23ua3IUw3pRZistZx8flMdIn+Ei+FhFyrJ2R5Wdg7lP+oKK5dc7duJtO
	 C48GaIXE4aPBRj6e+knAP+rfBRWF/JlXmE9UNpGcIxrjcuooOcbLgx22QJDLnKG8qHhsw
	 bjX/hdvrsRPoQKcWZurHIGRmt2QjDsTmhIfggXDlPRhXZvm/os/sZqu/iN5iQbMkHqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9tInXJsEBwF2in+Smmk73UGboke9kNOAuIqtZQF0Pdw=;
	b=pmkmJqq7m2nldusoIPP4/bR/LRRJbRbdiAGZ5Tuvu+XGUW76ml14RhFz7/0CXx1ZqYao
	 gV6+etOG4BgJav3nu83PmN4gSfyod5PPC3Ln7mLTOOxZQojhCSBWdFeQdVQnT5YPf3Ooc
	 eP/FR4JpY/1M/I31Pp70H4aQxwSxtkWlLY55LkeB2LQn7owZKDF8USwd7uqMDwKz3Mz0+
	 jp/w/1FOmslD3jc+5Hm3fgGEuJUQiwEXGoAU9EI0kmZhd72B2iYGi73VDXsnOeattIeV/
	 r1SE3f7R+sge1UvSmmtOtvvrgeos2AVuBW2Mc54i2M+7i4zdBsOV8LvTt91APpH5ntw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxW1iWm5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6DF606A31C;
	Wed, 18 Nov 2026 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxW1iWm5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7B31F000C4;
	Wed, 18 Nov 2026 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017005;
	bh=9tInXJsEBwF2in+Smmk73UGboke9kNOAuIqtZQF0Pdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxW1iWm5mWeivQdARpiI/XBMzVpH4J2+pab/ZNn1wVDXiQ1mXU3cStsZp2Ixo2hkR
	 /CoEiwWIHosQNEaOIIDHarjSY2zKUXElSe8B+t2FnrBq+otXy5sMjgv/dbjO+BdOZS
	 gn3ElzxAb6nucPas4uGnQij9n5qxceWuhWJGBkUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tate Whiteberg <whiteberg@arista.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0729/2651] serial: 8250: export and rename wait_for_xmitr()
Date: Wed, 18 Nov 2026 15:32:49 +0100
Message-ID: <20261118150314.113247693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f197db78c60c2..cc7e1d76c2b82 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -180,6 +180,7 @@ void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p);
 void serial8250_fifo_wait_for_lsr_thre(struct uart_8250_port *up,
 				       struct nbcon_write_context *wctxt,
 				       unsigned int count);
+void serial8250_wait_for_xmitr(struct uart_8250_port *up, int bits);
 
 void serial8250_rpm_get(struct uart_8250_port *p);
 void serial8250_rpm_put(struct uart_8250_port *p);
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index c961b969021ec..434ba234eb9fb 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2024,7 +2024,7 @@ static bool wait_for_lsr(struct uart_8250_port *up, int bits)
 }
 
 /* Wait for transmitter and holding register to empty with timeout */
-static void wait_for_xmitr(struct uart_8250_port *up, int bits)
+void serial8250_wait_for_xmitr(struct uart_8250_port *up, int bits)
 {
 	unsigned int tmout;
 	bool tx_ready;
@@ -2052,6 +2052,7 @@ static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 		}
 	}
 }
+EXPORT_SYMBOL_NS_GPL(serial8250_wait_for_xmitr, "SERIAL_8250");
 
 #ifdef CONFIG_CONSOLE_POLL
 /*
@@ -2098,7 +2099,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	ier = serial_port_in(port, UART_IER);
 	__serial8250_clear_IER(up);
 
-	wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
+	serial8250_wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
 	/*
 	 *	Send the character out.
 	 */
@@ -2108,7 +2109,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	 *	Finally, wait for transmitter to become empty
 	 *	and restore the IER
 	 */
-	wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
+	serial8250_wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
 	serial_port_out(port, UART_IER, ier);
 }
 
@@ -2223,7 +2224,7 @@ static void serial8250_THRE_test(struct uart_port *port)
 	 * Synchronize UART_IER access against the console.
 	 */
 	scoped_guard(uart_port_lock_irqsave, port) {
-		wait_for_xmitr(up, UART_LSR_THRE);
+		serial8250_wait_for_xmitr(up, UART_LSR_THRE);
 		serial_port_out_sync(port, UART_IER, UART_IER_THRI);
 		udelay(1); /* allow THRE to set */
 		iir_noint1 = serial_port_in(port, UART_IIR) & UART_IIR_NO_INT;
@@ -3293,7 +3294,7 @@ static void serial8250_console_wait_putchar(struct uart_port *port, unsigned cha
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 
-	wait_for_xmitr(up, UART_LSR_THRE);
+	serial8250_wait_for_xmitr(up, UART_LSR_THRE);
 	serial8250_console_putchar(port, ch);
 }
 
@@ -3507,7 +3508,7 @@ void serial8250_console_write(struct uart_8250_port *up,
 	 *	Finally, wait for transmitter to become empty
 	 *	and restore the IER
 	 */
-	wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
+	serial8250_wait_for_xmitr(up, UART_LSR_BOTH_EMPTY);
 
 	if (em485) {
 		mdelay(port->rs485.delay_rts_after_send);
-- 
2.53.0



