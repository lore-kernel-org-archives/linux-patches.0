Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053897;
	b=p4fRy3cTU+upPlRtvxgfhtLm3npDTsS7VljaF31CO4J7y3Py3JAN2Rn+6LkwGmEjY38A
	 ElIQlOy+xDNMiBngRtUPf19C8vWIrtwgUEDyFL8A3uXaYhxiintsFFGeqv/fhjvBnXYO7
	 x1PX2ZYoMympWH6f0wJE2beluO/6XqWmhBOf8J+x3DSQTBPQo8fOh11PzhMXkMocOrNNb
	 NFoMOWLvny+MwjxiyA1NloZ4wBqZVhEFYzz3tEeSazbyCF6w46obuvQVwqbvTsUFwx6Po
	 JsOtCYOTBp69qqwcUzxGzz6PTFo1mD+dkx/UIhkTtUmzyNWhKpySupmYX+ZvwDpEpxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5xW1t6zE5qkRhQzbBgtNNKS81OemPzAXfpYR4MvsK98=;
	b=IfTnhIs92OpVCfEX1tPd5Mao/YNHc9GItgIiecy4Oe6UBlnGIRmzgj0sRqvAcBPRpoEw
	 VJSLUlnoumT3erwZwesdEARSgdiZDfToTo23EKv0CH9RNQXRAO5AXNKV/0mL981+JPeML
	 MNvtP5nhEQEvymEXSxKvdtnvjD9JB4REqlhpAl0ryZklA9lHfLM5MZWOoc0auev8ydZLC
	 kK86l3ceecVMKzIoHojrUBqdi97aTgucoeAbN7z2QHve5+i3PB8vsSLp87GB/wdFhKq6+
	 IJKFAiox6rGfo3vYb9+zL4XmsQupZGw1LUlcq09AwI108IJ7Hzp5fi64Q6lsjVuWtNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1g2wP9OH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B6606A331;
	Thu, 19 Nov 2026 02:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1g2wP9OH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF081F000C9;
	Thu, 19 Nov 2026 02:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053897;
	bh=5xW1t6zE5qkRhQzbBgtNNKS81OemPzAXfpYR4MvsK98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1g2wP9OH8MJS1LokIpSJh8Odl7gYcEjY98FN9GMrN2Rcd1vvVakPnm92IRkRL7e5A
	 45nIg+lmAfKIqNb4Lw8PQMB3a+4HK3QG0vFekpb5HFre/kXHvq/V0jZJbZh4HfEc+g
	 4Qa9GvwzLdb6bY6BV0nvwsUqVcaGGKxx+CBFPQMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1083/2214] serial: 8250_exar: Clear interrupts before registering handler
Date: Wed, 18 Nov 2026 15:45:59 +0100
Message-ID: <20261118150055.563599394@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 89054dd594d51..8672c8d06a89e 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -719,14 +719,14 @@ exar_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
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



