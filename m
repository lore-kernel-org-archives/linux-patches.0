Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620407;
	b=lDzp6fuqWoyp/SJTDvzrDEGL71PmVP64elBlRya/v+jE5Enc1zFfEYkeuSKmv4a0PzXe
	 FLe2PrsSuw6IbKsvpbocxoEY4Q8KlKqsVahOkzUM4jPYzWcSuYxXKFOjpeVhs5xJqVhAX
	 XKw5VYgKNeBe3x3SQ2xxfRdIAGxuyvc23QZjM3rCnV6sxNF+DaAxzXGtcmxLd3itgjArZ
	 juAJsRNRmWYNzIewymCbYZTk9xNMz+U5UQeUwMNhqnvDtkDQwfX6kUBxR5vaZ55NfVa2W
	 RTWh/w6aQkBuCwuYW9J/00/qcY88SFiRIckbxVaywdteTN7WYuCpXTavdYzpZb9yrMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mOgU4htIni6yKgZwZY5A6kEvmMcb/kD3Pwx7Op+7/sA=;
	b=o/2LmDN0mWCXZmSL3MIaVIAcNJCGHj8/hBRvV5Gl6lWLQ8Pk8SWPH9nlgYHobZxoZaC/
	 2cn341w/YcYdprcxTfwqRNuveGRU74R4ezHaGzuWGjmFbwl8TAMmdj0EM5o2LHKR+Y7Uh
	 oAPpBldrZYDN8K0y/lTPuXScD557rsqbPzb6oq67LbV/dxV77FnKQGrdkKKmP4AhO+hiW
	 BtvbpP28LoLgG330Jl6KD+DcSZux54ZAJkzfZlCCIU1EuKLiq1ANY1xgzaYECwCWcInej
	 a/9fskovtPkfAqUg7/YeZK8W5I2A33VSRm9fQPpoh5JHN69rPr8iZTZ1lm6XIFSJi5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nccr3HRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6166A606A323;
	Wed, 25 Nov 2026 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nccr3HRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98401F000C6;
	Wed, 25 Nov 2026 15:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620407;
	bh=mOgU4htIni6yKgZwZY5A6kEvmMcb/kD3Pwx7Op+7/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nccr3HRoFAf9btHlWlV/HERJMfYLpUFu0Nj1UesHjHDA3mNdqeKbTBjkCxJ2yp3i/
	 DW3CH6wUe7gSYNQAJYs0oDQVsAgD8v6guKv7JE8OosjlYvN+UNNgxHfGH62KMlV1ky
	 BVYRsR9ga2dvUaBU0VVFFXbnhhX6BHmslguhNtDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shitalkumar Gandhi <shital.gandhi45@gmail.com>,
	Sherry Sun <sherry.sun@nxp.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 0907/1005] serial: fsl_lpuart: fix tty ref of wakeup event
Date: Wed, 25 Nov 2026 15:37:25 +0100
Message-ID: <20261125143842.940240306@linuxfoundation.org>
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

commit 0f0664a63efdfd70d1c555080781f4e8464445aa upstream.

To report a wakeup event, lpuart_resume_noirq() gets the tty with
tty_port_tty_get() and never puts it: each wakeup by the UART leaks a
reference, and the tty is not freed when it is closed.

With no_console_suspend, the function also gets there for a console
which is not open.  Then tty_port_tty_get() returns NULL, which is
dereferenced.

Fixes: 18bdfccf3c30 ("tty: serial: fsl_lpuart: Add missing wakeup event reporting")
Cc: stable <stable@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Frank Li <Frank.Li@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Shitalkumar Gandhi <shital.gandhi45@gmail.com>
Cc: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20261027-tty-llm-v1-18-99b0202ae546@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -3113,8 +3113,14 @@ static int lpuart_resume_noirq(struct de
 			/* check whether lpuart wakeup was triggered */
 			wake_active = stat & (UARTSTAT_RDRF | UARTSTAT_RXEDGIF);
 
-			if (wake_active && irqd_is_wakeup_set(irq_get_irq_data(sport->port.irq)))
-				pm_wakeup_event(tty_port_tty_get(port)->dev, 0);
+			if (wake_active && irqd_is_wakeup_set(irq_get_irq_data(sport->port.irq))) {
+				struct tty_struct *tty = tty_port_tty_get(port);
+
+				if (tty) {
+					pm_wakeup_event(tty->dev, 0);
+					tty_kref_put(tty);
+				}
+			}
 		}
 	}
 


