Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019777;
	b=RdoAx52xbvB1A1YG+6Cc0g8qSKhavRRhpgNRdgWD7+L+f79XMVBxVfMRCrEFAl7lZuVl
	 WOz/1IYVTDuoh2RchEUBPR5IcbqfF4VxQHg9uGdCAX9jo9TjDhYhY9N3d+N108w3od5Be
	 CSNTCFbSJYofcI7Qby64xmr/rK1xRaLmdPgX5f0sBV24x4YPkWEM2Vds6WxYUz5FyIhlY
	 4xC+TdniekmW5EjN9S07DqNy1eKv9nZB/dPxVjjPp9/Q9T5LN3C36jtPkBP+HYe1YYNZ+
	 NpMaX6DO49sPT1W5i83y6PdGyXag4bAWGTDYW/Ra0wMecPYv69KTDLLfxZXR/x6z7Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ScoONw1HX67kR7fwNKqH2gn8F2oKALLNt8mOUZ+p2vo=;
	b=FG/cHg7D9B+yvj08/V0cUVLX850KfulZFAy6pNMPoyWxlA+ryWQbVQ+jMwY7aNRum8n6
	 Hys+kMZMasznFNOL2bgivnvuJDUDCHnjbAsgP0NedW4tjBTd+/1HmF77/jCJYxlyavkuM
	 Rqz0tQ5EZQNb/UoOE9ebOWGCOwhZYKHr1+AyoEWxj3t7m2C7KuIIq5j/XccpCBD8T+jqd
	 QIWD6232LJxLv9xyTHorbqx39iNlCRKpHCirI5PiWkMtEq1onSbKT3r8wxTPgVQ4vWs/g
	 yRGgZWYx1hkX5m64idahSZLoXDvwLvvONi/gb6FF8pr+tCQdc1XWpAL6bdniAL5EfoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9oh4B+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF5606A325;
	Wed, 18 Nov 2026 16:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H9oh4B+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3D51F000C4;
	Wed, 18 Nov 2026 16:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019777;
	bh=ScoONw1HX67kR7fwNKqH2gn8F2oKALLNt8mOUZ+p2vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9oh4B+eJ74gf6o7MhFrB7iPrZXnJ3nqhJtYV1G8xcS4D52/xFZEu26uG4KKU3bGx
	 V+ZWy7ghtUNG8Ajg/asKWnrSLFaNtKQ/wNDgx86fwqOsNOxzz47qiglX0BmnYudtLN
	 quaus6JmrOEGQQoXNEL7yw7exMkxumR0AeprdORo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1718/2651] serial: max310x: fix RS485 delays being programmed as bit-times
Date: Wed, 18 Nov 2026 15:49:18 +0100
Message-ID: <20261118150349.480326808@linuxfoundation.org>
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

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit 7784d6aee59a142505072b3fbea97932b2fd1fa0 ]

The HDPIXDELAY register counts the RTS setup and hold delays in
bit-times, four bits per direction, but the driver has been writing the
struct serial_rs485 delay_rts_before_send/delay_rts_after_send values
into it unconverted - and the uapi expresses those in milliseconds. A
requested 9 ms setup delay is programmed as 9 bit-times, which at 9600
baud is 0.94 ms, roughly a tenth of what userspace asked for; the error
grows with the baud rate.

Cache the baud rate in set_termios() and convert the delays to
bit-times at the current rate, rounding up so the delay on the wire is
never shorter than requested, and capping at the 15 bit-times the
4-bit field can hold. The conversion lives in
max310x_set_rts_ctl_params(); set_termios() now calls it as well,
since the conversion depends on the baud rate.

The delays a 4-bit bit-time field can represent still fall well short
of the milliseconds the uapi can express; requests beyond 15 bit-times
are capped, and the -ERANGE rejection of values above 15 ms remains in
place for now.

Fixes: 55367c620aed ("serial: max310x: Add support for RS-485 mode")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-4-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -163,6 +163,10 @@
 #define MAX310X_IRDA_IRDAEN_BIT		(1 << 0) /* IRDA mode enable */
 #define MAX310X_IRDA_SIR_BIT		(1 << 1) /* SIR mode enable */
 
+/* HDPIXDELAY accessor macros */
+#define MAX310X_HDPIXDELAY_SETUP(val)	(((val) & 0x0f) << 4)
+#define MAX310X_HDPIXDELAY_HOLD(val)	((val) & 0x0f)
+
 /* Flow control trigger level register masks */
 #define MAX310X_FLOWLVL_HALT_MASK	GENMASK(3, 0) /* Flow control halt level */
 #define MAX310X_FLOWLVL_RES_MASK	GENMASK(7, 4) /* Flow control resume level */
@@ -296,6 +300,7 @@ struct max310x_one {
 	struct work_struct	md_work;
 	struct work_struct	rs_work;
 	struct regmap		*regmap;
+	unsigned int		baud;
 	bool			tx_break;	/* break_ctl() owns the transceiver */
 
 	u8 rx_buf[MAX310X_FIFO_SIZE];
@@ -937,23 +942,33 @@ static void max310x_set_mctrl(struct uar
 }
 
 /*
- * Program the chip's RS485 RTS timing (HDPIXDELAY) and the auto
- * transceiver control (MODE1) from the current configuration. The
- * rs485-config worker, startup() and break_ctl()'s break-off restore
- * each carried their own copy of this sequence.
+ * Program the chip's RS485 RTS timing. The HDPIXDELAY setup and hold fields
+ * count bit-times, four bits per direction, while the uapi expresses the
+ * delays in milliseconds: convert at the current baud rate, rounding up, and
+ * cap at the field maximum.
  */
 static void max310x_set_rts_ctl_params(struct max310x_one *one)
 {
+	const unsigned int max_bit_dly = 15;
 	struct uart_port *port = &one->port;
-	unsigned int delay;
+	unsigned int setup = 0, hold = 0;
 	u8 mode1 = 0;
 
-	delay = (clamp(port->rs485.delay_rts_before_send, 0U, 15U) << 4) |
-		clamp(port->rs485.delay_rts_after_send, 0U, 15U);
-	max310x_port_write(port, MAX310X_HDPIXDELAY_REG, delay);
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		/* Convert milliseconds to bit-times, rounding up. */
+		setup = DIV_ROUND_UP(one->baud * port->rs485.delay_rts_before_send,
+				     MSEC_PER_SEC);
+		hold  = DIV_ROUND_UP(one->baud * port->rs485.delay_rts_after_send,
+				     MSEC_PER_SEC);
+		setup = min(setup, max_bit_dly);
+		hold  = min(hold,  max_bit_dly);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
 		mode1 = MAX310X_MODE1_TRNSCVCTRL_BIT;
+	}
+
+	max310x_port_write(port, MAX310X_HDPIXDELAY_REG,
+			   MAX310X_HDPIXDELAY_SETUP(setup) |
+			   MAX310X_HDPIXDELAY_HOLD(hold));
 
 	/*
 	 * A break owns the transceiver: break_ctl() disabled auto-RTS and
@@ -1109,6 +1124,13 @@ static void max310x_set_termios(struct u
 
 	/* Update timeout according to new baud rate */
 	uart_update_timeout(port, termios->c_cflag, baud);
+
+	/*
+	 * Cache the new baud rate and reprogram the RS485 RTS delays, whose
+	 * millisecond-to-bit-time conversion depends on it.
+	 */
+	to_max310x_port(port)->baud = baud;
+	max310x_set_rts_ctl_params(to_max310x_port(port));
 }
 
 static void max310x_rs_proc(struct work_struct *ws)


