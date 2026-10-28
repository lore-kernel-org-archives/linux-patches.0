Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213954;
	b=BuiuHoiqfmZM/12FRn/VHLpxj0ugNTowhTR+DCTfTKYUg5tUkZ+X10NLU5E55Nzr7/ar
	 0CA8gJC+oKKyRRGKs7UJbG5NRsYXV4QvNxKReoCHOf33x6vI9DwgS+jkRMfvnYlagROqp
	 OvBaIZUG5nSJrlsrywy33a3v8lu1hFnEbH/gdU1sgbXspbqZ6cr03gP3hpFWilD0Y7Wqz
	 gqnH1QdrkwtaBbkJ5OewQInaoRkeLG4ZiOdSz6jo60oS7KvV3fafnwyKh7M4D65BOgsjc
	 PCWR5M6YPADMCLivS5CdSdNG0ksDlbcitMWgQVNtsNJEYMByCD60gl3sCq97uLMVAlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3e70iHbuKIWAiivadBlwRP56mrDV8MuCSCCwRbzLHWQ=;
	b=LCmlQ8+WAbYqN74ZI2qAOT5rcZZgnTWP0Dwb0lhjdPkoEOQv+IACoqxx5438BPp6UAeZ
	 AiKB8PqSWHNHw+rzx7GenVo5ZNYkKpk53uAGaqm3yP7H3HZUdUqoDeqGz4Ti2BU4oUZau
	 SDDhalUqMOlFLg5OM0k7l227hoxnema5eyS3SmdvmWV+qBwBcyKZLI05KPTt7mER4TP1K
	 MZivKxRUH84mQ0J+NZxhSABjSugiJLJm3bc+AR+YQf2gOGMRRoDkFTe8QJ7mI0kMq17bO
	 m7Z+z68YX+WPX4PijOaiHgzeK1c991hrJax7HktMl13DjETrMQmqp8Rpzs/TzAGdsYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCSMZgrA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE76606A31A;
	Wed, 28 Oct 2026 18:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCSMZgrA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AA51F01825;
	Wed, 28 Oct 2026 18:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213953;
	bh=3e70iHbuKIWAiivadBlwRP56mrDV8MuCSCCwRbzLHWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dCSMZgrAqByC9FFuCp4ROsFHEPM/ifIviN9cpXcPEvxh2oU+TFk//HxKHtUvxqVeG
	 c2zaBlyWsV0s5kJRlnX1WOJ1a4DtmdlI1GV4UQM28Q2uApMX9SjCFEBDDoJ/hMSkVN
	 B3fcJSnb4euanpB3lmwzxexVxStLcH4g/6iuW9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0688/1887] firmware: arm_scmi: Refactor device create/destroy helpers
Date: Wed, 28 Oct 2026 17:46:24 +0100
Message-ID: <20261028170515.069513107@linuxfoundation.org>
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

[ Upstream commit 2c3e674465e73e2f7eb52c39dc5c5e97e78e68ea ]

Refactor SCMI device create/destroy helpers: it is now possible to ask
for the creation of all the currently requested devices for a whole
protocol, not only for the creation of a single well-defined device.

While at that, re-instate uniqueness checks on the creation of SCMI
SystemPower devices.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222185049.737625-8-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 295416091e44 ("firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    | 141 ++++++++++++++++++++++++++---
 drivers/firmware/arm_scmi/common.h |   8 +-
 drivers/firmware/arm_scmi/driver.c |   9 +-
 include/linux/scmi_protocol.h      |   5 -
 4 files changed, 141 insertions(+), 22 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 14f96583b6e0d..36f75b6629db0 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -7,6 +7,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/atomic.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -30,6 +31,9 @@ struct scmi_requested_dev {
 	struct list_head node;
 };
 
+/* Track globally the creation of SCMI SystemPower related devices */
+static atomic_t scmi_syspower_registered = ATOMIC_INIT(0);
+
 /**
  * scmi_protocol_device_request  - Helper to request a device
  *
@@ -213,11 +217,11 @@ static int scmi_match_by_id_table(struct device *dev, void *data)
 	struct scmi_device_id *id_table = data;
 
 	return sdev->protocol_id == id_table->protocol_id &&
-		!strcmp(sdev->name, id_table->name);
+		(id_table->name && !strcmp(sdev->name, id_table->name));
 }
 
-struct scmi_device *scmi_child_dev_find(struct device *parent,
-					int prot_id, const char *name)
+static struct scmi_device *scmi_child_dev_find(struct device *parent,
+					       int prot_id, const char *name)
 {
 	struct scmi_device_id id_table;
 	struct device *dev;
@@ -300,13 +304,53 @@ static void scmi_device_release(struct device *dev)
 	kfree(to_scmi_dev(dev));
 }
 
-struct scmi_device *
-scmi_device_create(struct device_node *np, struct device *parent, int protocol,
-		   const char *name)
+static void __scmi_device_destroy(struct scmi_device *scmi_dev)
+{
+	pr_debug("(%s) Destroying SCMI device '%s' for protocol 0x%x (%s)\n",
+		 of_node_full_name(scmi_dev->dev.parent->of_node),
+		 dev_name(&scmi_dev->dev), scmi_dev->protocol_id,
+		 scmi_dev->name);
+
+	if (scmi_dev->protocol_id == SCMI_PROTOCOL_SYSTEM)
+		atomic_set(&scmi_syspower_registered, 0);
+
+	kfree_const(scmi_dev->name);
+	ida_free(&scmi_bus_id, scmi_dev->id);
+	device_unregister(&scmi_dev->dev);
+}
+
+static struct scmi_device *
+__scmi_device_create(struct device_node *np, struct device *parent,
+		     int protocol, const char *name)
 {
 	int id, retval;
 	struct scmi_device *scmi_dev;
 
+	/*
+	 * If the same protocol/name device already exist under the same parent
+	 * (i.e. SCMI instance) just return the existent device.
+	 * This avoids any race between the SCMI driver, creating devices for
+	 * each DT defined protocol at probe time, and the concurrent
+	 * registration of SCMI drivers.
+	 */
+	scmi_dev = scmi_child_dev_find(parent, protocol, name);
+	if (scmi_dev)
+		return scmi_dev;
+
+	/*
+	 * Ignore any possible subsequent failures while creating the device
+	 * since we are doomed anyway at that point; not using a mutex which
+	 * spans across this whole function to keep things simple and to avoid
+	 * to serialize all the __scmi_device_create calls across possibly
+	 * different SCMI server instances (parent)
+	 */
+	if (protocol == SCMI_PROTOCOL_SYSTEM &&
+	    atomic_cmpxchg(&scmi_syspower_registered, 0, 1)) {
+		dev_warn(parent,
+			 "SCMI SystemPower protocol device must be unique !\n");
+		return NULL;
+	}
+
 	scmi_dev = kzalloc(sizeof(*scmi_dev), GFP_KERNEL);
 	if (!scmi_dev)
 		return NULL;
@@ -336,6 +380,10 @@ scmi_device_create(struct device_node *np, struct device *parent, int protocol,
 	if (retval)
 		goto put_dev;
 
+	pr_debug("(%s) Created SCMI device '%s' for protocol 0x%x (%s)\n",
+		 of_node_full_name(parent->of_node),
+		 dev_name(&scmi_dev->dev), protocol, name);
+
 	return scmi_dev;
 put_dev:
 	kfree_const(scmi_dev->name);
@@ -344,18 +392,85 @@ scmi_device_create(struct device_node *np, struct device *parent, int protocol,
 	return NULL;
 }
 
-void scmi_device_destroy(struct scmi_device *scmi_dev)
+/**
+ * scmi_device_create  - A method to create one or more SCMI devices
+ *
+ * @np: A reference to the device node to use for the new device(s)
+ * @parent: The parent device to use identifying a specific SCMI instance
+ * @protocol: The SCMI protocol to be associated with this device
+ * @name: The requested-name of the device to be created; this is optional
+ *	  and if no @name is provided, all the devices currently known to
+ *	  be requested on the SCMI bus for @protocol will be created.
+ *
+ * This method can be invoked to create a single well-defined device (like
+ * a transport device or a device requested by an SCMI driver loaded after
+ * the core SCMI stack has been probed), or to create all the devices currently
+ * known to have been requested by the loaded SCMI drivers for a specific
+ * protocol (typically during SCMI core protocol enumeration at probe time).
+ *
+ * Return: The created device (or one of them if @name was NOT provided and
+ *	   multiple devices were created) or NULL if no device was created;
+ *	   note that NULL indicates an error ONLY in case a specific @name
+ *	   was provided: when @name param was not provided, a number of devices
+ *	   could have been potentially created for a whole protocol, unless no
+ *	   device was found to have been requested for that specific protocol.
+ */
+struct scmi_device *scmi_device_create(struct device_node *np,
+				       struct device *parent, int protocol,
+				       const char *name)
 {
-	kfree_const(scmi_dev->name);
-	ida_free(&scmi_bus_id, scmi_dev->id);
-	device_unregister(&scmi_dev->dev);
+	struct list_head *phead;
+	struct scmi_requested_dev *rdev;
+	struct scmi_device *scmi_dev = NULL;
+
+	if (name)
+		return __scmi_device_create(np, parent, protocol, name);
+
+	mutex_lock(&scmi_requested_devices_mtx);
+	phead = idr_find(&scmi_requested_devices, protocol);
+	/* Nothing to do. */
+	if (!phead) {
+		mutex_unlock(&scmi_requested_devices_mtx);
+		return scmi_dev;
+	}
+
+	/* Walk the list of requested devices for protocol and create them */
+	list_for_each_entry(rdev, phead, node) {
+		struct scmi_device *sdev;
+
+		sdev = __scmi_device_create(np, parent,
+					    rdev->id_table->protocol_id,
+					    rdev->id_table->name);
+		/* Report errors and carry on... */
+		if (sdev)
+			scmi_dev = sdev;
+		else
+			pr_err("(%s) Failed to create device for protocol 0x%x (%s)\n",
+			       of_node_full_name(parent->of_node),
+			       rdev->id_table->protocol_id,
+			       rdev->id_table->name);
+	}
+	mutex_unlock(&scmi_requested_devices_mtx);
+
+	return scmi_dev;
 }
+EXPORT_SYMBOL_GPL(scmi_device_create);
+
+void scmi_device_destroy(struct device *parent, int protocol, const char *name)
+{
+	struct scmi_device *scmi_dev;
+
+	scmi_dev = scmi_child_dev_find(parent, protocol, name);
+	if (scmi_dev)
+		__scmi_device_destroy(scmi_dev);
+}
+EXPORT_SYMBOL_GPL(scmi_device_destroy);
 
 static int __scmi_devices_unregister(struct device *dev, void *data)
 {
 	struct scmi_device *scmi_dev = to_scmi_dev(dev);
 
-	scmi_device_destroy(scmi_dev);
+	__scmi_device_destroy(scmi_dev);
 	return 0;
 }
 
@@ -377,6 +492,10 @@ int __init scmi_bus_init(void)
 
 void __exit scmi_bus_exit(void)
 {
+	/*
+	 * Destroy all remaining devices: just in case the drivers were
+	 * manually unbound and at first and then the modules unloaded.
+	 */
 	scmi_devices_unregister();
 	bus_unregister(&scmi_bus_type);
 	ida_destroy(&scmi_bus_id);
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 23f0ab3f2ed7f..a08d8da198be1 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -107,6 +107,11 @@ extern struct bus_type scmi_bus_type;
 #define SCMI_BUS_NOTIFY_DEVICE_UNREQUEST	1
 extern struct blocking_notifier_head scmi_requested_devices_nh;
 
+struct scmi_device *scmi_device_create(struct device_node *np,
+				       struct device *parent, int protocol,
+				       const char *name);
+void scmi_device_destroy(struct device *parent, int protocol, const char *name);
+
 int scmi_protocol_acquire(const struct scmi_handle *handle, u8 protocol_id);
 void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
 
@@ -168,9 +173,6 @@ struct scmi_transport_ops {
 	bool (*poll_done)(struct scmi_chan_info *cinfo, struct scmi_xfer *xfer);
 };
 
-struct scmi_device *scmi_child_dev_find(struct device *parent,
-					int prot_id, const char *name);
-
 /**
  * struct scmi_desc - Description of SoC integration
  *
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index f01097b9e953a..4c3677a205a8f 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2135,6 +2135,8 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	/* Create a uniquely named, dedicated transport device for this chan */
 	tdev = scmi_device_create(of_node, info->dev, prot_id, name);
 	if (!tdev) {
+		dev_err(info->dev,
+			"failed to create transport device (%s)\n", name);
 		devm_kfree(info->dev, cinfo);
 		return -EINVAL;
 	}
@@ -2144,7 +2146,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	ret = info->desc->ops->chan_setup(cinfo, info->dev, tx);
 	if (ret) {
 		of_node_put(of_node);
-		scmi_device_destroy(tdev);
+		scmi_device_destroy(info->dev, prot_id, name);
 		devm_kfree(info->dev, cinfo);
 		return ret;
 	}
@@ -2167,7 +2169,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 		/* Destroy channel and device only if created by this call. */
 		if (tdev) {
 			of_node_put(of_node);
-			scmi_device_destroy(tdev);
+			scmi_device_destroy(info->dev, prot_id, name);
 			devm_kfree(info->dev, cinfo);
 		}
 		return ret;
@@ -2246,10 +2248,11 @@ static int scmi_chan_destroy(int id, void *p, void *idr)
 	struct scmi_chan_info *cinfo = p;
 
 	if (cinfo->dev) {
+		struct scmi_info *info = handle_to_scmi_info(cinfo->handle);
 		struct scmi_device *sdev = to_scmi_dev(cinfo->dev);
 
 		of_node_put(cinfo->dev->of_node);
-		scmi_device_destroy(sdev);
+		scmi_device_destroy(info->dev, id, sdev->name);
 		cinfo->dev = NULL;
 	}
 
diff --git a/include/linux/scmi_protocol.h b/include/linux/scmi_protocol.h
index 4f765bc788ffb..0ce5746a4470a 100644
--- a/include/linux/scmi_protocol.h
+++ b/include/linux/scmi_protocol.h
@@ -804,11 +804,6 @@ struct scmi_device {
 
 #define to_scmi_dev(d) container_of(d, struct scmi_device, dev)
 
-struct scmi_device *
-scmi_device_create(struct device_node *np, struct device *parent, int protocol,
-		   const char *name);
-void scmi_device_destroy(struct scmi_device *scmi_dev);
-
 struct scmi_device_id {
 	u8 protocol_id;
 	const char *name;
-- 
2.53.0



