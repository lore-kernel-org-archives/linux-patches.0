Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422879;
	b=tcWkMbNQqtZ4VZ7uFPAvGw/vKeHRl+3QSLAiLhuqVJzFww+jwifu2VONqfydpaujzq2M
	 U6p8t5P+U0qChaKBiZ569vj6UfJMM6WXhnle6pR2ZFUTl2ou/kLxAb0c/LdYUIJOydcl8
	 ECzaX28IWaAguIkgGv3ui9Wlkunu9shq8ZOWoTyiPzGzr3ANTCc/cCX5lTka71U9U3kZr
	 bXbk9UU4p/N5o7lYS4XrODRk5gHym1Rr5YZI9J96nFuzNnSD9wrm1Y4pgLiMVgWS7g8kj
	 V4hWYdv9kwej6N55oYL8wPivJdV84V3SZcmSrQWyN8Q3j5E0+zEEnbeuFNFHeC8+iYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lBhY3eC1YKCpRgc527F0nrWKr+z+F7vIb1s40NuAdYk=;
	b=asSldQRwy+P7YGkJWqMd7pP9foLnPFbL+PhYmM16ZdXcXdp9TBmMW21qRO19Mi7Txn2Z
	 zSL/D1S5iQjxwZfc5g/6QxtEwiHNmiZB2FtpE68toPDVLJEuvdWW5B9Yo309PCFm66BqI
	 mrk4B0zvFogm8AgfaO8llb6GJnm37eWUeNH+90J3npKcVjLGSEXBz09t5rvHs6dJIKtb6
	 v6XiDNBGjrzYIPqRKnreblpgkz7pBLpdFVe1Ja83eR4G0EhL2jYq1b/9txuG6h6ConZny
	 QTGDeab1XUgt2fSOqo/sELK4qoyyMYQsOjzsslIowP2yFfmruZ5mAQL/Q3CQVjoSmkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwRbCKsd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE0A606A31A;
	Mon, 23 Nov 2026 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwRbCKsd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F6A1F000EC;
	Mon, 23 Nov 2026 08:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422878;
	bh=lBhY3eC1YKCpRgc527F0nrWKr+z+F7vIb1s40NuAdYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwRbCKsdF0iY3G5P7DQkHOcZURGwLpFCmqnYmNTWCG9NCvjYjqIFhGljDXE6YRfAr
	 J45QmDo1H2aBS6L9EWvvqVDm9s82KOB9V7zAjShbZQxFmQLVl14/A/T5CvHNpTu9Do
	 ayvnk9ChauvllJ9sEn9FjbKVuIdB7elMiJxOGOOVuHGDIVGhVdJNRZYjJP1X1P3SRW
	 sFb2ARFHAkcXhLOVoJsxwUK6hejDnqxbPq85Q/yNphyKahKmZjR40dHPWyxQqOSVuF
	 t6gdswl6IwE+MZnfNniF5cSxc+4y0bXXRKnrrx928mLbj125AVCn17qaPijtRo3A8P
	 566vE2Ln6tkVA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v1 08/10] PCI/TSM: Add sysfs lock and unlock for guest-assigned devices
Date: Mon, 23 Nov 2026 14:03:35 +0530
Message-ID: <20261123083337.2731019-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
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

A confidential guest needs to lock a PCI device before collecting and
verifying evidence about it. Userspace also needs a way to unlock the
device after use or when verification fails.

Add tsm/lock and tsm/unlock sysfs attributes for TSM drivers
implementing devsec_ops. Writing a TSM device name to tsm/lock calls its
lock callback. Unlock calls the matching driver's unlock callback

Take device::mutex to prevent driver attachment, then pci_tsm_rwsem
for write to protect pci_dev::tsm during either operation. This order
matches PCI DMA preparation, which runs with the device mutex held.
Return -EBUSY if a PCI driver is already attached. Also call unlock
during PCI device removal or TSM unregister, using the same lock order.
Guest TSM unregister processes one PCI device at a time and releases
both locks before moving to the next device.

Require ARCH_HAS_CC_PLATFORM and select CONFIDENTIAL_DEVICES so
pci_tsm_unlock() clears the device's accepted state.

Expose the TSM class device's pci_mode attribute so userspace can
distinguish host link TSM from guest device-security TSM. Evidence
retrieval and acceptance are handled separately through the attestation
subsystem.

Based on the original Device Security LOCK patch from
Dan Williams <djbw@kernel.org>, adapted to the current PCI/TSM structures
and locking rules.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-pci   |  35 ++-
 Documentation/ABI/testing/sysfs-class-tsm |  19 ++
 Documentation/driver-api/pci/tsm.rst      |  47 ++++
 drivers/pci/Kconfig                       |   2 +
 drivers/pci/tsm.c                         | 247 ++++++++++++++++++++--
 drivers/virt/coco/tsm-core.c              |  48 ++++-
 include/linux/pci-tsm.h                   |  21 +-
 7 files changed, 401 insertions(+), 18 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ab9083f3b0d3..0b13c6c53964 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -653,14 +653,17 @@ Description:
 		Encryption) establishment. Reads from this attribute return the
 		name of the connected TSM or the empty string if not
 		connected. A TSM device signals its readiness to accept PCI
-		connection via a KOBJ_CHANGE event.
+		connection via a KOBJ_CHANGE event. This is a "link" TSM
+		attribute, see Documentation/ABI/testing/sysfs-class-tsm.
 
 What:		/sys/bus/pci/devices/.../tsm/disconnect
 Contact:	linux-coco@lists.linux.dev
 Description:
 		(WO) Write the name of the TSM device that was specified
 		to 'connect' to teardown the connection.
-		The write fails with EBUSY if the TSM is in use.
+		The write fails with EBUSY if the TSM is in use. This is a
+		"link" TSM attribute, see
+		Documentation/ABI/testing/sysfs-class-tsm.
 
 What:		/sys/bus/pci/devices/.../tsm/dsm
 Contact:	linux-coco@lists.linux.dev
@@ -695,3 +698,31 @@ Description:
 		When present and the tsm/ attribute directory is present, the
 		authenticated attribute is an alias for the device 'connect'
 		state. See the 'tsm/connect' attribute for more details.
+		This is a "link" TSM attribute, see
+		Documentation/ABI/testing/sysfs-class-tsm.
+
+What:		/sys/bus/pci/devices/.../tsm/lock
+Contact:	linux-coco@lists.linux.dev
+Description:
+		(RW) Write the name of a TSM (TEE Security Manager) device
+		instance to this file to request that the platform transition
+		the PCIe device configuration to the TDISP LOCKED state. This
+		puts the device in a state where security sensitive
+		configuration settings cannot be changed without transitioning
+		the device to the PCIe TDISP ERROR state. Reads from this attribute
+		return the name of the TSM device instance that has arranged for
+		the device to be locked, or the empty string if not locked. A
+		TSM class device signals its readiness for lock requests via a
+		KOBJ_CHANGE event. Writes fail with EBUSY if this device is
+		bound to a driver. This is a "devsec" TSM attribute, see
+		Documentation/ABI/testing/sysfs-class-tsm. See
+		Documentation/driver-api/pci/tsm.rst for more details.
+
+What:		/sys/bus/pci/devices/.../tsm/unlock
+Contact:	linux-coco@lists.linux.dev
+Description:
+		(WO) Write the name of the TSM device that was specified to
+		'lock' to unlock the device configuration and release the TSM's
+		per-device state. Writes fail with EBUSY if this device is bound
+		to a driver. This is a "devsec" TSM
+		attribute, see Documentation/ABI/testing/sysfs-class-tsm.
diff --git a/Documentation/ABI/testing/sysfs-class-tsm b/Documentation/ABI/testing/sysfs-class-tsm
index 1ddb8f357961..76704501f082 100644
--- a/Documentation/ABI/testing/sysfs-class-tsm
+++ b/Documentation/ABI/testing/sysfs-class-tsm
@@ -20,3 +20,22 @@ Description:
 		Documentation/ABI/testing/sysfs-devices-pci-host-bridge for the
 		description of the pciDDDD:BB/streamH.R.E symlink and the
 		pciDDDD:BB/available_secure_streams attribute.
+
+What:		/sys/class/tsm/tsmN/pci_mode
+Contact:	linux-coco@lists.linux.dev
+Description:
+		(RO) A TSM with PCIe TDISP capability can be in one of two
+		modes.
+
+		    "link": typically for a hypervisor (VMM) to authenticate,
+			    establish a secure session, and setup link
+			    encryption.
+
+		    "devsec": typically for a confidential guest (TVM) to
+			      transition assigned devices through the TDISP
+			      state machine UNLOCKED->LOCKED->RUN.
+
+		See the "tsm/" entries in
+		Documentation/ABI/testing/sysfs-bus-pci for the available PCI
+		device attributes when a TSM with the given "pci_mode" is
+		registered.
diff --git a/Documentation/driver-api/pci/tsm.rst b/Documentation/driver-api/pci/tsm.rst
index 232b92bec93f..c9eec7b88144 100644
--- a/Documentation/driver-api/pci/tsm.rst
+++ b/Documentation/driver-api/pci/tsm.rst
@@ -5,6 +5,53 @@
 PCI Trusted Execution Environment Security Manager (TSM)
 ========================================================
 
+Overview
+========
+
+A "TSM", as detailed by PCIe r7.0 section 11 "TEE Device Interface
+Security Protocol (TDISP)", is an entity within the platform's Trusted
+Computing Base (TCB) that enforces security policies on the host. It
+serves to mitigate a threat model where devices may be under the control
+of an adversary. The adversarial threats are:
+
+- Identity: Device may be mimicking a legitimate device identity / firmware
+- Physical: link may be under observation, or control (reorder / drop data)
+- Virtual: Device MMIO presented to a guest may not actually map the
+  device, device DMA may be redirected.
+
+Linux exposes a TSM class device and PCI sysfs attributes for the
+operations supported by its TSM driver. A host uses ``tsm/connect`` and
+``tsm/disconnect`` to request or release the TSM's connection to a device.
+A confidential guest uses ``tsm/lock`` and ``tsm/unlock`` to lock or unlock
+an assigned device's security-sensitive configuration.
+
+Successful connect or lock does not necessarily mean that userspace has
+verified the device or that it is ready for use. Userspace retrieves
+evidence through the attestation subsystem and verifies it before
+requesting device use through ``evidence-accept``.
+
+Device Interface LOCK
+=====================
+The lock operation facilitated by tsm/lock (see
+Documentation/ABI/testing/sysfs-bus-pci) places the device in a mode
+where any security sensitive changes to the device configuration results
+in the device transitioning to the ERROR state. Userspace retrieves
+evidence about the locked configuration through the attestation subsystem
+and verifies it before requesting device use.
+The relying party is responsible for verifying not only the evidence but
+that the device is trusted to maintain those attested values while
+locked. Accepting the locked configuration also asserts that device is
+trusted to cease TCB interactions (send T=1 DMA / accept T=1 MMIO TLPs)
+when it is subsequently unlocked. The TSM is responsible for enforcing
+that the device is not unlocked within the interval between evidence
+collection and acceptance, by correlating the evidence from LOCK to the
+subsequent RUN request.
+
+While the PCIe specification allows for the device to operate outside
+the TCB when locked, depending on the TSM architecture implementation,
+T=0 DMA from the device may be blocked until the device is next
+unlocked.
+
 Subsystem Interfaces
 ====================
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 0c7408509ba2..f7b7a6e269a2 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -126,6 +126,8 @@ config PCI_IDE
 
 config PCI_TSM
 	bool "PCI TSM: Device security protocol support"
+	depends on ARCH_HAS_CC_PLATFORM
+	select CONFIDENTIAL_DEVICES
 	select PCI_IDE
 	select PCI_DOE
 	select TSM
diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index f04498265383..2fbd146db387 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -9,6 +9,7 @@
 #define dev_fmt(fmt) "PCI/TSM: " fmt
 
 #include <linux/bitfield.h>
+#include <linux/ioport.h>
 #include <linux/iommufd.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
@@ -88,6 +89,25 @@ static struct pci_tsm_pf0 *to_pci_tsm_pf0(struct pci_tsm *tsm)
 	return container_of(pf0->tsm, struct pci_tsm_pf0, base_tsm);
 }
 
+static inline bool is_devsec(struct pci_dev *pdev)
+{
+	return pdev->tsm && pdev->tsm->dsm_dev == NULL;
+}
+
+/* 'struct pci_tsm_devsec' wraps 'struct pci_tsm' when ->dsm_dev == NULL */
+struct pci_tsm_devsec *to_pci_tsm_devsec(struct pci_tsm *tsm)
+{
+	struct pci_dev *pdev = tsm->pdev;
+
+	if (!is_devsec(pdev) || !has_tee(pdev)) {
+		pci_WARN_ONCE(pdev, 1, "invalid context object\n");
+		return NULL;
+	}
+
+	return container_of(tsm, struct pci_tsm_devsec, base_tsm);
+}
+EXPORT_SYMBOL_GPL(to_pci_tsm_devsec);
+
 static void tsm_remove(struct pci_tsm *tsm)
 {
 	struct pci_dev *pdev;
@@ -630,6 +650,128 @@ static ssize_t dsm_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(dsm);
 
+/**
+ * pci_tsm_unlock() - Transition TDI from LOCKED/RUN to UNLOCKED
+ * @pdev: TDI device to unlock
+ *
+ * Returns void, requires all callers to have satisfied dependencies like making
+ * sure the device is locked and detached from its driver.
+ */
+static void pci_tsm_unlock(struct pci_dev *pdev)
+{
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+	device_lock_assert(&pdev->dev);
+
+	if (dev_WARN_ONCE(&pdev->dev, pdev->dev.driver,
+			  "unlock attempted on driver attached device\n"))
+		return;
+
+	device_cc_reject(&pdev->dev);
+	to_pci_tsm_ops(pdev->tsm)->unlock(pdev->tsm);
+	pdev->tsm = NULL;
+}
+
+static int pci_tsm_lock(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
+{
+	const struct pci_tsm_ops *ops = tsm_dev->pci_ops;
+	struct pci_tsm *tsm;
+
+	device_lock_assert(&pdev->dev);
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+
+	if (pdev->dev.driver)
+		return -EBUSY;
+
+	tsm = ops->lock(tsm_dev, pdev);
+	if (IS_ERR(tsm))
+		return PTR_ERR(tsm);
+
+	pdev->tsm = tsm;
+	return 0;
+}
+
+static ssize_t lock_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int rc, id;
+
+	rc = sscanf(buf, "tsm%d\n", &id);
+	if (rc != 1)
+		return -EINVAL;
+
+	ACQUIRE(device_intr, dev_lock)(&pdev->dev);
+	if ((rc = ACQUIRE_ERR(device_intr, &dev_lock)))
+		return rc;
+
+	ACQUIRE(rwsem_write_kill, lock)(&pci_tsm_rwsem);
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &lock)))
+		return rc;
+
+	if (pdev->tsm)
+		return -EBUSY;
+
+	struct tsm_dev *tsm_dev __free(put_tsm_dev) = find_tsm_dev(id);
+	if (!is_devsec_tsm(tsm_dev))
+		return -ENXIO;
+
+	rc = pci_tsm_lock(pdev, tsm_dev);
+	if (rc)
+		return rc;
+
+	return len;
+}
+
+static ssize_t lock_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct tsm_dev *tsm_dev;
+	int rc;
+
+	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
+	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &lock)))
+		return rc;
+
+	if (!pdev->tsm)
+		return sysfs_emit(buf, "\n");
+
+	tsm_dev = pdev->tsm->tsm_dev;
+	return sysfs_emit(buf, "%s\n", dev_name(&tsm_dev->dev));
+}
+static DEVICE_ATTR_RW(lock);
+
+static ssize_t unlock_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct tsm_dev *tsm_dev;
+	int rc;
+
+	ACQUIRE(device_intr, dev_lock)(&pdev->dev);
+	if ((rc = ACQUIRE_ERR(device_intr, &dev_lock)))
+		return rc;
+
+	ACQUIRE(rwsem_write_kill, lock)(&pci_tsm_rwsem);
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &lock)))
+		return rc;
+
+	if (!pdev->tsm)
+		return -EINVAL;
+
+	tsm_dev = pdev->tsm->tsm_dev;
+	if (!sysfs_streq(buf, dev_name(&tsm_dev->dev)))
+		return -EINVAL;
+
+	if (pdev->dev.driver)
+		return -EBUSY;
+
+	pci_tsm_unlock(pdev);
+
+	return len;
+}
+static DEVICE_ATTR_WO(unlock);
+
 /* The 'authenticated' attribute is exclusive to the presence of a 'link' TSM */
 static bool pci_tsm_link_group_visible(struct kobject *kobj)
 {
@@ -655,6 +797,13 @@ static bool pci_tsm_link_group_visible(struct kobject *kobj)
 }
 DEFINE_SIMPLE_SYSFS_GROUP_VISIBLE(pci_tsm_link);
 
+static bool pci_tsm_devsec_group_visible(struct kobject *kobj)
+{
+	struct pci_dev *pdev = to_pci_dev(kobj_to_dev(kobj));
+
+	return pci_tsm_devsec_count && has_tee(pdev);
+}
+
 /*
  * 'link' and 'devsec' TSMs share the same 'tsm/' sysfs group, so the TSM type
  * specific attributes need individual visibility checks.
@@ -679,12 +828,19 @@ static umode_t pci_tsm_attr_visible(struct kobject *kobj,
 		}
 	}
 
+	if (pci_tsm_devsec_group_visible(kobj)) {
+		if (attr == &dev_attr_lock.attr ||
+		    attr == &dev_attr_unlock.attr)
+			return attr->mode;
+	}
+
 	return 0;
 }
 
 static bool pci_tsm_group_visible(struct kobject *kobj)
 {
-	return pci_tsm_link_group_visible(kobj);
+	return pci_tsm_link_group_visible(kobj) ||
+	       pci_tsm_devsec_group_visible(kobj);
 }
 DEFINE_SYSFS_GROUP_VISIBLE(pci_tsm);
 
@@ -692,6 +848,8 @@ static struct attribute *pci_tsm_attrs[] = {
 	&dev_attr_connect.attr,
 	&dev_attr_disconnect.attr,
 	&dev_attr_dsm.attr,
+	&dev_attr_lock.attr,
+	&dev_attr_unlock.attr,
 	NULL
 };
 
@@ -804,6 +962,28 @@ int pci_tsm_link_constructor(struct pci_dev *pdev, struct pci_tsm *tsm,
 }
 EXPORT_SYMBOL_GPL(pci_tsm_link_constructor);
 
+/**
+ * pci_tsm_devsec_constructor() - devsec TSM context initialization
+ * @pdev: The PCI device
+ * @devsec: Device-security state to initialize
+ * @tsm_dev: Platform TEE Security Manager, initiator of security operations
+ */
+int pci_tsm_devsec_constructor(struct pci_dev *pdev, struct pci_tsm_devsec *devsec,
+			       struct tsm_dev *tsm_dev)
+{
+	struct pci_tsm *pci_tsm = &devsec->base_tsm;
+
+	if (!is_devsec_tsm(tsm_dev))
+		return -EINVAL;
+
+	pci_tsm->dsm_dev = NULL;
+	pci_tsm->pdev = pdev;
+	pci_tsm->tsm_dev = tsm_dev;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_tsm_devsec_constructor);
+
 /**
  * pci_tsm_pf0_constructor() - common 'struct pci_tsm_pf0' (DSM) initialization
  * @pdev: Physical Function 0 PCI device (as indicated by is_pci_tsm_pf0())
@@ -837,6 +1017,13 @@ void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *pf0)
 }
 EXPORT_SYMBOL_GPL(pci_tsm_pf0_destructor);
 
+static void devsec_sysfs_enable(struct pci_dev *pdev)
+{
+	pci_dbg(pdev, "TEE I/O Device capability detected (TDISP)\n");
+
+	sysfs_update_group(&pdev->dev.kobj, &pci_tsm_attr_group);
+}
+
 int pci_tsm_register(struct tsm_dev *tsm_dev)
 {
 	struct pci_dev *pdev = NULL;
@@ -858,8 +1045,10 @@ int pci_tsm_register(struct tsm_dev *tsm_dev)
 		for_each_pci_dev(pdev)
 			if (is_pci_tsm_pf0(pdev))
 				link_sysfs_enable(pdev);
-	} else if (is_devsec_tsm(tsm_dev)) {
-		pci_tsm_devsec_count++;
+	} else if (is_devsec_tsm(tsm_dev) && pci_tsm_devsec_count++ == 0) {
+		for_each_pci_dev(pdev)
+			if (has_tee(pdev))
+				devsec_sysfs_enable(pdev);
 	}
 
 	return 0;
@@ -888,6 +1077,9 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev) && !pci_tsm_link_count)
 		link_sysfs_disable(pdev);
 
+	if (is_devsec_tsm(tsm_dev) && !pci_tsm_devsec_count)
+		sysfs_update_group(&pdev->dev.kobj, &pci_tsm_attr_group);
+
 	/* Nothing else to do if this device never attached to the departing TSM */
 	if (!tsm)
 		return;
@@ -898,11 +1090,19 @@ static void __pci_tsm_destroy(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
 	else if (tsm_dev != tsm->tsm_dev)
 		return;
 
-	if (is_link_tsm(tsm_dev) && is_pci_tsm_pf0(pdev)) {
-		if (pci_tsm_disconnect(pdev))
-			pci_warn(pdev, "TSM connection is still in use\n");
-	} else {
-		tsm_remove(pdev->tsm);
+	/* Disconnect DSMs, unlock assigned TDIs, or clean up subfunctions. */
+	if (is_link_tsm(tsm_dev)) {
+		if (is_pci_tsm_pf0(pdev)) {
+			if (pci_tsm_disconnect(pdev))
+				pci_warn(pdev, "TSM connection is still in use\n");
+		} else {
+			tsm_remove(pdev->tsm);
+		}
+	}
+
+	if (is_devsec_tsm(tsm_dev) && has_tee(pdev)) {
+		device_lock_assert(&pdev->dev);
+		pci_tsm_unlock(pdev);
 	}
 }
 
@@ -926,7 +1126,17 @@ void pci_tsm_destroy(struct pci_dev *pdev)
 	struct tsm_dev *tsm_dev = NULL;
 	bool registration_locked = false;
 
-	down_write(&pci_tsm_rwsem);
+	/* Guest cleanup takes the device mutex before the PCI/TSM writer. */
+	scoped_guard(device, &pdev->dev) {
+		down_write(&pci_tsm_rwsem);
+		if (pdev->tsm && is_devsec_tsm(pdev->tsm->tsm_dev)) {
+			__pci_tsm_destroy(pdev, NULL);
+			up_write(&pci_tsm_rwsem);
+			return;
+		}
+	}
+
+	/* Host cleanup must not retain the device mutex while waiting for users. */
 	if (pdev->tsm && is_link_tsm(pdev->tsm->tsm_dev) &&
 	    is_pci_tsm_pf0(pdev)) {
 		struct pci_tsm_pf0 *pf0 = to_pci_tsm_pf0(pdev->tsm);
@@ -1082,11 +1292,22 @@ void pci_tsm_unregister(struct tsm_dev *tsm_dev)
 {
 	struct pci_dev *pdev = NULL;
 
+	if (is_devsec_tsm(tsm_dev)) {
+		scoped_guard(rwsem_write, &pci_tsm_rwsem)
+			pci_tsm_devsec_count--;
+
+		for_each_pci_dev_reverse(pdev) {
+			guard(device)(&pdev->dev);
+			guard(rwsem_write)(&pci_tsm_rwsem);
+
+			__pci_tsm_destroy(pdev, tsm_dev);
+		}
+
+		return;
+	}
+
 	guard(rwsem_write)(&pci_tsm_rwsem);
-	if (is_link_tsm(tsm_dev))
-		pci_tsm_link_count--;
-	if (is_devsec_tsm(tsm_dev))
-		pci_tsm_devsec_count--;
+	pci_tsm_link_count--;
 	for_each_pci_dev_reverse(pdev)
 		__pci_tsm_destroy(pdev, tsm_dev);
 }
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index ba9183783dd1..b7a0e85bbad7 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -10,10 +10,11 @@
 #include <linux/cleanup.h>
 #include <linux/jiffies.h>
 #include <linux/pci-tsm.h>
-#include <linux/pci-ide.h>
 #include <linux/pid.h>
 #include <linux/sched.h>
 
+#include <linux/pci-ide.h>
+
 /* The caller must hold a tsm_get_device() reference for the entire use. */
 const struct iommufd_viommu_ops *tsm_viommu_get_ops(struct tsm_dev *tsm_dev,
 		struct device *dev, enum iommu_viommu_type type)
@@ -25,10 +26,53 @@ const struct iommufd_viommu_ops *tsm_viommu_get_ops(struct tsm_dev *tsm_dev,
 }
 EXPORT_SYMBOL_GPL(tsm_viommu_get_ops);
 
+static ssize_t pci_mode_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct tsm_dev *tsm_dev = container_of(dev, struct tsm_dev, dev);
+	const struct pci_tsm_ops *ops = tsm_dev->pci_ops;
+
+	if (ops->connect)
+		return sysfs_emit(buf, "link\n");
+
+	if (ops->lock)
+		return sysfs_emit(buf, "devsec\n");
+
+	return sysfs_emit(buf, "none\n");
+}
+static DEVICE_ATTR_RO(pci_mode);
+
+static umode_t tsm_pci_visible(struct kobject *kobj, struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct tsm_dev *tsm_dev = container_of(dev, struct tsm_dev, dev);
+
+	if (tsm_dev->pci_ops)
+		return attr->mode;
+
+	return 0;
+}
+
+static struct attribute *tsm_pci_attrs[] = {
+	&dev_attr_pci_mode.attr,
+	NULL
+};
+
+static const struct attribute_group tsm_pci_group = {
+	.attrs = tsm_pci_attrs,
+	.is_visible = tsm_pci_visible,
+};
+
+static const struct attribute_group *tsm_pci_groups[] = {
+	&tsm_pci_group,
+	NULL
+};
+
 static void tsm_release(struct device *);
 static const struct class tsm_class = {
 	.name		= "tsm",
-	.dev_release	= tsm_release
+	.dev_release	= tsm_release,
+	.dev_groups	= tsm_pci_groups,
 };
 static DEFINE_IDA(tsm_ida);
 
diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 75df64a2e97d..c43aa3e85bb0 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -78,7 +78,8 @@ struct pci_tsm_ops {
 	 * @unlock: destroy TSM context and return device to UNLOCKED state
 	 *
 	 * Context: @lock and @unlock run under pci_tsm_rwsem held for write to
-	 * sync with TSM unregistration and each other
+	 * sync with TSM unregistration and each other. All operations run under
+	 * the device lock for mutual exclusion with driver attach and detach.
 	 */
 	struct_group_tagged(pci_tsm_devsec_ops, devsec_ops,
 		struct pci_tsm *(*lock)(struct tsm_dev *tsm_dev,
@@ -103,6 +104,13 @@ struct pci_tsm_ops {
  * sub-function (SR-IOV virtual function, or non-function0
  * multifunction-device), or a downstream endpoint (PCIe upstream switch-port as
  * DSM).
+ *
+ * For devsec operations it serves to indicate that the function / TDI has been
+ * locked to a given TSM.
+ *
+ * The common expectation is that there is only ever one TSM, but this is not
+ * enforced. The implementation only enforces that a device can be "connected"
+ * to a TSM instance or "locked" to a different TSM.
  */
 struct pci_tsm {
 	struct pci_dev *pdev;
@@ -131,6 +139,14 @@ struct pci_tsm_pf0 {
 	struct pci_doe_mb *doe_mb;
 };
 
+/**
+ * struct pci_tsm_devsec - context for tracking private/accepted PCI resources
+ * @base_tsm: generic core "tsm" context
+ */
+struct pci_tsm_devsec {
+	struct pci_tsm base_tsm;
+};
+
 /* physical function0 and capable of 'connect' */
 static inline bool is_pci_tsm_pf0(struct pci_dev *pdev)
 {
@@ -175,6 +191,8 @@ int pci_tsm_link_constructor(struct pci_dev *pdev, struct pci_tsm *tsm,
 			     struct tsm_dev *tsm_dev);
 int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *pf0,
 			    struct tsm_dev *tsm_dev);
+int pci_tsm_devsec_constructor(struct pci_dev *pdev, struct pci_tsm_devsec *devsec,
+			       struct tsm_dev *tsm_dev);
 void pci_tsm_pf0_destructor(struct pci_tsm_pf0 *pf0);
 int pci_tsm_doe_transfer(struct pci_dev *pdev, u8 type, const void *req,
 			 size_t req_sz, void *resp, size_t resp_sz);
@@ -187,6 +205,7 @@ struct pci_dev *pci_tsm_context_dsm_dev(struct pci_tsm_context *context);
 bool pci_tsm_context_match_device(struct pci_tsm_context *context,
 				  struct pci_dev *pdev);
 struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev);
+struct pci_tsm_devsec *to_pci_tsm_devsec(struct pci_tsm *tsm);
 #else
 static inline struct pci_tsm *pci_tsm_trylock_association(struct pci_tsm *tsm)
 {
-- 
2.43.0

