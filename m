Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214610;
	b=CH2ZO6y5SRXe1g8bP6hr+h8S0PpL9yI4C3GGEQ3p20bzBteqjmIjJ0otvTJqjy8sO+kv
	 xqmVHWkd4jOFWp6HxOsRVqXpZIRhWFQL34wFAw6rjGB1S5WRdsp5EFTPmuszuEJs4nWCo
	 qYBSFChEJe3PHv1kZFtWwqq7OPXKV2QlEAkv3sUKUgPvac184KcqSJQm3k6n5AMaV3cwy
	 8atBJCyRqCti5JgMktPzA2k8lyZ7qYGJES7l57kSzWSUBdPbBkCvbqr3uHpBvNzz0tP7h
	 /BG+UShfSLyggcG6XbzpLzrRgNiY5GbY7VQqqBBJ/YnJus1CbSq+xEB2zCs9o1TADEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R47Mi5BmFOyf/gZUFIdq7qYRQw3QIF3jIqXD4C5COR8=;
	b=SR3DFuHNnPRN5H3qSdebTyVKItY5wJS4rutKwNocj19lq9EirVxh59akbJuLQ4zAYhU3
	 Ew75mGuZSeqqZtpd7sYJlPpnDheG7R00XFS76QzcaWlHDmnQf3UG0yPV6Bk0Fo3cQd9Yj
	 inkJ0mVxtLlsfC/eHObCwdlnQN7hx/0+eFqAFOxtZcCVbJZxG4gkG2GHkQHCL0gMDFvU/
	 MaVMgj23Z8aJ7+hDpz79HclXmP/aNH77y+7vOMZf/XMixWIH3pPQy0w/3jmgPVucOXpIy
	 9J5XimI0lgXer99+SIs7StiVfQE7B3wthrDbGK0Oo+ukG7wODJehUhqWBUsgGJzquHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2k4xBSB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB383606A32E;
	Wed, 28 Oct 2026 19:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C2k4xBSB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFD01F01828;
	Wed, 28 Oct 2026 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214609;
	bh=R47Mi5BmFOyf/gZUFIdq7qYRQw3QIF3jIqXD4C5COR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2k4xBSB3jIy+IFYd/HMW35pm8hlrZSKNuVMikW6dLRAETbFY9nn3mHg8uw+D4lGK
	 dEuDu0wFk9Jz8PyjQbkNsCl+9st5DuyLppY8sjc6mJYRL/CB4QtrdJkkHcENui5del
	 W8D2aTZNSJYirzDXVpgirezVYLedvxKTUWo3H8xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Chris Lew <quic_clew@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>
Subject: [PATCH 6.1 0919/1887] net: qrtr: Drop the MHI auto_queue feature for IPCR DL channels
Date: Wed, 28 Oct 2026 17:50:15 +0100
Message-ID: <20261028170520.330390919@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 51731792a25cb312ca94cdccfa139eb46de1b2ef ]

MHI stack offers the 'auto_queue' feature, which allows the MHI stack to
auto queue the buffers for the RX path (DL channel). Though this feature
simplifies the client driver design, it introduces race between the client
drivers and the MHI stack. For instance, with auto_queue, the 'dl_callback'
for the DL channel may get called before the client driver is fully probed.
This means, by the time the dl_callback gets called, the client driver's
structures might not be initialized, leading to NULL ptr dereference.

Currently, the drivers have to workaround this issue by initializing the
internal structures before calling mhi_prepare_for_transfer_autoqueue().
But even so, there is a chance that the client driver's internal code path
may call the MHI queue APIs before mhi_prepare_for_transfer_autoqueue() is
called, leading to similar NULL ptr dereference. This issue has been
reported on the Qcom X1E80100 CRD machines affecting boot.

So to properly fix all these races, drop the MHI 'auto_queue' feature
altogether and let the client driver (QRTR) manage the RX buffers manually.
In the QRTR driver, queue the RX buffers based on the ring length during
probe and recycle the buffers in 'dl_callback' once they are consumed. This
also warrants removing the setting of 'auto_queue' flag from controller
drivers.

Currently, this 'auto_queue' feature is only enabled for IPCR DL channel.
So only the QRTR client driver requires the modification.

Fixes: 227fee5fc99e ("bus: mhi: core: Add an API for auto queueing buffers for DL channel")
Fixes: 68a838b84eff ("net: qrtr: start MHI channel after endpoit creation")
Reported-by: Johan Hovold <johan@kernel.org>
Closes: https://lore.kernel.org/linux-arm-msm/ZyTtVdkCCES0lkl4@hovoldconsulting.com
Suggested-by: Chris Lew <quic_clew@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Acked-by: Jeff Johnson <jjohnson@kernel.org> # drivers/net/wireless/ath/...
Acked-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251218-qrtr-fix-v2-1-c7499bfcfbe0@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c    | 20 +--------
 drivers/net/wireless/ath/ath11k/mhi.c |  4 --
 net/qrtr/mhi.c                        | 61 +++++++++++++++++++++++----
 3 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 4bb4bcd45b0a6..5a070ea4710c3 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -77,22 +77,6 @@ struct mhi_pci_dev_info {
 		.doorbell_mode_switch = false,		\
 	}
 
-#define MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(ch_num, ch_name, el_count, ev_ring) \
-	{						\
-		.num = ch_num,				\
-		.name = ch_name,			\
-		.num_elements = el_count,		\
-		.event_ring = ev_ring,			\
-		.dir = DMA_FROM_DEVICE,			\
-		.ee_mask = BIT(MHI_EE_AMSS),		\
-		.pollcfg = 0,				\
-		.doorbell = MHI_DB_BRST_DISABLE,	\
-		.lpm_notify = false,			\
-		.offload_channel = false,		\
-		.doorbell_mode_switch = false,		\
-		.auto_queue = true,			\
-	}
-
 #define MHI_EVENT_CONFIG_CTRL(ev_ring, el_count) \
 	{					\
 		.num_elements = el_count,	\
@@ -231,7 +215,7 @@ static const struct mhi_channel_config modem_qcom_v1_mhi_channels[] = {
 	MHI_CHANNEL_CONFIG_UL(14, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_DL(15, "QMI", 4, 0),
 	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 8, 0),
-	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 8, 0),
+	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 8, 0),
 	MHI_CHANNEL_CONFIG_UL_FP(34, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_DL_FP(35, "FIREHOSE", 32, 0),
 	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 2),
@@ -467,7 +451,7 @@ static const struct mhi_channel_config mhi_telit_fn980_hw_v1_channels[] = {
 	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
 	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
 	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 16, 0),
-	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 16, 0),
+	MHI_CHANNEL_CONFIG_DL(21, "IPCR", 16, 0),
 	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 1),
 	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0", 128, 2),
 };
diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 4bea36cc71085..0e838721aafb2 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -60,7 +60,6 @@ static struct mhi_channel_config ath11k_mhi_channels_qca6390[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 	},
 	{
 		.num = 21,
@@ -74,7 +73,6 @@ static struct mhi_channel_config ath11k_mhi_channels_qca6390[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = true,
 	},
 };
 
@@ -153,7 +151,6 @@ static struct mhi_channel_config ath11k_mhi_channels_qcn9074[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = false,
 	},
 	{
 		.num = 21,
@@ -167,7 +164,6 @@ static struct mhi_channel_config ath11k_mhi_channels_qcn9074[] = {
 		.lpm_notify = false,
 		.offload_channel = false,
 		.doorbell_mode_switch = false,
-		.auto_queue = true,
 	},
 };
 
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 9ced13c0627a7..aa9cd496b549f 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -24,13 +24,25 @@ static void qcom_mhi_qrtr_dl_callback(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
 	int rc;
 
-	if (!qdev || mhi_res->transaction_status)
+	if (!qdev || (mhi_res->transaction_status && mhi_res->transaction_status != -ENOTCONN))
 		return;
 
+	/* Channel got reset. So just free the buffer */
+	if (mhi_res->transaction_status == -ENOTCONN) {
+		devm_kfree(&mhi_dev->dev, mhi_res->buf_addr);
+		return;
+	}
+
 	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
 				mhi_res->bytes_xferd);
 	if (rc == -EINVAL)
 		dev_err(qdev->dev, "invalid ipcrouter packet\n");
+
+	/* Done with the buffer, now recycle it for future use */
+	rc = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, mhi_res->buf_addr,
+			   mhi_dev->mhi_cntrl->buffer_len, MHI_EOT);
+	if (rc)
+		dev_err(&mhi_dev->dev, "Failed to recycle the buffer: %d\n", rc);
 }
 
 /* From QRTR to MHI */
@@ -72,6 +84,29 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 	return rc;
 }
 
+static int qcom_mhi_qrtr_queue_dl_buffers(struct mhi_device *mhi_dev)
+{
+	u32 free_desc;
+	void *buf;
+	int ret;
+
+	free_desc = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
+	while (free_desc--) {
+		buf = devm_kmalloc(&mhi_dev->dev, mhi_dev->mhi_cntrl->buffer_len, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		ret = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, buf, mhi_dev->mhi_cntrl->buffer_len,
+				    MHI_EOT);
+		if (ret) {
+			dev_err(&mhi_dev->dev, "Failed to queue buffer: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 			       const struct mhi_device_id *id)
 {
@@ -87,20 +122,30 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	qdev->ep.xmit = qcom_mhi_qrtr_send;
 
 	dev_set_drvdata(&mhi_dev->dev, qdev);
-	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
-	if (rc)
-		return rc;
 
 	/* start channels */
-	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
-	if (rc) {
-		qrtr_endpoint_unregister(&qdev->ep);
+	rc = mhi_prepare_for_transfer(mhi_dev);
+	if (rc)
 		return rc;
-	}
+
+	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
+	if (rc)
+		goto err_unprepare;
+
+	rc = qcom_mhi_qrtr_queue_dl_buffers(mhi_dev);
+	if (rc)
+		goto err_unregister;
 
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;
+
+err_unregister:
+	qrtr_endpoint_unregister(&qdev->ep);
+err_unprepare:
+	mhi_unprepare_from_transfer(mhi_dev);
+
+	return rc;
 }
 
 static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
-- 
2.53.0



