Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6428A38398;
	Wed, 21 Feb 2024 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523468; cv=none; b=UDmu1Hja0HitCiNb1qffJCz57NPphXQlXl5F1RJlOvh7GcqtQDLJHjH+x3S7qbaw1496GQk3QvAMFS71mXC0SrBJN1rJIGXCGQJYFtnhYfocM/kffagK2Z1ptwG5rRhyfxUht8dAUdr+tKGfPFCFar3Flm+CxyE8aFKFutTAIOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523468; c=relaxed/simple;
	bh=mBO2ZKajVhciHqsdyGQGO0KcZuMOQBGQr9OIMzxMTf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBbGqXD8YBfy8mZJcWulD6iaqRc4jMSIffokXlaGMxtJDfrAyXvr+LnkZC6jjN678k3TP1H9MToRafjMBaUHBaNAF5Nc2s1ivmiccFgQl1ZKZL9AH07i64FtmslxMVu0V2dRtqGTvFFV1Pu+2VHwPFsQ23Q6JdBMT5GVsTZ4bJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUZAjQiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUZAjQiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67ADC433F1;
	Wed, 21 Feb 2024 13:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523468;
	bh=mBO2ZKajVhciHqsdyGQGO0KcZuMOQBGQr9OIMzxMTf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUZAjQizCtwAkYZvTVliPkHVCsFLlfXFNLbAuCtJz0VHN5nCh/TqPb1augEr1ukKt
	 TflY7Bys+UwVKsqe1ncGySwyUm9DJT5fCxFlcfAk5/zRzTu8AbXl/e40GmBu7Pk7SU
	 hLaWTW8fiyDlLa8djY6At0fh18H+n1dbA2s3v+Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 444/476] serial: 8250_exar: Fill in rs485_supported
Date: Wed, 21 Feb 2024 14:08:15 +0100
Message-ID: <20240221130024.451203037@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0b1976ceb01f..24878d5a6a05 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -123,6 +123,7 @@ struct exar8250;
 
 struct exar8250_platform {
 	int (*rs485_config)(struct uart_port *, struct serial_rs485 *);
+	const struct serial_rs485 *rs485_supported;
 	int (*register_gpio)(struct pci_dev *, struct uart_8250_port *);
 	void (*unregister_gpio)(struct uart_8250_port *);
 };
@@ -441,10 +442,15 @@ static int generic_rs485_config(struct uart_port *port,
 	return 0;
 }
 
+static const struct serial_rs485 generic_rs485_supported = {
+	.flags = SER_RS485_ENABLED,
+};
+
 static const struct exar8250_platform exar8250_default_platform = {
 	.register_gpio = xr17v35x_register_gpio,
 	.unregister_gpio = xr17v35x_unregister_gpio,
 	.rs485_config = generic_rs485_config,
+	.rs485_supported = &generic_rs485_supported,
 };
 
 static int iot2040_rs485_config(struct uart_port *port,
@@ -480,6 +486,10 @@ static int iot2040_rs485_config(struct uart_port *port,
 	return generic_rs485_config(port, rs485);
 }
 
+static const struct serial_rs485 iot2040_rs485_supported = {
+	.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX | SER_RS485_TERMINATE_BUS,
+};
+
 static const struct property_entry iot2040_gpio_properties[] = {
 	PROPERTY_ENTRY_U32("exar,first-pin", 10),
 	PROPERTY_ENTRY_U32("ngpios", 1),
@@ -508,6 +518,7 @@ static int iot2040_register_gpio(struct pci_dev *pcidev,
 
 static const struct exar8250_platform iot2040_platform = {
 	.rs485_config = iot2040_rs485_config,
+	.rs485_supported = &iot2040_rs485_supported,
 	.register_gpio = iot2040_register_gpio,
 	.unregister_gpio = xr17v35x_unregister_gpio,
 };
@@ -550,6 +561,7 @@ pci_xr17v35x_setup(struct exar8250 *priv, struct pci_dev *pcidev,
 
 	port->port.uartclk = baud * 16;
 	port->port.rs485_config = platform->rs485_config;
+	port->port.rs485_supported = platform->rs485_supported;
 
 	/*
 	 * Setup the UART clock for the devices on expansion slot to
-- 
2.43.0



