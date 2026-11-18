Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020591;
	b=bySqtWPyBrIn8f+AAGRZNxL4LMrywW2naXZ5A0/u2T39Pkb+5cUSSmymSEVZk2Vdhnlp
	 8ipHj3cTgtYJUEBwXzfEtxs+1IOJOVaIdZI5xxAbxqIRjyK46CtGpPsLDoqh5/nhCADSO
	 crC53eZ6MvkokW2lOIxW9K1tPq3DF1nJbk8/AwlfQZgBC1ZvNtyGkFQFSL8bJfex/mVFp
	 zBVQab850V4dLZ9f/bYEu04baxbdd+6luzyq4w65ATK1OWAYwNUbfdnxdT8MnKq2jABRk
	 bD2tlJ3QMUsOBzccugoFSwCF3GXYujSKCT0OnBempeaMYj7XbA2VOvt0pY6tODdG9Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L/3CpbBdiHRiNDiAMpYKmHQr9ccO92TXyXuPz06eRzY=;
	b=SnEgyHKUNXx7GPc5U4JUR6tNx7Z8IyRpH/guv/aozzCg+ha44HD+Xz5v8QNHNNWqVx5Y
	 la6NSnAFeogNaHl14VJBbccQLFSx//GGVYPqLCgnsRDIqdxfLSoAxYWBz61z0ao1Vm35t
	 MX8iqCkKcWt9uBF+4/jMEdllAcqvDmyWpdEpfUyT5MBtgXq7gUeooGScE6X0dE940dYq/
	 mvYI/LttMB/GbhvnSpJp5LX1vN6yJjMAmP+plwd1FRHqigKDSNYWRlQZNaaX/v1/QjPGn
	 E5bGv+uboM7p7s7yxHud3QqEp6G/0sb2KbeRdNnEnSwJJ78J1YYFv62J6a2R/hZQi/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4W7UQ5E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4E5606A31C;
	Wed, 18 Nov 2026 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4W7UQ5E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F406A1F000C4;
	Wed, 18 Nov 2026 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020591;
	bh=L/3CpbBdiHRiNDiAMpYKmHQr9ccO92TXyXuPz06eRzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4W7UQ5EM7+F3sXZ63trhZESKIFk10UN7ffZu/bMqWSm1SiIRmfzRANC93Ez+URCo
	 Vhgys3a5bfZQUyUDCrpChhfjw/4L+arkjijQpXpP5v8uK00rfZsWhWUGVyPH3EliY1
	 MfXM2YGfgKDjL+suPMXClxYlir3ff3RFn7ALjBWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1969/2651] PCI: endpoint: pci-epf-vntb: Track link state from both sides
Date: Wed, 18 Nov 2026 15:53:29 +0100
Message-ID: <20261118150357.361045833@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit f9eabc48327fae33cf0a02a8f312c24505dc413b ]

The control-region link status is currently updated only by
COMMAND_LINK_UP and COMMAND_LINK_DOWN from the HOST. The virtual
NTB link callbacks are empty. Consequently, the HOST can see the link as
up before the VHOST has enabled it, and ntb_link_disable() on the VHOST
leaves LINK_STATUS_UP set without notifying either NTB client.

ntb_netdev can hide this device-level state bug because ntb_transport uses
a separate per-QP LINK_DOWN_FLAG message. Use ntb_tool to observe the
device link state directly:

After bringing both sides up, start one waiter on each side:

  HOST# echo N > /sys/kernel/debug/ntb_tool/<H-device>/peer0/link_event
  VHOST# echo N > /sys/kernel/debug/ntb_tool/<V-device>/peer0/link_event

While both waiters are blocked, disable the link on the VHOST:

  VHOST# echo N > /sys/kernel/debug/ntb_tool/<V-device>/link

Without this patch, the link-disable command succeeds, but peer0/link
remains Y on both sides and neither waiter returns.

Track HOST and VHOST enablement separately and report the effective link
as up only when both sides have enabled it, as pci-epf-ntb does for its
two physical hosts. Both NTB clients observe this effective state, so
notify both sides only when it changes, including the side whose request
completes the transition. Serialize the two paths because HOST commands
run from delayed work while the VHOST callbacks may run concurrently.

With this patch, peer0/link changes to N on both sides and both waiters
return.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20261014071448.2473208-1-den@valinux.co.jp/
Link: https://patch.msgid.link/20261015142716.3452900-1-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 98 +++++++++++++++----
 1 file changed, 78 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 07ba338732d4e..bebdd93a067c0 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -41,6 +41,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #include <linux/pci-ep-msi.h>
@@ -147,7 +148,10 @@ struct epf_ntb {
 	u16 vntb_pid;
 	u16 vntb_vid;
 
-	bool linkup;
+	/* Serialize HOST and VHOST link state changes. */
+	struct mutex link_lock;
+	bool host_link_enabled;
+	bool vhost_link_enabled;
 
 	/*
 	 * True when doorbells are interrupt-driven (MSI or embedded), false
@@ -183,24 +187,55 @@ static struct pci_epf_header epf_ntb_header = {
 	.interrupt_pin	= PCI_INTERRUPT_INTA,
 };
 
+static void epf_ntb_update_link(struct epf_ntb *ntb)
+{
+	u16 link_status = READ_ONCE(ntb->reg->link_status);
+
+	/* The link is usable only after both sides have enabled it. */
+	if (ntb->host_link_enabled && ntb->vhost_link_enabled)
+		link_status |= LINK_STATUS_UP;
+	else
+		link_status &= ~LINK_STATUS_UP;
+
+	WRITE_ONCE(ntb->reg->link_status, link_status);
+}
+
+static int epf_ntb_notify_link(struct ntb_dev *ndev)
+{
+	struct pci_epf *epf = ntb_ndev(ndev)->epf;
+	int ret;
+
+	ntb_link_event(ndev);
+
+	ret = pci_epc_raise_irq(epf->epc, epf->func_no, epf->vfunc_no,
+				PCI_IRQ_MSI, EPF_IRQ_LINK + 1);
+	if (ret)
+		dev_err(&epf->dev, "Failed to raise link event IRQ: %d\n", ret);
+
+	return ret;
+}
+
 /**
- * epf_ntb_link_up() - Raise link_up interrupt to Virtual Host (VHOST)
+ * epf_ntb_set_link_enabled() - Set HOST link enablement
  * @ntb: NTB device that facilitates communication between HOST and VHOST
- * @link_up: true or false indicating Link is UP or Down
- *
- * Once NTB function in HOST invoke ntb_link_enable(),
- * this NTB function driver will trigger a link event to VHOST.
+ * @enabled: true when the HOST has enabled the link
  *
  * Returns: Zero for success, or an error code in case of failure
  */
-static int epf_ntb_link_up(struct epf_ntb *ntb, bool link_up)
+static int epf_ntb_set_link_enabled(struct epf_ntb *ntb, bool enabled)
 {
-	if (link_up)
-		ntb->reg->link_status |= LINK_STATUS_UP;
-	else
-		ntb->reg->link_status &= ~LINK_STATUS_UP;
+	bool notify;
+
+	scoped_guard(mutex, &ntb->link_lock) {
+		notify = ntb->host_link_enabled != enabled &&
+			 ntb->vhost_link_enabled;
+		ntb->host_link_enabled = enabled;
+		epf_ntb_update_link(ntb);
+	}
+
+	if (notify)
+		return epf_ntb_notify_link(ntb->ntb);
 
-	ntb_link_event(ntb->ntb);
 	return 0;
 }
 
@@ -325,16 +360,14 @@ static void epf_ntb_cmd_handler(struct work_struct *work)
 		ctrl->command_status = COMMAND_STATUS_OK;
 		break;
 	case COMMAND_LINK_UP:
-		ntb->linkup = true;
-		ret = epf_ntb_link_up(ntb, true);
+		ret = epf_ntb_set_link_enabled(ntb, true);
 		if (ret < 0)
 			ctrl->command_status = COMMAND_STATUS_ERROR;
 		else
 			ctrl->command_status = COMMAND_STATUS_OK;
 		goto reset_handler;
 	case COMMAND_LINK_DOWN:
-		ntb->linkup = false;
-		ret = epf_ntb_link_up(ntb, false);
+		ret = epf_ntb_set_link_enabled(ntb, false);
 		if (ret < 0)
 			ctrl->command_status = COMMAND_STATUS_ERROR;
 		else
@@ -1472,11 +1505,29 @@ static int vntb_epf_peer_mw_get_addr(struct ntb_dev *ndev, int idx,
 	return 0;
 }
 
+static int vntb_epf_set_link_enabled(struct ntb_dev *ndev, bool enabled)
+{
+	struct epf_ntb *ntb = ntb_ndev(ndev);
+	bool notify;
+
+	scoped_guard(mutex, &ntb->link_lock) {
+		notify = ntb->vhost_link_enabled != enabled &&
+			 ntb->host_link_enabled;
+		ntb->vhost_link_enabled = enabled;
+		epf_ntb_update_link(ntb);
+	}
+
+	if (notify)
+		return epf_ntb_notify_link(ndev);
+
+	return 0;
+}
+
 static int vntb_epf_link_enable(struct ntb_dev *ntb,
 			enum ntb_speed max_speed,
 			enum ntb_width max_width)
 {
-	return 0;
+	return vntb_epf_set_link_enabled(ntb, true);
 }
 
 static u32 vntb_epf_spad_read(struct ntb_dev *ndev, int idx)
@@ -1636,7 +1687,7 @@ static u64 vntb_epf_link_is_up(struct ntb_dev *ndev,
 {
 	struct epf_ntb *ntb = ntb_ndev(ndev);
 
-	return ntb->reg->link_status;
+	return READ_ONCE(ntb->reg->link_status);
 }
 
 static int vntb_epf_db_clear_mask(struct ntb_dev *ndev, u64 db_bits)
@@ -1654,7 +1705,7 @@ static int vntb_epf_db_clear(struct ntb_dev *ndev, u64 db_bits)
 
 static int vntb_epf_link_disable(struct ntb_dev *ntb)
 {
-	return 0;
+	return vntb_epf_set_link_enabled(ntb, false);
 }
 
 static struct device *vntb_epf_get_dma_dev(struct ntb_dev *ndev)
@@ -1797,6 +1848,10 @@ static int epf_ntb_bind(struct pci_epf *epf)
 		goto err_bar_alloc;
 	}
 
+	ntb->host_link_enabled = false;
+	ntb->vhost_link_enabled = false;
+	ntb->reg->link_status = 0;
+
 	ret = epf_ntb_epc_init(ntb);
 	if (ret) {
 		dev_err(dev, "Failed to initialize EPC\n");
@@ -1882,7 +1937,7 @@ static int epf_ntb_probe(struct pci_epf *epf,
 {
 	struct epf_ntb *ntb;
 	struct device *dev;
-	int i;
+	int ret, i;
 
 	dev = &epf->dev;
 
@@ -1893,6 +1948,9 @@ static int epf_ntb_probe(struct pci_epf *epf,
 	epf->header = &epf_ntb_header;
 	ntb->epf = epf;
 	ntb->vbus_number = 0xff;
+	ret = devm_mutex_init(dev, &ntb->link_lock);
+	if (ret)
+		return ret;
 
 	INIT_WORK(&ntb->peer_db_work, vntb_epf_peer_db_work);
 	disable_work(&ntb->peer_db_work);
-- 
2.53.0



