Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0242D7DF1;
	Tue, 21 Jul 2026 22:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674743; cv=none; b=f2usqHLofhVwB8nTBUXzOktxYmAbkSQIWgIwl6Ayr0/Q/r8g//xy9N8tZ5XQMgOLfSHGkhbHTpCioAScv/iGDJ3u0M7NmUUi9OjqKdUzgMI1Ll5T/9BvRRJUB3kYM3DtLnnPqRtcnL3DR4qYH+LeHgMwsAYpJcRCJT82MXae4XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674743; c=relaxed/simple;
	bh=9vgM6zP7sTe8gIMuy8+y4NMTSOCTfSmM5rXx6Dgklgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OxYxjXHIX5SfUeahcjeJyn6DtvuFtUjrz+MnbXLgbLHwLNBGrcOmlbN8a9iCA9avwNtfQG5khbRKVmu2A6rcPajMVhGNPzg7pFVdwT/4D2SPyn6K3F00yNhDnWlmuXArhsKUl+osvmimnckC7MEMniHmaUpaM+H/RUHekf1Y1hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQB+qwcE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQB+qwcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475DC1F000E9;
	Tue, 21 Jul 2026 22:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674742;
	bh=fKk1fflut4lG3iQezl4g7hCt9fv5cXFD8fVPmqE5CvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQB+qwcEcqHqhq+pZpkhO8dglsRY8cGgArkjzckqrkPp6UO7kNzZeSv3a3Cvx9UNR
	 n1PBoD7e3Clq28HAOqZvot8rvpBiN1+imtxgov0q2WoQxcLIQ+TCEN+AmUB0Q9aCKN
	 moCSt9U0ROxFx7YEf9CWpnqbCieYrqiWTpHW2gYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 656/699] serial: 8250_mid: Remove 8250_pci usage
Date: Tue, 21 Jul 2026 17:26:55 +0200
Message-ID: <20260721152410.560993992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit a136abd7e7abe0f1247f8ffde6cc7c8ab09f985b ]

8250_mid uses FL_*BASE* from linux/8250_pci.h and nothing else. The
code can be simplified by directly defining BARs within the driver
instead.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20230915094336.13278-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b1b4efea05a5 ("serial: 8250_mid: Disable DMA for selected platforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mid.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -12,7 +12,6 @@
 #include <linux/rational.h>
 
 #include <linux/dma/hsu.h>
-#include <linux/8250_pci.h>
 
 #include "8250.h"
 
@@ -32,9 +31,9 @@
 struct mid8250;
 
 struct mid8250_board {
-	unsigned int flags;
 	unsigned long freq;
 	unsigned int base_baud;
+	unsigned int bar;
 	int (*setup)(struct mid8250 *, struct uart_port *p);
 	void (*exit)(struct mid8250 *);
 };
@@ -169,7 +168,6 @@ static int dnv_setup(struct mid8250 *mid
 {
 	struct hsu_dma_chip *chip = &mid->dma_chip;
 	struct pci_dev *pdev = to_pci_dev(p->dev);
-	unsigned int bar = FL_GET_BASE(mid->board->flags);
 	int ret;
 
 	pci_set_master(pdev);
@@ -183,7 +181,7 @@ static int dnv_setup(struct mid8250 *mid
 	chip->dev = &pdev->dev;
 	chip->irq = pci_irq_vector(pdev, 0);
 	chip->regs = p->membase;
-	chip->length = pci_resource_len(pdev, bar);
+	chip->length = pci_resource_len(pdev, mid->board->bar);
 	chip->offset = DNV_DMA_CHAN_OFFSET;
 
 	/* Falling back to PIO mode if DMA probing fails */
@@ -292,7 +290,6 @@ static int mid8250_probe(struct pci_dev
 {
 	struct uart_8250_port uart;
 	struct mid8250 *mid;
-	unsigned int bar;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -304,7 +301,6 @@ static int mid8250_probe(struct pci_dev
 		return -ENOMEM;
 
 	mid->board = (struct mid8250_board *)id->driver_data;
-	bar = FL_GET_BASE(mid->board->flags);
 
 	memset(&uart, 0, sizeof(struct uart_8250_port));
 
@@ -317,8 +313,8 @@ static int mid8250_probe(struct pci_dev
 	uart.port.flags = UPF_SHARE_IRQ | UPF_FIXED_PORT | UPF_FIXED_TYPE;
 	uart.port.set_termios = mid8250_set_termios;
 
-	uart.port.mapbase = pci_resource_start(pdev, bar);
-	uart.port.membase = pcim_iomap(pdev, bar, 0);
+	uart.port.mapbase = pci_resource_start(pdev, mid->board->bar);
+	uart.port.membase = pcim_iomap(pdev, mid->board->bar, 0);
 	if (!uart.port.membase)
 		return -ENOMEM;
 
@@ -356,25 +352,25 @@ static void mid8250_remove(struct pci_de
 }
 
 static const struct mid8250_board pnw_board = {
-	.flags = FL_BASE0,
 	.freq = 50000000,
 	.base_baud = 115200,
+	.bar = 0,
 	.setup = pnw_setup,
 	.exit = pnw_exit,
 };
 
 static const struct mid8250_board tng_board = {
-	.flags = FL_BASE0,
 	.freq = 38400000,
 	.base_baud = 1843200,
+	.bar = 0,
 	.setup = tng_setup,
 	.exit = tng_exit,
 };
 
 static const struct mid8250_board dnv_board = {
-	.flags = FL_BASE1,
 	.freq = 133333333,
 	.base_baud = 115200,
+	.bar = 1,
 	.setup = dnv_setup,
 	.exit = dnv_exit,
 };


