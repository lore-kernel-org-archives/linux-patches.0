Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064877;
	b=YACHc1VNtBIYliENXB/cSQMz6bwNsYMT52uxLqUbHBmh/h9EY2LLFSn+9pZ5PL2LE6gt
	 LFtXrMsZngcrbJDPrd+eWftY4QwRaB+U+JDzHD3MXD67dpGec33QQDx5DGWKJeJz8ETbD
	 CjrAh2VouUhdrhnp2miA3rt+aZ61i1lCIQnXNPEN5EQrxpRKHI/3tjAiU/alS2HAZjcV7
	 qDY0GKg5rO1zDgmFqKKOcECw0vKGFfxQP+WHEQbyrCe/bNPylkHBuhABrqchvOIqFjA0M
	 L5UeGMHKpRjV5cMulInBr8hc25RaWnzL2Y/rPTHjGOUSEmGnATe2L1mTQJrxodjjhuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=STB7SjjHyC1A/KoysiiYvAgaxgCTZ3jn06tdWnSIaDs=;
	b=SIf90ZSNgID7InfHvnihqZy4G71ag+Hk5eLFZGCIXsdiXgKJELOxDDm2zpAQ+fNWeViD
	 2mAcv6zw2UJkZzLy/01qeiAO1X/QyqvynkOq9hxTsEu8w6LPpLE9Z/irbkY1Mzrw1tBhl
	 wFmjaLoOAEfkGR+mJ1J+SvzvDK+jpoYIleb6murdspkZFiXFRg/C2TF4D0aHh1cJxWcG1
	 1yBUBasFua5kfUyrqAVIn3bxuVr8XQiXy8CSPaDGZauqKja+3qmgOetK9XSlyTbJ0Mrt+
	 jr1C1HJZk4qPn3ZddOFXE6Bc18pY8qDP5LQ7hOlNPHysKWru94wfkLwOlIzEReP5ZBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASZA3V39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9256606CE50;
	Sat,  7 Nov 2026 15:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASZA3V39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FDA1F008A1;
	Sat,  7 Nov 2026 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064876;
	bh=STB7SjjHyC1A/KoysiiYvAgaxgCTZ3jn06tdWnSIaDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASZA3V39awsZNyKTOKw7W6tEnBJ/kIiA2rkpq8qz6f9BrhxHNNxDk+Dz/coO4nPU3
	 y9Q4zV7m0kZIThpLdi0qvgQzQkUYJZg2Gf+7Po+5VnRCDw5lNoTmRxlg4XezFKoecX
	 +k2/vc7gsyBtuztJ2DEWMtV+j+cqb7O7W4dffnT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0753/1257] serial: 8250_omap: set priv->line before enabling the IRQ
Date: Sat,  7 Nov 2026 08:50:49 -0500
Message-ID: <20261107135000.084990984@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 8276a44f0a0b68c07b2331cc0058036ac4c4190d ]

omap8250_irq() is requested in omap8250_probe() with IRQ_NOAUTOEN and
enabled only in omap_8250_startup(). The handler obtains the port by
serial8250_get_port(priv->line), but probe stores priv->line only after
serial8250_register_8250_port() returns.

The port becomes visible to userspace already inside
serial8250_register_8250_port() (uart_add_one_port()). So it can be
opened -- and the IRQ enabled -- before probe stores the line. An
interrupt in that window makes the handler call
serial8250_get_port(-ENODEV) and dereference a pointer outside of
serial8250_ports[].

Store the line in omap_8250_startup() before enable_irq(), so the
handler never runs with an unset line. Keep the assignment in probe
too, as remove and the system PM callbacks rely on it even when the
port was never opened.

Fixes: fef4f600319e ("serial: 8250: omap: Fix life cycle issues for interrupt handlers")
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/3b3a642f7df2285f49a7bbbe5d1c23fa442c7d94.1791873876.git.jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index ceecb39fb82da..70252258344cd 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -711,6 +711,9 @@ static int omap_8250_startup(struct uart_port *port)
 	struct uart_8250_dma *dma = &priv->omap8250_dma;
 	int ret;
 
+	/* ISR and runtime PM need the line; probe sets it only after registration */
+	priv->line = port->line;
+
 #ifdef CONFIG_PM
 	up->capabilities |= UART_CAP_RPM;
 #endif
-- 
2.53.0



