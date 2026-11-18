Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017019;
	b=mPRL+DxuPVbBWvqcyj4Cg1KzNmANXS9So3qHskXGNrtwsREHI4eJh5+P/BSDvUwNSEtx
	 5cbjpelnthshCRDXxiffbok1af2laxCBWvQZ2PjQXkVBOLhNonenTOF4fSpmjuT7KQp0W
	 y5Jof5H/t72Oag+qiOc8EkWpHPpqnbfwenET/2H0USpXZZ8NvkbSuebKCUBJvOeQ4YNsO
	 fWg9xtq6xeN4qHEa7hxPQieMQJ7nzoEeARFs4DHfx9GETmmK4svFKLB5z59rrCylzyXSD
	 3UW6+EqTe4qzOt3QEVH7swH0lzYhROym+Poh2fu5CT776jDYxFBIgnZGhPMgF1VCx5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N61i34l2TV8RsmNECL9V8jTS8t8LxLwy8BVY/oZxIIg=;
	b=rcBQd7IpfQXIvr0e12lG1JM98ypRpQpdprMcQ+82lSms/7bWt9WvBpuciGFpS3XvoiS0
	 P807hh0prgI2Yco4UVz662Ad8z7hWc3sh6w6kScQzBwXOMXaB+S8h2Q/X/dV/8U24VORL
	 xDaguqIJ3hmQSKvXER0TICM6uOZwVmN49TZtvk1JfChMCOkkDmdNsVTUY34S+9gzxbMbA
	 uEdgITevaqdZmDQK1s2ai4l0jFt8dDsp+qo9FfFjVhSzMBFCcOwlE20si2MkAddk5vWJY
	 OIubyZfjbkVBG5Qm6825Oca1Z/SOOyjwnh5o7Dx8ztXomuCnw6B0ybkNNVxDJ19WouQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Yz5yfH+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88FF606A325;
	Wed, 18 Nov 2026 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Yz5yfH+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3501F000C4;
	Wed, 18 Nov 2026 15:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017019;
	bh=N61i34l2TV8RsmNECL9V8jTS8t8LxLwy8BVY/oZxIIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Yz5yfH+AXEKVmGQ93hrj6DFsbt6320GxYBDBuiZbDDvNOsHv3B0lVhp8OgeUmOma
	 tRwgPOvuBxVJ/BSUSFohsIkt43w69qZ9aSV/beLiNfwVG9nFSUUdKJgcvIWwFfFpn/
	 FbPOHW3i7xWuifmPtmY1c3fzVweaSyIHZt+eSBYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Crescent Hsieh <crescentcy.hsieh@moxa.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0733/2651] serial: 8250_mxpcie: take the line settings from the new termios
Date: Wed, 18 Nov 2026 15:32:53 +0100
Message-ID: <20261118150314.258539711@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit dda3502cf1838f806b90405a127ec2e66c885c9d ]

mxpcie8250_set_termios() reads the line settings out of
port->state->port.tty, which is only set once the port has been opened.

uart_set_options() builds a termios of its own and calls ->set_termios()
with no tty behind it, so using such a board as the console
(console=ttyS<n>) dereferences a NULL tty during console setup, as does
attaching kgdboc to it and resuming a suspended console from
uart_resume_port().

Read the settings from the termios the serial core passes in instead.
It holds the same values on the normal path - uart_change_line_settings()
passes &tty->termios - and it is what serial8250_do_set_termios() right
above already uses.

Fixes: 55edf8511f47 ("serial: 8250_mxpcie: enable automatic RTS/CTS flow control")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Tested-by: Crescent Hsieh <crescentcy.hsieh@moxa.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Crescent Hsieh <crescentcy.hsieh@moxa.com>
Link: https://patch.msgid.link/20260901041519.114737-4-lilinmao@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mxpcie.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mxpcie.c b/drivers/tty/serial/8250/8250_mxpcie.c
index ef2516ec16da0..19f1f51eec477 100644
--- a/drivers/tty/serial/8250/8250_mxpcie.c
+++ b/drivers/tty/serial/8250/8250_mxpcie.c
@@ -218,8 +218,6 @@ static void mxpcie8250_set_termios(struct uart_port *port,
 				   const struct ktermios *old)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
-	struct tty_struct *tty = port->state->port.tty;
-	unsigned int cflag = tty->termios.c_cflag;
 	u8 efr, val;
 
 	serial8250_do_set_termios(port, new, old);
@@ -229,23 +227,25 @@ static void mxpcie8250_set_termios(struct uart_port *port,
 	efr = serial_in(up, MOXA_PUART_EFR);
 	efr &= ~(MOXA_PUART_EFR_AUTO_RTS | MOXA_PUART_EFR_AUTO_CTS);
 
-	if (cflag & CRTSCTS) {
+	if (new->c_cflag & CRTSCTS) {
 		efr |= (MOXA_PUART_EFR_AUTO_RTS | MOXA_PUART_EFR_AUTO_CTS);
 		up->port.status |= (UPSTAT_AUTORTS | UPSTAT_AUTOCTS);
 	}
 	/* Set on-chip software flow control character */
-	serial_out(up, MOXA_PUART_XON1, START_CHAR(tty));
-	serial_out(up, MOXA_PUART_XON2, START_CHAR(tty));
-	serial_out(up, MOXA_PUART_XOFF1, STOP_CHAR(tty));
-	serial_out(up, MOXA_PUART_XOFF2, STOP_CHAR(tty));
+	serial_out(up, MOXA_PUART_XON1, new->c_cc[VSTART]);
+	serial_out(up, MOXA_PUART_XON2, new->c_cc[VSTART]);
+	serial_out(up, MOXA_PUART_XOFF1, new->c_cc[VSTOP]);
+	serial_out(up, MOXA_PUART_XOFF2, new->c_cc[VSTOP]);
 
-	val = I_IXON(tty) ? MOXA_PUART_EFR_RX_FLOW_XON1_XOFF1 : MOXA_PUART_EFR_RX_FLOW_DISABLED;
+	val = (new->c_iflag & IXON) ? MOXA_PUART_EFR_RX_FLOW_XON1_XOFF1 :
+				      MOXA_PUART_EFR_RX_FLOW_DISABLED;
 	FIELD_MODIFY(MOXA_PUART_EFR_RX_FLOW_MASK, &efr, val);
 
-	val = I_IXOFF(tty) ? MOXA_PUART_EFR_TX_FLOW_XON1_XOFF1 : MOXA_PUART_EFR_TX_FLOW_DISABLED;
+	val = (new->c_iflag & IXOFF) ? MOXA_PUART_EFR_TX_FLOW_XON1_XOFF1 :
+				       MOXA_PUART_EFR_TX_FLOW_DISABLED;
 	FIELD_MODIFY(MOXA_PUART_EFR_TX_FLOW_MASK, &efr, val);
 
-	if (I_IXOFF(tty))
+	if (new->c_iflag & IXOFF)
 		up->port.status |= UPSTAT_AUTOXOFF;
 
 	serial_out(up, MOXA_PUART_EFR, efr);
-- 
2.53.0



