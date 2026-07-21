Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A7F44AB62;
	Tue, 21 Jul 2026 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670675; cv=none; b=coNQwfp5beFT0P3xQU2Wq0EeU+sA/b3tDdUp8LdeipYa8qtms9b4hm9vShFT+3z3jD1rBnzoQPkeF/AVa3Mb1m9SFk54WnMSz+vsMnPtN8J8DhIPqgYCFqPkoQf4ZB0hIrG4yi9Irvnxq1xxUj1tjGP7/kganGzx+F2GKe2AxD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670675; c=relaxed/simple;
	bh=v3Na8/b54o8bvRmSQQP10sd4sHqiau/6Lu8PWQSnudo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jv8w1Dwsir2lDF5+BextXQJ6bpvhpFrqwebfTXAjcuLhq5nXfhUjSYdGfAHqb28L0x0whC/LR10NC1Y/SAXOP8JNP0z+C6NErNDWTFGnAFE3VqxuTtzrMy4Xf6SupyQRVJesLUWMM07gZ8euCmBlmXY/dKX3M5msPHrHqi6xBUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLPVDK/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLPVDK/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB111F000E9;
	Tue, 21 Jul 2026 21:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670674;
	bh=DEjyI/n1nnf+6tiEcdHzMR8HQy7RQMCzLTws0nG4Vao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLPVDK/grSwuBY5WRhXku39NTUDUCIPQT1IwR43BJwYRoRmhE5BnUC7WpR/Z9KbsP
	 MKrpUawi/9U/Ea788PUmBemSa/Zm+/Q8gsN3hY0H1/hVs4EzPH9Cp3pHVMNV7uKq4B
	 zodid9mruAPKj2Viz6wk8UltGA+CK4MCQIW6JhfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1020/1067] serial: 8250_mid: Remove 8250_pci usage
Date: Tue, 21 Jul 2026 17:27:01 +0200
Message-ID: <20260721152447.388444108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -291,7 +289,6 @@ static int mid8250_probe(struct pci_dev
 {
 	struct uart_8250_port uart;
 	struct mid8250 *mid;
-	unsigned int bar;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -303,7 +300,6 @@ static int mid8250_probe(struct pci_dev
 		return -ENOMEM;
 
 	mid->board = (struct mid8250_board *)id->driver_data;
-	bar = FL_GET_BASE(mid->board->flags);
 
 	memset(&uart, 0, sizeof(struct uart_8250_port));
 
@@ -316,8 +312,8 @@ static int mid8250_probe(struct pci_dev
 	uart.port.flags = UPF_SHARE_IRQ | UPF_FIXED_PORT | UPF_FIXED_TYPE;
 	uart.port.set_termios = mid8250_set_termios;
 
-	uart.port.mapbase = pci_resource_start(pdev, bar);
-	uart.port.membase = pcim_iomap(pdev, bar, 0);
+	uart.port.mapbase = pci_resource_start(pdev, mid->board->bar);
+	uart.port.membase = pcim_iomap(pdev, mid->board->bar, 0);
 	if (!uart.port.membase)
 		return -ENOMEM;
 
@@ -353,25 +349,25 @@ static void mid8250_remove(struct pci_de
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


