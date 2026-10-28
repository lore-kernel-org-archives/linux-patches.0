Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214490;
	b=S0Qb5Wiiv/ygyku1kpzqNOjVabrD/7pE/RpiShaq/eV9tP0LIHSt0P81g7Cjt67U96p3
	 UHbUka0x0Gnbuhmi8wZeV49xKPjN1wUhcvVeW57eEJROhUqJu5/jhhyzKebn9uh3zSVXt
	 pECAdITLxRS/ngbnM8Zmt4gdWGjB6G7p1PYZv/VCb6QLhub+sSyTAlHCjJfFeiIO70PlH
	 0YOPAVLY/lsyPf5f3OlbkCKEvWZwTRXuFeGBUEBtvF1/4RE3Svsy63LKGmsxHKohqt4BE
	 NdbUYAU6wYKFS9PIEOSzs2ME0WChKdvxcyQCNXdJM4mA8uXhCKvDTBH5078zchGuK/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TO81mXqp3G8CI6oTgcOAQ++rNQPlqQG2n6mJJxGSLS0=;
	b=eMI7pa47rBMJn3txO7VFVn/tmmVcy3LPOuLTBjWuTGIkEnAX67iBMUM9G9bMbhdiEwK8
	 o30UNC3JuLWZnb46E7BG4Yz3O4Q2bN55SVZiaSsJ/q1fG42aSURL/wMGegSBP2/GXQ9FP
	 Kd0Jcz4klJkdQpZdQ/ozoXSUSFhyKXwedTGI3mpUUUOPsjj0DtPT+vZxQNCsjXllFZ4Sw
	 t3t3gdi3MHC+eByZCZkombfVMCBEICG5iLdC11p29eCwPHVvmjej7UENYqmfUMqYrQvNp
	 b44THswLbebjU5uiZfR+jR75iuYYNQd+NHHgIshAAlbakQXDJF6poVJg9X4x56cuRNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1JrFv9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457AF606A31F;
	Wed, 28 Oct 2026 19:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1JrFv9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975331F01828;
	Wed, 28 Oct 2026 19:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214490;
	bh=TO81mXqp3G8CI6oTgcOAQ++rNQPlqQG2n6mJJxGSLS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1JrFv9DEcgHUEvWnH365pPMod1WXPNAyqD+1mgGVYLthM6/PX1879EZKLj8H8KL3
	 2nGx1GH8mMb847Kc46rFhZlbvY5fWEPJlmrv00NwDV0PTYG+xS8HoEisnbZ8XrvNaG
	 LGfIycUbACZHnw4RSiE7FMF1xbi47JLVXa2LFvfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Levinsky <ben.levinsky@amd.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0877/1887] mailbox: zynqmp: Move buffered IPI setup to of_match selected routine
Date: Wed, 28 Oct 2026 17:49:33 +0100
Message-ID: <20261028170519.374810967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Ben Levinsky <ben.levinsky@amd.com>

[ Upstream commit 41bcf30100c521c73f0fcf05c3dc31967e6408be ]

Move routine that initializes the mailboxes for send and receive to
a function pointer that is set based on compatible string.

Signed-off-by: Ben Levinsky <ben.levinsky@amd.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 0aead8197fc1 ("mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 122 +++++++++++++++++++--------
 1 file changed, 87 insertions(+), 35 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 6a523759efa8b..b3428c714e2f6 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -72,6 +72,10 @@ struct zynqmp_ipi_mchan {
 	unsigned int chan_type;
 };
 
+struct zynqmp_ipi_mbox;
+
+typedef int (*setup_ipi_fn)(struct zynqmp_ipi_mbox *ipi_mbox, struct device_node *node);
+
 /**
  * struct zynqmp_ipi_mbox - Description of a ZynqMP IPI mailbox
  *                          platform data.
@@ -81,6 +85,7 @@ struct zynqmp_ipi_mchan {
  * @remote_id:            remote IPI agent ID
  * @mbox:                 mailbox Controller
  * @mchans:               array for channels, tx channel and rx channel.
+ * @setup_ipi_fn:         Function Pointer to set up IPI Channels
  */
 struct zynqmp_ipi_mbox {
 	struct zynqmp_ipi_pdata *pdata;
@@ -88,6 +93,7 @@ struct zynqmp_ipi_mbox {
 	u32 remote_id;
 	struct mbox_controller mbox;
 	struct zynqmp_ipi_mchan mchans[2];
+	setup_ipi_fn setup_ipi_fn;
 };
 
 /**
@@ -464,12 +470,9 @@ static void zynqmp_ipi_mbox_dev_release(struct device *dev)
 static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 				 struct device_node *node)
 {
-	struct zynqmp_ipi_mchan *mchan;
 	struct mbox_chan *chans;
 	struct mbox_controller *mbox;
-	struct resource res;
 	struct device *dev, *mdev;
-	const char *name;
 	int ret;
 
 	dev = ipi_mbox->pdata->dev;
@@ -489,6 +492,73 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 	}
 	mdev = &ipi_mbox->dev;
 
+	/* Get the IPI remote agent ID */
+	ret = of_property_read_u32(node, "xlnx,ipi-id", &ipi_mbox->remote_id);
+	if (ret < 0) {
+		dev_err(dev, "No IPI remote ID is specified.\n");
+		return ret;
+	}
+
+	ret = ipi_mbox->setup_ipi_fn(ipi_mbox, node);
+	if (ret) {
+		dev_err(dev, "Failed to set up IPI Buffers.\n");
+		return ret;
+	}
+
+	mbox = &ipi_mbox->mbox;
+	mbox->dev = mdev;
+	mbox->ops = &zynqmp_ipi_chan_ops;
+	mbox->num_chans = 2;
+	mbox->txdone_irq = false;
+	mbox->txdone_poll = true;
+	mbox->txpoll_period = 5;
+	mbox->of_xlate = zynqmp_ipi_of_xlate;
+	chans = devm_kzalloc(mdev, 2 * sizeof(*chans), GFP_KERNEL);
+	if (!chans)
+		return -ENOMEM;
+	mbox->chans = chans;
+	chans[IPI_MB_CHNL_TX].con_priv = &ipi_mbox->mchans[IPI_MB_CHNL_TX];
+	chans[IPI_MB_CHNL_RX].con_priv = &ipi_mbox->mchans[IPI_MB_CHNL_RX];
+	ipi_mbox->mchans[IPI_MB_CHNL_TX].chan_type = IPI_MB_CHNL_TX;
+	ipi_mbox->mchans[IPI_MB_CHNL_RX].chan_type = IPI_MB_CHNL_RX;
+	ret = devm_mbox_controller_register(mdev, mbox);
+	if (ret)
+		dev_err(mdev,
+			"Failed to register mbox_controller(%d)\n", ret);
+	else
+		dev_info(mdev,
+			 "Registered ZynqMP IPI mbox with TX/RX channels.\n");
+	return ret;
+}
+
+/**
+ * zynqmp_ipi_setup - set up IPI Buffers for classic flow
+ *
+ * @ipi_mbox: pointer to IPI mailbox private data structure
+ * @node: IPI mailbox device node
+ *
+ * This will be used to set up IPI Buffers for ZynqMP SOC if user
+ * wishes to use classic driver usage model on new SOC's with only
+ * buffered IPIs.
+ *
+ * Note that bufferless IPIs and mixed usage of buffered and bufferless
+ * IPIs are not supported with this flow.
+ *
+ * This will be invoked with compatible string "xlnx,zynqmp-ipi-mailbox".
+ *
+ * Return: 0 for success, negative value for failure
+ */
+static int zynqmp_ipi_setup(struct zynqmp_ipi_mbox *ipi_mbox,
+			    struct device_node *node)
+{
+	struct zynqmp_ipi_mchan *mchan;
+	struct device *mdev;
+	struct resource res;
+	const char *name;
+	int ret;
+
+	mdev = &ipi_mbox->dev;
+
 	mchan = &ipi_mbox->mchans[IPI_MB_CHNL_TX];
 	name = "local_request_region";
 	ret = zynqmp_ipi_mbox_get_buf_res(node, name, &res);
@@ -563,37 +633,7 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 	if (!mchan->rx_buf)
 		return -ENOMEM;
 
-	/* Get the IPI remote agent ID */
-	ret = of_property_read_u32(node, "xlnx,ipi-id", &ipi_mbox->remote_id);
-	if (ret < 0) {
-		dev_err(dev, "No IPI remote ID is specified.\n");
-		return ret;
-	}
-
-	mbox = &ipi_mbox->mbox;
-	mbox->dev = mdev;
-	mbox->ops = &zynqmp_ipi_chan_ops;
-	mbox->num_chans = 2;
-	mbox->txdone_irq = false;
-	mbox->txdone_poll = true;
-	mbox->txpoll_period = 5;
-	mbox->of_xlate = zynqmp_ipi_of_xlate;
-	chans = devm_kzalloc(mdev, 2 * sizeof(*chans), GFP_KERNEL);
-	if (!chans)
-		return -ENOMEM;
-	mbox->chans = chans;
-	chans[IPI_MB_CHNL_TX].con_priv = &ipi_mbox->mchans[IPI_MB_CHNL_TX];
-	chans[IPI_MB_CHNL_RX].con_priv = &ipi_mbox->mchans[IPI_MB_CHNL_RX];
-	ipi_mbox->mchans[IPI_MB_CHNL_TX].chan_type = IPI_MB_CHNL_TX;
-	ipi_mbox->mchans[IPI_MB_CHNL_RX].chan_type = IPI_MB_CHNL_RX;
-	ret = devm_mbox_controller_register(mdev, mbox);
-	if (ret)
-		dev_err(mdev,
-			"Failed to register mbox_controller(%d)\n", ret);
-	else
-		dev_info(mdev,
-			 "Registered ZynqMP IPI mbox with TX/RX channels.\n");
-	return ret;
+	return 0;
 }
 
 /**
@@ -621,6 +661,7 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 	struct zynqmp_ipi_pdata *pdata;
 	struct zynqmp_ipi_mbox *mbox;
 	int num_mboxes, ret = -EINVAL;
+	setup_ipi_fn ipi_fn;
 
 	num_mboxes = of_get_available_child_count(np);
 	if (num_mboxes == 0) {
@@ -641,9 +682,18 @@ static int zynqmp_ipi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ipi_fn = (setup_ipi_fn)device_get_match_data(&pdev->dev);
+	if (!ipi_fn) {
+		dev_err(dev,
+			"Mbox Compatible String is missing IPI Setup fn.\n");
+		return -ENODEV;
+	}
+
 	pdata->num_mboxes = num_mboxes;
 
 	mbox = pdata->ipi_mboxes;
+	mbox->setup_ipi_fn = ipi_fn;
+
 	for_each_available_child_of_node(np, nc) {
 		mbox->pdata = pdata;
 		ret = zynqmp_ipi_mbox_probe(mbox, nc);
@@ -689,7 +739,9 @@ static int zynqmp_ipi_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id zynqmp_ipi_of_match[] = {
-	{ .compatible = "xlnx,zynqmp-ipi-mailbox" },
+	{ .compatible = "xlnx,zynqmp-ipi-mailbox",
+	  .data = &zynqmp_ipi_setup,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, zynqmp_ipi_of_match);
-- 
2.53.0



