Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618467;
	b=GaF5GidVRDt6FvSskiwBwbQYNUyeg0cKnfjrV6e5hW5tuNj21hL4ZJbd62aFlF39U0lG
	 BAcEoIJB6Qtr15B5w1Qtab+RQ/MsaIwRD+JmnII+xxtQCuImrvAzoGBWxZcLEZUwGhqT+
	 HFvEDjWFRkXQFnWurv0RhEvDRd8PYky6f5yHS7JOFG21xXwZP4kFxEBSpP/2I9neQPF1X
	 dLx/At5DhBlakI6xZcqqASTT0xD67B1p8LRSz7N9P6G/jjXDgdMRaRPn8B1ow+UPj5E8V
	 vcH1nwnyG3d25goPwBbT6Zd1+4I3ZWdveIGy+iiTzjly6Np7puDoW2SlzUTq7UpuK1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q9UiVkL9pyoHUaWs6R+0bgFHMWok33XKBpjEgjoR1T0=;
	b=eM4cRmngv3U+SCX9tFQuD2OVO9Iwcrj0C0tpScPKVQUXFk29lES+LHOZwQkjQtaOwxjJ
	 MHNwmrERNW3T5ZxNk1TEkWlnaFvMl5WHTC77IjpMG7PmtR24DZLqUIIG7jY6pzwDaWUla
	 WRTuQj+6/K5/pv6sKmDkGk9accZUB4J91Pn8xyDKKcFVti4YloQofThCVcYwMeNcePneS
	 CuQaq+jR/kWicVZ+CSVWESY3jFGXhdUwMA64p3MZttRdwmWlsq80zYaPpjJLk4UCUYiSA
	 5JrhU1HbGfgWlrs0OYmUASfmPcU599IdC1RtnPXtNsEVnEzQ/62qzU1ZteTl5RjEhog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jrj4wiQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBA8606A31E;
	Wed, 25 Nov 2026 14:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jrj4wiQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B031F000CA;
	Wed, 25 Nov 2026 14:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618467;
	bh=q9UiVkL9pyoHUaWs6R+0bgFHMWok33XKBpjEgjoR1T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrj4wiQhlcBoEeNNUVyH1PX2totWrHJj2KlGjG1MnrwfzsmkPxdw8GACtrg44EzRu
	 0hx9TzeaOVtZtcb93EoPVMGDWfA3KwMma1NruhULfEU3+T/U7pwQg5sjuE1obIh8VS
	 QpfxEJ8ONWP3Run2xedCR4L/cTfTV/erVKNTTf4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cea7285bc17b76ffe39f@syzkaller.appspotmail.com,
	syzbot+a265816368571f78ab88@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.3 0289/1005] ACPI: scan: Do not hold physical_node_lock across device_offline() and device_online()
Date: Wed, 25 Nov 2026 15:27:07 +0100
Message-ID: <20261125143828.509150570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

[ Upstream commit 17654aa629cba9a70e31cc1b7226a4fc1a1c801a ]

acpi_bus_offline() and acpi_bus_online() hold the physical_node_lock of
the ACPI device being hot-removed while they call device_offline() and
device_online() for its physical nodes.  Offlining a CPU this way takes
cpu_add_remove_lock and the CPU hotplug lock under physical_node_lock,
and lockdep connects that to the uevent attribute of platform devices,
whose store method takes physical_node_lock in
acpi_primary_dev_companion():

  physical_node_lock (acpi_bus_offline())
    -> cpu_add_remove_lock -> cpu_hotplug_lock
    -> cpuhp_state-down (mce_cpu_pre_down() unregistering a device)
    -> device_links_lock (device_links_purge())
    -> kn->active of a uevent attribute (device link unregistration)
    -> physical_node_lock (uevent_store() -> acpi_companion_match())

syzbot has reported this cycle twice.  The uevent attribute waited for in
the link unregistration is the device link's, not a platform device's,
and the physical_node_lock taken at the end is that of the platform
device's ACPI companion, not of the processor being ejected, so lockdep
only connects them because they share lock classes and this is unlikely
to deadlock.  However, lockdep turns itself off after reporting it.

It can be reproduced in a QEMU guest by writing to the uevent attribute
of an ACPI-enumerated platform device, reading the uevent attribute of a
device link while the link is removed, offlining a CPU and ejecting one
through sysfs.

physical_node_lock protects the list of physical nodes.  Since
acpi_unbind_one() blocks on it, holding it also keeps device_offline()
and device_online() from running in parallel with whatever happens to a
device after it has been unbound from its ACPI companion, but that is not
necessary: a reference to each device is held while the lock is dropped,
and the removal of the devices that can actually be taken offline here
(CPUs, memory blocks and containers) is serialized by the device hotplug
lock or acpi_scan_lock, both of which acpi_device_hotplug() holds
throughout.

So drop physical_node_lock around device_offline() and device_online().
Mark the nodes to offline with a new offline_pending flag, hold a
reference to each device while the lock is dropped, and look its node up
again afterwards to record whether it needs to be put back online,
because it may have been unbound in the meantime.  Physical nodes added
while the lock is not held are not offlined by the current pass, which is
no different from adding them right after it.

Since acpi_container_offline() no longer runs under the container's
physical_node_lock, the nesting annotation added to
acpi_scan_is_offline() by commit 4c533c801d1c ("ACPI / scan: Annotate
physical_node_lock in acpi_scan_is_offline()") is not needed anymore, so
drop it.

Fixes: 683058e315f0 ("ACPI / hotplug: Use device offline/online for graceful hot-removal")
Reported-by: syzbot+cea7285bc17b76ffe39f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6ae18ed0.6200f071.51519.0f60.GAE@google.com
Reported-by: syzbot+a265816368571f78ab88@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6adf293a.67317f00.38c4bc.00af.GAE@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261029034507.2721580-3-sashal@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c     | 106 +++++++++++++++++++++++++++++++++-------
 include/acpi/acpi_bus.h |   1 +
 2 files changed, 88 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index c90734a48583e..ba2f03854591f 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -114,11 +114,7 @@ bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
 	bool offline = true;
 	char *envp[] = { "EVENT=offline", NULL };
 
-	/*
-	 * acpi_container_offline() calls this for all of the container's
-	 * children under the container's physical_node_lock lock.
-	 */
-	mutex_lock_nested(&adev->physical_node_lock, SINGLE_DEPTH_NESTING);
+	mutex_lock(&adev->physical_node_lock);
 
 	list_for_each_entry(pn, &adev->physical_node_list, node)
 		if (device_supports_offline(pn->dev) && !dev_offline(pn->dev)) {
@@ -133,6 +129,59 @@ bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
 	return offline;
 }
 
+static struct acpi_device_physical_node *
+acpi_find_physical_node(struct acpi_device *adev, struct device *dev)
+{
+	struct acpi_device_physical_node *pn;
+
+	lockdep_assert_held(&adev->physical_node_lock);
+
+	list_for_each_entry(pn, &adev->physical_node_list, node)
+		if (pn->dev == dev)
+			return pn;
+
+	return NULL;
+}
+
+static struct device *acpi_next_offline_pending(struct acpi_device *adev)
+{
+	struct acpi_device_physical_node *pn;
+
+	lockdep_assert_held(&adev->physical_node_lock);
+
+	/*
+	 * Find the first physical node that is still to be offlined, clear its
+	 * offline_pending flag and return its device with a reference held.
+	 */
+	list_for_each_entry(pn, &adev->physical_node_list, node)
+		if (pn->offline_pending) {
+			pn->offline_pending = false;
+			return get_device(pn->dev);
+		}
+
+	return NULL;
+}
+
+static struct device *acpi_next_put_online(struct acpi_device *adev)
+{
+	struct acpi_device_physical_node *pn;
+
+	lockdep_assert_held(&adev->physical_node_lock);
+
+	/*
+	 * Find the first physical node that has been offlined by
+	 * acpi_bus_offline(), clear its put_online flag and return its device
+	 * with a reference held.
+	 */
+	list_for_each_entry(pn, &adev->physical_node_list, node)
+		if (pn->put_online) {
+			pn->put_online = false;
+			return get_device(pn->dev);
+		}
+
+	return NULL;
+}
+
 static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 				    void **ret_p)
 {
@@ -140,6 +189,7 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 	struct acpi_device_physical_node *pn;
 	bool second_pass = (bool)data;
 	acpi_status status = AE_OK;
+	struct device *dev;
 
 	if (!device)
 		return AE_OK;
@@ -152,26 +202,43 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 	mutex_lock(&device->physical_node_lock);
 
 	list_for_each_entry(pn, &device->physical_node_list, node) {
-		int ret;
-
 		if (second_pass) {
 			/* Skip devices offlined by the first pass. */
-			if (pn->put_online)
-				continue;
+			pn->offline_pending = !pn->put_online;
 		} else {
+			pn->offline_pending = true;
 			pn->put_online = false;
 		}
-		ret = device_offline(pn->dev);
+	}
+
+	/*
+	 * Drop physical_node_lock around device_offline(), because the latter
+	 * acquires locks, like the CPU hotplug ones, that must not nest under
+	 * it.
+	 */
+	while ((dev = acpi_next_offline_pending(device))) {
+		int ret;
+
+		mutex_unlock(&device->physical_node_lock);
+		ret = device_offline(dev);
+		mutex_lock(&device->physical_node_lock);
+
 		if (ret >= 0) {
-			pn->put_online = !ret;
+			/* The device may have been unbound in the meantime. */
+			pn = acpi_find_physical_node(device, dev);
+			if (pn)
+				pn->put_online = !ret;
 		} else {
 			*ret_p = &device->dev;
 			if (second_pass) {
-				dev_warn(pn->dev, "Offline failed.\n");
+				dev_warn(dev, "Offline failed.\n");
 				status = AE_ERROR;
-				break;
 			}
 		}
+
+		put_device(dev);
+		if (ACPI_FAILURE(status))
+			break;
 	}
 
 	mutex_unlock(&device->physical_node_lock);
@@ -183,18 +250,19 @@ static acpi_status acpi_bus_online(acpi_handle handle, u32 lvl, void *data,
 				   void **ret_p)
 {
 	struct acpi_device *device = acpi_fetch_acpi_dev(handle);
-	struct acpi_device_physical_node *pn;
+	struct device *dev;
 
 	if (!device)
 		return AE_OK;
 
 	mutex_lock(&device->physical_node_lock);
 
-	list_for_each_entry(pn, &device->physical_node_list, node)
-		if (pn->put_online) {
-			device_online(pn->dev);
-			pn->put_online = false;
-		}
+	while ((dev = acpi_next_put_online(device))) {
+		mutex_unlock(&device->physical_node_lock);
+		device_online(dev);
+		mutex_lock(&device->physical_node_lock);
+		put_device(dev);
+	}
 
 	mutex_unlock(&device->physical_node_lock);
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 40df037804a5d..57145e2aec21a 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -329,6 +329,7 @@ struct acpi_device_physical_node {
 	struct device *dev;
 	unsigned int node_id;
 	bool put_online:1;
+	bool offline_pending:1;
 };
 
 struct acpi_device_properties {
-- 
2.53.0



