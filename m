Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC17213D245
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245218; cv=none; b=DZe+YzLl9gRRBLjjlyqBlvZU47XyCj14h3LANn2J0ryUThjnUagGOuJZhHQg4yS5jOeSnbyhSNXJ1SWjlJWGRNoy5ub5L6tnA4g1So7wb+YBSbrvEl/ZgdTRKeCaKLWD32xc0ca7WCPrWjUNGJOHOu7gq8uGxdFTuRq2Gji+ttQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245218; c=relaxed/simple;
	bh=kewR2uBkcTny6f6IgFHYsgMrVAXGPg5/f1jOQ9w1xDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu2JB5TCpTMLbxznAU9MHj/2mbZepguseS8YHuAUoW1jd5vgUOpHfTZj2GlmHNIE5fYEt7uqU8x40ogIFXxZ2wHcj/gzVpoZSe19o7jNes06ny2n6MA0us96rOp/PrTLl/s/OLWFeMFy+EV5Ti7G9eZJb5JniS4RKeXARFtGDiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZaN91TIW; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZaN91TIW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245216; x=1747781216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kewR2uBkcTny6f6IgFHYsgMrVAXGPg5/f1jOQ9w1xDE=;
  b=ZaN91TIW+8x+oPhAgxBxdQKtcjKUmzGknv1wXdL/uRLQVAzhk2SxeldQ
   lHVvkZiV7Fw1LueBbFa06T+S95dXbf0BUB5+NOCXfe1RwXpsKNr7NRFI/
   pZqHTU1jMqut2ARASvUufFcadjAyVAZFMHcu5D4L5ogbdAjfYgKp8kPfg
   oNawaKBOjVRBHGjKGHNbvIrSPm9TVzi1KkHravi+XCl+vi7WAGvbhtfYZ
   a4YuP1Xhn32Dl6aH5UiD4U0FeU41NH1caQwdxTqqq7U1egAdM4phU+xCK
   md2cTPUAqMXMbV9RzPc9IYl+XcfX0depSxzSDZlroBjt5mO3HcTsoaSHO
   g==;
X-CSE-ConnectionGUID: pPUQLx9XTDu9Oi/8K6Sgtw==
X-CSE-MsgGUID: t0hizzBYQ6Gt9wHJVzAi9A==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12200025"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12200025"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:41 -0700
X-CSE-ConnectionGUID: zq0pFpXWS6ebPr0Zi6x9gw==
X-CSE-MsgGUID: 2+NlFfxISxmt/ivpRL0kAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593528"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:40 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 47/49] peci, hwmon: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:46:18 -0700
Message-ID: <20240520224620.9480-48-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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
index 9d75ea54504c..b9d45483cabe 100644
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
 
 extern struct device_type peci_device_type;
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
index 0f83a9c6093b..b2d7adf05ba0 100644
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
index e6b0bffb14f4..5eb57b503c81 100644
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

