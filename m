Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620401;
	b=QqeOMvz1BEVoUKRqtw+vwzjxuFb8whSyYagm9V7NUgwuc8JqZY0KPcxs62VAhPukpn3d
	 RmFYkhIKGOO2QnxbVagwZF1DgHocVNzMr6MdtI+/Hd3HQ7iKOAwlo1/0SxPMmWfR0D+gn
	 7Zgv8deAXuFwCevQuTzt4NpoTa1Rs/gOeX1opVe2pOs2HkFbniaKeAb5IkoeF3AnLFQiJ
	 uE/k8MwP2WST44nvgBRzo4pLa/e3aC0fypaogTY2o5lDpVegeMK/Ti/3a6F5WLVhW6hcB
	 OveUQ2NJ0/BEBF8z/vvTvN3KxFobhu7loyiWtDzYScEijdR0vVhYSD3FEj7aQvbXRQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HEHSuxStyd+M0iGJD14feKPPtk3nfc0x9AsCj8zgVII=;
	b=yzW8NKBlFX0AuViydcgVD9qkJwWGTP6ecz/XWLZRT+XnfdC9zmc+tNFeyH10khaOBYzA
	 ealOEewrmw5hB0Zr3+jpJpLnpTJ22DQSy4FCukZ74iPu3/7uYmnZghrja/hm7SVgWUPQe
	 1V2grMkfEqL+8BC2tjKHBJtCsLMq6KBuzXbyF+gdX3eC1JjVO7abs9C8iyV55Y44jpD4A
	 slqtmyutmdbWrKp+kINkoTPSprS4V+9mrURqm2PIIjcsldyr+bzIe7hZ9lJnusiqR21kb
	 eaYeyVtQJ3yk/gV/RNvAZPNQCGZGgXYLX0HThFa9f0bx1ONKSkiOxjLuVtW5lr3NfZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueX5tDuQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C577D606A323;
	Wed, 25 Nov 2026 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueX5tDuQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D3F1F000C6;
	Wed, 25 Nov 2026 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620401;
	bh=HEHSuxStyd+M0iGJD14feKPPtk3nfc0x9AsCj8zgVII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueX5tDuQRRnFp39qw9bec5ct+l0DZFd7vaVbdv1d9NfSHvXTIBLx/21qzzjl4mc+5
	 dLV2bpSNX3g33k8W+GmTQnjVKnoAU6Vwb8LTubeWSeJRekxMWOQtPABx9cKtAHXuDd
	 z9dfreN4+BzbPas3nnNpvI8/krrl9STdlAQmZAHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Crescent Hsieh <crescentcy.hsieh@moxa.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linmao Li <lilinmao@kylinos.cn>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0905/1005] serial: 8250_mxpcie: handle hangup during break
Date: Wed, 25 Nov 2026 15:37:23 +0100
Message-ID: <20261125143842.890750813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 899e3c6e30ff34cf7a260b806fdedb56749e36e9 upstream.

Ending a software break on a Moxa PCIe port in RS-485 2-wire mode
dereferences a NULL tty pointer if the port was hung up while the break
was being sent.

send_break() calls ->break_ctl(tty, -1), sleeps for the break duration
and then calls ->break_ctl(tty, 0), without excluding a concurrent
hangup. A hangup (a modem DCD drop, or the session leader exiting while
another process of the session is in TCSBRK/TCSBRKP) runs uart_hangup(),
which shuts the port down and clears port->state->port.tty. The second
call still reaches mxpcie8250_software_break_ctl() through
uart_break_ctl(), which then does:

    struct tty_struct *tty = port->state->port.tty;
    ...
    baud = tty_get_baud_rate(tty);

with tty == NULL.

The bug was found by code inspection and has not been reproduced.

Fix by taking a reference to the port's tty with tty_port_tty_get() and
only restoring the divisor when a tty is still attached; a hung up port
is shut down, and the next open programs the divisor again through
set_termios().

Fixes: ade78d3d253c ("serial: 8250_mxpcie: add break support for RS485 using MUEx50 features")
Cc: stable <stable@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Crescent Hsieh <crescentcy.hsieh@moxa.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-17-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mxpcie.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_mxpcie.c
+++ b/drivers/tty/serial/8250/8250_mxpcie.c
@@ -411,7 +411,7 @@ static int mxpcie8250_handle_irq(struct
 static void mxpcie8250_software_break_ctl(struct uart_port *port, int break_state)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
-	struct tty_struct *tty = port->state->port.tty;
+	struct tty_struct *tty;
 	unsigned int baud, quot;
 	u8 sfr, tx_byte = 0x01;
 
@@ -438,9 +438,14 @@ static void mxpcie8250_software_break_ct
 
 		serial_out(up, UART_FCR, UART_FCR_CLEAR_XMIT);
 
-		baud = tty_get_baud_rate(tty);
-		quot = uart_get_divisor(port, baud);
-		serial8250_do_set_divisor(port, baud, quot);
+		/* A hangup during the break detaches the tty */
+		tty = tty_port_tty_get(&port->state->port);
+		if (tty) {
+			baud = tty_get_baud_rate(tty);
+			quot = uart_get_divisor(port, baud);
+			serial8250_do_set_divisor(port, baud, quot);
+			tty_kref_put(tty);
+		}
 		serial_out(up, UART_LCR, up->lcr);
 	}
 }


