Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046656;
	b=1LjD+3U2azvd7i9cf0QBVFIZLiU05P2aZf1FAKnni6kXZhC/97qrKqKV1QB4Gui2e/9l
	 +Gua9GBjo8L8FYZatOiiWFedDbrCwrVvdaA7mTQbcBIGTICoWNq2TUhIQWw7tyZwU4Kk3
	 mSpXKeXBxVutKhgdIRDffaVrKXSmxixSfrvQwWIzpXUbEJz6a9dL4O5W4mL2v/QyoC4Hu
	 47KDpwZ5hGcbAeVd+INV5PDad1RFk93zVl9/ptMT3POzs1cxgJVM/ysL+za9I6E0hMpke
	 v3TNCLLfNTeeHC4LjDU2e6ohybqQaIw51JbF10N6vZqnbDC7oBcLgn8CuzZJ8c9pihw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MjTvYkAX+7DRo6UuHXwForwCvmN6V0bk834fbqYSUSI=;
	b=MnisiwwR6uSP4YUrBoH+yCUroXQeFfqxr4hOpnCwA+ZgVJ45iER8VVpqXU8ZK6IgxEhX
	 NgprVAVmeD2Cy0KWDSEUR1RysbCVcl7USf8++7keZJ/3f4Mmj+392yEB4w5Oe6f74Y9zc
	 J21GkzklF5rTQ6JeVaXLoi3SmxAusshy/pzD/7NCqi5r/VMENHnuuercxpJz76clQwaF+
	 dVQa61jxON3dNt94ldcW55BPhIXvYceerbQwqQA7rpDe74q4CO95wW2UOAX90qS1FOnJB
	 Z58fcAG0pnqHLLgUnWvZQzYnqK3FRLpNxcmT4ovDcs3JcAI2gA06udusdvcDgYe+wYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeuJy1SM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB0F606A31C;
	Thu, 19 Nov 2026 00:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeuJy1SM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DD61F000C4;
	Thu, 19 Nov 2026 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046656;
	bh=MjTvYkAX+7DRo6UuHXwForwCvmN6V0bk834fbqYSUSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeuJy1SMiEgzgN0WSjPSq8TMnSMDZ17FoClzHQDcMA+gHgTSLB1RfBfs2oO48OloE
	 ED6z+j59PvWvHoBsd0mEs4vTr6UkeUNso63bbdRW9VcFPmvhw6j6XhCbUXA6PnE5wf
	 TGjEDQniRHb1SXUZ2iMqzruUeFf79wQNbSqrG7F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1359/2857] PCI: endpoint: pci-epf-vntb: Manage virtual NTB and PCI bus lifetime
Date: Wed, 18 Nov 2026 15:39:53 +0100
Message-ID: <20261118150250.338118696@linuxfoundation.org>
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
[ sashal: Adapted NTB pointer handling to the existing polling-based doorbell code without MSI IRQ handlers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 69 +++++++++++++++----
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 15c707840cc20..aa5f96e3ef74f 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -116,7 +116,7 @@ struct epf_ntb_ctrl {
 } __packed;
 
 struct epf_ntb {
-	struct ntb_dev ntb;
+	struct ntb_dev *ntb;
 	struct pci_epf *epf;
 	struct config_group group;
 
@@ -143,10 +143,15 @@ struct epf_ntb {
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
@@ -172,7 +177,7 @@ static int epf_ntb_link_up(struct epf_ntb *ntb, bool link_up)
 	else
 		ntb->reg->link_status &= ~LINK_STATUS_UP;
 
-	ntb_link_event(&ntb->ntb);
+	ntb_link_event(ntb->ntb);
 	return 0;
 }
 
@@ -262,7 +267,7 @@ static void epf_ntb_cmd_handler(struct work_struct *work)
 			if (readl(ntb->epf_db + i * 4))
 				ntb->db |= 1 << (i - 1);
 
-			ntb_db_event(&ntb->ntb, i);
+			ntb_db_event(ntb->ntb, i);
 			writel(0, ntb->epf_db + i * 4);
 		}
 	}
@@ -774,7 +779,6 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
 	}
 
 	INIT_DELAYED_WORK(&ntb->cmd_handler, epf_ntb_cmd_handler);
-	queue_work(kpcintb_workqueue, &ntb->cmd_handler.work);
 
 	return 0;
 
@@ -1023,6 +1027,7 @@ static int vpci_scan_bus(void *sysdata)
 		pr_err("create pci bus failed\n");
 		return -EINVAL;
 	}
+	ndev->vpci_bus = vpci_bus;
 
 	pci_bus_add_devices(vpci_bus);
 
@@ -1067,7 +1072,7 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
 	int ret;
 	struct device *dev;
 
-	dev = &ntb->ntb.dev;
+	dev = &ndev->dev;
 	barno = ntb->epf_ntb_bar[BAR_MW0 + idx];
 	epf_bar = &ntb->epf->bar[barno];
 	epf_bar->phys_addr = addr;
@@ -1170,7 +1175,7 @@ static int vntb_epf_peer_db_set(struct ntb_dev *ndev, u64 db_bits)
 				PCI_EPC_IRQ_MSI,
 				interrupt_num + 1);
 	if (ret)
-		dev_err(&ntb->ntb.dev, "Failed to raise IRQ\n");
+		dev_err(&ntb->epf->dev, "Failed to raise IRQ\n");
 
 	return ret;
 }
@@ -1253,13 +1258,18 @@ static const struct ntb_dev_ops vntb_epf_ops = {
 
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
@@ -1267,16 +1277,33 @@ static int pci_vntb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -EINVAL;
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
+
+	/* Stop the work reader */
+	cancel_delayed_work_sync(&ndev->cmd_handler);
+
+	ntb = xchg(&ndev->ntb, NULL);
+
+	ntb_unregister_device(ntb);
+}
+
 static struct pci_device_id pci_vntb_table[] = {
 	{
 		PCI_DEVICE(0xffff, 0xffff),
@@ -1288,6 +1315,7 @@ static struct pci_driver vntb_pci_driver = {
 	.name           = "pci-vntb",
 	.id_table       = pci_vntb_table,
 	.probe          = pci_vntb_probe,
+	.remove         = pci_vntb_remove,
 };
 
 /* ============ PCIe EPF Driver Bind ====================*/
@@ -1368,12 +1396,25 @@ static int epf_ntb_bind(struct pci_epf *epf)
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



