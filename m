Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059642;
	b=DS5OCh9d+7rQqIqvqzJIqSphZ6p/c0PViHNNXrA10SzJNRx6M7/LpaXID4aypIVtG/xS
	 jGLYA4KpCdMSaDUXZr2/4/dkwZuA1ApUEzcCIhEi2vajIQ9Sj9Aioci6o2/d38RYu655r
	 RVHiDLDRENFl0QQkb6XLMPlF5pcz1gZeEQHh1AhSSk94SOE2ixSmKOf/yCPrQVPxsV076
	 OcHtYeDWoG3V5CKV0Bq4LqhOjzjNoqe2ZXMK+Df371eqFqU8KJDFPmTn5tHUM7NYNsKq8
	 loNB5o58HhLw/N3G1sXwBvNb0eE0TQ8DjlMdueQ/NjmgNxlw6D5wccr2sqVkwcpUNBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Invcot8Na+e4itn+FwL7WSX5soXHj1VWeIFIan0yHno=;
	b=2kpxZz/HQwxkAxkYz32iSYIDw2JnWPiQRICuwFhQCHG4yU/L9UOfB/cszM45VYoGK0j0
	 OpXoRNk6sbSxMWUm95WV1XaYSVVzav5U3SK22p3EPCfhsGAYnCrjgvB+zumVnazGrdBS7
	 9QHrnx8lw8qn2M8GYv5OjUIURVzrLUQMyyiRutiJ6l9PsdpEwFPwfbURpASYOqsj6auog
	 vborz/cnzIgCNdbhPNG8G9A/m8HnCZCYcDgQqohy66c78pezs+B7mX4czv6p4zBghYtn7
	 XWutGd+lnNHj2pE5HyQYuu7qgwYYNktYUHlVga4GKCLm2AjQDJgvQlUD2aAl7ugNyqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zJ6c/7Ut";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D27360A2620;
	Thu, 19 Nov 2026 03:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ6c/7Ut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5821F000CA;
	Thu, 19 Nov 2026 03:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059641;
	bh=Invcot8Na+e4itn+FwL7WSX5soXHj1VWeIFIan0yHno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJ6c/7Utly+FuPhzDw/284Mhx3wPKTEfDV691cfSFbNrBln2ZDAaWoeXBj8BHzu8C
	 v8KAQ3L19nsiT3O8lPWDElZblNSjQiZCqck+U6qNN0V8blTqIYAy1XU8yKJIVyZ5hd
	 UpXVEv1Qhk0D19afIzKkXbNy9xKgaLY3nGCbmano=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0914/1848] serial: 8250_exar: store the GPIO platform device in struct exar8250
Date: Wed, 18 Nov 2026 15:49:12 +0100
Message-ID: <20261118145955.128244369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 33d337816e00994daaf670243186d9e537ee090d ]

The GPIO platform device is registered via platform->register_gpio()
when port 0 is being set up. It is stored to port->port.private_data of
the on-stack uart template (and from there it is copied into every
registered port). pci_xr17v35x_exit() then fetches it back by
serial8250_get_port(priv->line[0]).

But port 0 does not have to exist at that point. If
serial8250_register_8250_port() fails for port 0, priv->line[0] holds a
negative error code. The probe still succeeds (it only breaks the loop),
so on unbind, priv->line[0] (a negative value) is passed to
serial8250_get_port(). The GPIO device is never unregistered and a
bogus port is accessed.

The same problem would also occur after the planned conversion of
serial8250_register_8250_port() to return a uart port instead of a
line. As Sashiko pointed out in that case:
  If board->setup() fails for the first port (i=0) in exar_pci_probe(),
  priv->uport[0] remains NULL. If serial8250_register_8250_port() fails,
  it returns an ERR_PTR. In either case, the loop breaks and probe
  returns success. When the device is later unbound,
  pci_xr17v35x_exit() unconditionally passes priv->uport[0] to
  platform->unregister_gpio(), which will dereference it without
  checking for validity.

The GPIO device belongs to the PCI device, not to any particular port.
So store it in a new struct exar8250::gpio member. Pass priv to both
->register_gpio() and ->unregister_gpio(), so that pci_xr17v35x_exit()
does not need to look up any port at all.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Fixes: d0aeaa83f0b0 ("serial: exar: split out the exar code from 8250_pci")
Link: https://lore.kernel.org/all/sashiko-outbox-166269@kernel.org/
Assisted-by: LLM
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/03a8b5c71614fc672fef1e55c083bda6c73b5bf3.1791873876.git.jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adapted GPIO lifecycle changes to the existing property-array API and direct cleanup in pci_xr17v35x_exit() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index c48417ea9e30c..72f13829be6bd 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -168,7 +168,8 @@ struct exar8250;
 struct exar8250_platform {
 	int (*rs485_config)(struct uart_port *, struct serial_rs485 *);
 	const struct serial_rs485 *rs485_supported;
-	int (*register_gpio)(struct pci_dev *, struct uart_8250_port *);
+	int (*register_gpio)(struct exar8250 *priv, struct pci_dev *pcidev,
+			     struct uart_8250_port *port);
 };
 
 /**
@@ -190,6 +191,7 @@ struct exar8250 {
 	unsigned int		nr;
 	struct exar8250_board	*board;
 	void __iomem		*virt;
+	struct platform_device	*gpio;
 	int			line[];
 };
 
@@ -435,12 +437,11 @@ static const struct property_entry exar_gpio_properties[] = {
 	{ }
 };
 
-static int xr17v35x_register_gpio(struct pci_dev *pcidev,
+static int xr17v35x_register_gpio(struct exar8250 *priv, struct pci_dev *pcidev,
 				  struct uart_8250_port *port)
 {
 	if (pcidev->vendor == PCI_VENDOR_ID_EXAR)
-		port->port.private_data =
-			__xr17v35x_register_gpio(pcidev, exar_gpio_properties);
+		priv->gpio = __xr17v35x_register_gpio(pcidev, exar_gpio_properties);
 
 	return 0;
 }
@@ -522,8 +523,9 @@ static const struct property_entry iot2040_gpio_properties[] = {
 	{ }
 };
 
-static int iot2040_register_gpio(struct pci_dev *pcidev,
-			      struct uart_8250_port *port)
+static int iot2040_register_gpio(struct exar8250 *priv,
+				 struct pci_dev *pcidev,
+				 struct uart_8250_port *port)
 {
 	u8 __iomem *p = port->port.membase;
 
@@ -532,8 +534,7 @@ static int iot2040_register_gpio(struct pci_dev *pcidev,
 	writeb(IOT2040_UARTS_ENABLE, p + UART_EXAR_MPIOLVL_15_8);
 	writeb(IOT2040_UARTS_GPIO_HI_MODE, p + UART_EXAR_MPIOSEL_15_8);
 
-	port->port.private_data =
-		__xr17v35x_register_gpio(pcidev, iot2040_gpio_properties);
+	priv->gpio = __xr17v35x_register_gpio(pcidev, iot2040_gpio_properties);
 
 	return 0;
 }
@@ -602,7 +603,7 @@ pci_xr17v35x_setup(struct exar8250 *priv, struct pci_dev *pcidev,
 		/* Setup Multipurpose Input/Output pins. */
 		setup_gpio(pcidev, p);
 
-		ret = platform->register_gpio(pcidev, port);
+		ret = platform->register_gpio(priv, pcidev, port);
 	}
 
 	return ret;
@@ -611,11 +612,11 @@ pci_xr17v35x_setup(struct exar8250 *priv, struct pci_dev *pcidev,
 static void pci_xr17v35x_exit(struct pci_dev *pcidev)
 {
 	struct exar8250 *priv = pci_get_drvdata(pcidev);
-	struct uart_8250_port *port = serial8250_get_port(priv->line[0]);
-	struct platform_device *pdev = port->port.private_data;
 
-	platform_device_unregister(pdev);
-	port->port.private_data = NULL;
+	if (priv->gpio) {
+		platform_device_unregister(priv->gpio);
+		priv->gpio = NULL;
+	}
 }
 
 static inline void exar_misc_clear(struct exar8250 *priv)
-- 
2.53.0



