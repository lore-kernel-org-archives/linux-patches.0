Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213943;
	b=HG/zNnJAqHlJadID0FHZkJOTzowyjbyR+G6Ehx+IpVi7O3FIUERZS6EkWC3U/9uJ3zxm
	 oRCLUO7C/4KA8buteGdl9rL1SYDpudFYait19nQMA8ywMgIgOV/a6PBb0e7lJOoZqLAQu
	 eLI3SO6741VVFk6bE1T7x3q0fpTKPViliLu4ExbvvXMEeK838xsoevM5I2prOtEY2sX0d
	 +ASSKg35dWni0fj8MMTV9JOUN0NhFIalsNR40qevVX+nClpdCZnK2Z5TT3JsXSs2CYyCb
	 1DIpPLpILczazDWcwHGert9f+4LQr2XYbPva0/SDIkQZpFcDZ37GWWOg4OJLyvDTXoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGBQx2IQofrqKoUvifEIsV2WsvGqZmokiMiSf9eewcc=;
	b=0cXeSH9y/tVwNhRVtuA91u8gFyGyTdHsMg+hITpOqWXsrAMIeat6swPyRY/rh72TGfE8
	 1dp9gRYpHX11Fkg2cuPzZnYGd87IM0sPwnSoemWBe1Ey94VAFeCp3d2qNgfNYNbf5SdsQ
	 PQTBxMUs/e4M54Iv9RREM1HCay/COL81srwLTpG+tob2Kf3RTlh1+5etYKnZ+6I7YXjhB
	 Ot15Vaq/LXV8o051TG3muMAqcbBGG0EGcepcLVjreb3BTOIMfbCeLegr02hy8JmZqxbQs
	 BkOSKWOfGORNYrqbzYk1l3hMhuKYM2qTF3//4g6Fvcq6JJYgAkWTT/4viPrVi4y8ssg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+aVCGDU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3DA606A31A;
	Wed, 28 Oct 2026 18:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+aVCGDU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB191F01825;
	Wed, 28 Oct 2026 18:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213942;
	bh=FGBQx2IQofrqKoUvifEIsV2WsvGqZmokiMiSf9eewcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+aVCGDUj70STTAp+IO6dQ3GWHtWlhmCEyyOuwPBRQFy4F8hTiXEjux5Ofp5+ql+B
	 YC6VUqeW0yTt6wHfoD6WuMcEgEhAJKcTuFPRVvsglw22ExP7tOsrJiKPcpE2RUgRYR
	 7bptQuU2VASyKYFEzQQI+q8zlChS/qEqd61SKmnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0685/1887] firmware: arm_scmi: Add common notifier helpers
Date: Wed, 28 Oct 2026 17:46:21 +0100
Message-ID: <20261028170515.001311072@linuxfoundation.org>
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

[ Upstream commit 53b8c25df7082edd78a3fc63e359abee0f28fa70 ]

Add a pair of notifier chains and generic empty notifier callbacks.
Currently they are still unused but they will be used to act properly
on device request and creation events.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222185049.737625-5-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 295416091e44 ("firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    |  6 ++-
 drivers/firmware/arm_scmi/common.h |  5 ++
 drivers/firmware/arm_scmi/driver.c | 83 +++++++++++++++++++++++++++++-
 3 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 83829c6303c22..c3df8ed76bd72 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -15,6 +15,9 @@
 
 #include "common.h"
 
+BLOCKING_NOTIFIER_HEAD(scmi_requested_devices_nh);
+EXPORT_SYMBOL_GPL(scmi_requested_devices_nh);
+
 static DEFINE_IDA(scmi_bus_id);
 
 static const struct scmi_device_id *
@@ -97,12 +100,13 @@ static void scmi_dev_remove(struct device *dev)
 		scmi_drv->remove(scmi_dev);
 }
 
-static struct bus_type scmi_bus_type = {
+struct bus_type scmi_bus_type = {
 	.name =	"scmi_protocol",
 	.match = scmi_dev_match,
 	.probe = scmi_dev_probe,
 	.remove = scmi_dev_remove,
 };
+EXPORT_SYMBOL_GPL(scmi_bus_type);
 
 int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 			 const char *mod_name)
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 2a18578a4d578..46666ecdf46c9 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -105,6 +105,11 @@ void scmi_setup_protocol_implemented(const struct scmi_protocol_handle *ph,
 
 int __init scmi_bus_init(void);
 void __exit scmi_bus_exit(void);
+extern struct bus_type scmi_bus_type;
+
+#define SCMI_BUS_NOTIFY_DEVICE_REQUEST		0
+#define SCMI_BUS_NOTIFY_DEVICE_UNREQUEST	1
+extern struct blocking_notifier_head scmi_requested_devices_nh;
 
 int scmi_protocol_acquire(const struct scmi_handle *handle, u8 protocol_id);
 void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index dc55a492461a0..a3257955b8c4e 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -150,6 +150,9 @@ struct scmi_protocol_instance {
  * @notify_priv: Pointer to private data structure specific to notifications.
  * @node: List head
  * @users: Number of users of this instance
+ * @bus_nb: A notifier to listen for device bind/unbind on the scmi bus
+ * @dev_req_nb: A notifier to listen for device request/unrequest on the scmi
+ *		bus
  */
 struct scmi_info {
 	struct device *dev;
@@ -169,9 +172,13 @@ struct scmi_info {
 	void *notify_priv;
 	struct list_head node;
 	int users;
+	struct notifier_block bus_nb;
+	struct notifier_block dev_req_nb;
 };
 
 #define handle_to_scmi_info(h)	container_of(h, struct scmi_info, handle)
+#define bus_nb_to_scmi_info(nb)	container_of(nb, struct scmi_info, bus_nb)
+#define req_nb_to_scmi_info(nb)	container_of(nb, struct scmi_info, dev_req_nb)
 
 static const int scmi_linux_errmap[] = {
 	/* better than switch case as long as return value is continuous */
@@ -2553,6 +2560,60 @@ static void scmi_cleanup_txrx_channels(struct scmi_info *info)
 	scmi_cleanup_channels(info, &info->rx_idr);
 }
 
+static int scmi_bus_notifier(struct notifier_block *nb,
+			     unsigned long action, void *data)
+{
+	struct scmi_info *info = bus_nb_to_scmi_info(nb);
+	struct scmi_device *sdev = to_scmi_dev(data);
+
+	/* Skip transport devices and devices of different SCMI instances */
+	if (!strncmp(sdev->name, "__scmi_transport_device", 23) ||
+	    sdev->dev.parent != info->dev)
+		return NOTIFY_DONE;
+
+	switch (action) {
+	case BUS_NOTIFY_BIND_DRIVER:
+		break;
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	dev_dbg(info->dev, "Device %s (%s) is now %s\n", dev_name(&sdev->dev),
+		sdev->name, action == BUS_NOTIFY_BIND_DRIVER ?
+		"about to be BOUND." : "UNBOUND.");
+
+	return NOTIFY_OK;
+}
+
+static int scmi_device_request_notifier(struct notifier_block *nb,
+					unsigned long action, void *data)
+{
+	struct device_node *np;
+	struct scmi_device_id *id_table = data;
+	struct scmi_info *info = req_nb_to_scmi_info(nb);
+
+	np = idr_find(&info->active_protocols, id_table->protocol_id);
+	if (!np)
+		return NOTIFY_DONE;
+
+	dev_dbg(info->dev, "%sRequested device (%s) for protocol 0x%x\n",
+		action == SCMI_BUS_NOTIFY_DEVICE_REQUEST ? "" : "UN-",
+		id_table->name, id_table->protocol_id);
+
+	switch (action) {
+	case SCMI_BUS_NOTIFY_DEVICE_REQUEST:
+		break;
+	case SCMI_BUS_NOTIFY_DEVICE_UNREQUEST:
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
 static int scmi_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -2572,6 +2633,8 @@ static int scmi_probe(struct platform_device *pdev)
 
 	info->dev = dev;
 	info->desc = desc;
+	info->bus_nb.notifier_call = scmi_bus_notifier;
+	info->dev_req_nb.notifier_call = scmi_device_request_notifier;
 	INIT_LIST_HEAD(&info->node);
 	idr_init(&info->protocols);
 	mutex_init(&info->protocols_mtx);
@@ -2607,10 +2670,19 @@ static int scmi_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = scmi_xfer_info_init(info);
+	ret = bus_register_notifier(&scmi_bus_type, &info->bus_nb);
 	if (ret)
 		goto clear_txrx_setup;
 
+	ret = blocking_notifier_chain_register(&scmi_requested_devices_nh,
+					       &info->dev_req_nb);
+	if (ret)
+		goto clear_bus_notifier;
+
+	ret = scmi_xfer_info_init(info);
+	if (ret)
+		goto clear_dev_req_notifier;
+
 	if (scmi_notification_init(handle))
 		dev_err(dev, "SCMI Notifications NOT available.\n");
 
@@ -2668,6 +2740,11 @@ static int scmi_probe(struct platform_device *pdev)
 
 notification_exit:
 	scmi_notification_exit(&info->handle);
+clear_dev_req_notifier:
+	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
+					   &info->dev_req_nb);
+clear_bus_notifier:
+	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
 clear_txrx_setup:
 	scmi_cleanup_txrx_channels(info);
 	return ret;
@@ -2696,6 +2773,10 @@ static int scmi_remove(struct platform_device *pdev)
 		of_node_put(child);
 	idr_destroy(&info->active_protocols);
 
+	blocking_notifier_chain_unregister(&scmi_requested_devices_nh,
+					   &info->dev_req_nb);
+	bus_unregister_notifier(&scmi_bus_type, &info->bus_nb);
+
 	/* Safe to free channels since no more users */
 	scmi_cleanup_txrx_channels(info);
 
-- 
2.53.0



