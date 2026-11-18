Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034882;
	b=SdvUQHP9Cqu1ozbzA1IppTOoi3GQIXBjoByZewgpvxyJLkR1wT4qVdcXFJKLLNwjQlcH
	 q3BaL01+49QqjqL+7MTpt+t/gT4P/hiEv+qQZvjI/ORc8KXVNEsOnix498sWJCrt4+H/o
	 BFcrH8O+hTGdGfczTgEfZX1c4t5yXRrtRogpU6ZZdXMqjWssdKNXaVanVpjMyY08gAfBk
	 i6aoUAIknElaXojoGPrXfmDczNq2R1PpczQb8eWZsjrZOe6WM5NhCLHmz5/cSGK784b2R
	 ANGjK8ZG7P3lOLvnd9EfkLTMh27eNRhKGVYiVJHl3a/NmsXC7n4yg/6Zsyz4rBrBAhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lzFvR4NOqjBQg2FKRDC7lTQE7cNLQMFo1oqg0EXXcKs=;
	b=kxCOJQFmazmzP/tTlcn7yrrqD0g+wxQ/Y0q01HqiEhrqoJQsnjipxTMEaxhfwLqniq0M
	 X80gTnHuxkVCJYFkNqYANthF3yh29LGPB6UIm31UZM/YOLRM6HdylDYUgDRM7NFK5C8tq
	 3F/JrPHargLxm/5EjOcL3QIFyFYIqs6euOiQ67LJOEOArFLwOb6wNalqW3leMi5rR7LdB
	 gr+xMtVP9vwvq0SgSAfP7DMqW05VYNyuwbNZQI7PClokAUOJ1TJJyrZ3pJUQ80aEwv+E7
	 lVDPwbfkGqF9opk2Dko2xKvcNO1aC2IRNlU01vNi9ZigmDLLF7e+0zPZXKo1IgH2OCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l3JjSZAL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FF7606A31C;
	Wed, 18 Nov 2026 20:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l3JjSZAL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFC71F000C4;
	Wed, 18 Nov 2026 20:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034882;
	bh=lzFvR4NOqjBQg2FKRDC7lTQE7cNLQMFo1oqg0EXXcKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3JjSZAL2s3AtLA3JFz2Eh5WzqDPTMoKxMa66kRFrr9k3iM4p9ePwn1Rg7WCVfIq4
	 Nqlm9pStdyikzzRpSXQOUvQzJW6g53BTupJpwWTE5IlJ9Co2wggabhD6mplgymGUGS
	 Pa0mmoyMNCE0/w+IGbmulFFES7F7nC0akouNGZHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tobias Gannert <tobias.gannert@ziehl-abegg.de>,
	Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>,
	David Laight <david.laight.linux@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0526/3318] serial: sc16is7xx: refill TX FIFO below trigger using fresh TXLVL
Date: Wed, 18 Nov 2026 15:19:08 +0100
Message-ID: <20261118150332.980385450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>

[ Upstream commit 527484911a40f6e84cf47e8bc490f7da61ab4151 ]

sc16is7xx_handle_tx() reads TXLVL once and sizes the hardware TX FIFO
write from that value. TXLVL reports free space in the hardware TX FIFO.

On this SPI-backed path, hardirq/softirq activity, RT scheduling, and
waiting for synchronous SPI transfers can delay the refill while the UART
continues draining. The TXLVL value can therefore become stale before the
hardware TX FIFO write completes.

One failing ftrace with the default 8-free-space trigger showed:

  tx_start       txlvl=9  txlvl_read_us=580
  tx_pre_write   sent=9   pre_write_us=16
  tx_segment     sent=9   seg_us=364
  tx_post_write  txlvl_before=9 sent=9 txlvl_after=12 pending_after=29
                 post_gap_us=12 post_txlvl_us=130

The driver read 9 free spaces and wrote 9 bytes to the hardware TX FIFO,
but the post-write TXLVL read still reported 12 free spaces while 29 bytes
remained queued in the xmit kfifo. Even allowing for the post-write read
window, the hardware TX FIFO had not been filled below the 8-free-space
trigger, so no new threshold crossing was expected.

The captured failing samples had the same pattern: data remained queued
in the xmit kfifo while post-write TXLVL remained above the hardware
trigger. The hardware TX FIFO then drained empty before another refill
was requested, producing an unintended gap on the wire.

Fix this by re-reading TXLVL after each hardware TX FIFO write while data
remains queued in the xmit kfifo. If TXLVL is still at or above the
trigger, top up the hardware TX FIFO again. Stop when the xmit kfifo is
empty or a TXLVL read confirms that hardware TX FIFO free space is
strictly below the trigger.

Stopping when TXLVL was equal to the trigger still allowed TX gaps in the
tested workload. Continuing until TXLVL was strictly below the trigger
eliminated the observed gaps caused by stale-TXLVL under-fill.

Program the hardware TX trigger explicitly through TLR using the same
constant as the refill-loop threshold. This prevents the software refill
condition from diverging from the programmed hardware trigger.

Tested on SC16IS752 over 1 MHz SPI on an i.MX6ULL single-core
PREEMPT_RT system, transmitting RS-485 at 115200 baud 8N1 under
continuous Modbus RTU load.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@kernel.org
Reported-by: Tobias Gannert <tobias.gannert@ziehl-abegg.de>
Link: https://lore.kernel.org/linux-serial/20260623112225.82386-3-paultyson.mbewe@ziehl-abegg.de/
Signed-off-by: Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>
Reviewed-by: David Laight <david.laight.linux@gmail.com>
Link: https://patch.msgid.link/20260930145628.566535-2-paultyson.mbewe@ziehl-abegg.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adapted the TX loop to use circ_buf helpers (uart_circ_empty, CIRC_CNT_TO_END) instead of kfifo calls, and kept the older comment text in the defines. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 46 +++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index ac2380978ae70..b208181de2455 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -242,6 +242,8 @@
 #define SC16IS7XX_TLR_TX_TRIGGER(words)	((((words) / 4) & 0x0f) << 0)
 #define SC16IS7XX_TLR_RX_TRIGGER(words)	((((words) / 4) & 0x0f) << 4)
 
+#define SC16IS7XX_TX_TRIGGER_LEVEL	8
+
 /* IOControl register bits (Only 750/760) */
 #define SC16IS7XX_IOCONTROL_LATCH_BIT	BIT(0)   /* Enable input latching */
 #define SC16IS7XX_IOCONTROL_MODEM_A_BIT	BIT(1)   /* Enable GPIO[7:4] as modem A pins */
@@ -692,6 +694,21 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 	tty_flip_buffer_push(&port->state->port);
 }
 
+static unsigned int sc16is7xx_txlvl(struct uart_port *port)
+{
+	unsigned int txlvl;
+
+	txlvl = sc16is7xx_port_read(port, SC16IS7XX_TXLVL_REG);
+	if (txlvl > SC16IS7XX_FIFO_SIZE) {
+		dev_err_ratelimited(port->dev,
+				    "chip reports %u free bytes in TX FIFO, but it only has %u\n",
+				    txlvl, SC16IS7XX_FIFO_SIZE);
+		return 0;
+	}
+
+	return txlvl;
+}
+
 static void sc16is7xx_handle_tx(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->state->xmit;
@@ -712,24 +729,25 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 		return;
 	}
 
-	/* Get length of data pending in circular buffer */
-	to_send = uart_circ_chars_pending(xmit);
-	if (likely(to_send)) {
-		/* Limit to size of TX FIFO */
-		txlen = sc16is7xx_port_read(port, SC16IS7XX_TXLVL_REG);
-		if (txlen > SC16IS7XX_FIFO_SIZE) {
-			dev_err_ratelimited(port->dev,
-				"chip reports %d free bytes in TX fifo, but it only has %d",
-				txlen, SC16IS7XX_FIFO_SIZE);
-			txlen = 0;
-		}
-		to_send = (to_send > txlen) ? txlen : to_send;
+	txlen = sc16is7xx_txlvl(port);
 
+	/* Handle circular buffer wrap-around by sending multiple segments */
+	while (txlen > 0 && !uart_circ_empty(xmit)) {
+		to_send = uart_circ_chars_pending(xmit);
+		to_send = min(to_send, txlen);
 		to_send = min_t(unsigned int, to_send,
 				CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE));
 
 		sc16is7xx_fifo_write(port, &xmit->buf[xmit->tail], to_send);
 		uart_xmit_advance(port, to_send);
+
+		if (uart_circ_empty(xmit))
+			break;
+
+		/* Refill below the trigger to enable the next THRI crossing. */
+		txlen = sc16is7xx_txlvl(port);
+		if (txlen < SC16IS7XX_TX_TRIGGER_LEVEL)
+			break;
 	}
 
 	uart_port_lock_irqsave(port, &flags);
@@ -1168,6 +1186,10 @@ static int sc16is7xx_startup(struct uart_port *port)
 			     SC16IS7XX_TCR_RX_RESUME(24) |
 			     SC16IS7XX_TCR_RX_HALT(48));
 
+	/* Sync hardware and software TX trigger levels */
+	sc16is7xx_port_write(port, SC16IS7XX_TLR_REG,
+			     SC16IS7XX_TLR_TX_TRIGGER(SC16IS7XX_TX_TRIGGER_LEVEL));
+
 	/* Disable TCR/TLR access */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG, SC16IS7XX_MCR_TCRTLR_BIT, 0);
 
-- 
2.53.0



