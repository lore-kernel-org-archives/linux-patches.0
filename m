Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212914;
	b=N56ZkN2kWuJ/fYDbHILcbWmxigxaIPMwsDg/61AV2U15RVptmwNfvKtf0lVjmcnIoP+4
	 7egbfkZvqiGEl1TWKwr7dKbBJkwGcpHwarnMUaZXp+8hfSSFSE0fmnVrPV7tcZjn+f5Bv
	 Nups4Dcuz4rAZnyoxsBuV82js0v/+pPYI6YgRVnWNmP+50f8XxMobWQKPsugMuKZooZWG
	 UlVfWySwvZN2qgwUe3uT7asJSTyijfDm7nwJb0+5U2+Ww8dSs+6zm5CEBFLGW5J3X0yg6
	 9xkVRbze/JEhf5jz2mLXrT/M9OZm322uNhbzIxgyxVzxyIh3AIV1p0d4e0uldZItlVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sUifrdCEb0SqhtXe6gIWIAS0Nc4PcwWudFk2GEk9BKw=;
	b=HpWBkGQLboYvCRrQCbUuE1Rwr42RAdqA0o634y7pzjm4age3azPIyYBg+5sieiQGeSBv
	 eD369d52sPSrsro43jt5M+cQeCrRXkJMumDRXOH3Ctj3Erkz1CyX+WI23IiZ2yI9cvZ8h
	 cWt5Z1eYS1Zh8ebRbgfT2FM/h4adVknNhXkKlsJiZIaOu2JCPTKT0LmaK5YG2OAH/N+hl
	 Vh029rItJRe9GPxvQJRvniRu2r+lpwk3+TgUMs2NgRzRRWmpdKpQgg8htE3KAfOwSo60E
	 /rw4HWeUEQkiRUrihWvMHFyKYWFzX0Szrr3T0EG4RQAKNDxEj6Vq2E9rYz6XmfZGZ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJ2Aa4CA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5C560A2604;
	Wed, 28 Oct 2026 18:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJ2Aa4CA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5651F01825;
	Wed, 28 Oct 2026 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212913;
	bh=sUifrdCEb0SqhtXe6gIWIAS0Nc4PcwWudFk2GEk9BKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJ2Aa4CARp3UQ/L0UY8ecWR0lQTrgV98I9e4sWtylA5WwSbF1lTA+PRVX1TRf14qa
	 SSPTBLds4lx5HA6hOU6cH89XbzKj/qWtEBiPpmgp46rnUkDvWBMjO3stME6I5AGbqD
	 xGzVIm9ijCOkxRXW1QQXcIEpcUjBggZknamyuGHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Pemberton <wfp5p@virginia.edu>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0321/1887] USB: serial: ssu100: fix baud rate overflow
Date: Wed, 28 Oct 2026 17:40:17 +0100
Message-ID: <20261028170506.532997278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit afc235a217360c6859068d2e37a4df305c4d1be2 upstream.

The requested baud rate is incorrectly truncated to 16 bits so that
line speeds above 65535 bps cannot be set.

Use 32 bits for the rate and remainder while rejecting rates outside of
[50,460800] to avoid having the divisor or remainder overflow.

This issue was flagged by an LLM.

Fixes: 52af95459939 ("USB: add USB serial ssu100 driver")
Cc: stable@vger.kernel.org	# 2.6.36
Cc: Bill Pemberton <wfp5p@virginia.edu>
Assisted-by: LLM
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ssu100.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -34,6 +34,7 @@
 
 #define  SERIAL_EVEN_PARITY         (UART_LCR_PARITY | UART_LCR_EPAR)
 
+#define  MIN_BAUD_RATE              50
 #define  MAX_BAUD_RATE              460800
 
 #define ATC_DISABLED                0x00
@@ -219,9 +220,10 @@ static void ssu100_set_termios(struct tt
 {
 	struct usb_device *dev = port->serial->dev;
 	struct ktermios *termios = &tty->termios;
-	u16 baud, divisor, remainder;
+	speed_t baud, remainder;
 	unsigned int cflag = termios->c_cflag;
 	u16 urb_value = 0; /* will hold the new flags */
+	u16 divisor;
 	int result;
 
 	if (cflag & PARENB) {
@@ -237,6 +239,18 @@ static void ssu100_set_termios(struct tt
 	if (!baud)
 		baud = 9600;
 
+	if (baud < MIN_BAUD_RATE || baud > MAX_BAUD_RATE) {
+		if (old_termios)
+			baud = tty_termios_baud_rate(old_termios);
+		else
+			baud = clamp(baud, MIN_BAUD_RATE, MAX_BAUD_RATE);
+
+		tty_encode_baud_rate(tty, baud, baud);
+
+		if (!baud)
+			baud = 9600;
+	}
+
 	dev_dbg(&port->dev, "%s - got baud = %d\n", __func__, baud);
 
 
@@ -312,7 +326,7 @@ static int ssu100_open(struct tty_struct
 		dev_dbg(&port->dev, "%s - set uart failed\n", __func__);
 
 	if (tty)
-		ssu100_set_termios(tty, port, &tty->termios);
+		ssu100_set_termios(tty, port, NULL);
 
 	return usb_serial_generic_open(tty, port);
 }


