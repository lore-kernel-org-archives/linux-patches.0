Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422834;
	b=e0nJE6q7ETvA+8FJSPYSKtFa3Ks9jOFtA0V4421qo1EgKVdOeRLx+z6UZSMs+DjTTTDd
	 oc1JcdmuFQx8tb+BzPSFozmE4wj0etR6p9i5/H+ywXM5JMPy7kP3avzKzIHnIdA6bI7i2
	 WADpluCavJn0lb0TRB3BbAp7uc1IWjNO1Ybqa7R3s8B3sEVr3Ly/wVWWvfCsvgBGuIfDS
	 w//G4XAqSYxPgruXrP5DnVVj3jjRAf6B739rJciyk7l9LvCArOiJlBp+0wTqX2lZkr37E
	 Yu8gWeXFx5PvbCmNB1AR2OwajxqfUBl0XMPWyIjI4ALqdsR5qOlriACmKDcW/CaFvZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=O0scTIKxAQUJYWe12ImmOtEeVbN1lJEAM+Vm8C0+Gjw=;
	b=dfVwhHBdATHKtjYYRlJrWpau/pZITm0nf32cs0aZt2IaqbTGzwXo2d8UTW9alOtTx+yA
	 1o+V5shyEXbIQ69Kh19zXoHO5pIxhGu4t3mjw4EbHj0Z16lqmr0n5q6zm49PI9jz1BE9b
	 L5XFzM7ArTl8Bifhe/jBk98UnGCoqwC/vDEILp2ZE+GgqvowknYHwf33Zdms8FGPJtPoM
	 5o2kV/p8Q5wRe7vj9qm+JlSnbN3MIFJ60ULoHqmcEfD/FgC0GBQYN4xm6n/LvB1g3AxAM
	 IZVSDTtnYt1A6w9vIY6p+0lnEOpl2HGT/Q+CtRD4MhO5g+G+4jAkvtEm97xEQlVSNYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HzGvO1W5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DF2606A332;
	Mon, 23 Nov 2026 08:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HzGvO1W5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D081F000C0;
	Mon, 23 Nov 2026 08:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422833;
	bh=O0scTIKxAQUJYWe12ImmOtEeVbN1lJEAM+Vm8C0+Gjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzGvO1W5Hr0QWfoJMo7mMUUWTS22omZix3u18nm4WPEwyYROWVwCjLoy2YfBR2+VY
	 AY4AqfrR7rD0v2IWCdj521N3DVArRSOA3iPTASbYu28PihhWzw1lPrmGUbSEZrMeTJ
	 ajvedFZ9JagcBF7LpspnviYh+8sFmRFM285YgqAkG80BmDWNVX8UeC6B27nGx1cpKx
	 sMEd/qsz3kAzl8clzqukvoWSYR6TLp53njRr1srj9tQCgU5cyK/kmnxtxrQCRJt1CF
	 8LAwv5SSDxd1YayObVX8JfEwv+x6nu/7pzPzdL8V3myrdK0oIi8yS3Wtq6IBmelRu+
	 OFhXVvjr25eng==
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
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v1 01/10] PCI/TSM: Report active IDE streams per host bridge
Date: Mon, 23 Nov 2026 14:03:28 +0530
Message-ID: <20261123083337.2731019-2-aneesh.kumar@kernel.org>
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

From: Dan Williams <dan.j.williams@intel.com>

The first attempt at an ABI for this failed to account for naming
collisions across host bridges:

Commit a4438f06b1db ("PCI/TSM: Report active IDE streams")

Revive this ABI with a per host bridge link that appears at first stream
creation for a given host bridge and disappears after the last stream is
removed.

For systems with many host bridge objects it allows:

    ls /sys/class/tsm/tsmN/pci*/stream*

...to find all the host bridges with active streams without first iterating
over all host bridges. Yilun notes that is handy to have this short cut [1]
and from an administrator perspective it helps with inventory for
constrained stream resources.

Link: http://lore.kernel.org/aXLtILY85oMU5qlb@yilunxu-OptiPlex-7050 [1]
Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-tsm | 13 ++++
 drivers/pci/ide.c                         |  4 +
 drivers/virt/coco/tsm-core.c              | 95 +++++++++++++++++++++++
 include/linux/pci-ide.h                   |  2 +
 include/linux/tsm.h                       |  4 +
 5 files changed, 118 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-tsm b/Documentation/ABI/testing/sysfs-class-tsm
index 2949468deaf7..1ddb8f357961 100644
--- a/Documentation/ABI/testing/sysfs-class-tsm
+++ b/Documentation/ABI/testing/sysfs-class-tsm
@@ -7,3 +7,16 @@ Description:
 		signals when the PCI layer is able to support establishment of
 		link encryption and other device-security features coordinated
 		through a platform tsm.
+
+What:		/sys/class/tsm/tsmN/pciDDDD:BB
+Contact:	linux-pci@vger.kernel.org
+Description:
+		(RO) When a PCIe host bridge has established a secure connection
+		via a TSM to an endpoint, this symlink appears. It facilitates a
+		TSM instance scoped view of PCIe Link Encryption and Secure
+		Session resource consumption across host bridges. The symlink
+		appears when a host bridge has 1 or more IDE streams established
+		with this TSM, and disappears when that number returns to 0. See
+		Documentation/ABI/testing/sysfs-devices-pci-host-bridge for the
+		description of the pciDDDD:BB/streamH.R.E symlink and the
+		pciDDDD:BB/available_secure_streams attribute.
diff --git a/drivers/pci/ide.c b/drivers/pci/ide.c
index beb67b8fb5c5..19f61f957fb4 100644
--- a/drivers/pci/ide.c
+++ b/drivers/pci/ide.c
@@ -11,6 +11,7 @@
 #include <linux/pci_regs.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
+#include <linux/tsm.h>
 
 #include "pci.h"
 
@@ -370,6 +371,9 @@ void pci_ide_stream_release(struct pci_ide *ide)
 	if (ide->partner[PCI_IDE_EP].enable)
 		pci_ide_stream_disable(pdev, ide);
 
+	if (ide->tsm_dev)
+		tsm_ide_stream_unregister(ide);
+
 	if (ide->partner[PCI_IDE_RP].setup)
 		pci_ide_stream_teardown(rp, ide);
 
diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 696c1abfece7..f07e68dcf6e1 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -4,11 +4,13 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/tsm.h>
+#include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/cleanup.h>
 #include <linux/jiffies.h>
 #include <linux/pci-tsm.h>
+#include <linux/pci-ide.h>
 #include <linux/pid.h>
 #include <linux/sched.h>
 
@@ -273,6 +275,98 @@ int tsm_unregister(struct tsm_dev *tsm_dev)
 }
 EXPORT_SYMBOL_GPL(tsm_unregister);
 
+static DEFINE_XARRAY(tsm_ide_streams);
+static DEFINE_MUTEX(tsm_ide_streams_lock);
+
+/* tracker for the bridge symlink when the bridge has any streams */
+struct tsm_ide_stream {
+	struct tsm_dev *tsm_dev;
+	struct pci_host_bridge *bridge;
+	struct kref kref;
+};
+
+static struct tsm_ide_stream *create_streams(struct tsm_dev *tsm_dev,
+					    struct pci_host_bridge *bridge)
+{
+	int rc;
+
+	struct tsm_ide_stream *streams __free(kfree) = kzalloc_obj(*streams);
+	if (!streams)
+		return NULL;
+
+	streams->tsm_dev = tsm_dev;
+	streams->bridge = bridge;
+	kref_init(&streams->kref);
+	rc = xa_insert(&tsm_ide_streams, (unsigned long)bridge, streams,
+		       GFP_KERNEL);
+	if (rc)
+		return NULL;
+
+	rc = sysfs_create_link(&tsm_dev->dev.kobj, &bridge->dev.kobj,
+			       dev_name(&bridge->dev));
+	if (rc) {
+		xa_erase(&tsm_ide_streams, (unsigned long)bridge);
+		return NULL;
+	}
+
+	return no_free_ptr(streams);
+}
+
+int tsm_ide_stream_register(struct pci_ide *ide, struct tsm_dev *tsm_dev)
+{
+	struct tsm_ide_stream *streams;
+	struct pci_dev *pdev = ide->pdev;
+	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
+
+	guard(mutex)(&tsm_ide_streams_lock);
+	streams = xa_load(&tsm_ide_streams, (unsigned long)bridge);
+	if (streams)
+		kref_get(&streams->kref);
+	else
+		streams = create_streams(tsm_dev, bridge);
+
+	if (!streams)
+		return -ENOMEM;
+
+	ide->tsm_dev = tsm_dev;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tsm_ide_stream_register);
+
+static void destroy_streams(struct kref *kref)
+{
+	struct tsm_ide_stream *streams =
+		container_of(kref, struct tsm_ide_stream, kref);
+	struct tsm_dev *tsm_dev = streams->tsm_dev;
+	struct pci_host_bridge *bridge = streams->bridge;
+
+	lockdep_assert_held(&tsm_ide_streams_lock);
+	sysfs_remove_link(&tsm_dev->dev.kobj, dev_name(&bridge->dev));
+	xa_erase(&tsm_ide_streams, (unsigned long)bridge);
+	kfree(streams);
+}
+
+void tsm_ide_stream_unregister(struct pci_ide *ide)
+{
+	struct tsm_ide_stream *streams;
+	struct tsm_dev *tsm_dev = ide->tsm_dev;
+	struct pci_dev *pdev = ide->pdev;
+	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
+
+	guard(mutex)(&tsm_ide_streams_lock);
+	streams = xa_load(&tsm_ide_streams, (unsigned long)bridge);
+	/* catch API abuse */
+	if (dev_WARN_ONCE(&tsm_dev->dev,
+			  !streams || streams->tsm_dev != tsm_dev,
+			  "no IDE streams associated with %s\n",
+			  dev_name(&bridge->dev)))
+		return;
+	kref_put(&streams->kref, destroy_streams);
+	ide->tsm_dev = NULL;
+}
+EXPORT_SYMBOL_GPL(tsm_ide_stream_unregister);
+
 static void tsm_release(struct device *dev)
 {
 	struct tsm_dev *tsm_dev = container_of(dev, typeof(*tsm_dev), dev);
@@ -290,6 +384,7 @@ module_init(tsm_init)
 static void __exit tsm_exit(void)
 {
 	class_unregister(&tsm_class);
+	xa_destroy(&tsm_ide_streams);
 }
 module_exit(tsm_exit)
 
diff --git a/include/linux/pci-ide.h b/include/linux/pci-ide.h
index ae07d9f699c0..381a1bf22a95 100644
--- a/include/linux/pci-ide.h
+++ b/include/linux/pci-ide.h
@@ -82,6 +82,7 @@ struct pci_ide_regs {
  * @host_bridge_stream: allocated from host bridge @ide_stream_ida pool
  * @stream_id: unique Stream ID (within Partner Port pairing)
  * @name: name of the established Selective IDE Stream in sysfs
+ * @tsm_dev: For TSM established IDE, the TSM device context
  *
  * Negative @stream_id values indicate "uninitialized" on the
  * expectation that with TSM established IDE the TSM owns the stream_id
@@ -93,6 +94,7 @@ struct pci_ide {
 	u8 host_bridge_stream;
 	int stream_id;
 	const char *name;
+	struct tsm_dev *tsm_dev;
 };
 
 /*
diff --git a/include/linux/tsm.h b/include/linux/tsm.h
index 0996b888df21..866a71478d3c 100644
--- a/include/linux/tsm.h
+++ b/include/linux/tsm.h
@@ -162,4 +162,8 @@ tsm_viommu_get_ops(struct tsm_dev *tsm_dev, struct device *dev,
 	return NULL;
 }
 #endif
+
+struct pci_ide;
+int tsm_ide_stream_register(struct pci_ide *ide, struct tsm_dev *tsm_dev);
+void tsm_ide_stream_unregister(struct pci_ide *ide);
 #endif /* __TSM_H */
-- 
2.43.0

