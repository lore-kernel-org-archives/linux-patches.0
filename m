Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618751;
	b=MRL8frr+LEXk7YY1eoMHYzkiMOd0FNXZVvubqOhm1udYBRdsW8lLfkoFB0F+C2rzG/67
	 bWXdUGWAY5k6dJ6CrKBtQDWaMTMYH9HNKEjMMFapRQNxjua7dqOxeiRv3GCSdaHkYRD00
	 3sQhYS/bjsjLxm56PtzKJvIeAEjMael3TUr9a/W9/LeoCxTRm8SqQT1ylEVkjBwDFC1iC
	 v9QtYG+rYALeVqyQkJ4M37/yumJMDokTS7pRf7M7gGadgSv4iZY5NaJ0whxaYuHIhahHk
	 xG0QozR+c/FzcPSuwRza9tTjPfrGqPmOXL66mYlUEqmFtGSk8tmRTSivjWbH1nxRq0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lgd6+yASXKca6IQHXIhQtLezwySnejC6NRaSyMcs3TU=;
	b=Y8OJlHr20nefQxiFw6nF6Z90eNjLcSL2GWV6R/U+soYNS8GTr/SdVY3ikpYdSZnB0O8n
	 PkFz0SK8ud7RhLx97SeT+N0z07wUMNpRtQbGIwK8aQ22gMs8Lc6q0wL4gjRoq/kj5j8/C
	 zsanG+ObTXghECMOYX20S+2v7FA0UV/r/O9LX/uQXIAJu4NgrxW4xdSkfGsS2s8DwBr10
	 fNmMrWM7okqFZty9pPWYBHp7rhXGWZlCP5bUk1sgDFtl1U/VGauo0dLKqI9FFSzsjfIHo
	 oww0xZBIgsGR+z5frhbkpaw2L+JyRctHnveFejSj0tFYLlaZL603JYwiXW0g2wBA2pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=byuDCLEo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845CF606A31E;
	Wed, 25 Nov 2026 14:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=byuDCLEo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A571F000D4;
	Wed, 25 Nov 2026 14:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618751;
	bh=lgd6+yASXKca6IQHXIhQtLezwySnejC6NRaSyMcs3TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=byuDCLEon6z3nGKmKlMSJN8ixE7LZGW2ocPLd2karrOYzcithk9ddHPo934vCuwxH
	 t6CSrCYWvdkPoDUYcoFKRfoe/o5x9jzOSi/WEhMS+PXm6HOslYICAiiMeLvUEfyfpi
	 HjiNj1Ftwsmr5t8vWas31ghoBRYwliJbfCqp6vQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badal Nilawar <badal.nilawar@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0378/1005] drm/xe/cri: Expose device UID through sysfs
Date: Wed, 25 Nov 2026 15:28:36 +0100
Message-ID: <20261125143830.593640682@linuxfoundation.org>
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

From: Badal Nilawar <badal.nilawar@intel.com>

[ Upstream commit 0acb5de8d7a9aec9419f316ef06b937dde285685 ]

Expose a read-only sysfs attribute, device_uid, that reports the
GPU SoC's unique identifier.

Bspec: 53048, 53049
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Badal Nilawar <badal.nilawar@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260929171823.3811737-2-badal.nilawar@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 7539edbca32d ("drm/xe/pat: Return error from xe_pat_init_early() on unknown platform")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/sysfs-driver-intel-xe-gpu     | 10 ++++++
 drivers/gpu/drm/xe/regs/xe_regs.h             |  2 ++
 drivers/gpu/drm/xe/xe_device.c                |  9 +++++
 drivers/gpu/drm/xe/xe_device_sysfs.c          | 36 +++++++++++++++++++
 drivers/gpu/drm/xe/xe_device_types.h          |  5 +++
 drivers/gpu/drm/xe/xe_pci.c                   |  2 ++
 drivers/gpu/drm/xe/xe_pci_types.h             |  1 +
 7 files changed, 65 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-intel-xe-gpu

diff --git a/Documentation/ABI/testing/sysfs-driver-intel-xe-gpu b/Documentation/ABI/testing/sysfs-driver-intel-xe-gpu
new file mode 100644
index 0000000000000..4dc4afc3961d9
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-intel-xe-gpu
@@ -0,0 +1,10 @@
+What:		/sys/bus/pci/drivers/xe/.../device_uid
+Date:		October 2026
+KernelVersion:	7.4
+Contact:	intel-xe@lists.freedesktop.org
+Description:
+		RO. Unique 64-bit identifier of the GPU SoC device, exposed as
+		hexadecimal value.
+
+		This sysfs file is present only on supported Intel Xe platforms.
+		Accessible only to users with administrative privileges.
diff --git a/drivers/gpu/drm/xe/regs/xe_regs.h b/drivers/gpu/drm/xe/regs/xe_regs.h
index ef4746b7b5d34..437485b5a0af9 100644
--- a/drivers/gpu/drm/xe/regs/xe_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_regs.h
@@ -30,6 +30,8 @@
 #define XEHP_MTCFG_ADDR				XE_REG(0x101800)
 #define   TILE_COUNT				REG_GENMASK(15, 8)
 
+#define CRI_DEVICE_UID				XE_REG(0x102008)
+
 #define GGC					XE_REG(0x108040)
 #define   GMS_MASK				REG_GENMASK(15, 8)
 #define   GGMS_MASK				REG_GENMASK(7, 6)
diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index ee732e5495f7d..6dc02ec55b902 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -742,6 +742,7 @@ static void vf_update_device_info(struct xe_device *xe)
 	xe->info.skip_guc_pc = 1;
 	xe->info.skip_pcode = 1;
 	xe->info.has_drm_ras = false;
+	xe->info.has_device_uid = false;
 }
 
 static int xe_device_vram_alloc(struct xe_device *xe)
@@ -942,6 +943,12 @@ static int xe_debug_page_size_alloc_ctrl_init(struct xe_device *xe)
 }
 #endif
 
+static void xe_uid_probe(struct xe_device *xe)
+{
+	if (xe->info.has_device_uid)
+		xe->device_uid = xe_mmio_read64_2x32(xe_root_tile_mmio(xe), CRI_DEVICE_UID);
+}
+
 int xe_device_probe(struct xe_device *xe)
 {
 	struct xe_tile *tile;
@@ -949,6 +956,8 @@ int xe_device_probe(struct xe_device *xe)
 	int err;
 	u8 id;
 
+	xe_uid_probe(xe);
+
 	xe_pat_init_early(xe);
 
 	err = xe_sriov_init(xe);
diff --git a/drivers/gpu/drm/xe/xe_device_sysfs.c b/drivers/gpu/drm/xe/xe_device_sysfs.c
index a73e0e957cb0b..18783a286a830 100644
--- a/drivers/gpu/drm/xe/xe_device_sysfs.c
+++ b/drivers/gpu/drm/xe/xe_device_sysfs.c
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/sysfs.h>
 
+#include "regs/xe_regs.h"
 #include "xe_device.h"
 #include "xe_device_sysfs.h"
 #include "xe_mmio.h"
@@ -264,6 +265,35 @@ static const struct attribute_group auto_link_downgrade_attr_group = {
 	.attrs = auto_link_downgrade_attrs,
 };
 
+/**
+ * DOC: Device Unique ID
+ *
+ * On supported platforms, Xe driver exposes a unique 64-bit GPU SOC
+ * device identifier through the 'device_uid' sysfs entry.
+ *
+ * See Documentation/ABI/testing/sysfs-driver-intel-xe-gpu for the ABI
+ * specification.
+ */
+
+static ssize_t
+device_uid_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct xe_device *xe = pdev_to_xe_device(pdev);
+
+	return sysfs_emit(buf, "0x%016llx\n", xe->device_uid);
+}
+static DEVICE_ATTR_ADMIN_RO(device_uid);
+
+static struct attribute *device_uid_attrs[] = {
+	&dev_attr_device_uid.attr,
+	NULL
+};
+
+static const struct attribute_group device_uid_attr_group = {
+	.attrs = device_uid_attrs,
+};
+
 int xe_device_sysfs_init(struct xe_device *xe)
 {
 	struct device *dev = xe->drm.dev;
@@ -285,5 +315,11 @@ int xe_device_sysfs_init(struct xe_device *xe)
 			return ret;
 	}
 
+	if (xe->info.has_device_uid) {
+		ret = devm_device_add_group(dev, &device_uid_attr_group);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
diff --git a/drivers/gpu/drm/xe/xe_device_types.h b/drivers/gpu/drm/xe/xe_device_types.h
index 03a7bb08adf7b..e4431f27d43c5 100644
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -171,6 +171,8 @@ struct xe_device {
 		u8 has_cached_pt:1;
 		/** @info.has_device_atomics_on_smem: Supports device atomics on SMEM */
 		u8 has_device_atomics_on_smem:1;
+		/** @info.has_device_uid: Device supports unique 64-bit GPU SOC ID */
+		u8 has_device_uid:1;
 		/** @info.has_drm_ras: Device supports drm_ras (Reliability, Availability, Serviceability) */
 		u8 has_drm_ras:1;
 		/** @info.has_fan_control: Device supports fan control */
@@ -255,6 +257,9 @@ struct xe_device {
 		bool oob_initialized;
 	} wa_active;
 
+	/** @device_uid: unique 64-bit GPU SOC identifier */
+	u64 device_uid;
+
 	/** @survivability: survivability information for device */
 	struct xe_survivability survivability;
 
diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 5f2a0b19839d1..06e1062ec1705 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -470,6 +470,7 @@ static const struct xe_device_desc cri_desc = {
 	PLATFORM(CRESCENTISLAND),
 	.dma_mask_size = 52,
 	.has_display = false,
+	.has_device_uid = true,
 	.has_drm_ras = true,
 	.has_flat_ccs = false,
 	.has_gsc_nvm = 1,
@@ -791,6 +792,7 @@ static int xe_info_init_early(struct xe_device *xe,
 
 	xe->info.is_dgfx = desc->is_dgfx;
 	xe->info.has_cached_pt = desc->has_cached_pt;
+	xe->info.has_device_uid = desc->has_device_uid;
 	xe->info.has_drm_ras = desc->has_drm_ras;
 	xe->info.has_fan_control = desc->has_fan_control;
 	/* runtime fusing may force flat_ccs to disabled later */
diff --git a/drivers/gpu/drm/xe/xe_pci_types.h b/drivers/gpu/drm/xe/xe_pci_types.h
index fed509ff601e4..fe327323a0be6 100644
--- a/drivers/gpu/drm/xe/xe_pci_types.h
+++ b/drivers/gpu/drm/xe/xe_pci_types.h
@@ -40,6 +40,7 @@ struct xe_device_desc {
 
 	u8 has_cached_pt:1;
 	u8 has_display:1;
+	u8 has_device_uid:1;
 	u8 has_drm_ras:1;
 	u8 has_fan_control:1;
 	u8 has_flat_ccs:1;
-- 
2.53.0



