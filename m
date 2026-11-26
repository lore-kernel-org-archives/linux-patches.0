Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705133;
	b=adjmJrL3xktXJzfzwKFNGGoSHoE9pbAWV1wz7BGSCERbE3TllI5hjOZWeBEoR0OjiaDT
	 RUNeIMnKVxSpONPIfMt2SEytNvBchvG6hcCZlNMAVbaP8dIplIdQrRKHq10hosDPYCQnn
	 sSqAGMA3KiqgWDm7hjqWryJpDGkR1+nmRBYghOZ7fhAZMd+b5kGbsY/Fz54KFWyczURh6
	 kEDCwxXY0TWVxuUWWlWasjPnpijQ8Y7id1k7FVk1bAdgKMB0c30rxYKwnazsKzC2ikjNY
	 hkNGi+o4queoAfS91fFs35DWIyj85vFoi6dTZUvuIKwkTsg28fGHy+UOGn/zw2bM54A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t3OFtsNRDHs4aX0siHC9NxiI8H6qOhi87Q4agp9xxYY=;
	b=sB7zaldCBokPB+/FGf9PzXTcZcoVQEqgsfDC/5UzHM7WzOeK4aTZouB3R0n6lAR5+Ur4
	 9Jxk22YXrNH92cW1+4FmbGOZD5ruo0PWvzQT3N72RpelOJo1GRJrWvzsYZXXOzEyuOLfH
	 QrHsyhSLBqQ7/2dZFY4/ICsZxibBX2FsDeXIIhkgc/mh4C/Y/4dql7YaNAiB4Kfno98Hd
	 jXCLut3tgfEQWuJACxi54dJ/s8LhVQSpCO8+wHH6hLfZI3/uugrG6VAFGzDgR4FBA6yMj
	 lbNVZjQVhJAdYp5KujtdPxhH9uxCDFSK3DiRUAR5nhMArfScosMI59EPPELjDuZ4pPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlxu2wk+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C70606A31E;
	Thu, 26 Nov 2026 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlxu2wk+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67381F000C0;
	Thu, 26 Nov 2026 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705133;
	bh=t3OFtsNRDHs4aX0siHC9NxiI8H6qOhi87Q4agp9xxYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlxu2wk+K2uEH09LT415YywH6JQRjCQ3Fc9meF2RQxBo2oL2WMBh9CIjl8I3+LV5M
	 gcUFjGpxAMgGNlIJEiTYm84FW437D6KLIw7plHXgWsT+VREV/U5frpgES2UsvHDbR5
	 ikOOz0S2vU66GfkJHfEIsb063xpco7AsHH/mheBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/319] ACPI: scan: Introduce acpi_fetch_acpi_dev()
Date: Thu, 26 Nov 2026 15:37:42 +0100
Message-ID: <20261126144008.866968887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit e3c963c498871e0d4b2eceb32e2b989493838ccc ]

Introduce acpi_fetch_acpi_dev() as a more reasonable replacement for
acpi_bus_get_device() and modify the code in scan.c to use it instead
of the latter.

No expected functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 17654aa629cb ("ACPI: scan: Do not hold physical_node_lock across device_offline() and device_online()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c     | 34 ++++++++++++++++++++++++----------
 include/acpi/acpi_bus.h |  1 +
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 05b0b7fbbb740..8b5733895aba9 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -135,12 +135,12 @@ bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
 static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 				    void **ret_p)
 {
-	struct acpi_device *device = NULL;
+	struct acpi_device *device = acpi_fetch_acpi_dev(handle);
 	struct acpi_device_physical_node *pn;
 	bool second_pass = (bool)data;
 	acpi_status status = AE_OK;
 
-	if (acpi_bus_get_device(handle, &device))
+	if (!device)
 		return AE_OK;
 
 	if (device->handler && !device->handler->hotplug.enabled) {
@@ -181,10 +181,10 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 static acpi_status acpi_bus_online(acpi_handle handle, u32 lvl, void *data,
 				   void **ret_p)
 {
-	struct acpi_device *device = NULL;
+	struct acpi_device *device = acpi_fetch_acpi_dev(handle);
 	struct acpi_device_physical_node *pn;
 
-	if (acpi_bus_get_device(handle, &device))
+	if (!device)
 		return AE_OK;
 
 	mutex_lock(&device->physical_node_lock);
@@ -595,6 +595,19 @@ int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device)
 }
 EXPORT_SYMBOL(acpi_bus_get_device);
 
+/**
+ * acpi_fetch_acpi_dev - Retrieve ACPI device object.
+ * @handle: ACPI handle associated with the requested ACPI device object.
+ *
+ * Return a pointer to the ACPI device object associated with @handle, if
+ * present, or NULL otherwise.
+ */
+struct acpi_device *acpi_fetch_acpi_dev(acpi_handle handle)
+{
+	return handle_to_device(handle, NULL);
+}
+EXPORT_SYMBOL_GPL(acpi_fetch_acpi_dev);
+
 static void get_acpi_device(void *dev)
 {
 	acpi_dev_get(dev);
@@ -797,7 +810,7 @@ static const char * const acpi_ignore_dep_ids[] = {
 
 static struct acpi_device *acpi_bus_get_parent(acpi_handle handle)
 {
-	struct acpi_device *device = NULL;
+	struct acpi_device *device;
 	acpi_status status;
 
 	/*
@@ -812,7 +825,9 @@ static struct acpi_device *acpi_bus_get_parent(acpi_handle handle)
 		status = acpi_get_parent(handle, &handle);
 		if (ACPI_FAILURE(status))
 			return status == AE_NULL_ENTRY ? NULL : acpi_root;
-	} while (acpi_bus_get_device(handle, &device));
+
+		device = acpi_fetch_acpi_dev(handle);
+	} while (!device);
 	return device;
 }
 
@@ -2004,11 +2019,10 @@ static bool acpi_bus_scan_second_pass;
 static acpi_status acpi_bus_check_add(acpi_handle handle, bool check_dep,
 				      struct acpi_device **adev_p)
 {
-	struct acpi_device *device = NULL;
+	struct acpi_device *device = acpi_fetch_acpi_dev(handle);
 	acpi_object_type acpi_type;
 	int type;
 
-	acpi_bus_get_device(handle, &device);
 	if (device)
 		goto out;
 
@@ -2549,8 +2563,8 @@ int __init acpi_scan_init(void)
 	if (result)
 		goto out;
 
-	result = acpi_bus_get_device(ACPI_ROOT_OBJECT, &acpi_root);
-	if (result)
+	acpi_root = acpi_fetch_acpi_dev(ACPI_ROOT_OBJECT);
+	if (!acpi_root)
 		goto out;
 
 	/* Fixed feature devices do not exist on HW-reduced platform */
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 7ce4e01b2406e..cdc3490a49633 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -505,6 +505,7 @@ extern int unregister_acpi_notifier(struct notifier_block *);
  */
 
 int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device);
+struct acpi_device *acpi_fetch_acpi_dev(acpi_handle handle);
 acpi_status acpi_bus_get_status_handle(acpi_handle handle,
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);
-- 
2.53.0



