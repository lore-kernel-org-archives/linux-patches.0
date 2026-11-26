Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705136;
	b=vONx+UTWQw0gX5WXstorERg12WfSw18aiP1xDgwhDDNRTGRxEnMehtK069/QqkwD9tqD
	 867G/8osXXdPpf0m/6NpMgHHuafA8FVtu8U4JH90mY8dalUsYNRYNYgtqmAOGknhP8Bfo
	 /wN57frDHt47otBetNUfLcruIXOAEjtsS8elasY1zC+/iYcEZLzKIMpMpT0pGJ5tgC0Rk
	 si0i8p8CgjRZ4lPfn/anN4dqUKGnHmAV7pPD7PbX3FyIE3AKxHBeZOlv93jUBZGjmMRGo
	 oEnI7A5m34Z0pVrtiLEsSuEXQFZEjNqIfl9LsVI+EcRXNL5FsxBqZV+pr0i+8qZJ2/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+HReGEaVaNAvcDMoYTIDX2UAf57wigODshTRXdLir90=;
	b=yVqMHSat9vBSlitXFq0UKP92/pD6LBpNgvDnPgeXs+FbMf8sThJzfLIiJaOPMsukQIW9
	 CaqspJ1GFCcux/U64z4Ni5OpIps8ykGlI5GevguKSa+E9oWDfSQVnhMi1nrqtV0L/2X7m
	 Tyq/XuqZvsNKjV7Gb5d+/MGj1E0BqkmAnpxSLpi1RTGvN/boYtb1jlGuXEbv7IE8WCRYn
	 q7jQTFrsRXQqZDhcEVvBZYbxIOkZh3xACLB2A9RX3RfqGXLlRHKUAwITdSKCtVbppv+LQ
	 N+9rN6PIXZQDx011hDF/cgC5Y7k5tfzvnu5XObPvNuieW72fiGthhhw5uzxhVIJbElQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I/MwMzFv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF0E606A31C;
	Thu, 26 Nov 2026 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I/MwMzFv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D92D1F000C4;
	Thu, 26 Nov 2026 14:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705135;
	bh=+HReGEaVaNAvcDMoYTIDX2UAf57wigODshTRXdLir90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/MwMzFvOwrM2jg5K7+4jT6KBUSPqRG4wmC4X6mEXeM8MqLTqKvgNvNDFR+zFkDOq
	 yIAqxsMRO5JAELMUQj1HomLsrS4Qcb8bpgcg7UxtOmNMw35rVaCjWA9ST0HINu9BHD
	 K2i6BUYMTS1uCtPYVY0NG5kQltgB+KzKVcFLwzlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cea7285bc17b76ffe39f@syzkaller.appspotmail.com,
	syzbot+a265816368571f78ab88@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 095/319] ACPI: scan: Do not hold physical_node_lock across device_offline() and device_online()
Date: Thu, 26 Nov 2026 15:37:43 +0100
Message-ID: <20261126144008.889229577@linuxfoundation.org>
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
index 8b5733895aba9..fcf5f10af713c 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -113,11 +113,7 @@ bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
 	bool offline = true;
 	char *envp[] = { "EVENT=offline", NULL };
 
-	/*
-	 * acpi_container_offline() calls this for all of the container's
-	 * children under the container's physical_node_lock lock.
-	 */
-	mutex_lock_nested(&adev->physical_node_lock, SINGLE_DEPTH_NESTING);
+	mutex_lock(&adev->physical_node_lock);
 
 	list_for_each_entry(pn, &adev->physical_node_list, node)
 		if (device_supports_offline(pn->dev) && !pn->dev->offline) {
@@ -132,6 +128,59 @@ bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
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
@@ -139,6 +188,7 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 	struct acpi_device_physical_node *pn;
 	bool second_pass = (bool)data;
 	acpi_status status = AE_OK;
+	struct device *dev;
 
 	if (!device)
 		return AE_OK;
@@ -151,26 +201,43 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
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
@@ -182,18 +249,19 @@ static acpi_status acpi_bus_online(acpi_handle handle, u32 lvl, void *data,
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
index cdc3490a49633..26e9678b63a76 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -338,6 +338,7 @@ struct acpi_device_physical_node {
 	struct list_head node;
 	struct device *dev;
 	bool put_online:1;
+	bool offline_pending:1;
 };
 
 struct acpi_device_properties {
-- 
2.53.0



