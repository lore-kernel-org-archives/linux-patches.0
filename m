Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213946;
	b=sV+G8SQWGwUmDjQxRXVky94H9pDyTmIG0UsavX3ggFzv+T8NzY45aquCe5EfPYVbgiE7
	 o5lkVDQ7YQLQvz3EVZCsd99UZ7psbYkiiD+N4ZZDMMMqqvUo0th0uWMuQV8kIl9z3btqf
	 6KJ9DWbmYNsaXM7Ue/GwYFD5HME4ZYh1XJFHNruOZEnqInyvkC3XuMFT2bYXN3Ehmlmjo
	 wnF7u+e60iNBAXa8UTwyyQRBgBS5qXKQiWwh0uYkwfK7SrZzKHqY7YNtsvHVPltn8F3aF
	 Ds/tkiL9PsSH7lS1W3wh1dqQ+p8MhEeJoQDwNLhtdVwKDWCkghIMIR1GtuuWkR+Eu0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dXmWDe96dOk9da+OMYAUgLD8Hr2FxWweZGJFRazG0X4=;
	b=EcECckTwE975N1wkQSX+cOWWPH9b8/lWdevg2/JtRpt8q7+xjbPnaKT+F/lE/spElRcP
	 VoNM//gGhzJ4hwO1f6LL9OgLRrREgMpYIgHRxML6Gq+/HI6xasEq/84TjO6DSzsKlTRRn
	 Od48oROfJ06bDYXANkZUyHV7/k2ggYTvVLsM+oCVXQ/E6pMlnbLckEV+j6NUsFVNpK6sx
	 bGkulxEaqfaQHnMFrnsiflUcoDV53T6lFpXyNswaXvcH1rwMbEDNns3DMYiAwmgADz5FL
	 0eU424bGXbbOZajl7JPT9sWXCCr0rkX5Gr59SR9+VGTkoWUiRSQ/lEghRO8SGmXeURQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2hgEQO0o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871D6606A31C;
	Wed, 28 Oct 2026 18:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2hgEQO0o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55B71F01825;
	Wed, 28 Oct 2026 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213945;
	bh=dXmWDe96dOk9da+OMYAUgLD8Hr2FxWweZGJFRazG0X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hgEQO0oO+C+vuloU5G3ru9bma5OSgnxrBPwJW54VFzIwgeEkuyH6bDFxFPGaViS8
	 NTAO9mQ4GmDpgSfjgykowZpNcxYoqmdDWGZXyjdOrb2jGUN8m16ubhj8JkVJTZP8Fb
	 RwW0hqC8QvgwEkk1rRowyMqd/2DCDoSAGb2oty9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0686/1887] firmware: arm_scmi: Refactor protocol device creation
Date: Wed, 28 Oct 2026 17:46:22 +0100
Message-ID: <20261028170515.024663391@linuxfoundation.org>
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

[ Upstream commit d3cd7c525fd2ecce3a6c963f314969a54783d211 ]

Move protocol device request helpers from driver.c compilation unit to
bus.c, so reducing the cross interactions between driver.c and bus.c.

Get rid of old protocol device creation process as a whole from driver.c
and remove also stale SCMI system power unicity checks.

While at that make such helpers call into scmi_requested_devices_nh
notification chain.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221222185049.737625-6-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 295416091e44 ("firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    | 157 ++++++++++++++-
 drivers/firmware/arm_scmi/common.h |   2 -
 drivers/firmware/arm_scmi/driver.c | 296 -----------------------------
 3 files changed, 156 insertions(+), 299 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index c3df8ed76bd72..7514b3e326114 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/device.h>
@@ -20,6 +21,160 @@ EXPORT_SYMBOL_GPL(scmi_requested_devices_nh);
 
 static DEFINE_IDA(scmi_bus_id);
 
+static DEFINE_IDR(scmi_requested_devices);
+/* Protect access to scmi_requested_devices */
+static DEFINE_MUTEX(scmi_requested_devices_mtx);
+
+struct scmi_requested_dev {
+	const struct scmi_device_id *id_table;
+	struct list_head node;
+};
+
+/**
+ * scmi_protocol_device_request  - Helper to request a device
+ *
+ * @id_table: A protocol/name pair descriptor for the device to be created.
+ *
+ * This helper let an SCMI driver request specific devices identified by the
+ * @id_table to be created for each active SCMI instance.
+ *
+ * The requested device name MUST NOT be already existent for any protocol;
+ * at first the freshly requested @id_table is annotated in the IDR table
+ * @scmi_requested_devices and then the requested device is advertised to any
+ * registered party via the @scmi_requested_devices_nh notification chain.
+ *
+ * Return: 0 on Success
+ */
+static int scmi_protocol_device_request(const struct scmi_device_id *id_table)
+{
+	int ret = 0;
+	unsigned int id = 0;
+	struct list_head *head, *phead = NULL;
+	struct scmi_requested_dev *rdev;
+
+	pr_debug("Requesting SCMI device (%s) for protocol %x\n",
+		 id_table->name, id_table->protocol_id);
+
+	/*
+	 * Search for the matching protocol rdev list and then search
+	 * of any existent equally named device...fails if any duplicate found.
+	 */
+	mutex_lock(&scmi_requested_devices_mtx);
+	idr_for_each_entry(&scmi_requested_devices, head, id) {
+		if (!phead) {
+			/* A list found registered in the IDR is never empty */
+			rdev = list_first_entry(head, struct scmi_requested_dev,
+						node);
+			if (rdev->id_table->protocol_id ==
+			    id_table->protocol_id)
+				phead = head;
+		}
+		list_for_each_entry(rdev, head, node) {
+			if (!strcmp(rdev->id_table->name, id_table->name)) {
+				pr_err("Ignoring duplicate request [%d] %s\n",
+				       rdev->id_table->protocol_id,
+				       rdev->id_table->name);
+				ret = -EINVAL;
+				goto out;
+			}
+		}
+	}
+
+	/*
+	 * No duplicate found for requested id_table, so let's create a new
+	 * requested device entry for this new valid request.
+	 */
+	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
+	if (!rdev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	rdev->id_table = id_table;
+
+	/*
+	 * Append the new requested device table descriptor to the head of the
+	 * related protocol list, eventually creating such head if not already
+	 * there.
+	 */
+	if (!phead) {
+		phead = kzalloc(sizeof(*phead), GFP_KERNEL);
+		if (!phead) {
+			kfree(rdev);
+			ret = -ENOMEM;
+			goto out;
+		}
+		INIT_LIST_HEAD(phead);
+
+		ret = idr_alloc(&scmi_requested_devices, (void *)phead,
+				id_table->protocol_id,
+				id_table->protocol_id + 1, GFP_KERNEL);
+		if (ret != id_table->protocol_id) {
+			pr_err("Failed to save SCMI device - ret:%d\n", ret);
+			kfree(rdev);
+			kfree(phead);
+			ret = -EINVAL;
+			goto out;
+		}
+		ret = 0;
+	}
+	list_add(&rdev->node, phead);
+
+out:
+	mutex_unlock(&scmi_requested_devices_mtx);
+
+	if (!ret)
+		blocking_notifier_call_chain(&scmi_requested_devices_nh,
+					     SCMI_BUS_NOTIFY_DEVICE_REQUEST,
+					     (void *)rdev->id_table);
+
+	return ret;
+}
+
+/**
+ * scmi_protocol_device_unrequest  - Helper to unrequest a device
+ *
+ * @id_table: A protocol/name pair descriptor for the device to be unrequested.
+ *
+ * The unrequested device, described by the provided id_table, is at first
+ * removed from the IDR @scmi_requested_devices and then the removal is
+ * advertised to any registered party via the @scmi_requested_devices_nh
+ * notification chain.
+ */
+static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table)
+{
+	struct list_head *phead;
+
+	pr_debug("Unrequesting SCMI device (%s) for protocol %x\n",
+		 id_table->name, id_table->protocol_id);
+
+	mutex_lock(&scmi_requested_devices_mtx);
+	phead = idr_find(&scmi_requested_devices, id_table->protocol_id);
+	if (phead) {
+		struct scmi_requested_dev *victim, *tmp;
+
+		list_for_each_entry_safe(victim, tmp, phead, node) {
+			if (!strcmp(victim->id_table->name, id_table->name)) {
+				list_del(&victim->node);
+
+				mutex_unlock(&scmi_requested_devices_mtx);
+				blocking_notifier_call_chain(&scmi_requested_devices_nh,
+							     SCMI_BUS_NOTIFY_DEVICE_UNREQUEST,
+							     (void *)victim->id_table);
+				kfree(victim);
+				mutex_lock(&scmi_requested_devices_mtx);
+				break;
+			}
+		}
+
+		if (list_empty(phead)) {
+			idr_remove(&scmi_requested_devices,
+				   id_table->protocol_id);
+			kfree(phead);
+		}
+	}
+	mutex_unlock(&scmi_requested_devices_mtx);
+}
+
 static const struct scmi_device_id *
 scmi_dev_match_id(struct scmi_device *scmi_dev, struct scmi_driver *scmi_drv)
 {
@@ -127,7 +282,7 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 
 	retval = driver_register(&driver->driver);
 	if (!retval)
-		pr_debug("registered new scmi driver %s\n", driver->name);
+		pr_debug("Registered new scmi driver %s\n", driver->name);
 
 	return retval;
 }
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 46666ecdf46c9..feccde5e29650 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -172,8 +172,6 @@ struct scmi_transport_ops {
 	bool (*poll_done)(struct scmi_chan_info *cinfo, struct scmi_xfer *xfer);
 };
 
-int scmi_protocol_device_request(const struct scmi_device_id *id_table);
-void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table);
 struct scmi_device *scmi_child_dev_find(struct device *parent,
 					int prot_id, const char *name);
 
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index a3257955b8c4e..9fa5632aa2c75 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -61,19 +61,6 @@ static DEFINE_MUTEX(scmi_list_mutex);
 /* Track the unique id for the transfers for debug & profiling purpose */
 static atomic_t transfer_last_id;
 
-static DEFINE_IDR(scmi_requested_devices);
-static DEFINE_MUTEX(scmi_requested_devices_mtx);
-
-/* Track globally the creation of SCMI SystemPower related devices */
-static bool scmi_syspower_registered;
-/* Protect access to scmi_syspower_registered */
-static DEFINE_MUTEX(scmi_syspower_mtx);
-
-struct scmi_requested_dev {
-	const struct scmi_device_id *id_table;
-	struct list_head node;
-};
-
 /**
  * struct scmi_xfers_info - Structure to manage transfer information
  *
@@ -2243,288 +2230,6 @@ static int scmi_channels_setup(struct scmi_info *info)
 	return 0;
 }
 
-/**
- * scmi_get_protocol_device  - Helper to get/create an SCMI device.
- *
- * @np: A device node representing a valid active protocols for the referred
- * SCMI instance.
- * @info: The referred SCMI instance for which we are getting/creating this
- * device.
- * @prot_id: The protocol ID.
- * @name: The device name.
- *
- * Referring to the specific SCMI instance identified by @info, this helper
- * takes care to return a properly initialized device matching the requested
- * @proto_id and @name: if device was still not existent it is created as a
- * child of the specified SCMI instance @info and its transport properly
- * initialized as usual.
- *
- * Return: A properly initialized scmi device, NULL otherwise.
- */
-static inline struct scmi_device *
-scmi_get_protocol_device(struct device_node *np, struct scmi_info *info,
-			 int prot_id, const char *name)
-{
-	struct scmi_device *sdev;
-
-	/* Already created for this parent SCMI instance ? */
-	sdev = scmi_child_dev_find(info->dev, prot_id, name);
-	if (sdev)
-		return sdev;
-
-	mutex_lock(&scmi_syspower_mtx);
-	if (prot_id == SCMI_PROTOCOL_SYSTEM && scmi_syspower_registered) {
-		dev_warn(info->dev,
-			 "SCMI SystemPower protocol device must be unique !\n");
-		mutex_unlock(&scmi_syspower_mtx);
-
-		return NULL;
-	}
-
-	pr_debug("Creating SCMI device (%s) for protocol %x\n", name, prot_id);
-
-	sdev = scmi_device_create(np, info->dev, prot_id, name);
-	if (!sdev) {
-		dev_err(info->dev, "failed to create %d protocol device\n",
-			prot_id);
-		mutex_unlock(&scmi_syspower_mtx);
-
-		return NULL;
-	}
-
-	if (prot_id == SCMI_PROTOCOL_SYSTEM)
-		scmi_syspower_registered = true;
-
-	mutex_unlock(&scmi_syspower_mtx);
-
-	return sdev;
-}
-
-static inline void
-scmi_create_protocol_device(struct device_node *np, struct scmi_info *info,
-			    int prot_id, const char *name)
-{
-	struct scmi_device *sdev;
-
-	sdev = scmi_get_protocol_device(np, info, prot_id, name);
-	if (!sdev)
-		return;
-
-	/* setup handle now as the transport is ready */
-	scmi_set_handle(sdev);
-}
-
-/**
- * scmi_create_protocol_devices  - Create devices for all pending requests for
- * this SCMI instance.
- *
- * @np: The device node describing the protocol
- * @info: The SCMI instance descriptor
- * @prot_id: The protocol ID
- *
- * All devices previously requested for this instance (if any) are found and
- * created by scanning the proper @&scmi_requested_devices entry.
- */
-static void scmi_create_protocol_devices(struct device_node *np,
-					 struct scmi_info *info, int prot_id)
-{
-	struct list_head *phead;
-
-	mutex_lock(&scmi_requested_devices_mtx);
-	phead = idr_find(&scmi_requested_devices, prot_id);
-	if (phead) {
-		struct scmi_requested_dev *rdev;
-
-		list_for_each_entry(rdev, phead, node)
-			scmi_create_protocol_device(np, info, prot_id,
-						    rdev->id_table->name);
-	}
-	mutex_unlock(&scmi_requested_devices_mtx);
-}
-
-/**
- * scmi_protocol_device_request  - Helper to request a device
- *
- * @id_table: A protocol/name pair descriptor for the device to be created.
- *
- * This helper let an SCMI driver request specific devices identified by the
- * @id_table to be created for each active SCMI instance.
- *
- * The requested device name MUST NOT be already existent for any protocol;
- * at first the freshly requested @id_table is annotated in the IDR table
- * @scmi_requested_devices, then a matching device is created for each already
- * active SCMI instance. (if any)
- *
- * This way the requested device is created straight-away for all the already
- * initialized(probed) SCMI instances (handles) and it remains also annotated
- * as pending creation if the requesting SCMI driver was loaded before some
- * SCMI instance and related transports were available: when such late instance
- * is probed, its probe will take care to scan the list of pending requested
- * devices and create those on its own (see @scmi_create_protocol_devices and
- * its enclosing loop)
- *
- * Return: 0 on Success
- */
-int scmi_protocol_device_request(const struct scmi_device_id *id_table)
-{
-	int ret = 0;
-	unsigned int id = 0;
-	struct list_head *head, *phead = NULL;
-	struct scmi_requested_dev *rdev;
-	struct scmi_info *info;
-
-	pr_debug("Requesting SCMI device (%s) for protocol %x\n",
-		 id_table->name, id_table->protocol_id);
-
-	/*
-	 * Search for the matching protocol rdev list and then search
-	 * of any existent equally named device...fails if any duplicate found.
-	 */
-	mutex_lock(&scmi_requested_devices_mtx);
-	idr_for_each_entry(&scmi_requested_devices, head, id) {
-		if (!phead) {
-			/* A list found registered in the IDR is never empty */
-			rdev = list_first_entry(head, struct scmi_requested_dev,
-						node);
-			if (rdev->id_table->protocol_id ==
-			    id_table->protocol_id)
-				phead = head;
-		}
-		list_for_each_entry(rdev, head, node) {
-			if (!strcmp(rdev->id_table->name, id_table->name)) {
-				pr_err("Ignoring duplicate request [%d] %s\n",
-				       rdev->id_table->protocol_id,
-				       rdev->id_table->name);
-				ret = -EINVAL;
-				goto out;
-			}
-		}
-	}
-
-	/*
-	 * No duplicate found for requested id_table, so let's create a new
-	 * requested device entry for this new valid request.
-	 */
-	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
-	if (!rdev) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	rdev->id_table = id_table;
-
-	/*
-	 * Append the new requested device table descriptor to the head of the
-	 * related protocol list, eventually creating such head if not already
-	 * there.
-	 */
-	if (!phead) {
-		phead = kzalloc(sizeof(*phead), GFP_KERNEL);
-		if (!phead) {
-			kfree(rdev);
-			ret = -ENOMEM;
-			goto out;
-		}
-		INIT_LIST_HEAD(phead);
-
-		ret = idr_alloc(&scmi_requested_devices, (void *)phead,
-				id_table->protocol_id,
-				id_table->protocol_id + 1, GFP_KERNEL);
-		if (ret != id_table->protocol_id) {
-			pr_err("Failed to save SCMI device - ret:%d\n", ret);
-			kfree(rdev);
-			kfree(phead);
-			ret = -EINVAL;
-			goto out;
-		}
-		ret = 0;
-	}
-	list_add(&rdev->node, phead);
-
-	/*
-	 * Now effectively create and initialize the requested device for every
-	 * already initialized SCMI instance which has registered the requested
-	 * protocol as a valid active one: i.e. defined in DT and supported by
-	 * current platform FW.
-	 */
-	mutex_lock(&scmi_list_mutex);
-	list_for_each_entry(info, &scmi_list, node) {
-		struct device_node *child;
-
-		child = idr_find(&info->active_protocols,
-				 id_table->protocol_id);
-		if (child) {
-			struct scmi_device *sdev;
-
-			sdev = scmi_get_protocol_device(child, info,
-							id_table->protocol_id,
-							id_table->name);
-			if (sdev) {
-				/* Set handle if not already set: device existed */
-				if (!sdev->handle)
-					sdev->handle =
-						scmi_handle_get_from_info_unlocked(info);
-				/* Relink consumer and suppliers */
-				if (sdev->handle)
-					scmi_device_link_add(&sdev->dev,
-							     sdev->handle->dev);
-			}
-		} else {
-			dev_err(info->dev,
-				"Failed. SCMI protocol %d not active.\n",
-				id_table->protocol_id);
-		}
-	}
-	mutex_unlock(&scmi_list_mutex);
-
-out:
-	mutex_unlock(&scmi_requested_devices_mtx);
-
-	return ret;
-}
-
-/**
- * scmi_protocol_device_unrequest  - Helper to unrequest a device
- *
- * @id_table: A protocol/name pair descriptor for the device to be unrequested.
- *
- * An helper to let an SCMI driver release its request about devices; note that
- * devices are created and initialized once the first SCMI driver request them
- * but they destroyed only on SCMI core unloading/unbinding.
- *
- * The current SCMI transport layer uses such devices as internal references and
- * as such they could be shared as same transport between multiple drivers so
- * that cannot be safely destroyed till the whole SCMI stack is removed.
- * (unless adding further burden of refcounting.)
- */
-void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table)
-{
-	struct list_head *phead;
-
-	pr_debug("Unrequesting SCMI device (%s) for protocol %x\n",
-		 id_table->name, id_table->protocol_id);
-
-	mutex_lock(&scmi_requested_devices_mtx);
-	phead = idr_find(&scmi_requested_devices, id_table->protocol_id);
-	if (phead) {
-		struct scmi_requested_dev *victim, *tmp;
-
-		list_for_each_entry_safe(victim, tmp, phead, node) {
-			if (!strcmp(victim->id_table->name, id_table->name)) {
-				list_del(&victim->node);
-				kfree(victim);
-				break;
-			}
-		}
-
-		if (list_empty(phead)) {
-			idr_remove(&scmi_requested_devices,
-				   id_table->protocol_id);
-			kfree(phead);
-		}
-	}
-	mutex_unlock(&scmi_requested_devices_mtx);
-}
-
 static int scmi_chan_destroy(int id, void *p, void *idr)
 {
 	struct scmi_chan_info *cinfo = p;
@@ -2733,7 +2438,6 @@ static int scmi_probe(struct platform_device *pdev)
 		}
 
 		of_node_get(child);
-		scmi_create_protocol_devices(child, info, prot_id);
 	}
 
 	return 0;
-- 
2.53.0



