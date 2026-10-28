Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213937;
	b=aR9Iya9vIqI62yxibm+EkWODqLAvFJaLZWqelfvxymzzYRb6Zt75f8od3gwDGEha5et2
	 VhSrgv9azO92fzEtILuNfMYT6LDuYb5K4fQqNQ7uveyxkSHljRe1R82s8q/5oFJ7yjn29
	 cmvMdeS1k2S2jgbyQx6FMYgR61qK2AYC2TaCyMJ58LXkhFMnE0/ThOeGzEswv3NbUi7E1
	 P0TSXNaY1SASuitcugzOChOT22HIm3uDIeqoOU/ZQA8r/tl6GANBQa3wLF6b9FoPXzCiK
	 4UfcTz66iKNNFxuvpTnMCSRWwwoQCwhGQQcCprI2NGndG0sz8mwQrEKaRkMjXlYyQfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jhfamc7rKVaYoGRp0RWA6GmdrJmzedYUveIGsE7mFmw=;
	b=OOuEBcFqguzaLTce6N02ByaeDBGhB52fj31Nn0wbSTQb/2MBwCuA2FEx8WnI22GHdRSb
	 rLjeEHTmXwdNeAs6d+JL8iBCYJ+y++yJRO7JMVxPvRyPvlm32KvDt/F+etS5bNtfwHWCR
	 fuW8kwRns1B54ffP5A+7KShaN9VPOmSXgODekP0OeXZv/uiZ2JtgIMfB/9mf1fG1wmY9X
	 UshJBHFI7qyMh8qLqexBY7H0UIK6CTWooCm4Ycr4K7IEFHtMr2j9y4fg8xoNbdBe+1z9U
	 tZyavmD9AZVEhh0j+EWWo7TGA/tGYO1In3oAb1JjLA4l771OeRY66JwCpK3yem4k5cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooO2g02B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276BE606A31C;
	Wed, 28 Oct 2026 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooO2g02B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F0C1F01828;
	Wed, 28 Oct 2026 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213937;
	bh=jhfamc7rKVaYoGRp0RWA6GmdrJmzedYUveIGsE7mFmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooO2g02BnVJzw4R4Z0P8InY4j/Wb/2bMRxn+XDxwzWEr+jMw4JWjndD5CM644I32l
	 gXxVGsrIipYiUNRdW4Cvq0zLGixxSyCjH2mwyPLQCs+0NWr50F6D5s1F6XXeknivFg
	 /0+RHpKrQfWddHxuUqmkFdmsIv9MdCp4IE3L9hZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0683/1887] firmware: arm_scmi: Use dedicated devices to initialize channels
Date: Wed, 28 Oct 2026 17:46:19 +0100
Message-ID: <20261028170514.956066153@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 05a2801d8b90c1b5159618d4bd3a3c65d60f3ff1 ]

Refactor channels initialization to use dedicated transport devices
instead of using devices borrowed from the SCMI drivers.

Initialize all channels, as described in the device tree, upfront during
SCMI core stack probe phase and free all of them, including the underlying
devices, when the SCMI core is removed.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222185049.737625-3-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 295416091e44 ("firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h  |   1 -
 drivers/firmware/arm_scmi/driver.c  | 158 ++++++++++++++++++++--------
 drivers/firmware/arm_scmi/mailbox.c |   2 -
 drivers/firmware/arm_scmi/optee.c   |   2 -
 drivers/firmware/arm_scmi/smc.c     |   2 -
 drivers/firmware/arm_scmi/virtio.c  |   2 -
 6 files changed, 116 insertions(+), 51 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 15882266910b6..3b601e4d99507 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -229,7 +229,6 @@ extern const struct scmi_desc scmi_optee_desc;
 #endif
 
 void scmi_rx_callback(struct scmi_chan_info *cinfo, u32 msg_hdr, void *priv);
-void scmi_free_channel(struct scmi_chan_info *cinfo, struct idr *idr, int id);
 
 /* shmem related declarations */
 struct scmi_shared_mem;
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f6d1063699f1e..018713475d16d 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2031,23 +2031,20 @@ static int scmi_xfer_info_init(struct scmi_info *sinfo)
 	return ret;
 }
 
-static int scmi_chan_setup(struct scmi_info *info, struct device *dev,
+static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 			   int prot_id, bool tx)
 {
 	int ret, idx;
+	char name[32];
 	struct scmi_chan_info *cinfo;
 	struct idr *idr;
+	struct scmi_device *tdev = NULL;
 
 	/* Transmit channel is first entry i.e. index 0 */
 	idx = tx ? 0 : 1;
 	idr = tx ? &info->tx_idr : &info->rx_idr;
 
-	/* check if already allocated, used for multiple device per protocol */
-	cinfo = idr_find(idr, prot_id);
-	if (cinfo)
-		return 0;
-
-	if (!info->desc->ops->chan_available(dev->of_node, idx)) {
+	if (!info->desc->ops->chan_available(of_node, idx)) {
 		cinfo = idr_find(idr, SCMI_PROTOCOL_BASE);
 		if (unlikely(!cinfo)) /* Possible only if platform has no Rx */
 			return -EINVAL;
@@ -2058,27 +2055,49 @@ static int scmi_chan_setup(struct scmi_info *info, struct device *dev,
 	if (!cinfo)
 		return -ENOMEM;
 
-	cinfo->dev = dev;
 	cinfo->rx_timeout_ms = info->desc->max_rx_timeout_ms;
 
+	/* Create a unique name for this transport device */
+	snprintf(name, 32, "__scmi_transport_device_%s_%02X",
+		 idx ? "rx" : "tx", prot_id);
+	/* Create a uniquely named, dedicated transport device for this chan */
+	tdev = scmi_device_create(of_node, info->dev, prot_id, name);
+	if (!tdev) {
+		devm_kfree(info->dev, cinfo);
+		return -EINVAL;
+	}
+	of_node_get(of_node);
+
+	cinfo->dev = &tdev->dev;
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
-	if (ret)
+	if (ret) {
+		of_node_put(of_node);
+		scmi_device_destroy(tdev);
+		devm_kfree(info->dev, cinfo);
 		return ret;
+	}
 
 	if (tx && is_polling_required(cinfo, info)) {
 		if (is_transport_polling_capable(info))
-			dev_info(dev,
+			dev_info(&tdev->dev,
 				 "Enabled polling mode TX channel - prot_id:%d\n",
 				 prot_id);
 		else
-			dev_warn(dev,
+			dev_warn(&tdev->dev,
 				 "Polling mode NOT supported by transport.\n");
 	}
 
 idr_alloc:
 	ret = idr_alloc(idr, cinfo, prot_id, prot_id + 1, GFP_KERNEL);
 	if (ret != prot_id) {
-		dev_err(dev, "unable to allocate SCMI idr slot err %d\n", ret);
+		dev_err(info->dev,
+			"unable to allocate SCMI idr slot err %d\n", ret);
+		/* Destroy channel and device only if created by this call. */
+		if (tdev) {
+			of_node_put(of_node);
+			scmi_device_destroy(tdev);
+			devm_kfree(info->dev, cinfo);
+		}
 		return ret;
 	}
 
@@ -2087,13 +2106,14 @@ static int scmi_chan_setup(struct scmi_info *info, struct device *dev,
 }
 
 static inline int
-scmi_txrx_setup(struct scmi_info *info, struct device *dev, int prot_id)
+scmi_txrx_setup(struct scmi_info *info, struct device_node *of_node,
+		int prot_id)
 {
-	int ret = scmi_chan_setup(info, dev, prot_id, true);
+	int ret = scmi_chan_setup(info, of_node, prot_id, true);
 
 	if (!ret) {
 		/* Rx is optional, report only memory errors */
-		ret = scmi_chan_setup(info, dev, prot_id, false);
+		ret = scmi_chan_setup(info, of_node, prot_id, false);
 		if (ret && ret != -ENOMEM)
 			ret = 0;
 	}
@@ -2101,6 +2121,54 @@ scmi_txrx_setup(struct scmi_info *info, struct device *dev, int prot_id)
 	return ret;
 }
 
+/**
+ * scmi_channels_setup  - Helper to initialize all required channels
+ *
+ * @info: The SCMI instance descriptor.
+ *
+ * Initialize all the channels found described in the DT against the underlying
+ * configured transport using custom defined dedicated devices instead of
+ * borrowing devices from the SCMI drivers; this way channels are initialized
+ * upfront during core SCMI stack probing and are no more coupled with SCMI
+ * devices used by SCMI drivers.
+ *
+ * Note that, even though a pair of TX/RX channels is associated to each
+ * protocol defined in the DT, a distinct freshly initialized channel is
+ * created only if the DT node for the protocol at hand describes a dedicated
+ * channel: in all the other cases the common BASE protocol channel is reused.
+ *
+ * Return: 0 on Success
+ */
+static int scmi_channels_setup(struct scmi_info *info)
+{
+	int ret;
+	struct device_node *child, *top_np = info->dev->of_node;
+
+	/* Initialize a common generic channel at first */
+	ret = scmi_txrx_setup(info, top_np, SCMI_PROTOCOL_BASE);
+	if (ret)
+		return ret;
+
+	for_each_available_child_of_node(top_np, child) {
+		u32 prot_id;
+
+		if (of_property_read_u32(child, "reg", &prot_id))
+			continue;
+
+		if (!FIELD_FIT(MSG_PROTOCOL_ID_MASK, prot_id))
+			dev_err(info->dev,
+				"Out of range protocol %d\n", prot_id);
+
+		ret = scmi_txrx_setup(info, child, prot_id);
+		if (ret) {
+			of_node_put(child);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * scmi_get_protocol_device  - Helper to get/create an SCMI device.
  *
@@ -2150,14 +2218,6 @@ scmi_get_protocol_device(struct device_node *np, struct scmi_info *info,
 		return NULL;
 	}
 
-	if (scmi_txrx_setup(info, &sdev->dev, prot_id)) {
-		dev_err(&sdev->dev, "failed to setup transport\n");
-		scmi_device_destroy(sdev);
-		mutex_unlock(&scmi_syspower_mtx);
-
-		return NULL;
-	}
-
 	if (prot_id == SCMI_PROTOCOL_SYSTEM)
 		scmi_syspower_registered = true;
 
@@ -2391,19 +2451,39 @@ void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table)
 	mutex_unlock(&scmi_requested_devices_mtx);
 }
 
-static int scmi_cleanup_txrx_channels(struct scmi_info *info)
+static int scmi_chan_destroy(int id, void *p, void *idr)
 {
-	int ret;
-	struct idr *idr = &info->tx_idr;
+	struct scmi_chan_info *cinfo = p;
+
+	if (cinfo->dev) {
+		struct scmi_device *sdev = to_scmi_dev(cinfo->dev);
 
-	ret = idr_for_each(idr, info->desc->ops->chan_free, idr);
-	idr_destroy(&info->tx_idr);
+		of_node_put(cinfo->dev->of_node);
+		scmi_device_destroy(sdev);
+		cinfo->dev = NULL;
+	}
 
-	idr = &info->rx_idr;
-	ret = idr_for_each(idr, info->desc->ops->chan_free, idr);
-	idr_destroy(&info->rx_idr);
+	idr_remove(idr, id);
 
-	return ret;
+	return 0;
+}
+
+static void scmi_cleanup_channels(struct scmi_info *info, struct idr *idr)
+{
+	/* At first free all channels at the transport layer ... */
+	idr_for_each(idr, info->desc->ops->chan_free, idr);
+
+	/* ...then destroy all underlying devices */
+	idr_for_each(idr, scmi_chan_destroy, idr);
+
+	idr_destroy(idr);
+}
+
+static void scmi_cleanup_txrx_channels(struct scmi_info *info)
+{
+	scmi_cleanup_channels(info, &info->tx_idr);
+
+	scmi_cleanup_channels(info, &info->rx_idr);
 }
 
 static int scmi_probe(struct platform_device *pdev)
@@ -2455,7 +2535,8 @@ static int scmi_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	ret = scmi_txrx_setup(info, dev, SCMI_PROTOCOL_BASE);
+	/* Setup all channels described in the DT at first */
+	ret = scmi_channels_setup(info);
 	if (ret)
 		return ret;
 
@@ -2525,14 +2606,9 @@ static int scmi_probe(struct platform_device *pdev)
 	return ret;
 }
 
-void scmi_free_channel(struct scmi_chan_info *cinfo, struct idr *idr, int id)
-{
-	idr_remove(idr, id);
-}
-
 static int scmi_remove(struct platform_device *pdev)
 {
-	int ret, id;
+	int id;
 	struct scmi_info *info = platform_get_drvdata(pdev);
 	struct device_node *child;
 
@@ -2554,9 +2630,7 @@ static int scmi_remove(struct platform_device *pdev)
 	idr_destroy(&info->active_protocols);
 
 	/* Safe to free channels since no more users */
-	ret = scmi_cleanup_txrx_channels(info);
-	if (ret)
-		dev_warn(&pdev->dev, "Failed to cleanup SCMI channels.\n");
+	scmi_cleanup_txrx_channels(info);
 
 	return 0;
 }
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 2017f93599e66..3cd731cbe9b88 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -173,8 +173,6 @@ static int mailbox_chan_free(int id, void *p, void *data)
 		smbox->cinfo = NULL;
 	}
 
-	scmi_free_channel(cinfo, data, id);
-
 	return 0;
 }
 
diff --git a/drivers/firmware/arm_scmi/optee.c b/drivers/firmware/arm_scmi/optee.c
index 78d5dd399aba0..dd3ddda136e00 100644
--- a/drivers/firmware/arm_scmi/optee.c
+++ b/drivers/firmware/arm_scmi/optee.c
@@ -488,8 +488,6 @@ static int scmi_optee_chan_free(int id, void *p, void *data)
 	cinfo->transport_info = NULL;
 	channel->cinfo = NULL;
 
-	scmi_free_channel(cinfo, data, id);
-
 	return 0;
 }
 
diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
index 795f7ccc89b12..7413dda373d40 100644
--- a/drivers/firmware/arm_scmi/smc.c
+++ b/drivers/firmware/arm_scmi/smc.c
@@ -185,8 +185,6 @@ static int smc_chan_free(int id, void *p, void *data)
 	cinfo->transport_info = NULL;
 	scmi_info->cinfo = NULL;
 
-	scmi_free_channel(cinfo, data, id);
-
 	return 0;
 }
 
diff --git a/drivers/firmware/arm_scmi/virtio.c b/drivers/firmware/arm_scmi/virtio.c
index a917eca7d9024..d68c01cb7aa00 100644
--- a/drivers/firmware/arm_scmi/virtio.c
+++ b/drivers/firmware/arm_scmi/virtio.c
@@ -489,8 +489,6 @@ static int virtio_chan_free(int id, void *p, void *data)
 	virtio_break_device(vioch->vqueue->vdev);
 	scmi_vio_channel_cleanup_sync(vioch);
 
-	scmi_free_channel(cinfo, data, id);
-
 	return 0;
 }
 
-- 
2.53.0



