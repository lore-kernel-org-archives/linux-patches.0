Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064882;
	b=g+lqE1CToJAHYUfUAm6lggZRgen3j0CophRr/8HtJzgiOKSA3jAlwQ+jj/twa8I+Z1Re
	 SClmazsBfgMF4cs9cdVLBTFQ79hGfcyw1qbVVh0pxzGusqT9q9YUJvzgEjF9ko034Psc0
	 oO/vsdxR969Q2BRDhCTyWOKfUqEWvN4ONen9pKtnEm5U9aH/CnVs4VwiqwvEHh2EezCzI
	 q6D+GTtbO9niFl0JuG3CC6RUBIUtKivSoFmhZTvlQu0UfmU09BtM4+a+atlXZQz3T6VkK
	 nJp+BDffFfDtciIfQjyH3ZGz2s4XK9ioYWQffusYKXd6wnb0KbyL6a1i1R1z+bT40eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SoVH8t/g3xL0j3N0YDwdK0Abyn5NxfKhvVqmzhP+s4w=;
	b=lepzDRLntDwd7mf8J9RKXJqIRTpuhPFdLv8Jn4Hla4/8+fGsGJKgyE2m+AoEwMWse0mz
	 1o87Em3tRpKtIyoLywuRQ0sJQ9uozTgCGN0QVtuArlwKg97FAQ2NQgi4wIDYv2kdlhNCB
	 6tT/SdeQsSMtZ3Ti9SY5jtvrf7nQkXcEAvTa9SqPb+ADhD3mhVDvRHxWnYRRaHqMCfX3q
	 vaE9yDJc0hz1LJ5WFbJXkWUYgGHuDdDZpzxlVN2EBw+XHQk9jtIiChcHk+moCA9pBhgJi
	 ExulBF8pvIN1p3AVmpWSDGKa8H6jiCe1RDdjHTX9kSMtui4LH7k8kuTYDC81agDvvTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pxEE/Ppv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0E8606CE59;
	Sat,  7 Nov 2026 15:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxEE/Ppv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532651F0089F;
	Sat,  7 Nov 2026 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064881;
	bh=SoVH8t/g3xL0j3N0YDwdK0Abyn5NxfKhvVqmzhP+s4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxEE/PpvItTFtduXdRDu18+M13AJQIZGZSdDGxy6rmPugdUy7nARSr+EruA94Gmrw
	 uTMfFME0EwtVk616PpzUXKBpqpTQuQw8SHcM9YJCOOs12AjVWtlZq516GYE8iTmRE+
	 5wT4UfyqDvtBySB8+2mjNnUncUZiJg/Up7icFta4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0756/1257] serial: amba-pl011: keep transmitter enabled when disabling RS485
Date: Sat,  7 Nov 2026 08:50:52 -0500
Message-ID: <20261107135000.167602574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 97f85204275ae4d7fb530e451f3acc65c1ec1155 ]

Disabling RS485 on an open port calls pl011_rs485_tx_stop(), which
turns off the transmitter. Only the RS485 TX path turns it back on, so
any later output stays queued and tcdrain() hangs until the port is
closed.

pl011_rs485_tx_stop() also checks only the hardware FIFO. If a DMA
transfer has started but has not filled the FIFO yet, the transmitter
is turned off under the transfer and the DMA channel never recovers.

When leaving RS485 mode, cancel pending deferred starts and stops, leave
the transmitter enabled and start any TX that was still waiting for
delay_rts_before_send.

Fixes: 8d479237727c ("serial: amba-pl011: add RS485 support")
Cc: stable@kernel.org
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261012-fix-pl011-rs485-txe-v2-1-e9bf7d218389@tipi-net.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index d57b39f58a9bf..c5e3b120060f9 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2399,8 +2399,31 @@ static int pl011_rs485_config(struct uart_port *port, struct ktermios *termios,
 	struct uart_amba_port *uap =
 		container_of(port, struct uart_amba_port, port);
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
+	if ((port->rs485.flags & SER_RS485_ENABLED) &&
+	    !(rs485->flags & SER_RS485_ENABLED)) {
+		bool tx_pending = uap->rs485_tx_state == WAIT_AFTER_RTS;
+		u32 cr = pl011_read(uap, REG_CR);
+
+		/*
+		 * Leaving RS485 mode, which only enables the transmitter while
+		 * sending. Don't stop it, as that stalls a DMA transfer still
+		 * in flight. Drop pending deferred starts and stops and keep
+		 * it enabled.
+		 */
+		hrtimer_try_to_cancel(&uap->trigger_start_tx);
+		hrtimer_try_to_cancel(&uap->trigger_stop_tx);
+		uap->rs485_tx_state = OFF;
+
+		cr |= UART011_CR_TXE | UART011_CR_RXE;
+		pl011_write(cr, uap, REG_CR);
+
+		/* Start TX that was still waiting for delay_rts_before_send */
+		if (tx_pending && !uart_tx_stopped(port) &&
+		    !pl011_dma_tx_start(uap))
+			pl011_start_tx_pio(uap);
+	} else if (port->rs485.flags & SER_RS485_ENABLED) {
 		pl011_rs485_tx_stop(uap);
+	}
 
 	/* Make sure auto RTS is disabled */
 	if (rs485->flags & SER_RS485_ENABLED) {
-- 
2.53.0



