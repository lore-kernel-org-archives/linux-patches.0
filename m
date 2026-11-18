Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038175;
	b=00qd16nfiQB/h3q/jnDvNxSKym6iKgpCvVye5QHO5bDvykZczbz2MOn8SvtRMkUXvK/1
	 tiMrd+3l/W9y7km5eIP/aA7O9VKhqDthAsLkboA5NkbBCckAp08aEcz1sjYILVClBk5+y
	 RKWHXMkMj+in0CIbEM0qJ7qf4DCdtdxafL1j077m7okZ03riiVif7odEwRk2ZJlJiuxoB
	 7v9VWjY1vUjm3hNYDajQhE71dcGycQQYEkzA9wr+jaTO/vaW4pa/PtCMJwhfqnjGMfD5P
	 Fhi00Dr+HF+MIL+FnhsyHernPDVrtaONejYuY7Z2IQHyaSq9xiP8DW/WTmbFxm8ZKvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U9Y7QioAHguRzV2lcKXprIYECyZwGeODLiD6yhUKQtw=;
	b=B9gG5hX11yNcnaSVWca3TBovQDEXzSiZ8+ZnKVd15K/Z7qhms61hkvXKPGxivW051N/R
	 sszGqTBn0K9Yd8HuTz76DlXWg3hgft2fwYkz2fdhThkOSM3ka8ZxyDAIhjOF4G93+v/mJ
	 Pes1YbQEBSwugBE+WPnlg1CejxW63PPnYvcuRu/oxmnwW0vwFN2qQ9TjabQ7Zyv5x0519
	 fnQLvbWzTIxiGnk/rbc/ImjSy+/YUCb+Al2DUN0mw37uHZJlRN9s7zl0R6Es1SFS9/wFa
	 5U5yvmDwQOS4JKDX2zrKo5b+m/yWIy+FlH/59q6TQQbxOyzT1Xs11ZfVzMqzLiHlruw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfmpGbUw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D09606A31C;
	Wed, 18 Nov 2026 21:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfmpGbUw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A186F1F000C4;
	Wed, 18 Nov 2026 21:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038175;
	bh=U9Y7QioAHguRzV2lcKXprIYECyZwGeODLiD6yhUKQtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfmpGbUws3+U1a7WNhwbAI6tfSo9AmakNmz+rX5yjeVHY8E+XLqCWaY72XKBiNw9u
	 pcNzR6UHKW+cQ3PJpx13Hm6fwZXZxBm9Oh8KQHxWx/lOnPCbjWGOAEyoKKpXEsNq6W
	 uScto2kADgp+ydRvbcgaFuUNmUwecy0t+ebO6LbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1611/3318] PCI: endpoint: pci-epf-vntb: Manage virtual NTB and PCI bus lifetime
Date: Wed, 18 Nov 2026 15:37:13 +0100
Message-ID: <20261118150409.517928465@linuxfoundation.org>
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
[ sashal: adapted lifetime handling to the polling-based doorbell implementation without MSI doorbell IRQ support ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 69 +++++++++++++++----
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 22364ebd73ed7..3de4269155f67 100644
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
@@ -771,7 +776,6 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
 	}
 
 	INIT_DELAYED_WORK(&ntb->cmd_handler, epf_ntb_cmd_handler);
-	queue_work(kpcintb_workqueue, &ntb->cmd_handler.work);
 
 	return 0;
 
@@ -1020,6 +1024,7 @@ static int vpci_scan_bus(void *sysdata)
 		pr_err("create pci bus failed\n");
 		return -EINVAL;
 	}
+	ndev->vpci_bus = vpci_bus;
 
 	pci_bus_add_devices(vpci_bus);
 
@@ -1064,7 +1069,7 @@ static int vntb_epf_mw_set_trans(struct ntb_dev *ndev, int pidx, int idx,
 	int ret;
 	struct device *dev;
 
-	dev = &ntb->ntb.dev;
+	dev = &ndev->dev;
 	barno = ntb->epf_ntb_bar[BAR_MW0 + idx];
 	epf_bar = &ntb->epf->bar[barno];
 	epf_bar->phys_addr = addr;
@@ -1167,7 +1172,7 @@ static int vntb_epf_peer_db_set(struct ntb_dev *ndev, u64 db_bits)
 				PCI_EPC_IRQ_MSI,
 				interrupt_num + 1);
 	if (ret)
-		dev_err(&ntb->ntb.dev, "Failed to raise IRQ\n");
+		dev_err(&ntb->epf->dev, "Failed to raise IRQ\n");
 
 	return ret;
 }
@@ -1250,13 +1255,18 @@ static const struct ntb_dev_ops vntb_epf_ops = {
 
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
@@ -1264,16 +1274,33 @@ static int pci_vntb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1285,6 +1312,7 @@ static struct pci_driver vntb_pci_driver = {
 	.name           = "pci-vntb",
 	.id_table       = pci_vntb_table,
 	.probe          = pci_vntb_probe,
+	.remove         = pci_vntb_remove,
 };
 
 /* ============ PCIe EPF Driver Bind ====================*/
@@ -1365,12 +1393,25 @@ static int epf_ntb_bind(struct pci_epf *epf)
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



