Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044128;
	b=GT0KNMIqgmF4jPme8793qs+rUm62KKwlIfgIbhDGpvTn+j4o0EriYXczNBwZcUdiEBVa
	 bvPMzBgpHYNieF0gCe6bD4FTLc0vtfFMVfTBi6vMMgBLiEPQzGgM0AQur61qT+QcRTqWx
	 CmUMcOhHLCcMG8TpuzaHa3Ynn/I0g3634Xml/w3YArl6nxC7+b5JgzpVdBzgaP6R675n7
	 ZrxTtvnYZT4nT5RRGMYE70UbKNuG9MuQ/Jghyv5Hx/tqyLa8oMzry61LAIq+CbFxcEK1b
	 ts3vRMqMruYus17tCIOsIgYdrWem3Mn+ogEiEG1tptvJDNapGVq6GEeHRed90ppTw/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=72AsFpUPhhFqBdzvASuPLNosvMj0YJiUt+cmOXDS/Mk=;
	b=OyFRhnCdnUkCMtUY+mAAiZXT+N81lGqLRVREjrWm0anT0oJn6mLDvhL0MxLdhCcgxx0V
	 deTLmHf1rXJLeqEyX+y9HlAmORnJ+NBtjxgpxOTAnsCIbXrT+UgAGYvlP+YJJEITH/cxU
	 96s493uOUmAAtTWQn9AqHw6+X3NIcfknnwktTX1Nx729YsK164lkyP9Ius5YQDohHNOZM
	 EWIRnfeqPiiXAdkBdheKxPs/JuGOBEiegTv+EIpg/ilU2Axy65y8dRZ/oZzQir2XobpZW
	 7A/L226Uua2koe0cYlHS+IE4PCTCf3XEPiWQWGCl0kyRPIdaR10tlmNA1iccnDrt+ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQEvBLRI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2602606A31C;
	Wed, 18 Nov 2026 23:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HQEvBLRI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7DC1F000C5;
	Wed, 18 Nov 2026 23:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044128;
	bh=72AsFpUPhhFqBdzvASuPLNosvMj0YJiUt+cmOXDS/Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQEvBLRIXF0mvHS8dBy8a4q2CHh+rqLU1H+pn8/QTMhtHbvJ1ID8RRUg9AUUmOzDH
	 mM5txOzk0ES0GdXtm28FtJ9FcL5Bq4torvVZLnCLgpde2xtI2+SjJUMWBV6eRAiToD
	 orELVPn3G8vWqg82tLGVYgIKHjbAb17F2xuMAfzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kendall Willis <k-willis@ti.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0455/2857] serial: 8250_omap: fix wake irq cleared during suspend
Date: Wed, 18 Nov 2026 15:24:49 +0100
Message-ID: <20261118150217.807361375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted to the older file by moving the wake-irq setup into probe just before port registration, and also dropped the wake-irq clear from the startup error path, which upstream context lacks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 830446a776d89..39c9d496a3f12 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -685,12 +685,6 @@ static int omap_8250_startup(struct uart_port *port)
 	struct omap8250_priv *priv = port->private_data;
 	int ret;
 
-	if (priv->wakeirq) {
-		ret = dev_pm_set_dedicated_wake_irq(port->dev, priv->wakeirq);
-		if (ret)
-			return ret;
-	}
-
 	pm_runtime_get_sync(port->dev);
 
 	serial_out(up, UART_FCR, UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
@@ -740,7 +734,6 @@ static int omap_8250_startup(struct uart_port *port)
 err:
 	pm_runtime_mark_last_busy(port->dev);
 	pm_runtime_put_autosuspend(port->dev);
-	dev_pm_clear_wake_irq(port->dev);
 	return ret;
 }
 
@@ -775,7 +768,6 @@ static void omap_8250_shutdown(struct uart_port *port)
 	pm_runtime_mark_last_busy(port->dev);
 	pm_runtime_put_autosuspend(port->dev);
 	free_irq(port->irq, port);
-	dev_pm_clear_wake_irq(port->dev);
 }
 
 static void omap_8250_throttle(struct uart_port *port)
@@ -1468,6 +1460,13 @@ static int omap8250_probe(struct platform_device *pdev)
 		}
 	}
 #endif
+
+	if (priv->wakeirq) {
+		ret = dev_pm_set_dedicated_wake_irq(&pdev->dev, priv->wakeirq);
+		if (ret)
+			goto err;
+	}
+
 	ret = serial8250_register_8250_port(&up);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "unable to register 8250 port\n");
@@ -1478,6 +1477,7 @@ static int omap8250_probe(struct platform_device *pdev)
 	pm_runtime_put_autosuspend(&pdev->dev);
 	return 0;
 err:
+	dev_pm_clear_wake_irq(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	flush_work(&priv->qos_work);
@@ -1497,6 +1497,7 @@ static int omap8250_remove(struct platform_device *pdev)
 
 	serial8250_unregister_port(priv->line);
 	priv->line = -ENODEV;
+	dev_pm_clear_wake_irq(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
 	flush_work(&priv->qos_work);
-- 
2.53.0



