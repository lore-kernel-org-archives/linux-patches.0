Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026343;
	b=pyEshnsqjt4EKI0CMSaLlr3sfOnlR6myPH/mN13eKxzDhNyGFMufKd87ybB4+rCeyKYD
	 JO17dpSRoNUqYf3pAHOT9Vu/d0V98U46pQdQd+jhAwA1F/bnwsPZ5pJdPqDO5LwplClM7
	 kZdJwvSA6C+y7fsF7Pq77WFu2G5bMnORepT0YMsjsvEQE1OF5A1BclUi8lqet2+rOopZQ
	 436end8+ba1uz5TorO1FAvzRxXfcB+wrWzm8J77/haTpRLfESJxdgaBMqmcX7s639uBct
	 4G063din+1mxfluTobhVsmys2ybF/XMWvwErYu1B80apUV2+/TzWUTL/KCe2RHSLB8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4UzPaRRR/u7N2sBJbVe8Qjo8DbQ6ZkG6GdoDgSV7RiI=;
	b=d2oxJoAisah7Vc5wL7Emm1+KiaKcLCQbEYCoJD1cXuC/O7PXzra0C3pVyQu8nc6niTxL
	 2kelrA2Tbx8w9pbmpsLwveVDXo3sR45Cy4tMUakHPmR1oqHs8GJuYq7Z9RW4rB36SPZGe
	 P3b+OFdNXc2wsRgHJpp8E8uPDZzJjU+zA0Xzp8qfs/+oH7iTOEJt9Owyvz7MxOJJUUgNB
	 F7+B/wcjYq+5lrnv1T7dxdmNkPag7UCBugj//fObYdqVtrEGkvz1ER3TgJU7Q+DbdBWGJ
	 KCGfAEa4RcHTkKPa1vb+Rarm534GF8D3w2+39twQRt/QtuAVYVii9akXNSIDDCJuLIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bqb6Fxcf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F091B606A320;
	Wed, 18 Nov 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bqb6Fxcf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0561F000C6;
	Wed, 18 Nov 2026 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026342;
	bh=4UzPaRRR/u7N2sBJbVe8Qjo8DbQ6ZkG6GdoDgSV7RiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bqb6FxcfiDhow6LvPAF6ur1svnAgUYrCJjYlivl0GNujWfVFuKNyFYAfVHK0JyvIq
	 LyH+ixAyQTwR3z3EBcWwB3Hkhqud1HfJfRAx7tCHh7AiCNL9EcfRFWRJUanwOGLlT1
	 qaI5kbMu+zBwfIei4zbwirKq4VwtUI7Rxzf6lsHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1401/2151] serial: max310x: dont clobber the TX break bit in set_termios
Date: Wed, 18 Nov 2026 15:52:16 +0100
Message-ID: <20261118150213.026304811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

[ Upstream commit 3b2de448ec0332c1cb8c38b4c5ff0c8e860befbc ]

A TX break asserted with TIOCSBRK ends early, with no error reported,
as soon as any termios change lands on the port: a break is a state
that must hold until TIOCCBRK, but max310x_set_termios() overwrites
the whole LCR register, and LCR also carries the TX break bit that
break_ctl() drives. No concurrency is required - a baud or parity
change from the same process ends the break just as well, and
break-led protocols lose their break with nothing in the logs.

Update only the LCR bits that are derived from termios and leave the
TX break and RTS pin control bits untouched. Since nothing clears a
break when a port is closed with the break still asserted - the tty
core sends no break-off on release, and the unconditional write here
was the accidental recovery - clear TXBREAK in startup(), the same way
8250 does.

Fixes: f65444187a66 ("serial: New serial driver MAX310X")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Link: https://patch.msgid.link/20261008-max310x-rs485-sw-delay-v8-1-6ba881f81e1f@vaisala.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -156,6 +156,8 @@
 #define MAX310X_LCR_FORCEPARITY_BIT	(1 << 5) /* 9-bit multidrop parity */
 #define MAX310X_LCR_TXBREAK_BIT		(1 << 6) /* TX break enable */
 #define MAX310X_LCR_RTS_BIT		(1 << 7) /* RTS pin control */
+/* LCR bits owned by termios; TX break and RTS are driven elsewhere */
+#define MAX310X_LCR_TERMIOS_MASK	GENMASK(5, 0)
 
 /* IRDA register bits */
 #define MAX310X_IRDA_IRDAEN_BIT		(1 << 0) /* IRDA mode enable */
@@ -941,8 +943,12 @@ static void max310x_set_termios(struct u
 	if (termios->c_cflag & CSTOPB)
 		lcr |= MAX310X_LCR_STOPLEN_BIT; /* 2 stops */
 
-	/* Update LCR register */
-	max310x_port_write(port, MAX310X_LCR_REG, lcr);
+	/*
+	 * Update LCR register. Leave the TX break bit alone: it is driven by
+	 * break_ctl(), and a whole-register write here would end a break in
+	 * progress.
+	 */
+	max310x_port_update(port, MAX310X_LCR_REG, MAX310X_LCR_TERMIOS_MASK, lcr);
 
 	/* Set read status mask */
 	port->read_status_mask = MAX310X_LSR_RXOVR_BIT;
@@ -1060,6 +1066,13 @@ static int max310x_startup(struct uart_p
 
 	max310x_power(port, 1);
 
+	/*
+	 * Clear a latched break: nothing clears TXBREAK when a port is
+	 * closed with a break still asserted, and set_termios() no longer
+	 * rewrites it.
+	 */
+	max310x_port_update(port, MAX310X_LCR_REG, MAX310X_LCR_TXBREAK_BIT, 0);
+
 	/* Configure MODE1 register */
 	max310x_port_update(port, MAX310X_MODE1_REG,
 			    MAX310X_MODE1_TRNSCVCTRL_BIT, 0);


