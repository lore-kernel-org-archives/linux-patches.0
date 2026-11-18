Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034813;
	b=1oiX26H2HgOiJRl9+FmmdEYW4d18dt32L3Tj1FQSFqdqpHodt494d/kIudzxFIcW7hz9
	 jSMFjh+4Z7my8/0AM2gj63TZKK0ezpTcIG9UuaBS2TmkAcjwynDYOsl8jyKmiG5oodBMd
	 L68tcJf8L4eto2HwB+wa5BZcm1Da7YjTUxDcaTZKRlQos478S/RjokbebPhAgt7UZn8x3
	 lan5DlVGEPW92MKQNLm2P7vbnjzHIHUjNyM/9PWJrvV9WP2Jch4nYwYKt3WixhPLrN3qe
	 dFBNxKAKFj7tLXh/qJjuceaKwcoQmV0JtI88Iv+JVp4LvuHsOq75Cg2jMSV8eiYpYFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yKYwvBu5vssCMi8H/n0kWTxlwE5moEJOBGFiXmZAnL4=;
	b=aZHBF1drgNE4wE4jKTfDrKfIsQ9653Lq4oLOh5nqheUdVHirfs0hatHPS7gZQVAubFWU
	 7R3c3j1+LChEyWiJS38Yb9re3FklKcyTptnQI4DwSzj7aPk0clOWhPM1dOPqqTOC5HH0W
	 BDKER7Q873N8c/9dHda0H+5tO2gYDCJCyYKsHe3v01dD9aajHDHj7RdqJ2cTgeruytPPb
	 ByZczfSzog18Syl6vpzVg2dBpWLbr0bnpK9u/XA2UPoVnO5Qn/885ZoQ7FzsgrpZN7HUJ
	 aKQmK90+uV0IdVyaomSKoZjhw03knRwPNbXVfW0XAMJ1Fnc4doInkv/+XwGkfPphzGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFiJvzCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B3A606A32F;
	Wed, 18 Nov 2026 20:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFiJvzCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC871F000C5;
	Wed, 18 Nov 2026 20:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034813;
	bh=yKYwvBu5vssCMi8H/n0kWTxlwE5moEJOBGFiXmZAnL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFiJvzChQGTwShAgLf3/0MgV006Q28ELsfuwJOBQXoxHiDBYsf9o5z8D2j5xCQ9Q8
	 Z6XhvfEBf+AkIDzg0nqywt99Xi5/VlGh/8HqXjiauWt9q3SHl9c4vYMG9YXYFJ+xCr
	 LXIzha9g8Tc8/E7IL++hr9BMWf8Pow5wBGHXNDdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kendall Willis <k-willis@ti.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0503/3318] serial: 8250_omap: fix wake irq cleared during suspend
Date: Wed, 18 Nov 2026 15:18:45 +0100
Message-ID: <20261118150332.164689134@linuxfoundation.org>
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

From: Kendall Willis <k-willis@ti.com>

[ Upstream commit 73f3e6ca7a6a7c952977c7c94f1c6dddebcafa34 ]

The wake irq was cleared in shutdown(), which runs during the suspend
sequence, making it impossible to wake the system via UART.
Move wake irq setup to probe() and teardown to remove() so the irq
remains armed during suspend when the UART is a wakeup source.

Cc: stable@kernel.org
Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
Signed-off-by: Kendall Willis <k-willis@ti.com>
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Link: https://patch.msgid.link/20260825-uart-wakeirq-fix-v2-1-0b9fba03d9b6@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Adjusted context for the older tree: startup uses pm_runtime_get_sync, shutdown uses spin_lock_irq, probe lacks the pinctrl block, and remove() returns int. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 8796d0525f356..b4df9c377b153 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -704,12 +704,6 @@ static int omap_8250_startup(struct uart_port *port)
 	struct uart_8250_dma *dma = &priv->omap8250_dma;
 	int ret;
 
-	if (priv->wakeirq) {
-		ret = dev_pm_set_dedicated_wake_irq(port->dev, priv->wakeirq);
-		if (ret)
-			return ret;
-	}
-
 	pm_runtime_get_sync(port->dev);
 
 	serial_out(up, UART_FCR, UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
@@ -782,7 +776,6 @@ static void omap_8250_shutdown(struct uart_port *port)
 	serial_out(up, UART_IER, 0);
 	spin_unlock_irq(&port->lock);
 	disable_irq_nosync(up->port.irq);
-	dev_pm_clear_wake_irq(port->dev);
 
 	serial8250_release_dma(up);
 	up->dma = NULL;
@@ -1572,6 +1565,12 @@ static int omap8250_probe(struct platform_device *pdev)
 
 	priv->wakeirq = irq_of_parse_and_map(np, 1);
 
+	if (priv->wakeirq) {
+		ret = dev_pm_set_dedicated_wake_irq(&pdev->dev, priv->wakeirq);
+		if (ret)
+			goto err;
+	}
+
 	ret = serial8250_register_8250_port(&up);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register 8250 port\n");
@@ -1582,6 +1581,7 @@ static int omap8250_probe(struct platform_device *pdev)
 	pm_runtime_put_autosuspend(&pdev->dev);
 	return 0;
 err:
+	dev_pm_clear_wake_irq(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	flush_work(&priv->qos_work);
@@ -1604,6 +1604,7 @@ static int omap8250_remove(struct platform_device *pdev)
 	omap_8250_shutdown(&up->port);
 	serial8250_unregister_port(priv->line);
 	priv->line = -ENODEV;
+	dev_pm_clear_wake_irq(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	flush_work(&priv->qos_work);
-- 
2.53.0



