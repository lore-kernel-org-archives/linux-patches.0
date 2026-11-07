Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063373;
	b=cogBRWHs988AN04QggzM2xfX0po/Fi4c7ghpHrqjtAeLk2sP9LVdx+vDauixOYCG2N5A
	 LTBHl4xHkQpBSFqH9AYYS/vS0YSUlUYGohN661HRo5WZAqRrRw5hdmNDGk/XCrabZj7Gz
	 nN7IL4dJ7t0yuH8JhnvYX+5f5+Z7b5rdU5kcrdLES8URXydyrNhYXkeBqV14VrANGF9PG
	 eCAOazmyRawRWYEuPblFsdMJuCsQsyoUVrKslO62lGUgZthM5oj0OofeSQoBP214eMKn1
	 fH+T49xhUydUxrhNgYOa+iqOdDORgQ2O+n6pJBleRkjH05Rge5KBBI0g8sRHrPVq9KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eEsKdYAliUj1efEUqNP/J6Rp7lytkmUTNKpyvAcLv+U=;
	b=PpwtPFIBOJfzGa8otLy+nRDOrGKMibe1eJNaeFzPCh7nv7ncB7fWXcJB4wxcJ1MJ2Xsa
	 ZFUI9k5XzQmtJlup//FXOV3cbwyMiwL1MYb6+wUGNVv28TOwVBrXA1UA38gs5rZqg3mOw
	 6mCFOi2PYJGUhxzBJ/3XY2liTT+ebtlAzUGpY8kmlO/a0XCxW7CjT44sfRdXOCcHUlawK
	 h3Su+s7lsBwCtYPm4nGKJsbUhZk9KEwT89arRZfqXDL4Bcv0Wm2s2bC3ivSYGiXhwa7IQ
	 ZdyANyok1XMFsRlWntLSlVMdeaYO7DURNtNlts/08VXM0dtDJ6Di/wAPmZ+oYq4Y1Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVSYFOCK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99553606D801;
	Sat,  7 Nov 2026 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVSYFOCK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417441F008A2;
	Sat,  7 Nov 2026 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063373;
	bh=eEsKdYAliUj1efEUqNP/J6Rp7lytkmUTNKpyvAcLv+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVSYFOCKMwsF5OC77NadOEAoSPm5GrWT4Q5xwfXQ70d8nxWrz1ncab2pIg1AVlR9D
	 fO1cwIFF7ZU/zKVCbGq6G/XG4zGWFtT14oLItRmjmg7HLB3MdVviiaEMkrNpCZmxAB
	 9UuxKAeoioMWi98PnaE5fhJnAnwZh9qbio/9UBNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 548/869] serial: 8250_omap: set priv->line before enabling the IRQ
Date: Sat,  7 Nov 2026 08:53:50 -0500
Message-ID: <20261107134911.960073259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index c0ffee2516142..8c48e0a26b3cb 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -727,6 +727,9 @@ static int omap_8250_startup(struct uart_port *port)
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



