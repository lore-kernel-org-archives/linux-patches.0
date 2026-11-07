Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061421;
	b=mUGMT6AXrhrNvEnYidGgFol6LxirVpKuAexnkGZ4R7XI18RYOLlnvN4xHIWKL8SGhTTz
	 L+zY+vKWMiv9fBKL9L5D2DCvfYCSIyiIrGMpAj7Rwup7sp9Lv3vrCplWqN4/nmUZQvsCQ
	 BP+UPryqU5FmDNu1I0z8i1jeLlqiUnYyr8XLvpLeKXp5lYMkpX8JKdcuyuSpRwiRALFLL
	 kfCBqgyrqcTTpnEtmMS2MjUNCeQPp+OGhyVQeEL2zRfHJvhC0KLnGMv3LaNqexfPr2BpC
	 FRVB5ebU2C8FZ0L1LintxA80siI9DQhltpslHcHeXigfIj3EcscsD3I4McB5wjIfDFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z83p261aTKRC3vc7AOJ4O8yiKwS5mej76FiZHc6FENA=;
	b=aisLdLpT5Mv2o/76i5GOI5jlLqKKF1I6mOmC8xd5Kweze2krd2rneoQSSMGtv3W6sVkp
	 5iMoEtGmwuj9PJoj9FZuLxNg6ghcvRGdl5lm2B2OtSxJpnV8usanaAt/QUPX5I7M7SoI7
	 INucpiJcWRKbdKAzAK5EsNrcrYTaKHcI4LH8L/SkvqEf4JCkSpRtClju7RWSfPxMufq7m
	 jdgcuh/i1FlEJyfARMJ2fcH3yuDYBgt4rAXYGCCO0X6WvzzN+p/Kyeyqf1LkiA6AnW4TK
	 l0plRPXKTl4ZdzeBk/B2RolQ5pV5i7xHAL09XyO7XO5nWpmKNqDm96kfE4IZFXdVRWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ta5jbzfx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA9A606A32F;
	Sat,  7 Nov 2026 14:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ta5jbzfx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD6D1F0089F;
	Sat,  7 Nov 2026 14:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061421;
	bh=Z83p261aTKRC3vc7AOJ4O8yiKwS5mej76FiZHc6FENA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ta5jbzfxkXmKiItjMB0ifuWef9qQBndZb/a5T4+oQH1etZlL+BHPgLiGQPfyh13MI
	 fER8WIFNAlXA2Ggy9OcsZ2uL4AUwTyhLNVqafS3eUp7NDgNhEcBj13qL/EiqXYTe+x
	 MLYhiZfN8033tsZc6E+P3tM3PHYGDv72zJaDmD7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kendall Willis <k-willis@ti.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0532/1536] serial: 8250_omap: fix wake irq cleared during suspend
Date: Sat,  7 Nov 2026 08:42:28 -0500
Message-ID: <20261107135012.553933365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Kept the older pm_runtime_get_sync() and uart_port_lock_irq() code in the startup and shutdown hunks, since the guard/scoped_guard and UART_CAP_RPM context from upstream is missing here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 07b1918e35ec1..93a2414194f62 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -716,12 +716,6 @@ static int omap_8250_startup(struct uart_port *port)
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
@@ -794,7 +788,6 @@ static void omap_8250_shutdown(struct uart_port *port)
 	serial_out(up, UART_IER, 0);
 	uart_port_unlock_irq(port);
 	disable_irq_nosync(up->port.irq);
-	dev_pm_clear_wake_irq(port->dev);
 
 	serial8250_release_dma(up);
 	up->dma = NULL;
@@ -1602,6 +1595,12 @@ static int omap8250_probe(struct platform_device *pdev)
 
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
@@ -1612,6 +1611,7 @@ static int omap8250_probe(struct platform_device *pdev)
 	pm_runtime_put_autosuspend(&pdev->dev);
 	return 0;
 err:
+	dev_pm_clear_wake_irq(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	flush_work(&priv->qos_work);
@@ -1634,6 +1634,7 @@ static void omap8250_remove(struct platform_device *pdev)
 	omap_8250_shutdown(&up->port);
 	serial8250_unregister_port(priv->line);
 	priv->line = -ENODEV;
+	dev_pm_clear_wake_irq(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	flush_work(&priv->qos_work);
-- 
2.53.0



