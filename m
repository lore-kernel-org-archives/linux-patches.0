Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0D426ED46;
	Sat, 12 Sep 2026 19:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242468; cv=none; b=PFnh8565zP0znQORw7bVrRXCJlppxvew+ZXjgWAuHhg3LuUd4b8n/I8SGB2t8cE+MeTBaD2umfyNNkm0hhrBPbiigyMfaqNWBFQxH0FaCW3ewaH6v+TWKFdXgVIRVxCuv55SQSANQlwCm3qncHge9pqzegqGxieVFeTAbRJRrzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242468; c=relaxed/simple;
	bh=dp3QjAy4vmPRUoHvc1M/m3ZZLZ6ppQ8NKZGRafhguO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jDeYeygCgtJxI8ku+EhQp0LbTXEdJENCvYEO8v1j961TfV6Bfpim+Ud4ii7QYVQkQRMcqmfHz+X0JLu96xlyUFdJptZrnLPdskA3oYzi1pcNKvyLS3Dv0wnzCUNy8k8o2ibs/IYK95Bz3+oZ836HcK5TM5yRTmk9N5KtyGLbXFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJE8sdLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJE8sdLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56291F000FF;
	Sat, 12 Sep 2026 19:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242467;
	bh=C+5/zoWgGcvSsITLEVkgjDP9vpo+MyL2nhdRaLlf48w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJE8sdLGjuBmQPYN6Jq5acJ3VR2YXX4QGYAcmXOXv0DU9L+r+BtNrEnz41I5eecHH
	 0p4Ifg5yt2kH0P50jbhuE73oQ+F0XiH50tydcc89H1cogXPTL6jBwcAFW6UYYebL15
	 NZGVR/NR2Hq/f8l1DpqVCy/RtUyytn0Jpzv1xdQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 413/798] driver core: platform: reorder functions
Date: Sat, 12 Sep 2026 09:00:41 +0200
Message-ID: <20260912065526.617852474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e21d740a3fe5ad2db7b5f5c2331fe2b713b1edba ]

This way all callbacks and structures used to initialize
platform_bus_type are defined just before platform_bus_type and in the
same order. Also move platform_drv_probe_fail just before it's only
user.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20201119124611.2573057-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 589b9e6f96be ("usb: renesas_usbhs: Fix power-off ordering on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 293 ++++++++++++++++++++--------------------
 1 file changed, 147 insertions(+), 146 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 647066229fec3..fa023cf80dc48 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -772,11 +772,6 @@ static int platform_drv_probe(struct device *_dev)
 	return ret;
 }
 
-static int platform_drv_probe_fail(struct device *_dev)
-{
-	return -ENXIO;
-}
-
 static int platform_drv_remove(struct device *_dev)
 {
 	struct platform_driver *drv = to_platform_driver(_dev->driver);
@@ -827,6 +822,11 @@ void platform_driver_unregister(struct platform_driver *drv)
 }
 EXPORT_SYMBOL_GPL(platform_driver_unregister);
 
+static int platform_drv_probe_fail(struct device *_dev)
+{
+	return -ENXIO;
+}
+
 /**
  * __platform_driver_probe - register driver for non-hotpluggable device
  * @drv: platform driver structure
@@ -1017,109 +1017,6 @@ void platform_unregister_drivers(struct platform_driver * const *drivers,
 }
 EXPORT_SYMBOL_GPL(platform_unregister_drivers);
 
-/* modalias support enables more hands-off userspace setup:
- * (a) environment variable lets new-style hotplug events work once system is
- *     fully running:  "modprobe $MODALIAS"
- * (b) sysfs attribute lets new-style coldplug recover from hotplug events
- *     mishandled before system is fully running:  "modprobe $(cat modalias)"
- */
-static ssize_t modalias_show(struct device *dev,
-			     struct device_attribute *attr, char *buf)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	int len;
-
-	len = of_device_modalias(dev, buf, PAGE_SIZE);
-	if (len != -ENODEV)
-		return len;
-
-	len = acpi_device_modalias(dev, buf, PAGE_SIZE - 1);
-	if (len != -ENODEV)
-		return len;
-
-	return sysfs_emit(buf, "platform:%s\n", pdev->name);
-}
-static DEVICE_ATTR_RO(modalias);
-
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &pdev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", pdev->driver_override);
-	device_unlock(dev);
-
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
-static ssize_t numa_node_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	return sysfs_emit(buf, "%d\n", dev_to_node(dev));
-}
-static DEVICE_ATTR_RO(numa_node);
-
-static umode_t platform_dev_attrs_visible(struct kobject *kobj, struct attribute *a,
-		int n)
-{
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
-
-	if (a == &dev_attr_numa_node.attr &&
-			dev_to_node(dev) == NUMA_NO_NODE)
-		return 0;
-
-	return a->mode;
-}
-
-static struct attribute *platform_dev_attrs[] = {
-	&dev_attr_modalias.attr,
-	&dev_attr_numa_node.attr,
-	&dev_attr_driver_override.attr,
-	NULL,
-};
-
-static struct attribute_group platform_dev_group = {
-	.attrs = platform_dev_attrs,
-	.is_visible = platform_dev_attrs_visible,
-};
-__ATTRIBUTE_GROUPS(platform_dev);
-
-static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
-{
-	struct platform_device	*pdev = to_platform_device(dev);
-	int rc;
-
-	/* Some devices have extra OF data and an OF-style MODALIAS */
-	rc = of_device_uevent_modalias(dev, env);
-	if (rc != -ENODEV)
-		return rc;
-
-	rc = acpi_device_uevent_modalias(dev, env);
-	if (rc != -ENODEV)
-		return rc;
-
-	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
-			pdev->name);
-	return 0;
-}
-
 static const struct platform_device_id *platform_match_id(
 			const struct platform_device_id *id,
 			struct platform_device *pdev)
@@ -1134,44 +1031,6 @@ static const struct platform_device_id *platform_match_id(
 	return NULL;
 }
 
-/**
- * platform_match - bind platform device to platform driver.
- * @dev: device.
- * @drv: driver.
- *
- * Platform device IDs are assumed to be encoded like this:
- * "<name><instance>", where <name> is a short description of the type of
- * device, like "pci" or "floppy", and <instance> is the enumerated
- * instance of the device, like '0' or '42'.  Driver IDs are simply
- * "<name>".  So, extract the <name> from the platform_device structure,
- * and compare it against the name of the driver. Return whether they match
- * or not.
- */
-static int platform_match(struct device *dev, struct device_driver *drv)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct platform_driver *pdrv = to_platform_driver(drv);
-
-	/* When driver_override is set, only bind to the matching driver */
-	if (pdev->driver_override)
-		return !strcmp(pdev->driver_override, drv->name);
-
-	/* Attempt an OF style match first */
-	if (of_driver_match_device(dev, drv))
-		return 1;
-
-	/* Then try ACPI style match */
-	if (acpi_driver_match_device(dev, drv))
-		return 1;
-
-	/* Then try to match against the id table */
-	if (pdrv->id_table)
-		return platform_match_id(pdrv->id_table, pdev) != NULL;
-
-	/* fall-back to driver name match */
-	return (strcmp(pdev->name, drv->name) == 0);
-}
-
 #ifdef CONFIG_PM_SLEEP
 
 static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
@@ -1316,6 +1175,148 @@ int platform_pm_restore(struct device *dev)
 
 #endif /* CONFIG_HIBERNATE_CALLBACKS */
 
+/* modalias support enables more hands-off userspace setup:
+ * (a) environment variable lets new-style hotplug events work once system is
+ *     fully running:  "modprobe $MODALIAS"
+ * (b) sysfs attribute lets new-style coldplug recover from hotplug events
+ *     mishandled before system is fully running:  "modprobe $(cat modalias)"
+ */
+static ssize_t modalias_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	int len;
+
+	len = of_device_modalias(dev, buf, PAGE_SIZE);
+	if (len != -ENODEV)
+		return len;
+
+	len = acpi_device_modalias(dev, buf, PAGE_SIZE - 1);
+	if (len != -ENODEV)
+		return len;
+
+	return sysfs_emit(buf, "platform:%s\n", pdev->name);
+}
+static DEVICE_ATTR_RO(modalias);
+
+static ssize_t numa_node_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", dev_to_node(dev));
+}
+static DEVICE_ATTR_RO(numa_node);
+
+static ssize_t driver_override_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	ssize_t len;
+
+	device_lock(dev);
+	len = sysfs_emit(buf, "%s\n", pdev->driver_override);
+	device_unlock(dev);
+
+	return len;
+}
+
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	int ret;
+
+	ret = driver_set_override(dev, &pdev->driver_override, buf, count);
+	if (ret)
+		return ret;
+
+	return count;
+}
+static DEVICE_ATTR_RW(driver_override);
+
+static struct attribute *platform_dev_attrs[] = {
+	&dev_attr_modalias.attr,
+	&dev_attr_numa_node.attr,
+	&dev_attr_driver_override.attr,
+	NULL,
+};
+
+static umode_t platform_dev_attrs_visible(struct kobject *kobj, struct attribute *a,
+		int n)
+{
+	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+
+	if (a == &dev_attr_numa_node.attr &&
+			dev_to_node(dev) == NUMA_NO_NODE)
+		return 0;
+
+	return a->mode;
+}
+
+static struct attribute_group platform_dev_group = {
+	.attrs = platform_dev_attrs,
+	.is_visible = platform_dev_attrs_visible,
+};
+__ATTRIBUTE_GROUPS(platform_dev);
+
+
+/**
+ * platform_match - bind platform device to platform driver.
+ * @dev: device.
+ * @drv: driver.
+ *
+ * Platform device IDs are assumed to be encoded like this:
+ * "<name><instance>", where <name> is a short description of the type of
+ * device, like "pci" or "floppy", and <instance> is the enumerated
+ * instance of the device, like '0' or '42'.  Driver IDs are simply
+ * "<name>".  So, extract the <name> from the platform_device structure,
+ * and compare it against the name of the driver. Return whether they match
+ * or not.
+ */
+static int platform_match(struct device *dev, struct device_driver *drv)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct platform_driver *pdrv = to_platform_driver(drv);
+
+	/* When driver_override is set, only bind to the matching driver */
+	if (pdev->driver_override)
+		return !strcmp(pdev->driver_override, drv->name);
+
+	/* Attempt an OF style match first */
+	if (of_driver_match_device(dev, drv))
+		return 1;
+
+	/* Then try ACPI style match */
+	if (acpi_driver_match_device(dev, drv))
+		return 1;
+
+	/* Then try to match against the id table */
+	if (pdrv->id_table)
+		return platform_match_id(pdrv->id_table, pdev) != NULL;
+
+	/* fall-back to driver name match */
+	return (strcmp(pdev->name, drv->name) == 0);
+}
+
+static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct platform_device	*pdev = to_platform_device(dev);
+	int rc;
+
+	/* Some devices have extra OF data and an OF-style MODALIAS */
+	rc = of_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
+
+	rc = acpi_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
+
+	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
+			pdev->name);
+	return 0;
+}
+
 int platform_dma_configure(struct device *dev)
 {
 	enum dev_dma_attr attr;
-- 
2.53.0



