Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062328;
	b=gmb4Qdqci5Tpr6Ii4VX7/CZVv4DwgcwiCVuS9zCfHYiC6z3FGZLI1LS6ZdYBAPrY7ch9
	 LgvEQXV/9dmBfUgUn+P9frFN5tWsRp2eLIabJO57HRjFmPgfZEoORj248EPxDUwTIP5SD
	 4HxhCGxxjWYQX24wczkkH1f2xvO6xOXJeuQGHKoCX2zemWJnD49xsIzl3MwtCASD0sScR
	 0e17yr/QEBZVXeRevKsUOBy5i/BrDnyhE2dYUTPKm+mm7bB24aYkmwbvjxVANjCfAEFHN
	 P76A4d3+zhKvFApq/R+7vbwTHwp1gqFtZI8bsqkriQSboA+9iUtuAxpG1LpXLb2tNfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QosH4TKcB8Q0fGZGDAQ+fexmYGfLnigaczvdONRhxgU=;
	b=wa2clM/SNlvbvJA0fS8mpmvthHuK2RFgxa3kHm99WD4nOTEPdH994S8sjnX+y3p+tgx6
	 NS7Fqe5WrDmQXwQ3a1dRHL5KRWEKV0FMUXTdD/u1ut73gNRGFCbRv4wIs2Ykl3cFlTPQm
	 +K32CTYO04hAz8z1mh2yBvaf7ZGykzBPL+8BCna9LX9nwrI/phIUcbfw6JQd6Cp9+/VqG
	 ud5zNWsxb1pd1NsOs1DokBripi+7e4DS1bP1MEA91e041TrU/OZkRHDL+346+ivHCAwB8
	 vQZkWCZHYHaQPLxeKzRFzfy0JZnqGYaTZ5Qr/miqHoRxZpw6uNL46pzND6yz45NSHIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfnk4bxc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA717606A660;
	Sat,  7 Nov 2026 14:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfnk4bxc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D3E1F0089F;
	Sat,  7 Nov 2026 14:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062327;
	bh=QosH4TKcB8Q0fGZGDAQ+fexmYGfLnigaczvdONRhxgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfnk4bxc6DDEdEUzmEbwBnfIK3s5MPNkb8i5sq4yf9lWNJqh615swNihjQe0PGyjt
	 Ze602cf2rCLckyxUP33964fgIOkneLL06gwdsPMTZ/qraWozZTHjfu1rDcbIO1AKaI
	 2ZAs0d8+elv/lg7yztIGkXfB9JBe55bgIhYNY1P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1259/1536] serial: 8250_exar: store the GPIO platform device in struct exar8250
Date: Sat,  7 Nov 2026 08:54:35 -0500
Message-ID: <20261107135033.130750378@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 36 ++++++++++++++---------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 5ed6514ec88aa..2fbefc2228d61 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -231,8 +231,9 @@ struct exar8250_platform {
 	int (*rs485_config)(struct uart_port *port, struct ktermios *termios,
 			    struct serial_rs485 *rs485);
 	const struct serial_rs485 *rs485_supported;
-	int (*register_gpio)(struct pci_dev *pcidev, struct uart_8250_port *port);
-	void (*unregister_gpio)(struct uart_8250_port *port);
+	int (*register_gpio)(struct exar8250 *priv, struct pci_dev *pcidev,
+			     struct uart_8250_port *port);
+	void (*unregister_gpio)(struct exar8250 *priv);
 };
 
 /**
@@ -255,6 +256,7 @@ struct exar8250 {
 	unsigned int		osc_freq;
 	struct exar8250_board	*board;
 	void __iomem		*virt;
+	struct platform_device	*gpio;
 	int			line[];
 };
 
@@ -1232,22 +1234,21 @@ static const struct software_node exar_gpio_node = {
 	.properties = exar_gpio_properties,
 };
 
-static int xr17v35x_register_gpio(struct pci_dev *pcidev, struct uart_8250_port *port)
+static int xr17v35x_register_gpio(struct exar8250 *priv, struct pci_dev *pcidev,
+				  struct uart_8250_port *port)
 {
 	if (pcidev->vendor == PCI_VENDOR_ID_EXAR)
-		port->port.private_data =
-			__xr17v35x_register_gpio(pcidev, &exar_gpio_node);
+		priv->gpio = __xr17v35x_register_gpio(pcidev, &exar_gpio_node);
 
 	return 0;
 }
 
-static void xr17v35x_unregister_gpio(struct uart_8250_port *port)
+static void xr17v35x_unregister_gpio(struct exar8250 *priv)
 {
-	if (!port->port.private_data)
-		return;
-
-	__xr17v35x_unregister_gpio(port->port.private_data);
-	port->port.private_data = NULL;
+	if (priv->gpio) {
+		__xr17v35x_unregister_gpio(priv->gpio);
+		priv->gpio = NULL;
+	}
 }
 
 static int sealevel_rs485_config(struct uart_port *port, struct ktermios *termios,
@@ -1344,8 +1345,9 @@ static const struct software_node iot2040_gpio_node = {
 	.properties = iot2040_gpio_properties,
 };
 
-static int iot2040_register_gpio(struct pci_dev *pcidev,
-			      struct uart_8250_port *port)
+static int iot2040_register_gpio(struct exar8250 *priv,
+				 struct pci_dev *pcidev,
+				 struct uart_8250_port *port)
 {
 	u8 __iomem *p = port->port.membase;
 
@@ -1354,8 +1356,7 @@ static int iot2040_register_gpio(struct pci_dev *pcidev,
 	writeb(IOT2040_UARTS_ENABLE, p + UART_EXAR_MPIOLVL_15_8);
 	writeb(IOT2040_UARTS_GPIO_HI_MODE, p + UART_EXAR_MPIOSEL_15_8);
 
-	port->port.private_data =
-		__xr17v35x_register_gpio(pcidev, &iot2040_gpio_node);
+	priv->gpio = __xr17v35x_register_gpio(pcidev, &iot2040_gpio_node);
 
 	return 0;
 }
@@ -1432,7 +1433,7 @@ pci_xr17v35x_setup(struct exar8250 *priv, struct pci_dev *pcidev,
 		/* Setup Multipurpose Input/Output pins. */
 		setup_gpio(pcidev, p);
 
-		ret = platform->register_gpio(pcidev, port);
+		ret = platform->register_gpio(priv, pcidev, port);
 	}
 
 	return ret;
@@ -1442,9 +1443,8 @@ static void pci_xr17v35x_exit(struct pci_dev *pcidev)
 {
 	const struct exar8250_platform *platform = exar_get_platform();
 	struct exar8250 *priv = pci_get_drvdata(pcidev);
-	struct uart_8250_port *port = serial8250_get_port(priv->line[0]);
 
-	platform->unregister_gpio(port);
+	platform->unregister_gpio(priv);
 }
 
 static inline void exar_misc_clear(struct exar8250 *priv)
-- 
2.53.0



