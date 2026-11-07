Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064880;
	b=Gd9FpScDTpsLpt6QWj285GPwEkcXb23WJgJ3UICYSiAtuOBsqMynFMEZYc0gJKkEx++j
	 GZ2ddiZD3ciSnyxnRxuRxEezIgMy87mOdb289EkN8AdYe+tEzXBewO90ozLcFpoK73dlx
	 AEHOchSDyDjdV+LEkt+xF95vAmzDK4Q6jU6qG3bBo+ACz4V7OOHEPz43OD3NWtP19CJPY
	 Yyc1pA18+wQXJPkGODq5Xftstar3oEd5mtbgAfp9drjKmklLdA15v0aYqnW9XD6j1Pzqd
	 SIW8YJoI7XrJ+AsCh+aYwzNdVEpJXSEpbCCxketDI1DHzDXLY2ufIOm/ygxUBLVV27Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=63M5mS+jJrOedN/JHiFnZB7KnQ/cdYIYjLvRD6KLEn8=;
	b=ib06z8PjRi6qZb3JB58TgfCQsS+DiApsoygf1rKLdW3oEQZUea7jwoe9lVLd7FGJTGd/
	 JPbHNoSI+uHserBZ6NMMOCpF5dgpsD/6jh2fJWPbM297A3MJ8w/xVRIi4sfUQGUdEDQPD
	 3ug8bSNhlR627U0Bx7lYJ0lx2/LMGGOrGqjRGWAXyqohjCnF6M7A8v3zBKefkLUg0d0+2
	 aqnvojYqdSuICLKbYiXANOIBR+MgZfTULrwhVHd/Lmx8RWxuUl9qYub8EPIpXlN2qILEk
	 ROXhxH0ikCC2ATebNbzgjgl/qMmiAxo/OjUKbLzNRnSz23OMelo6MRiekmPAMAMXixg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGnkSCrX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAD7606CE59;
	Sat,  7 Nov 2026 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGnkSCrX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDC51F0089F;
	Sat,  7 Nov 2026 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064879;
	bh=63M5mS+jJrOedN/JHiFnZB7KnQ/cdYIYjLvRD6KLEn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGnkSCrXqjqPsaTQRNWSxlRLzlRJzEG3HLVrZXiI9KLSiCu5zhgfyLLzjBohpIB1/
	 b0yI/cidQuD/kYxcVC7u1i0grn2qZZh2FumoaI86P9CNY1URMmXNgooUfYs2cI7Nw1
	 jBtVolZ0FbTVZg4AYZCkzm1HbEz3+mLq3AdUHySw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0755/1257] serial: amba-pl011: honour delay_rts_before_send for every write
Date: Sat,  7 Nov 2026 08:50:51 -0500
Message-ID: <20261107135000.140628715@linuxfoundation.org>
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

[ Upstream commit 8a9750209596be35d109de5aa89623b049855c67 ]

While the driver waits out delay_rts_before_send, another write calls
pl011_start_tx() again. pl011_rs485_tx_start() then switches straight
to SEND, and the data goes out before the delay has passed.

Leave the start to the trigger_start_tx timer while it is pending.

Fixes: 2c1fd53af21b ("serial: amba-pl011: Fix RTS handling in RS485 mode")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261011-fix-pl011-rs485-rts-delay-v1-1-5078e61bc408@tipi-net.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index e67f2ac454b63..d57b39f58a9bf 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1420,10 +1420,6 @@ static void pl011_rs485_tx_start(struct uart_amba_port *uap)
 	struct uart_port *port = &uap->port;
 	u32 cr;
 
-	if (uap->rs485_tx_state == WAIT_AFTER_RTS) {
-		uap->rs485_tx_state = SEND;
-		return;
-	}
 	if (uap->rs485_tx_state == WAIT_AFTER_SEND ||
 	    uap->rs485_tx_state == WAIT_AFTER_SEND_DELAY) {
 		hrtimer_try_to_cancel(&uap->trigger_stop_tx);
@@ -1462,6 +1458,10 @@ static void pl011_start_tx(struct uart_port *port)
 
 	if ((uap->port.rs485.flags & SER_RS485_ENABLED) &&
 	    uap->rs485_tx_state != SEND) {
+		/* trigger_start_tx starts TX once delay_rts_before_send passed */
+		if (uap->rs485_tx_state == WAIT_AFTER_RTS)
+			return;
+
 		pl011_rs485_tx_start(uap);
 		if (uap->rs485_tx_state == WAIT_AFTER_RTS)
 			return;
@@ -1478,8 +1478,10 @@ static enum hrtimer_restart pl011_trigger_start_tx(struct hrtimer *t)
 	unsigned long flags;
 
 	uart_port_lock_irqsave(&uap->port, &flags);
-	if (uap->rs485_tx_state == WAIT_AFTER_RTS)
+	if (uap->rs485_tx_state == WAIT_AFTER_RTS) {
+		uap->rs485_tx_state = SEND;
 		pl011_start_tx(&uap->port);
+	}
 	uart_port_unlock_irqrestore(&uap->port, flags);
 
 	return HRTIMER_NORESTART;
-- 
2.53.0



