Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017017;
	b=DJkJK3IClF543CW6bVYUiid0yqP7RfylemCw0agvjw/+ytu01Tu0nSHf+pf5koZYaiWp
	 DaEGh66zductwo+QJyfx+jx5YWGAVfe4HUmXJMR1kKK2UX5Cqqp2Xo+GUiA6GNVTBD97J
	 26WajitJGek2zU6yH73aVbeBplsKMBNjZ9EaUVL5r0LMjY5eRE4IREROfyFCmRT+feNXi
	 N9pTzLTDJqaKy6yOvUVgVzVVhUCebIPeMcKrIURg/e/lEq2af6mym/vICgDTVSYnAPsCB
	 QTw/skOjSZp2dPhV9+GwDyNl9efEwCDKBOAiS4BSCbgC5D5zWYV2EoDw+T7798ctlvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKLtDeYml+jRelerK9HjAj/kptc/8n76SlaKoBmNLxY=;
	b=4bWvaZadxt39IXcaGneber2c6xdXH88vmYr0PLxsv5MgleOPTUYEA0uJIMK0AaTAUGKB
	 G4FGJgIRO7p2PU2b782s9xSo9ZkaXLwknm/j6LFm6fEnA6QmcmMXjUBb7WCJX1rxr1Bwr
	 1xhxHfLbZs+sS7OF+It2NcXyaWvDkODwNgswiJDDyWWkWWIFtRaIZF24L5qd4ST/txf0y
	 opzH3b1501A2sC73+4PwJ9D2gGcLi/ygpgc83lVKSbEDq5aOuLJgGYlz4yjr/x/yn5KLr
	 4QlnpvkxObiLvNjwR/y017eDkxmYHy+GvTF0VeesWPCY4S2ApjbqzhUoU9C1KOYSZhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8I5thIP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9557606A32A;
	Wed, 18 Nov 2026 15:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8I5thIP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4496C1F000C4;
	Wed, 18 Nov 2026 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017016;
	bh=MKLtDeYml+jRelerK9HjAj/kptc/8n76SlaKoBmNLxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8I5thIP+N0pkBeMxTQOP8NU7xOCR4YSJJ0fz6UGSK2MWjkn/jx9388ztwpGW7IyZ
	 ZIZaYVDrkFn+SIRr8lj+dSXPlXJqD9rsIuAzJm62cdBa4dN7i4uFnddhSIH8fhFFib
	 D1yZ1i0zGihpcDXg80NcmXOe3g5Thq2zVnjK2ex0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Crescent Hsieh <crescentcy.hsieh@moxa.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0732/2651] serial: 8250_mxpcie: only unregister the ports that were registered
Date: Wed, 18 Nov 2026 15:32:52 +0100
Message-ID: <20261118150314.221197665@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 39eaa90b6bd1dbe147c90c345796bc042080d80e ]

When serial8250_register_8250_port() fails the loop stops and the probe
keeps the ports registered so far, like pciserial_init_ports() in
8250_pci.c this driver was split from.  What the split lost is that
function's priv->nr: mxpcie8250_remove() walks all num_ports entries,
but the ones the loop never reached keep the zero devm_kzalloc() left
there, and the one that failed keeps a negative error code.

serial8250_unregister_port() checks neither, so removal unregisters
line 0 - a port this driver does not own - and indexes
serial8250_ports[] with a negative line number.

Record how many ports were registered and unregister only those.

Fixes: 0481a041e956 ("serial: 8250: split Moxa PCIe serial board support out of 8250_pci")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Crescent Hsieh <crescentcy.hsieh@moxa.com>
Link: https://patch.msgid.link/20260901041519.114737-3-lilinmao@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_mxpcie.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mxpcie.c b/drivers/tty/serial/8250/8250_mxpcie.c
index c0e3517d4e4ec..ef2516ec16da0 100644
--- a/drivers/tty/serial/8250/8250_mxpcie.c
+++ b/drivers/tty/serial/8250/8250_mxpcie.c
@@ -109,6 +109,7 @@ struct mxpcie8250_port {
 struct mxpcie8250 {
 	unsigned int supp_rs;
 	unsigned int num_ports;
+	unsigned int nr;	/* ports actually registered */
 	void __iomem *bar1_base; /* UART registers (MMIO) */
 	void __iomem *bar2_base; /* UIR / GPIO / CPLD (IO) */
 	struct mxpcie8250_port port[] __counted_by(num_ports);
@@ -517,6 +518,7 @@ static int mxpcie8250_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	struct mxpcie8250 *priv;
 	unsigned short device = pdev->device;
 	unsigned int num_ports;
+	unsigned int i;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -564,7 +566,7 @@ static int mxpcie8250_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	up.port.handle_irq = mxpcie8250_handle_irq;
 	up.port.break_ctl = mxpcie8250_break_ctl;
 
-	for (unsigned int i = 0; i < num_ports; i++) {
+	for (i = 0; i < num_ports; i++) {
 		mxpcie8250_setup_port(pdev, priv, &up, i);
 
 		dev_dbg(dev, "Setup PCI port: port %lx, irq %d, type %d\n",
@@ -580,6 +582,7 @@ static int mxpcie8250_probe(struct pci_dev *pdev, const struct pci_device_id *id
 		}
 		priv->port[i].rx_trig_level = MOXA_PUART_RX_TRIG_DEFAULT;
 	}
+	priv->nr = i;
 
 	return 0;
 }
@@ -588,7 +591,7 @@ static void mxpcie8250_remove(struct pci_dev *pdev)
 {
 	struct mxpcie8250 *priv = pci_get_drvdata(pdev);
 
-	for (unsigned int i = 0; i < priv->num_ports; i++)
+	for (unsigned int i = 0; i < priv->nr; i++)
 		serial8250_unregister_port(priv->port[i].line);
 }
 
-- 
2.53.0



