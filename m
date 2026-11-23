Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422872;
	b=kpg57WoG1jFV9liU87akoJzlPFPDkDQUtCG8euNIji+ER5KWQRLZnt2jQcVABGBPaczF
	 SOfLVPuc5TQDU51IqtpBBaDpRBsImzzB+JlVqG6jAoh1dsTG9iZS4NSxIOLlf0qklmHRY
	 2Anz4sg0Jdho3aX18u2X6g6OePF7FgmtufYEyUk0J560csDs13qBpNHKwNpdKHz+sZmWE
	 Gsj1vc+hl6hHllkQ0se6IcrC+TD2S/lWVe2blQ9mPVIucXfB7rNjgH9Ew9WgtoZi05mUc
	 BuGYndZ0VoJQqzYQfIfyXscgGcf+J5w9feMADA2VL09/ouV0Y8rUsMG7PBwPUBrxL0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/3FVCNFSODmk6JlCNvbBuVbU+xDkYYseTCLLRPcL+FA=;
	b=fB2yzoLe7dHHGYJkM4nZ7NaLjxHBy49VBxhGNrEkJ5eG73q2DMizni59gtxPfUbGNIt1
	 fVYcQNTN40Y7fe3NIAL1cj1gyDyvsj7tAIoGxSMCahqMFMe+W3nXCMr6hlonvcko27bVK
	 oxQ0i4yotYCUb6sIlrEUq3QWR4uhaUChxdY1309kzuZ3h0p7ddtbdAR7y8FPqgjAaj3JV
	 bvizx9uZU4D9eVvFvEnALcnbnZ1LkmEVlZ3TYy877VfMZcxMSkneeWchgVgydOE1gxgoO
	 QCFcxKYHi8TqRJkEKoDSbCXsS6q/Iyj+mC6Nav0r+7YAiRxPL9FIDsZgd7ulB34ldUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jrqfwlll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3B0606A31F;
	Mon, 23 Nov 2026 08:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jrqfwlll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307C61F000EC;
	Mon, 23 Nov 2026 08:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422871;
	bh=/3FVCNFSODmk6JlCNvbBuVbU+xDkYYseTCLLRPcL+FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrqfwlllhPwyVyXY7O/iublZDfU1leSYq4DxrGGIlRte9UPtloGMsqae4Q/CUUUcT
	 trlV0rnhfnTUeh6LbokURL0LLemfqHyq1gZzbR3/m5i7/8kLqAMaEosP2xYsSoaol+
	 0jroRASzrzGR59OZhMDjd65ECau+QLzltWY56DabMbzurFeJkGTPGHMnBkQLwuPHVa
	 fzaYNHo36YwgPegSXTiYUiArkQ9dRZD0Eg1ALOcmrziskDFIJEuoV22gIRRWSC6Gs0
	 QE+HY/+gNAImrSZlUlp8S2Xui2/sgnushw7DIPxKUVfbXt883ZBE82mzDhPF70uFAV
	 +RIQlmKo67t4g==
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
Subject: [PATCH v1 07/10] device core: Add helpers to record confidential device acceptance
Date: Mon, 23 Nov 2026 14:03:34 +0530
Message-ID: <20261123083337.2731019-8-aneesh.kumar@kernel.org>
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

Add a flag to record whether a device is accepted for private memory
access, with helpers to set, clear and read it. Setting or clearing the
flag requires device::mutex and fails with -EBUSY if a driver is
attached.

Follow-up patches will have TSM drivers mark devices accepted after
verification and setup. PCI DMA setup will check this state before
allowing the device to access private memory.

Based on the original patch from Dan Williams <djbw@kernel.org>.
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 MAINTAINERS            |  1 +
 drivers/base/Kconfig   |  4 +++
 drivers/base/Makefile  |  1 +
 drivers/base/base.h    |  9 ++++++
 drivers/base/coco.c    | 68 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h | 22 ++++++++++++++
 6 files changed, 105 insertions(+)
 create mode 100644 drivers/base/coco.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a3ee234d79ae..142ba5af8798 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28553,6 +28553,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tsm/linux.git
 F:	Documentation/ABI/testing/configfs-tsm-report
 F:	Documentation/driver-api/coco/
 F:	Documentation/driver-api/pci/tsm.rst
+F:	drivers/base/coco.c
 F:	drivers/pci/tsm.c
 F:	drivers/virt/coco/guest/
 F:	drivers/virt/coco/tsm-core.c
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index a9acf4575f4f..be8d1484f210 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -242,4 +242,8 @@ config FW_DEVLINK_SYNC_STATE_TIMEOUT
 	  command line option on every system/board your kernel is expected to
 	  work on.
 
+config CONFIDENTIAL_DEVICES
+	depends on ARCH_HAS_CC_PLATFORM
+	bool
+
 endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 435710f643a5..8f5725e3e670 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_DEV_COREDUMP) += devcoredump.o
 obj-$(CONFIG_GENERIC_MSI_IRQ) += platform-msi.o
 obj-$(CONFIG_GENERIC_ARCH_TOPOLOGY) += arch_topology.o
 obj-$(CONFIG_ACPI) += physical_location.o
+obj-$(CONFIG_CONFIDENTIAL_DEVICES) += coco.o
 
 obj-y			+= test/
 
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 866b2beb6baa..97a9fcb10c97 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -108,8 +108,13 @@ struct driver_private {
  * @dead: This device is currently either in the process of or has been
  *	  removed from the system. Any asynchronous events scheduled for this
  *	  device should exit without taking any action.
+ * @cc_accepted: Device accepted for private memory access. Bus code checks
+ *		 this state before enabling DMA during driver attachment.
  *
  * Nothing outside of the driver core should ever touch these fields.
+ *
+ * All bitfield flags are manipulated under device_lock() to avoid
+ * read-modify-write collisions.
  */
 struct device_private {
 	struct klist klist_children;
@@ -122,6 +127,10 @@ struct device_private {
 	char *deferred_probe_reason;
 	struct device *device;
 	u8 dead:1;
+#ifdef CONFIG_CONFIDENTIAL_DEVICES
+	u8 cc_accepted:1;
+#endif
+
 };
 #define to_device_private_parent(obj)	\
 	container_of(obj, struct device_private, knode_parent)
diff --git a/drivers/base/coco.c b/drivers/base/coco.c
new file mode 100644
index 000000000000..3e00bb37556e
--- /dev/null
+++ b/drivers/base/coco.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2026 Intel Corporation */
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/lockdep.h>
+#include "base.h"
+
+/*
+ * The device_cc_*() helpers record whether a device has been accepted for
+ * private memory access. Recording acceptance does not enable DMA. Bus code
+ * can check this state before enabling DMA during driver attachment.
+ */
+
+/**
+ * device_cc_accept() - Record acceptance for private memory access
+ * @dev: device to accept
+ *
+ * Call after the required verification and device setup have succeeded.
+ * This helper only records acceptance; it does not enable DMA.
+ *
+ * Context: The caller must hold dev->mutex. No driver may be attached.
+ * Return: 0 on success, or -EBUSY if a driver is attached.
+ */
+int device_cc_accept(struct device *dev)
+{
+	lockdep_assert_held(&dev->mutex);
+
+	if (dev->driver)
+		return -EBUSY;
+
+	dev->p->cc_accepted = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(device_cc_accept);
+
+/**
+ * device_cc_reject() - Clear acceptance for private memory access
+ * @dev: device whose acceptance state is cleared
+ *
+ * This helper only clears the recorded state; it does not disable DMA.
+ *
+ * Context: The caller must hold dev->mutex. No driver may be attached.
+ * Return: 0 on success, or -EBUSY if a driver is attached.
+ */
+int device_cc_reject(struct device *dev)
+{
+	lockdep_assert_held(&dev->mutex);
+
+	if (dev->driver)
+		return -EBUSY;
+
+	dev->p->cc_accepted = 0;
+
+	return 0;
+}
+
+/**
+ * device_cc_accepted() - Read the recorded acceptance state
+ * @dev: device to check
+ *
+ * Context: The caller must hold dev->mutex to serialize with state changes.
+ * Return: true if the device is accepted for private memory access.
+ */
+bool device_cc_accepted(struct device *dev)
+{
+	return dev->p->cc_accepted;
+}
diff --git a/include/linux/device.h b/include/linux/device.h
index 429e39f647cf..cf872935adae 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1396,6 +1396,28 @@ static inline bool device_link_test(const struct device_link *link, u32 flags)
 	return !!(link->flags & flags);
 }
 
+/* Confidential Device state helpers */
+#ifdef CONFIG_CONFIDENTIAL_DEVICES
+int device_cc_accept(struct device *dev);
+int device_cc_reject(struct device *dev);
+bool device_cc_accepted(struct device *dev);
+#else
+static inline int device_cc_accept(struct device *dev)
+{
+	lockdep_assert_held(&dev->mutex);
+	return 0;
+}
+static inline int device_cc_reject(struct device *dev)
+{
+	lockdep_assert_held(&dev->mutex);
+	return 0;
+}
+static inline bool device_cc_accepted(struct device *dev)
+{
+	return false;
+}
+#endif /* CONFIG_CONFIDENTIAL_DEVICES */
+
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
2.43.0

