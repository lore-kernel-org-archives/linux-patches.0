Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063968;
	b=OccJ23cOxo+rJOO0ISufABFQbtj0xxEcQ05NWl88hZla8nIjqVB4M1u64CqEcO+KCpw+
	 lXmxsm9MZUNV+4kuHXa7SBQr9fp1YvQqGfLSp1lq7SmzLIqJGzmClsbR9AlsEwJIFOI75
	 HcThQ5N2uAgvVO+cLlgWXmQuKhxQP3W71qzXMPUsAjvKUCQzDiTGgKjhTAOTuGBgHK2qy
	 G9q/TOJalTw7mu0x3soWxsi63FTe/kxuBVq/DZ2hpVz0GiF5WCHq8kQ8k0MD9lJfZp4lF
	 izjJVmNJf9oo4PpKYt1HXHYRzbSPnJ/sGqZOcfEFWhk+DvlQgNUjRIMVMO4rKZUfbSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ojNEEzOmgQHbxZ2ZuRhWj+oyH82/ZxWdhUa6dGCluIs=;
	b=JLYRTj8N4x9DE7U4x19nI0SI33OubNCG3/FiUuses/iaJ/+16JTifoJEVZwbzMkhfdTx
	 gqW7xq+NQ5kRZKKLrEqegVngYZuNSEnVyzBZWGY/EooOYeOiQKIpzuCiWPvQpHPdSsCr3
	 Smd0HXNlJI6LgGW6+wpFupyBIFs+gYW/+tjjiymtYKO1A1gyhGVBi52cZup0CrI9JsiiV
	 PbXSj1+I9ZwmB4CQA/YCfLWdaNzwXBng3BleNAA3f9V3tevphl1eTAp+P/NqEYTDKzIgX
	 CDyvIfv6MJRNU1SXrtkkl+aE0GDyW0CQBYhMkFEXMgMptpA18/h0BuQ0WlbAr1ANWeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pmUbe7va;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5D6606EE97;
	Sat,  7 Nov 2026 15:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pmUbe7va
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCE71F008A4;
	Sat,  7 Nov 2026 15:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063967;
	bh=ojNEEzOmgQHbxZ2ZuRhWj+oyH82/ZxWdhUa6dGCluIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pmUbe7vazjUCoXp2OUwQaiThEQ3sqFiGCiVKNVD6MwI9v6BS0dIvmpdzvuJbYrHQQ
	 zaAEMMq6vEyJJeCZFuuTgtIK3xRmaGnKuWdQHsT2xrXrQ0jhdFepkp+shgQuC6RaHU
	 2QgmEb/9t/zx2eiNghRMEs2+njEzN2NbA6OEvsqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0154/1257] PCI: endpoint: pci-epf-vntb: Manage virtual NTB and PCI bus lifetime
Date: Sat,  7 Nov 2026 08:40:50 -0500
Message-ID: <20261107134943.571200165@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 5cdbd6d3a3a147fa9975e35f2602cbec9a72a932 ]

The virtual PCI driver registers an ntb_dev but has no remove callback.
Unbinding the endpoint function can therefore free BARs while the NTB
device and its client still use them. It also leaves the virtual PCI
devices and root bus allocated.

Allocate an ntb_dev for each virtual PCI probe and unregister it from the
matching remove callback. Start command processing only after registration.
Publish the device for doorbell IRQs at the same point. During remove, stop
the command work and drain IRQ handlers before unregistering the device.

Retain the root bus returned by pci_scan_bus() so it can be removed on
unbind. Unregister the virtual PCI driver before releasing endpoint
resources. Stop and remove the root bus under the PCI rescan/remove lock,
then release its host bridge.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org # 6.0+
Link: https://patch.msgid.link/20260901063238.631166-3-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 85 +++++++++++++++----
 1 file changed, 70 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index c3caec927d748..8ae50779452a9 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -132,7 +132,7 @@ struct epf_ntb_ctrl {
 } __packed;
 
 struct epf_ntb {
-	struct ntb_dev ntb;
+	struct ntb_dev *ntb;
 	struct pci_epf *epf;
 	struct config_group group;
 
@@ -166,10 +166,15 @@ struct epf_ntb {
 	void __iomem *vpci_mw_addr[MAX_MW];
 
 	struct delayed_work cmd_handler;
+	struct pci_bus *vpci_bus;
 };
 
 #define to_epf_ntb(epf_group) container_of((epf_group), struct epf_ntb, group)
-#define ntb_ndev(__ntb) container_of(__ntb, struct epf_ntb, ntb)
+
+static struct epf_ntb *ntb_ndev(struct ntb_dev *ntb)
+{
+	return ntb->pdev->sysdata;
+}
 
 static struct pci_epf_header epf_ntb_header = {
 	.vendorid	= PCI_ANY_ID,
@@ -195,7 +200,7 @@ static int epf_ntb_link_up(struct epf_ntb *ntb, bool link_up)
 	else
 		ntb->reg->link_status &= ~LINK_STATUS_UP;
 
-	ntb_link_event(&ntb->ntb);
+	ntb_link_event(ntb->ntb);
 	return 0;
 }
 
@@ -284,7 +289,7 @@ static void epf_ntb_cmd_handler(struct work_struct *work)
 	     i++) {
 		if (ntb->epf_db[i]) {
 			atomic64_or(1 << (i - EPF_IRQ_DB_START), &ntb->db);
-			ntb_db_event(&ntb->ntb, i - EPF_IRQ_DB_START);
+			ntb_db_event(ntb->ntb, i - EPF_IRQ_DB_START);
 			ntb->epf_db[i] = 0;
 		}
 	}
@@ -348,12 +353,18 @@ static void epf_ntb_cmd_handler(struct work_struct *work)
 static irqreturn_t epf_ntb_doorbell_handler(int irq, void *data)
 {
 	struct epf_ntb *ntb = data;
+	struct ntb_dev *ndev;
 	int i;
 
+	/* Pair with smp_store_release() in pci_vntb_probe() */
+	ndev = smp_load_acquire(&ntb->ntb);
+	if (!ndev)
+		return IRQ_HANDLED;
+
 	for (i = EPF_IRQ_DB_START; i < ntb->db_count; i++)
 		if (irq == ntb->epf->db_msg[i].virq) {
 			atomic64_or(1 << (i - EPF_IRQ_DB_START), &ntb->db);
-			ntb_db_event(&ntb->ntb, i - EPF_IRQ_DB_START);
+			ntb_db_event(ndev, i - EPF_IRQ_DB_START);
 		}
 
 	return IRQ_HANDLED;
@@ -985,7 +996,6 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
 	}
 
 	INIT_DELAYED_WORK(&ntb->cmd_handler, epf_ntb_cmd_handler);
-	queue_work(kpcintb_workqueue, &ntb->cmd_handler.work);
 
 	atomic64_set(&ntb->peer_db_pending, 0);
 	enable_work(&ntb->peer_db_work);
@@ -1337,6 +1347,7 @@ static int vpci_scan_bus(void *sysdata)
 		pr_err("create pci bus failed\n");
 		return -EINVAL;
 	}
+	ndev->vpci_bus = vpci_bus;
 
 	pci_bus_add_devices(vpci_bus);
 
@@ -1420,7 +1431,7 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
 	int ret;
 	struct device *dev;
 
-	dev = &ntb->ntb.dev;
+	dev = &ndev->dev;
 	barno = ntb->epf_ntb_bar[BAR_MW1 + idx];
 	epf_bar = &ntb->epf->bar[barno];
 	epf_bar->phys_addr = addr;
@@ -1558,7 +1569,7 @@ static void vntb_epf_peer_db_work(struct work_struct *work)
 			ret = pci_epc_raise_irq(epf->epc, func_no, vfunc_no,
 						PCI_IRQ_MSI, interrupt_num);
 			if (ret)
-				dev_err(&ntb->ntb.dev,
+				dev_err(&epf->dev,
 					"Failed to raise IRQ for interrupt_num %u: %d\n",
 					interrupt_num, ret);
 		}
@@ -1676,13 +1687,18 @@ static const struct ntb_dev_ops vntb_epf_ops = {
 
 static int pci_vntb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int ret;
 	struct epf_ntb *ndev = (struct epf_ntb *)pdev->sysdata;
 	struct device *dev = &pdev->dev;
+	struct ntb_dev *ntb;
+	int ret;
 
-	ndev->ntb.pdev = pdev;
-	ndev->ntb.topo = NTB_TOPO_NONE;
-	ndev->ntb.ops =  &vntb_epf_ops;
+	ntb = devm_kzalloc(dev, sizeof(*ntb), GFP_KERNEL);
+	if (!ntb)
+		return -ENOMEM;
+
+	ntb->pdev = pdev;
+	ntb->topo = NTB_TOPO_NONE;
+	ntb->ops = &vntb_epf_ops;
 
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret) {
@@ -1690,16 +1706,41 @@ static int pci_vntb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 	}
 
-	ret = ntb_register_device(&ndev->ntb);
+	ret = ntb_register_device(ntb);
 	if (ret) {
 		dev_err(dev, "Failed to register NTB device\n");
 		return ret;
 	}
 
+	/* Publish after ntb_register_device() succeeds */
+	smp_store_release(&ndev->ntb, ntb);
+	queue_delayed_work(kpcintb_workqueue, &ndev->cmd_handler, 0);
+
 	dev_dbg(dev, "PCI Virtual NTB driver loaded\n");
 	return 0;
 }
 
+static void pci_vntb_remove(struct pci_dev *pdev)
+{
+	struct epf_ntb *ndev = pdev->sysdata;
+	struct ntb_dev *ntb;
+	unsigned int i;
+
+	/* Stop the work reader, then close and drain the IRQ gate */
+	cancel_delayed_work_sync(&ndev->cmd_handler);
+
+	ntb = xchg(&ndev->ntb, NULL);
+
+	if (ndev->msi_doorbell)
+		for (i = 0; i < ndev->db_count; i++) {
+			if (epf_ntb_db_irq_is_duplicated(ndev->epf, i))
+				continue;
+			synchronize_irq(ndev->epf->db_msg[i].virq);
+		}
+
+	ntb_unregister_device(ntb);
+}
+
 static struct pci_device_id pci_vntb_table[] = {
 	{
 		PCI_DEVICE(0xffff, 0xffff),
@@ -1711,6 +1752,7 @@ static struct pci_driver vntb_pci_driver = {
 	.name           = "pci-vntb",
 	.id_table       = pci_vntb_table,
 	.probe          = pci_vntb_probe,
+	.remove         = pci_vntb_remove,
 };
 
 /* ============ PCIe EPF Driver Bind ====================*/
@@ -1791,12 +1833,25 @@ static int epf_ntb_bind(struct pci_epf *epf)
  */
 static void epf_ntb_unbind(struct pci_epf *epf)
 {
+	struct pci_host_bridge *bridge;
 	struct epf_ntb *ntb = epf_get_drvdata(epf);
 
+	pci_unregister_driver(&vntb_pci_driver);
+
+	if (ntb->vpci_bus) {
+		bridge = to_pci_host_bridge(ntb->vpci_bus->bridge);
+
+		pci_lock_rescan_remove();
+		pci_stop_root_bus(ntb->vpci_bus);
+		pci_remove_root_bus(ntb->vpci_bus);
+		ntb->vpci_bus = NULL;
+		pci_unlock_rescan_remove();
+
+		pci_free_host_bridge(bridge);
+	}
+
 	epf_ntb_epc_cleanup(ntb);
 	epf_ntb_config_spad_bar_free(ntb);
-
-	pci_unregister_driver(&vntb_pci_driver);
 }
 
 // EPF driver probe
-- 
2.53.0



