Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679FA7F460;
	Wed, 21 Feb 2024 14:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524820; cv=none; b=NmqMC9vfC7BYbEt3vCJ8YaWGxHcrJUrD/KZehbm5rfgmGhGVU4BlDQ/BXbSuwmE/W6Vbl4/u3DItUtvHTehV6BF62tzvVY98U5E9YZXT5Kqs2xR10SBiE/P3L+bt7XbhvSQnVUUkzLvZG+OKo0GGsevOaPDYqEMsUfumlYlA8sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524820; c=relaxed/simple;
	bh=N2+UzwXOM2ZVpshRmYz7bMTFiMlrbYxR0OXqbbc53So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KaFFETtSkR5JLDJmu9YtvqP3tEAtJzgHs5PhX6oz1V0CANHtsojTxgsMJnk/o8atk6QR0t2vRK5mTn6IOps9SRK6hX9y5h7Wb1YZrRmlXU0AwwXdT4YOgl3caeQogXiQwHK3wO21KgnWd7Vs+932Jb1vXAXuRoU+hFGfRHL1NCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPqnOJAI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPqnOJAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72E2C433C7;
	Wed, 21 Feb 2024 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524820;
	bh=N2+UzwXOM2ZVpshRmYz7bMTFiMlrbYxR0OXqbbc53So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPqnOJAIQfB+jzz71E8giuftcYU7RFWqBUEqp8C+X7GFk60cxA1Gg2558FE4HMS38
	 WIcawSMVIFNbXe1nKb95vYzloTKiHWhd5sW+VduYav1jCcsopPXaLdlYhKbQvugf4k
	 7ZOKlIlZquBxxKKOgYnbokGD7s/h8K1I12jbVS68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/379] serial: 8250_exar: Fill in rs485_supported
Date: Wed, 21 Feb 2024 14:08:58 +0100
Message-ID: <20240221130005.686719416@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 59c221f8e1269278161313048c71929c9950b2c4 ]

Add information on supported serial_rs485 features.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220606100433.13793-8-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0c2a5f471ce5 ("serial: 8250_exar: Set missing rs485_supported flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 5c2adf14049b..19de9f535c67 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -123,6 +123,7 @@ struct exar8250;
 
 struct exar8250_platform {
 	int (*rs485_config)(struct uart_port *, struct serial_rs485 *);
+	const struct serial_rs485 *rs485_supported;
 	int (*register_gpio)(struct pci_dev *, struct uart_8250_port *);
 };
 
@@ -423,9 +424,14 @@ static int generic_rs485_config(struct uart_port *port,
 	return 0;
 }
 
+static const struct serial_rs485 generic_rs485_supported = {
+	.flags = SER_RS485_ENABLED,
+};
+
 static const struct exar8250_platform exar8250_default_platform = {
 	.register_gpio = xr17v35x_register_gpio,
 	.rs485_config = generic_rs485_config,
+	.rs485_supported = &generic_rs485_supported,
 };
 
 static int iot2040_rs485_config(struct uart_port *port,
@@ -461,6 +467,10 @@ static int iot2040_rs485_config(struct uart_port *port,
 	return generic_rs485_config(port, rs485);
 }
 
+static const struct serial_rs485 iot2040_rs485_supported = {
+	.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
+};
+
 static const struct property_entry iot2040_gpio_properties[] = {
 	PROPERTY_ENTRY_U32("exar,first-pin", 10),
 	PROPERTY_ENTRY_U32("ngpios", 1),
@@ -485,6 +495,7 @@ static int iot2040_register_gpio(struct pci_dev *pcidev,
 
 static const struct exar8250_platform iot2040_platform = {
 	.rs485_config = iot2040_rs485_config,
+	.rs485_supported = &iot2040_rs485_supported,
 	.register_gpio = iot2040_register_gpio,
 };
 
@@ -522,6 +533,7 @@ pci_xr17v35x_setup(struct exar8250 *priv, struct pci_dev *pcidev,
 
 	port->port.uartclk = baud * 16;
 	port->port.rs485_config = platform->rs485_config;
+	port->port.rs485_supported = platform->rs485_supported;
 
 	/*
 	 * Setup the UART clock for the devices on expansion slot to
-- 
2.43.0



