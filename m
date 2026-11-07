Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063950;
	b=MZge7gDDQi10Pa12wXWFaD5jonbVDyHtC5GEehyT4HcG4/ydy46wtVNATzRA6Yk+VB5M
	 fq4InqAgDsNOisTIMecY7QPph+0nnhP2W70d9jIZm1gtlQiCP06lIb5bYq77UzTiPBVLw
	 1dm9oMaaQ0RZAHMVAgwrnF1XVe7rUxnAeYjuxffB+3spVPlGIbBgXK0MR8DdI20vuLKNk
	 u/4SGbqgKT9GmpeFbXSySDiwtzd9w0hRfKT24STpgN0HE+moDNgF4SDQ29w5f92LRtgXy
	 nAHMZaPGn+UJ6ZoVPFBNWtdZDIsxxtdS6uL3VO9lMzYBj/qeJkyS6bnYdjY56G3P60A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kzekzhk5gFZbb6b20p9jvlXPP7LvYontmZvKrazZWcM=;
	b=swkhicDKrtbGykKS+NZUh5sgAttg4Ep6Yu1VNgMk/So9+hDvVQbWY1WdkcI4Ic7DjpMy
	 XwDSsmBKmXdyiRaPEr+oLPLpHSExhLw07xShxR8+9/vHmi78daMeKFyd0nMRlADNUbrbi
	 YlPloV+rC5a1wlT3R16w9ySskRdhDebjgxc9ShYzNrRPTJFW7YXbtrrPsaFgyTJDMjwxT
	 mhboAHa58bnO93Ye0GHQx5m9llKVdLj3fIMPhNpblBfE83IUlHPcPpIzsofwp/qxMEQu3
	 IjW2kFm5qmA1VLzypTLBKO6q+7+eReXRcmV6WFTEoNaRaHRrO6z/MoUrUSfgHpGmlGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mFjqJDw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B187606D829;
	Sat,  7 Nov 2026 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mFjqJDw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EDC1F008A1;
	Sat,  7 Nov 2026 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063949;
	bh=kzekzhk5gFZbb6b20p9jvlXPP7LvYontmZvKrazZWcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFjqJDw7vSzO24SNRumYqzIkCD+tTf6FifIBzGJ+c9AX78GzXPcXknC/ouzFsh6rR
	 Dq+nlmcdcV4kkYsJpm+CqswQpCY3G8Bov2huNgciWmX5uhNuqIh5XEIq2fgYAsDkyw
	 /bM5wPntFlOjS1z8CDi83B43rl1fXt9We5QYkjPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0141/1257] PCI: rzg3s: Fix IRQ domain initialization error handling
Date: Sat,  7 Nov 2026 08:40:37 -0500
Message-ID: <20261107134943.203825013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 5d9e9b3a27994a2fadce283801b7104a68ea4c48 ]

rzg3s_pcie_init_irqdomain() installs chained handlers for the INTx
parent interrupts before creating the INTx irqdomain and initializing
MSI support.

If any subsequent step fails, such as obtaining an INTx IRQ,
creating the irqdomain, or initializing MSI, the error path returns
without removing any chained handlers that were already installed.
This leaves stale handler and data pointers attached to the parent
interrupts.

Add a helper to tear down the INTx IRQ setup, including removing the IRQ
domain and clearing the chained handlers. Use it to unwind partially
completed initialization and from the normal IRQ domain teardown path.

Fixes: 7ef502fb35b28 ("PCI: Add Renesas RZ/G3S host controller driver")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260811200013.185956-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rzg3s-host.c | 50 +++++++++++++++++-------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/controller/pcie-rzg3s-host.c b/drivers/pci/controller/pcie-rzg3s-host.c
index f51b5d7c19983..3f7393c49a08c 100644
--- a/drivers/pci/controller/pcie-rzg3s-host.c
+++ b/drivers/pci/controller/pcie-rzg3s-host.c
@@ -1006,22 +1006,38 @@ static const struct irq_domain_ops rzg3s_pcie_intx_domain_ops = {
 	.xlate = irq_domain_xlate_onetwocell,
 };
 
+static void rzg3s_pcie_teardown_intx(struct rzg3s_pcie_host *host,
+				     int count)
+{
+	while (--count >= 0) {
+		irq_set_chained_handler_and_data(host->intx_irqs[count], NULL,
+						 NULL);
+	}
+
+	if (host->intx_domain)
+		irq_domain_remove(host->intx_domain);
+}
+
 static int rzg3s_pcie_init_irqdomain(struct rzg3s_pcie_host *host)
 {
 	struct device *dev = host->dev;
 	struct platform_device *pdev = to_platform_device(dev);
+	int i, ret;
 
-	for (int i = 0; i < PCI_NUM_INTX; i++) {
+	for (i = 0; i < PCI_NUM_INTX; i++) {
 		char irq_name[5] = {0};
 		int irq;
 
 		scnprintf(irq_name, ARRAY_SIZE(irq_name), "int%c", 'a' + i);
 
 		irq = platform_get_irq_byname(pdev, irq_name);
-		if (irq < 0)
-			return dev_err_probe(dev, irq,
-					     "Failed to parse and map INT%c IRQ\n",
-					     'A' + i);
+		if (irq < 0) {
+			ret = irq;
+			dev_err_probe(dev, ret,
+				      "Failed to parse and map INT%c IRQ\n",
+				      'A' + i);
+			goto teardown_intx;
+		}
 
 		host->intx_irqs[i] = irq;
 		irq_set_chained_handler_and_data(irq,
@@ -1033,21 +1049,27 @@ static int rzg3s_pcie_init_irqdomain(struct rzg3s_pcie_host *host)
 						     PCI_NUM_INTX,
 						     &rzg3s_pcie_intx_domain_ops,
 						     host);
-	if (!host->intx_domain)
-		return dev_err_probe(dev, -EINVAL,
-				     "Failed to add irq domain for INTx IRQs\n");
+	if (!host->intx_domain) {
+		ret = -EINVAL;
+		dev_err_probe(dev, ret,
+			      "Failed to add irq domain for INTx IRQs\n");
+		goto teardown_intx;
+	}
 	irq_domain_update_bus_token(host->intx_domain, DOMAIN_BUS_WIRED);
 
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
-		int ret = rzg3s_pcie_init_msi(host);
+		ret = rzg3s_pcie_init_msi(host);
 
-		if (ret) {
-			irq_domain_remove(host->intx_domain);
-			return ret;
-		}
+		if (ret)
+			goto teardown_intx;
 	}
 
 	return 0;
+
+teardown_intx:
+	rzg3s_pcie_teardown_intx(host, i);
+
+	return ret;
 }
 
 static void rzg3s_pcie_teardown_irqdomain(struct rzg3s_pcie_host *host)
@@ -1055,7 +1077,7 @@ static void rzg3s_pcie_teardown_irqdomain(struct rzg3s_pcie_host *host)
 	if (IS_ENABLED(CONFIG_PCI_MSI))
 		rzg3s_pcie_teardown_msi(host);
 
-	irq_domain_remove(host->intx_domain);
+	rzg3s_pcie_teardown_intx(host, PCI_NUM_INTX);
 }
 
 static int rzg3s_pcie_set_max_link_speed(struct rzg3s_pcie_host *host)
-- 
2.53.0



