Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039442;
	b=NF7xWGVCwZGpd+8hogx4+nzmMnZPIxDbbaYRxk66Oeq0+gXhcZZPWBjWsW8INLMLfPrx
	 bh/p9SeTYSwS8nJ5LN0T7U3a/qybnwILALtkcNdv5EFqmF+kzPMAJH5Vl7NGGsJCu3/lX
	 f2XfV56sVCdZbuSUZ6kKfEZeOb2eRkeN2OeNJciinMzih3UlZqRevsSSFSlgyqnOOMBk6
	 urTgMK64NIt0l269O0OQYyyTcUZfCsBmBcYY33k3rif9qyTN4FM32ri8nCFH8xzFdcvg6
	 KstPQ0dkSmR64Mf/AxVH8qLIujpVUhbepRrM+zA7tPlRGYHbmO3byxuNjWgQOn/RP2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pmhE3KBG3Jx3K9Pk1lCg9HaRdsh9N7kHo22vS8pz2Nk=;
	b=kc6tUjp0L7zQgzChYtZH4QHRVTO3ONu5CkxAa6Z0plSKrYN1rW42h+PSNx5mcIoR5I2V
	 7I9f53JPYgkGj+3W2FSDV/rncTtL0KgXjWIQXpM+BL4+co1LqxLiwIeDXxQblQFL3xPuL
	 SQ04HKdExrAQcD5XfstMz5iB4LG7+p1FdP+jGyGEYnTJJrMgs4nz+xkpLH2WWnJ0n3jwy
	 XQo0v3irznYu980m+MBHc3UcjvxiNJG1/66BwozKZU2890KKbOB4CXuiLUbRErYSMvcye
	 6+Ry2wrVXC3nuCCTahkRp/AbF6+gW+aCyaW8tR3MqXSu9WmoCqmUb0j3ZUjUthqG2MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoqnR+L1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6406606A31C;
	Wed, 18 Nov 2026 22:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoqnR+L1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617121F000C4;
	Wed, 18 Nov 2026 22:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039442;
	bh=pmhE3KBG3Jx3K9Pk1lCg9HaRdsh9N7kHo22vS8pz2Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoqnR+L1gus2V4GPxrq9MEqcx2uznJvt3V0Tkv6Mj+n8F6iA1UFRLh/uwp3gxXJHg
	 XRGJ7YnZUkbTmvqlGnB373d6fgNVl1SxdjMUiu8rsKIUvp6KEBrnM44Ynj3N0ML41K
	 +Lp33as8W9BHmeA7QxiZ4/XXz+y73AJkOodv5SlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Peixin Xie <peixin.xie@linux.spacemit.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2103/3318] ACPI: scan: Stop calling acpi_bus_init_power() early
Date: Wed, 18 Nov 2026 15:45:25 +0100
Message-ID: <20261118150425.171589320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2f4ddf2bd1baf0ee3c8542ec6f382a3585cae607 ]

There is a problem, introduced by commit 9d9bcae47fd5 ("ACPI: delay
enumeration of devices with a _DEP pointing to an INT3472 device")
inadvertently, that devices with missing dependencies may be put
into power state D0 prematurely [1].

Namely, acpi_bus_init_power() called by acpi_bus_get_power_flags()
during the early initialization of ACPI device objects, may discover
that all of the power resources needed by the given device to be in
power state D0 are initially on, so it will reference count those
power resources and transition the device into D0.  Later, if
acpi_bus_attach() running for that device notices that it has missing
dependencies, the enumeration of it will be deferred and its
power_manageable flag will be cleared, even though it is still in D0
at that point.

After the dependencies in question have been met, acpi_bus_attach()
runs again for the device and now it calls acpi_bus_init_power() that
takes additional references to the power resources used by the device
in D0.  These additional references prevent the power resources from
being turned off when the device goes into D3hot/D3cold.

Another problem, related to the previous one, is that ACPI power state
initialization may be carried out for devices whose parents are not
ready for enumeration which may lead to initialization ordering issues.

To address both, stop calling acpi_bus_init_power() from
acpi_bus_get_power_flags(), but also take the initialization of
PCI devices into account, which needs to be done because they
are initialized and bound to their ACPI companions before
acpi_bus_attach() is called for the latter.

To that end, notice that acpi_power_up_if_adr_present() is used for
powering-up PCI devices in D3cold before walking the bus in order to
discover them and the initial ACPI power state of those devices needs
to be known for this purpose, so add an acpi_bus_init_power() invocation
to that function.  [The debug statement printed by it duplicates the
debug statements printed during the acpi_bus_init_power() execution, so
drop it.]

Moreover, since the ACPI companions of PCI devices are associated with
the corresponding PCI devices found on the bus before acpi_bus_attach()
is called for them, it is not necessary or even useful to skip them in
acpi_bus_attach() due to an ACPI status mismatch, so avoid doing that
and complain if the ACPI status does not match the observed situation.

Also use the ACPI power state tracking to decide whether or not
the device's power state needs to be initialized in acpi_bus_attach()
instead of using the "initialized" flag of the ACPI device object
for this purpose, which is fragile and inconvenient, and clear the
power_manageable flag on failure in acpi_bus_init_power() (additionally,
poison the device ACPI power state as "invalid" if the initialization of
it fails).  That allows the clearing of the power_manageable flag for
devices with unmet dependencies to be dropped.

While at it, add a debug message pringing statement to
acpi_bus_init_power() to facilitate diagnostics.

Fixes: 9d9bcae47fd5 ("ACPI: delay enumeration of devices with a _DEP pointing to an INT3472 device")
Link: https://lore.kernel.org/linux-acpi/20260820-acpi-power-resource-ref-fix-v2-1-29818173ea13@linux.spacemit.com/ [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Peixin Xie <peixin.xie@linux.spacemit.com>
Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/2295263.irdbgypaU6@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_pm.c | 62 ++++++++++++++++++++++++++++++++--------
 drivers/acpi/scan.c      | 40 +++++++++++++++++---------
 2 files changed, 76 insertions(+), 26 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index cfc9700142959..368a495e6f5dc 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -23,6 +23,8 @@
 #include "fan.h"
 #include "internal.h"
 
+#define ACPI_D_STATE_INVALID	ACPI_D_STATE_COUNT
+
 /**
  * acpi_power_state_string - String representation of ACPI device power state.
  * @state: ACPI device power state to return the string representation of.
@@ -293,24 +295,28 @@ int acpi_bus_set_power(acpi_handle handle, int state)
 }
 EXPORT_SYMBOL(acpi_bus_set_power);
 
-int acpi_bus_init_power(struct acpi_device *device)
+static int acpi_device_init_power(struct acpi_device *device)
 {
 	int state;
 	int result;
 
-	if (!device)
-		return -EINVAL;
-
-	device->power.state = ACPI_STATE_UNKNOWN;
-	if (!acpi_device_is_present(device)) {
-		device->flags.initialized = false;
-		return -ENXIO;
-	}
-
 	result = acpi_device_get_power(device, &state);
 	if (result)
 		return result;
 
+	/*
+	 * If the current power state of the device is D0 and it has a parent
+	 * whose power state is not ignored, and the parent's power state
+	 * initialization has failed, the parent's power state can be updated to
+	 * D0 for consistency.
+	 */
+	if (!device->power.flags.ignore_parent && state == ACPI_STATE_D0) {
+		struct acpi_device *parent = acpi_dev_parent(device);
+
+		if (parent && parent->power.state == ACPI_D_STATE_INVALID)
+			parent->power.state = ACPI_STATE_D0;
+	}
+
 	if (state < ACPI_STATE_D3_COLD && device->power.flags.power_resources) {
 		/* Reference count the power resources. */
 		result = acpi_power_on_resources(device, state);
@@ -340,9 +346,36 @@ int acpi_bus_init_power(struct acpi_device *device)
 		state = ACPI_STATE_D0;
 	}
 	device->power.state = state;
+
+	acpi_handle_debug(device->handle, "Initial power state: %s\n",
+			  acpi_power_state_string(state));
+
 	return 0;
 }
 
+int acpi_bus_init_power(struct acpi_device *device)
+{
+	int result;
+
+	if (device->power.state != ACPI_STATE_UNKNOWN)
+		return 0;
+
+	/*
+	 * The ACPI device power state can be only initialized once.  If this
+	 * fails, ACPI power management will not be used for the device going
+	 * forward.
+	 */
+	result = acpi_device_init_power(device);
+	if (result) {
+		device->flags.power_manageable = 0;
+		device->power.state = ACPI_D_STATE_INVALID;
+		acpi_handle_info(device->handle,
+				 "Initial power state undetermined, ACPI PM disabled\n");
+	}
+
+	return result;
+}
+
 /**
  * acpi_device_fix_up_power - Force device with missing _PSC into D0.
  * @device: Device object whose power state is to be fixed up.
@@ -464,8 +497,13 @@ static int acpi_power_up_if_adr_present(struct acpi_device *adev, void *not_used
 	if (!(adev->flags.power_manageable && adev->pnp.type.bus_address))
 		return 0;
 
-	acpi_handle_debug(adev->handle, "Power state: %s\n",
-			  acpi_power_state_string(adev->power.state));
+	/*
+	 * This is done during the PCI root initialization which occurs before
+	 * acpi_bus_attach() is called for the device, so the ACPI power state
+	 * of the device needs to be initialized here.
+	 */
+	if (acpi_bus_init_power(adev))
+		return 0;
 
 	if (adev->power.state == ACPI_STATE_D3_COLD)
 		return acpi_device_set_power(adev, ACPI_STATE_D0);
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index b2bb9b34fb8af..73f2fc472b596 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -17,6 +17,7 @@
 #include <linux/kthread.h>
 #include <linux/dmi.h>
 #include <linux/dma-map-ops.h>
+#include <linux/pci.h>
 #include <linux/platform_data/x86/apple.h>
 #include <linux/pgtable.h>
 #include <linux/crc32.h>
@@ -1086,8 +1087,7 @@ static void acpi_bus_get_power_flags(struct acpi_device *device)
 			device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
 	}
 
-	if (acpi_bus_init_power(device))
-		device->flags.power_manageable = 0;
+	device->power.state = ACPI_STATE_UNKNOWN;
 }
 
 static void acpi_bus_get_flags(struct acpi_device *device)
@@ -2185,38 +2185,50 @@ static int acpi_scan_attach_handler(struct acpi_device *device)
 static int acpi_bus_attach(struct acpi_device *device, void *first_pass)
 {
 	bool skip = !first_pass && device->flags.visited;
+	struct pci_dev *pci;
 	acpi_handle ejd;
 	int ret;
 
 	if (skip)
 		goto ok;
 
+	device->flags.initialized = true;
+
 	if (ACPI_SUCCESS(acpi_bus_get_ejd(device->handle, &ejd)))
 		register_dock_dependent_device(device, ejd);
 
 	acpi_bus_get_status(device);
-	/* Skip devices that are not ready for enumeration (e.g. not present) */
-	if (!acpi_dev_ready_for_enumeration(device)) {
-		device->flags.initialized = false;
+	/*
+	 * If the given ACPI device object has been already associated with a
+	 * PCI device found on the bus, its status is effectively "present and
+	 * enabled", and dependencies are not tracked for PCI devices, so it is
+	 * not necessary or even useful to check the device's readiness in that
+	 * case.
+	 */
+	pci = acpi_dev_get_pci_dev(device);
+	if (pci) {
+		acpi_handle_debug(device->handle, "PCI companion %s found\n",
+				  pci_name(pci));
+
+		if (!acpi_device_is_present(device))
+			pci_info(pci, FW_BUG "ACPI status differs from reality\n");
+
+		pci_dev_put(pci);
+	} else if (!acpi_dev_ready_for_enumeration(device)) {
+		/* The device is not ready (e.g. not present), so skip it. */
 		acpi_device_clear_enumerated(device);
-		device->flags.power_manageable = 0;
 		return 0;
 	}
+
 	if (device->handler)
 		goto ok;
 
 	acpi_ec_register_opregions(device);
 
-	if (!device->flags.initialized) {
-		device->flags.power_manageable =
-			device->power.states[ACPI_STATE_D0].flags.valid;
-		if (acpi_bus_init_power(device))
-			device->flags.power_manageable = 0;
+	acpi_bus_init_power(device);
 
-		device->flags.initialized = true;
-	} else if (device->flags.visited) {
+	if (device->flags.visited)
 		goto ok;
-	}
 
 	ret = acpi_scan_attach_handler(device);
 	if (ret < 0)
-- 
2.53.0



