Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018859;
	b=0ODi4mcFzL1ldGUM0DEdVTZM+PYAnP9Fm0lzzPGA8sxYV6wK/RN7+O3OKy5mO/QuBqw7
	 FNR4Uh/2N7CkRBrpSnAJOIiUHrPhO/MDpcERc1YBlRicdej3r9HwwfUDJmbr7GYD6WCEn
	 F78Z4v2fhlxovz6Lig3SS6OzBDil3E7QR0ZfySgUjVpH36X9GhyqVO86BELotJ3cy686F
	 6FEmvcLdvi78Xie65eAILKj11OIubNGXcCKHw1PwTXHklc0b789ATDOwQTxI2cfI/PHXU
	 7liAV9t5vJH7VCr6yvTBwSnkpw9SBxMMOW0WgembNlOBTeaaofZbcpDzkvtrQgpuseA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k1No1Vp+xPVH5rVKpzLWlSxHRQUCB38IRX1tpMkuShI=;
	b=Sb02zw5pDJOSCxppmKe4U6jDT8/WMWM/YJnYr4MhxR5UCuC8+oR9PdveQd3GCftI+isz
	 MOUYZ3QAtugIN00wKY+BaYYq0ZAuZcACFWV0+QrMtRQPAGXzc7f9JKfCh2QIk3vhrXCdW
	 G2VLe8Ty66b2Ba8N3h6fCI6ivbwAx6X0T/9tGO+Mq6UZ1J00pBHZAntJQ+cufun854Zu0
	 D54s2kqykZ3j5GnZu3ue1ipSG590wMjU42JfDQlH0jbXNi7RsCKsUF5cDtT5pFlvBCza2
	 94LTOwzrsruOhc07WnaKU1D/pV4XVnddpM0US6nfT1R4WCtDkV6rKM8pUEryV/kqhXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yt2Hw1Iu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC361606A31C;
	Wed, 18 Nov 2026 16:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yt2Hw1Iu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0F31F000C4;
	Wed, 18 Nov 2026 16:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018859;
	bh=k1No1Vp+xPVH5rVKpzLWlSxHRQUCB38IRX1tpMkuShI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yt2Hw1IuWU0TYbBydd051rweo1PeulpGAcY9tODXlAxlMqGvH02XDzErTOF7tpeFN
	 pV5kvBg0lNbQJancslD2L7NZNAnKDYWSrXBWC+S1Pt8TEhYkJz4tZf4/5xwHKHA1Np
	 nJB1A6YSLGyDs91nhAmhBmhHbhhi5luRWBYcH6EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: [PATCH 7.3 1388/2651] PCI/ACPI: Centralize pcie_ports_native checking
Date: Wed, 18 Nov 2026 15:43:48 +0100
Message-ID: <20261118150337.987667171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 4fe37866b0d92cdc45b62954a76489a9d9f8bd73 ]

If the user booted with "pcie_ports=native", we take control of the PCIe
port services unconditionally, regardless of what _OSC says.

Centralize the testing of pcie_ports_native in acpi_pci_root_create(),
where we interpret the _OSC results, so other places only have to check
host_bridge->native_X and we don't have to sprinkle tests of
pcie_ports_native everywhere.

Rather than overriding the host_bridge->native_X flags after the fact, fold
"pcie_ports=native" into the _OSC control mask we evaluate, i.e., proceed
as though the platform had granted control of the port services.  That way
there is a single mechanism deciding each native_X flag, and we can report
exactly which features we are overriding _OSC for instead of just noting
that we are overriding something:

  acpi PNP0A08:00: _OSC: OS forcing control ("pcie_ports=native") of [PCIeHotplug PME AER DPC]

Forcing host_bridge->native_aer also restores DPC service binding under
"pcie_ports=native", which regressed in commit 97ca178c899d ("PCI/DPC:
Allow DPC on all Downstream Ports when OS controls AER").  That commit
replaced the AER service test in get_port_device_capability() with
host->native_aer, so DPC stayed off when host_bridge->native_aer was not
set.

This also extends "pcie_ports=native" to host_bridge->native_dpc, which had
no pcie_ports_native fallback before.  That effect is narrow.  native_dpc
is only consumed by pci_dpc_recovered(), where with CONFIG_PCIE_EDR=n it
previously gave up immediately and now lets pciehp wait for DPC recovery
before treating a Link Down as a hotplug event.

Fold "pcie_ports=dpc-native" into the control mask the same way, so
host_bridge->native_dpc reflects it as well, with the same narrow effect on
pci_dpc_recovered().  Move the pcie_ports_dpc_native declaration to
<linux/pci.h> so acpi_pci_root_create() can test it.

host_bridge->native_ltr is deliberately not forced.  "pcie_ports=" controls
PCIe port services and LTR is not one.  There is no PCIE_PORT_SERVICE_LTR,
and native_ltr is only used by pci_configure_ltr() to enable ASPM L1.2, so
forcing it would be an ASPM policy decision users did not ask for.

SHPC hotplug is left alone for a simpler reason: SHPC is a conventional PCI
feature rather than a PCIe one, so "pcie_ports=" has no bearing on it.

Fixes: 97ca178c899d ("PCI/DPC: Allow DPC on all Downstream Ports when OS controls AER")
Closes: https://lore.kernel.org/linux-pci/20260901064554.2178688-1-kanie@linux.alibaba.com/
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Guixin Liu <kanie@linux.alibaba.com>
Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org> # ACPI core
Link: https://patch.msgid.link/20261002211828.1293177-4-sathyanarayanan.kuppuswamy@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_root.c           | 43 ++++++++++++++++++++++++++++++-
 drivers/pci/hotplug/pciehp_core.c |  2 +-
 drivers/pci/pci-acpi.c            |  3 ---
 drivers/pci/pcie/aer.c            |  6 ++---
 drivers/pci/pcie/aer_cxl_rch.c    |  2 +-
 drivers/pci/pcie/err.c            |  2 +-
 drivers/pci/pcie/portdrv.c        |  6 ++---
 drivers/pci/pcie/portdrv.h        |  2 --
 include/linux/pci.h               |  2 ++
 9 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 756dc2f055f51..a1a9c06012f87 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -999,6 +999,19 @@ static void acpi_pci_root_release_info(struct pci_host_bridge *bridge)
 			flag = 0;		\
 	} while (0)
 
+#define FLAG(x)		((x) ? '+' : '-')
+
+/*
+ * _OSC control bits for the features implemented by the PCIe port driver,
+ * i.e., the ones "pcie_ports=native" applies to.  LTR and SHPC hotplug are
+ * negotiated via _OSC as well, but they are not portdrv services, so
+ * "pcie_ports=" has no bearing on them.
+ */
+#define OSC_PCIE_PORT_SERVICE_CONTROLS	(OSC_PCI_EXPRESS_NATIVE_HP_CONTROL | \
+					 OSC_PCI_EXPRESS_PME_CONTROL | \
+					 OSC_PCI_EXPRESS_AER_CONTROL | \
+					 OSC_PCI_EXPRESS_DPC_CONTROL)
+
 struct pci_bus *acpi_pci_root_create(struct acpi_pci_root *root,
 				     struct acpi_pci_root_ops *ops,
 				     struct acpi_pci_root_info *info,
@@ -1009,7 +1022,7 @@ struct pci_bus *acpi_pci_root_create(struct acpi_pci_root *root,
 	int node = acpi_get_node(device->handle);
 	struct pci_bus *bus;
 	struct pci_host_bridge *host_bridge;
-	u32 ctrl, ext_ctrl;
+	u32 ctrl, ext_ctrl, override = 0;
 
 	info->root = root;
 	info->bridge = device;
@@ -1039,6 +1052,26 @@ struct pci_bus *acpi_pci_root_create(struct acpi_pci_root *root,
 	ctrl = root->osc_control_set;
 	ext_ctrl = root->osc_ext_control_set;
 
+	/*
+	 * If the user specified "pcie_ports=native", use the PCIe port
+	 * services regardless of what _OSC says, i.e., proceed as though the
+	 * platform had granted us control of them.  "pcie_ports=dpc-native"
+	 * does the same for DPC alone.  This may conflict with firmware that
+	 * expects to own those features.
+	 */
+	if (pcie_ports_native)
+		override = OSC_PCIE_PORT_SERVICE_CONTROLS & ~ctrl;
+	else if (pcie_ports_dpc_native)
+		override = OSC_PCI_EXPRESS_DPC_CONTROL & ~ctrl;
+
+	if (override) {
+		decode_osc_control(root, pcie_ports_native ?
+				   "OS forcing control (\"pcie_ports=native\") of" :
+				   "OS forcing control (\"pcie_ports=dpc-native\") of",
+				   override);
+		ctrl |= override;
+	}
+
 	OSC_OWNER(ctrl, OSC_PCI_EXPRESS_NATIVE_HP_CONTROL,
 		  host_bridge->native_pcie_hotplug);
 	OSC_OWNER(ctrl, OSC_PCI_SHPC_NATIVE_HP_CONTROL,
@@ -1051,6 +1084,14 @@ struct pci_bus *acpi_pci_root_create(struct acpi_pci_root *root,
 	OSC_OWNER(ext_ctrl, OSC_CXL_ERROR_REPORTING_CONTROL,
 		  host_bridge->native_cxl_error);
 
+	dev_info(&root->device->dev, "OS native features: SHPCHotplug%c PCIeHotplug%c PME%c AER%c DPC%c LTR%c\n",
+		 FLAG(host_bridge->native_shpc_hotplug),
+		 FLAG(host_bridge->native_pcie_hotplug),
+		 FLAG(host_bridge->native_pme),
+		 FLAG(host_bridge->native_aer),
+		 FLAG(host_bridge->native_dpc),
+		 FLAG(host_bridge->native_ltr));
+
 	acpi_dev_power_up_children_with_adr(device);
 
 	pci_scan_child_bus(bus);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 5ce32dc7e178f..a25fbd9954247 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -258,7 +258,7 @@ static bool pme_is_native(struct pcie_device *dev)
 	const struct pci_host_bridge *host;
 
 	host = pci_find_host_bridge(dev->port->bus);
-	return pcie_ports_native || host->native_pme;
+	return host->native_pme;
 }
 
 static void pciehp_disable_interrupt(struct pcie_device *dev)
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 42d545edd7fad..1150f2fbabf41 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -812,9 +812,6 @@ bool pciehp_is_native(struct pci_dev *bridge)
 	if (!IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))
 		return false;
 
-	if (pcie_ports_native)
-		return true;
-
 	host = pci_find_host_bridge(bridge->bus);
 	return host->native_pcie_hotplug;
 }
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 490f096cfe91c..6ab23318b4052 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -260,7 +260,7 @@ int pcie_aer_is_native(struct pci_dev *dev)
 	if (!dev->aer_cap)
 		return 0;
 
-	return pcie_ports_native || host->native_aer;
+	return host->native_aer;
 }
 EXPORT_SYMBOL_NS_GPL(pcie_aer_is_native, "CXL");
 
@@ -1860,7 +1860,7 @@ static pci_ers_result_t aer_root_reset(struct pci_dev *dev)
 	 */
 	aer = root ? root->aer_cap : 0;
 
-	if ((host->native_aer || pcie_ports_native) && aer)
+	if (host->native_aer && aer)
 		aer_disable_irq(root);
 
 	if (type == PCI_EXP_TYPE_RC_EC || type == PCI_EXP_TYPE_RC_END) {
@@ -1875,7 +1875,7 @@ static pci_ers_result_t aer_root_reset(struct pci_dev *dev)
 			pci_is_root_bus(dev->bus) ? "Root" : "Downstream", rc);
 	}
 
-	if ((host->native_aer || pcie_ports_native) && aer) {
+	if (host->native_aer && aer) {
 		/* Clear Root Error Status */
 		pci_read_config_dword(root, aer + PCI_ERR_ROOT_STATUS, &reg32);
 		pci_write_config_dword(root, aer + PCI_ERR_ROOT_STATUS, reg32);
diff --git a/drivers/pci/pcie/aer_cxl_rch.c b/drivers/pci/pcie/aer_cxl_rch.c
index e471eefec9c40..b480dad8bbf4d 100644
--- a/drivers/pci/pcie/aer_cxl_rch.c
+++ b/drivers/pci/pcie/aer_cxl_rch.c
@@ -31,7 +31,7 @@ static bool cxl_error_is_native(struct pci_dev *dev)
 {
 	struct pci_host_bridge *host = pci_find_host_bridge(dev->bus);
 
-	return (pcie_ports_native || host->native_aer);
+	return host->native_aer;
 }
 
 static int cxl_rch_handle_error_iter(struct pci_dev *dev, void *data)
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index d77403d8855bd..1a7fc71c79d8a 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -273,7 +273,7 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	 * it is responsible for clearing this status.  In that case, the
 	 * signaling device may not even be visible to the OS.
 	 */
-	if (host->native_aer || pcie_ports_native) {
+	if (host->native_aer) {
 		pcie_clear_device_status(dev);
 		pci_aer_clear_nonfatal_status(dev);
 	}
diff --git a/drivers/pci/pcie/portdrv.c b/drivers/pci/pcie/portdrv.c
index a9cbfc1d2bc75..32fc623dd4108 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -223,7 +223,7 @@ static int get_port_device_capability(struct pci_dev *dev)
 	if (dev->is_pciehp &&
 	    (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
 	     pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM) &&
-	    (pcie_ports_native || host->native_pcie_hotplug)) {
+	    host->native_pcie_hotplug) {
 		services |= PCIE_PORT_SERVICE_HP;
 
 		/*
@@ -240,14 +240,14 @@ static int get_port_device_capability(struct pci_dev *dev)
 	if ((pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
              pci_pcie_type(dev) == PCI_EXP_TYPE_RC_EC) &&
 	    dev->aer_cap && pci_aer_available() &&
-	    (pcie_ports_native || host->native_aer))
+	    host->native_aer)
 		services |= PCIE_PORT_SERVICE_AER;
 #endif
 
 	/* Root Ports and Root Complex Event Collectors may generate PMEs */
 	if ((pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
 	     pci_pcie_type(dev) == PCI_EXP_TYPE_RC_EC) &&
-	    (pcie_ports_native || host->native_pme)) {
+	    host->native_pme) {
 		services |= PCIE_PORT_SERVICE_PME;
 
 		/*
diff --git a/drivers/pci/pcie/portdrv.h b/drivers/pci/pcie/portdrv.h
index cc58bf2f2c844..e1b6a8af6f712 100644
--- a/drivers/pci/pcie/portdrv.h
+++ b/drivers/pci/pcie/portdrv.h
@@ -25,8 +25,6 @@
 
 #define PCIE_PORT_DEVICE_MAXSERVICES   5
 
-extern bool pcie_ports_dpc_native;
-
 #ifdef CONFIG_PCIEAER
 int pcie_aer_init(void);
 #else
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 272378dd8973b..97a1096d5a8ac 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1916,12 +1916,14 @@ static inline int pci_irqd_intx_xlate(struct irq_domain *d,
 #ifdef CONFIG_PCIEPORTBUS
 extern bool pcie_ports_disabled;
 extern bool pcie_ports_native;
+extern bool pcie_ports_dpc_native;
 
 int pcie_set_target_speed(struct pci_dev *port, enum pci_bus_speed speed_req,
 			  bool use_lt);
 #else
 #define pcie_ports_disabled	true
 #define pcie_ports_native	false
+#define pcie_ports_dpc_native	false
 
 static inline int pcie_set_target_speed(struct pci_dev *port,
 					enum pci_bus_speed speed_req,
-- 
2.53.0



