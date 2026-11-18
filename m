Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046991;
	b=YNxDPw+XfrFNH0l8itrWuB+DrLkcDIfw5SLcU99J4jTKVAsJXPz/+MOE1WIxjMRmuYGq
	 8NTxTgmIsL+OlUA0YVw3+yNmewtJ+hDwruwS9UwrZyi9wQyTWvP6FxQh6uOLYP+PlRaaE
	 xBUtR80WSYsQGD6sUYR1xnVctFpVUDfv9yBjh7hf7d2ULj8py0Loq/DrdhiHridTtu5DQ
	 qRjfer+zGIyLGuLN/fclUhZFbhzrPsY+VcaTx3vQP5/3XhIub7xbTePe0gfNHvKgehbES
	 LeqQ/kP7CtZ8GZTdnEMY887DWxk5ZQokPqxdx0nQqsbc1R7BsZmpJDOh6Kiem6ABZDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FfWpycVuj+4qI4eeeFc4rbBhu9z7rwtgh5NeaNmdsKE=;
	b=5q9HegWIREfBwR4XoCfCVhT9zp3KPz4rU00JhBUN6OdcpDKjtmXSrQ8RZ96KnvC+4O/X
	 GcLXJYD7qXR74vdQV7U3xIUCiLxqfVRxy5HBkOo5CZkCT/FiiOHXFM+HR/kvcwGBRo7Rn
	 u0YntaZu0qhGyPVSXSaCoVzxLQnOpGnB9CTSmlg2jmvAmccCMj28IZzEOfGUKLOOlXoL7
	 Pm5WyGSAJ9K4PToUFC03MzYftr/QQB/bTlhUhm5PKSupwUQdu0wyNULnEZ1dnG2gdFd85
	 nAXC5Ksp3EafFIwni7DRYA1br9MZeQSybMVRq7DCZpAHoBuR1jwmNc+hLeTh397plTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjnL+f0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0F4606A32A;
	Thu, 19 Nov 2026 00:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjnL+f0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB561F000C4;
	Thu, 19 Nov 2026 00:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046990;
	bh=FfWpycVuj+4qI4eeeFc4rbBhu9z7rwtgh5NeaNmdsKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjnL+f0Gl3kKaU++X/tIfiJ5IFHWrZopFF2++lDTjBTnwian29rKLUdUXgKWozoI/
	 w3DjdlPa8sR6uYDpjWbgo6c/cyhhUk7UhofYUvnxeRnTYCy4W6/HReUL0t4igPlJn7
	 AbCzoFWv/rULn/BUEUtw8FFMG2XhpHStf5qtp3G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1480/2857] serial: 8250_exar: Clear interrupts before registering handler
Date: Wed, 18 Nov 2026 15:41:54 +0100
Message-ID: <20261118150254.597939805@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5bc430afeba5d5101765c1f1a4437a90218b00b9 ]

While now there is no issue if IRQ is fired before we clearing
the interrupts as the handler does the same, but strictly speaking
it might be problematic if IRQ handler wants to do something more.

Move clearing interrupt code to be called before registering the
IRQ handler.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240219150627.2101198-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 33d337816e00 ("serial: 8250_exar: store the GPIO platform device in struct exar8250")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index bbca9c501c604..b8efa464f1b3e 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -718,14 +718,14 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	uart.port.irq = pci_irq_vector(pcidev, 0);
 	uart.port.dev = &pcidev->dev;
 
+	/* Clear interrupts */
+	exar_misc_clear(priv);
+
 	rc = devm_request_irq(&pcidev->dev, uart.port.irq, exar_misc_handler,
 			 IRQF_SHARED, "exar_uart", priv);
 	if (rc)
 		return rc;
 
-	/* Clear interrupts */
-	exar_misc_clear(priv);
-
 	for (i = 0; i < nr_ports && i < maxnr; i++) {
 		rc = board->setup(priv, pcidev, &uart, i);
 		if (rc) {
-- 
2.53.0



