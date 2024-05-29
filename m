Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5609B839E2
	for <patches@lists.linux.dev>; Wed, 29 May 2024 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717003169; cv=none; b=oaX8nNcy9Tpj8P8Bx2PCwsz0b8S/Y3egralukCYYEWJc+xGBsujPhvUqfonndeZJi6SDHbcXWkw/N/O4pCW6KM9GWoXfObbhABi6CHOYVeajboyt7WVV4zMfd+qXfumssgxeJ8CoWWRJ8ElcQUIkIjmVJdDwck5rO91T3WO68uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717003169; c=relaxed/simple;
	bh=lyUdJaNno+zU58CiKeVUgESvZuoscLbK/A8CXCF0nmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZiWfVqJ3YTaXzQO784jMAsNxo31FTD/mGPikOczLtVnBtGNFGRc99vmes0BpqdHlQm9v6xcKTB2zIicOInShTPd5hSE0STGxJKlEDef+IA0k9dq8rvLPfL+fKRr0qh+87UlEsYVWOdfugqYHwBOU1IoPHMQlEL53ma5cCi7aDMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uc8Ifmo8; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uc8Ifmo8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717003168; x=1748539168;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lyUdJaNno+zU58CiKeVUgESvZuoscLbK/A8CXCF0nmQ=;
  b=Uc8Ifmo8fZgJMCXbCTWEoCar2t5y64HzOaribMGvRAGggxmtWLSYU4fU
   COwO+X8ear1mrqwwPj4dthMBNVYez8nSxCePJy457cuxRJQudfagehWfg
   Gsof7QFr8t0Tar0KOwlgtpm3bL84tbpwPoEkjcbZNo1CzjHTbZb7tuS5/
   cyqAHV1Pq3pCHLYvRU/miAKSbDulj/F88NgMK/6pl3YoAXDzw28J4+HTC
   0204L78StUQJkDbltMQ05vg1tt4pzioWR2Ma0HxOP3+3u3z0Hghfce6ls
   QJ0kibZhxBtO7e+IuWXPeeu3GfQuhr2eX7U6hEvj7t2rifjVSzewbPAk2
   g==;
X-CSE-ConnectionGUID: Y6VSe6QoSj2vlk5Qg6dcEw==
X-CSE-MsgGUID: AYRCYZoRSryh5T+Rgbj6vw==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="24836863"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="24836863"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 10:19:28 -0700
X-CSE-ConnectionGUID: 0fP4ctFyQD+OzDmePoDbPQ==
X-CSE-MsgGUID: pEN7A2qeQBqXSomT9p4/qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="40023469"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 10:19:28 -0700
From: Tony Luck <tony.luck@intel.com>
To: Iwona Winiarska <iwona.winiarska@intel.com>,
	Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	openbmc@lists.ozlabs.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] peci, hwmon: Switch to new Intel CPU model defines
Date: Wed, 29 May 2024 10:19:20 -0700
Message-ID: <20240529171920.62571-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update peci subsystem to use the same vendor-family-model
combined definition that core x86 code uses.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
TIP tree applied the patches that implement the new CPU model number
macros (and a couple of dozen patches to arch/x86/ files too). So
v6.10-rc1 has all the necesary code to apply patches to other trees in
this cycle.

The previous posting of this patch[1] had a tiny bit of fuzz due to
nearby changes in drivers/peci/internal.h. This one applies cleanly
to v6.10-rc1.

Iwona, Jean, Guenter: Can you check that it still looks good. If so
apply it to your tree and kick the process in gear to have it appear in
the intel-next tree with eventual merge to Linus in next merge window.

Thanks

-Tony

[1] https://lore.kernel.org/all/20240520224620.9480-48-tony.luck@intel.com/

 include/linux/peci-cpu.h     | 24 ++++++++++++++++++++++++
 include/linux/peci.h         |  6 ++----
 drivers/peci/internal.h      |  6 ++----
 drivers/hwmon/peci/cputemp.c |  8 ++++----
 drivers/peci/core.c          |  5 ++---
 drivers/peci/cpu.c           | 21 +++++++--------------
 drivers/peci/device.c        |  3 +--
 7 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/include/linux/peci-cpu.h b/include/linux/peci-cpu.h
index ff8ae9c26c80..601cdd086bf6 100644
--- a/include/linux/peci-cpu.h
+++ b/include/linux/peci-cpu.h
@@ -6,6 +6,30 @@
 
 #include <linux/types.h>
 
+/* Copied from x86 <asm/processor.h> */
+#define X86_VENDOR_INTEL       0
+
+/* Copied from x86 <asm/cpu_device_id.h> */
+#define VFM_MODEL_BIT	0
+#define VFM_FAMILY_BIT	8
+#define VFM_VENDOR_BIT	16
+#define VFM_RSVD_BIT	24
+
+#define	VFM_MODEL_MASK	GENMASK(VFM_FAMILY_BIT - 1, VFM_MODEL_BIT)
+#define	VFM_FAMILY_MASK	GENMASK(VFM_VENDOR_BIT - 1, VFM_FAMILY_BIT)
+#define	VFM_VENDOR_MASK	GENMASK(VFM_RSVD_BIT - 1, VFM_VENDOR_BIT)
+
+#define VFM_MODEL(vfm)	(((vfm) & VFM_MODEL_MASK) >> VFM_MODEL_BIT)
+#define VFM_FAMILY(vfm)	(((vfm) & VFM_FAMILY_MASK) >> VFM_FAMILY_BIT)
+#define VFM_VENDOR(vfm)	(((vfm) & VFM_VENDOR_MASK) >> VFM_VENDOR_BIT)
+
+#define	VFM_MAKE(_vendor, _family, _model) (	\
+	((_model) << VFM_MODEL_BIT) |		\
+	((_family) << VFM_FAMILY_BIT) |		\
+	((_vendor) << VFM_VENDOR_BIT)		\
+)
+/* End of copied code */
+
 #include "../../arch/x86/include/asm/intel-family.h"
 
 #define PECI_PCS_PKG_ID			0  /* Package Identifier Read */
diff --git a/include/linux/peci.h b/include/linux/peci.h
index 90e241458ef6..3e0bc37591d6 100644
--- a/include/linux/peci.h
+++ b/include/linux/peci.h
@@ -59,8 +59,7 @@ static inline struct peci_controller *to_peci_controller(void *d)
  * struct peci_device - PECI device
  * @dev: device object to register PECI device to the device model
  * @info: PECI device characteristics
- * @info.family: device family
- * @info.model: device model
+ * @info.x86_vfm: device vendor-family-model
  * @info.peci_revision: PECI revision supported by the PECI device
  * @info.socket_id: the socket ID represented by the PECI device
  * @addr: address used on the PECI bus connected to the parent controller
@@ -73,8 +72,7 @@ static inline struct peci_controller *to_peci_controller(void *d)
 struct peci_device {
 	struct device dev;
 	struct {
-		u16 family;
-		u8 model;
+		u32 x86_vfm;
 		u8 peci_revision;
 		u8 socket_id;
 	} info;
diff --git a/drivers/peci/internal.h b/drivers/peci/internal.h
index 506bafcccbbf..7a4f6eae2f90 100644
--- a/drivers/peci/internal.h
+++ b/drivers/peci/internal.h
@@ -66,13 +66,11 @@ struct peci_request *peci_xfer_ep_mmio64_readl(struct peci_device *device, u8 ba
 /**
  * struct peci_device_id - PECI device data to match
  * @data: pointer to driver private data specific to device
- * @family: device family
- * @model: device model
+ * @x86_vfm: device vendor-family-model
  */
 struct peci_device_id {
 	const void *data;
-	u16 family;
-	u8 model;
+	u32 x86_vfm;
 };
 
 extern const struct device_type peci_device_type;
diff --git a/drivers/hwmon/peci/cputemp.c b/drivers/hwmon/peci/cputemp.c
index a812c15948d9..5a682195b98f 100644
--- a/drivers/hwmon/peci/cputemp.c
+++ b/drivers/hwmon/peci/cputemp.c
@@ -360,10 +360,10 @@ static int init_core_mask(struct peci_cputemp *priv)
 	int ret;
 
 	/* Get the RESOLVED_CORES register value */
-	switch (peci_dev->info.model) {
-	case INTEL_FAM6_ICELAKE_X:
-	case INTEL_FAM6_ICELAKE_D:
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	switch (peci_dev->info.x86_vfm) {
+	case INTEL_ICELAKE_X:
+	case INTEL_ICELAKE_D:
+	case INTEL_SAPPHIRERAPIDS_X:
 		ret = peci_ep_pci_local_read(peci_dev, 0, reg->bus, reg->dev,
 					     reg->func, reg->offset + 4, &data);
 		if (ret)
diff --git a/drivers/peci/core.c b/drivers/peci/core.c
index 8f8bda2f2a62..8ff3e5d225ae 100644
--- a/drivers/peci/core.c
+++ b/drivers/peci/core.c
@@ -163,9 +163,8 @@ EXPORT_SYMBOL_NS_GPL(devm_peci_controller_add, PECI);
 static const struct peci_device_id *
 peci_bus_match_device_id(const struct peci_device_id *id, struct peci_device *device)
 {
-	while (id->family != 0) {
-		if (id->family == device->info.family &&
-		    id->model == device->info.model)
+	while (id->x86_vfm != 0) {
+		if (id->x86_vfm == device->info.x86_vfm)
 			return id;
 		id++;
 	}
diff --git a/drivers/peci/cpu.c b/drivers/peci/cpu.c
index bd990acd92b8..152bbd8e717a 100644
--- a/drivers/peci/cpu.c
+++ b/drivers/peci/cpu.c
@@ -294,38 +294,31 @@ peci_cpu_probe(struct peci_device *device, const struct peci_device_id *id)
 
 static const struct peci_device_id peci_cpu_device_ids[] = {
 	{ /* Haswell Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_HASWELL_X,
+		.x86_vfm = INTEL_HASWELL_X,
 		.data	= "hsx",
 	},
 	{ /* Broadwell Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_BROADWELL_X,
+		.x86_vfm = INTEL_BROADWELL_X,
 		.data	= "bdx",
 	},
 	{ /* Broadwell Xeon D */
-		.family	= 6,
-		.model	= INTEL_FAM6_BROADWELL_D,
+		.x86_vfm = INTEL_BROADWELL_D,
 		.data	= "bdxd",
 	},
 	{ /* Skylake Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_SKYLAKE_X,
+		.x86_vfm = INTEL_SKYLAKE_X,
 		.data	= "skx",
 	},
 	{ /* Icelake Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_ICELAKE_X,
+		.x86_vfm = INTEL_ICELAKE_X,
 		.data	= "icx",
 	},
 	{ /* Icelake Xeon D */
-		.family	= 6,
-		.model	= INTEL_FAM6_ICELAKE_D,
+		.x86_vfm = INTEL_ICELAKE_D,
 		.data	= "icxd",
 	},
 	{ /* Sapphire Rapids Xeon */
-		.family	= 6,
-		.model	= INTEL_FAM6_SAPPHIRERAPIDS_X,
+		.x86_vfm = INTEL_SAPPHIRERAPIDS_X,
 		.data	= "spr",
 	},
 	{ }
diff --git a/drivers/peci/device.c b/drivers/peci/device.c
index ee01f03c29b7..37ca7dd61807 100644
--- a/drivers/peci/device.c
+++ b/drivers/peci/device.c
@@ -100,8 +100,7 @@ static int peci_device_info_init(struct peci_device *device)
 	if (ret)
 		return ret;
 
-	device->info.family = peci_x86_cpu_family(cpu_id);
-	device->info.model = peci_x86_cpu_model(cpu_id);
+	device->info.x86_vfm = IFM(peci_x86_cpu_family(cpu_id), peci_x86_cpu_model(cpu_id));
 
 	ret = peci_get_revision(device, &revision);
 	if (ret)
-- 
2.45.0

