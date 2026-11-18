Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038472;
	b=qj8m8Fd3QLtiBuAlMMTj4oZNeb7SH0L+bqm9/gPGYj77VqgwPnxLaBhudF9GaBjJhMOQ
	 qBlEqgzk6y18wH4/WOhmgLzBriPxF5qoP7rQCs8yDvarekfdIUeR/j5CQwPHGm50BNdlK
	 1gPm9tpGOXpbkediaoEKIhY6ULALkTck/3fSwzrqhBSd7y+eircZX4DWXLPQJVLJjS5VL
	 yUaCcMzbyDba+9mmTbOhhdvsWpz1jHZ5KBVnqhs3kZfwNGZEqq9hmGtjTkeP4Rhh5wUcJ
	 0tIdTGWCspuABQ4F/0GHOpbsTsGuroQd8vjiJV5w4dKVZqLc9JUmCpG0CtXFaQ/21CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LwK0rcRD7ne1rC+0jzBV7BY02t+SV7QzsQYjqn7Qw2M=;
	b=YhgWZH6y66YoDb06Q4g+JzQTk0p+m4pEPzRTjfUNKnvtykNDaBqD4YUaK/pd/4HjEgLC
	 yj8vcRLvSTM35+egO1pYHOGq1WZgmsq0odqHZ7BIAnoxzPk1x+QGnoPSKszknkophyS0v
	 2/51RQarHBZJTZsxczNanqJTRT4Ypa8yAU6HtMBOMmxIyaYZwY+Asa7kYSOcBRxabFm3p
	 DDNRpgqyRJX25INA0FxTxKfShVFXTqAqt8vrjGDKebFZu0udA36u89akfT8gh0LZvgGAX
	 z09vt4nhALIXaSfF8+OJKo2F+8YAy9gsNbp9LKepkbHWhH/1gfKppFUhhPxNc1DUTDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yCvh/Dlo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855D3606A32F;
	Wed, 18 Nov 2026 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yCvh/Dlo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2531F000C7;
	Wed, 18 Nov 2026 21:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038472;
	bh=LwK0rcRD7ne1rC+0jzBV7BY02t+SV7QzsQYjqn7Qw2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yCvh/DloOtkyMIVvM1YtZhNds0htIzPsPZd52zVH02a+BurrOZurQg8CvWNvcjsUi
	 xG8Jnbrc2nvkJ6g0dvcwOr4+QKLltG90Rk3Mt1onwbXGPdnHb/F8kGUE86BPme61P2
	 +zaqe0HIrdMuSSD7pQiQpME50p+knR+qAY+T+4Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1738/3318] serial: 8250_exar: Clear interrupts before registering handler
Date: Wed, 18 Nov 2026 15:39:20 +0100
Message-ID: <20261118150414.005411760@linuxfoundation.org>
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
index e79ee33d432c9..95cde2c001118 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -722,14 +722,14 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
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



