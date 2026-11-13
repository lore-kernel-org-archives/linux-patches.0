Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591319;
	b=32A1bIxo0a9HMjGBQxWh6D4j/7Q2cgqS5dZgC9Ak+cyHNaHcJowT/9jbZx7rPfq88lUI
	 hv/zEmF9WdCm0vvGgwOgeWurjfS4+0vitTsw2hSde8XpznAYWoNbzjH4PVpCzJSlLPpKr
	 WIgU/0SRhjrooB0fZZxGOkOB6vm0tuLg+7+s71IJepd/lO8wZHZtvCawpHsi7mLfMU2j8
	 lC75lplYOSpVsVRXlYtQ2W8B1gk5Yp7Mjs4KOSUI1ysjh/ifWliX7yDJXMPSKPG/gA4yj
	 NS0j2hA6LPXGViX40JGb179/rSrSHpAjKlUz9sBIXNBLvBfb2z4KvJJR8jBSUL+7rww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BWZSuIYrKuoxa9w3Be/jZh8erxZYJXBMfW8VOODpA40=;
	b=XsJUhovCHvozP0nQgpYI8dU7QX4XZ9fH33OrIogh6aZRoRc/5TH1SVaMRZB/H9YNgG8Y
	 DclJaCfLxpbBv29uc5fJd6tAS5RzSU2GvEDRwPMy7Fk9ONLJWnFKQaIzGzIqzjYVs44fE
	 WOm73XlITgCr0PYNLNSQ09Nv5VmcheZaWITA+2IEHhn2YO+/ORdLGahwcSHZAoeMgr80G
	 0nxYKJQz3OpcuByYfhS9yqeUqCe4LnIJjXtp+cxUBxyirflXSkGpLx6mwtbNq7Xn2Dlt5
	 fT/9eeNpnEVhfqC2nyDytlEmxtAukuhkfzPQz/A0dMl4tX0qXYEl7ogyZxFDUUbXANA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVOkptzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD0A60776DC;
	Fri, 13 Nov 2026 17:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVOkptzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8961F000C9;
	Fri, 13 Nov 2026 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591319;
	bh=BWZSuIYrKuoxa9w3Be/jZh8erxZYJXBMfW8VOODpA40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVOkptzWnSVIMdg7prWf3ioUr72ftkFLWL88sHgbfUzkkqT//XTUxnAf8sT1bNIkH
	 8rjWHfPPdLH7S9Ud6Ko4GT6h0HtE7TsiZQRzW7WAYWSOMHXQbVoPxhPc4Qpu24L1UL
	 vXymh+Xz+vFLAdQhBej66oP/unt5BFduCr+ebXbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 425/670] PCI: endpoint: pci-epf-vntb: Manage virtual NTB and PCI bus lifetime
Date: Fri, 13 Nov 2026 10:49:49 -0500
Message-ID: <20261113153826.136431763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted NTB pointer changes to the existing polling doorbell implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 69 +++++++++++++++----
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 963a1a1f983db..710bddc30cdfc 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -116,7 +116,7 @@ struct epf_ntb_ctrl {
 } __packed;
 
 struct epf_ntb {
-	struct ntb_dev ntb;
+	struct ntb_dev *ntb;
 	struct pci_epf *epf;
 	struct config_group group;
 
@@ -142,10 +142,15 @@ struct epf_ntb {
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
@@ -171,7 +176,7 @@ static int epf_ntb_link_up(struct epf_ntb *ntb, bool link_up)
 	else
 		ntb->reg->link_status &= ~LINK_STATUS_UP;
 
-	ntb_link_event(&ntb->ntb);
+	ntb_link_event(ntb->ntb);
 	return 0;
 }
 
@@ -259,7 +264,7 @@ static void epf_ntb_cmd_handler(struct work_struct *work)
 	for (i = 1; i < ntb->db_count; i++) {
 		if (ntb->epf_db[i]) {
 			ntb->db |= 1 << (i - 1);
-			ntb_db_event(&ntb->ntb, i);
+			ntb_db_event(ntb->ntb, i);
 			ntb->epf_db[i] = 0;
 		}
 	}
@@ -760,7 +765,6 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
 	}
 
 	INIT_DELAYED_WORK(&ntb->cmd_handler, epf_ntb_cmd_handler);
-	queue_work(kpcintb_workqueue, &ntb->cmd_handler.work);
 
 	return 0;
 
@@ -1009,6 +1013,7 @@ static int vpci_scan_bus(void *sysdata)
 		pr_err("create pci bus failed\n");
 		return -EINVAL;
 	}
+	ndev->vpci_bus = vpci_bus;
 
 	pci_bus_add_devices(vpci_bus);
 
@@ -1053,7 +1058,7 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
 	int ret;
 	struct device *dev;
 
-	dev = &ntb->ntb.dev;
+	dev = &ndev->dev;
 	barno = ntb->epf_ntb_bar[BAR_MW0 + idx];
 	epf_bar = &ntb->epf->bar[barno];
 	epf_bar->phys_addr = addr;
@@ -1153,7 +1158,7 @@ static int vntb_epf_peer_db_set(struct ntb_dev *ndev, u64 db_bits)
 	ret = pci_epc_raise_irq(ntb->epf->epc, func_no, vfunc_no,
 				PCI_IRQ_MSI, interrupt_num + 1);
 	if (ret)
-		dev_err(&ntb->ntb.dev, "Failed to raise IRQ\n");
+		dev_err(&ntb->epf->dev, "Failed to raise IRQ\n");
 
 	return ret;
 }
@@ -1236,13 +1241,18 @@ static const struct ntb_dev_ops vntb_epf_ops = {
 
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
@@ -1250,16 +1260,33 @@ static int pci_vntb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1271,6 +1298,7 @@ static struct pci_driver vntb_pci_driver = {
 	.name           = "pci-vntb",
 	.id_table       = pci_vntb_table,
 	.probe          = pci_vntb_probe,
+	.remove         = pci_vntb_remove,
 };
 
 /* ============ PCIe EPF Driver Bind ====================*/
@@ -1351,12 +1379,25 @@ static int epf_ntb_bind(struct pci_epf *epf)
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



