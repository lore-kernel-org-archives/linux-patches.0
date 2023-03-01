Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE750A32
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 02:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677636073; x=1709172073;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8fGhALj/6YuPeeMFkK3yfUkQG/FNpfhZ0YdkO37eDWg=;
  b=bK9od+nyfqlDp7GRRcmEwQcbIr6lJOUctqWcl/ma2OLs3i9t62tD4UUB
   DKRmcngjN+IQkg0jB/rPZRtrNx81LmVaPPQ9Lf8EberotB8S0OmBnC3dM
   CobWMIxjYauQJn+qCSpqxjswbwzF6bY/oE8Nld09tS/2DYvgaJGehZl+Y
   fqOF+pN7PTXZ8FTk1Rt/vwXQxjOJTw1GlikftzWJ94ItHyARciqvYvUYa
   eniyBybBThTT7/IYJ8aymUcSSbFaj2oqyyZx5/+zIly7utKDl9Sh4vdDj
   /VZYeOBix7X8H3HX73/+vO0Cwf3or6GDd4CKDXmrVadC5MSWPrNgAqqkg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="420558423"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="420558423"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 18:01:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="704639942"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="704639942"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 18:01:11 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH v3 2/8] platform/x86/intel/ifs: IFS cleanup
Date: Tue, 28 Feb 2023 17:59:36 -0800
Message-Id: <20230301015942.462799-3-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230301015942.462799-1-jithu.joseph@intel.com>
References: <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230301015942.462799-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cleanup incorporating misc review comments

 - Remove the subdirectory intel_ifs/0 for devicenode [1]
 - Make plat_ifs_groups non static and use it directly without using a
    function [2]

Link: https://lore.kernel.org/lkml/Y+4kQOtrHt5pdsSO@kroah.com/ [1]
Link: https://lore.kernel.org/lkml/Y9nyxNesVHCUXAcH@kroah.com/  [2]

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h   | 2 +-
 drivers/platform/x86/intel/ifs/core.c  | 6 +++---
 drivers/platform/x86/intel/ifs/sysfs.c | 9 +--------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index e07463c794d4..ab168ddf28f1 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -246,6 +246,6 @@ static inline struct ifs_data *ifs_get_data(struct device *dev)
 extern bool *ifs_pkg_auth;
 int ifs_load_firmware(struct device *dev);
 int do_core_test(int cpu, struct device *dev);
-const struct attribute_group **ifs_get_groups(void);
+extern struct attribute *plat_ifs_attrs[];
 
 #endif
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index b518b661daf0..62c44dbae757 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -20,6 +20,8 @@ static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
 
+ATTRIBUTE_GROUPS(plat_ifs);
+
 bool *ifs_pkg_auth;
 
 static struct ifs_device ifs_device = {
@@ -29,8 +31,8 @@ static struct ifs_device ifs_device = {
 	},
 	.misc = {
 		.name = "intel_ifs_0",
-		.nodename = "intel_ifs/0",
 		.minor = MISC_DYNAMIC_MINOR,
+		.groups = plat_ifs_groups,
 	},
 };
 
@@ -53,8 +55,6 @@ static int __init ifs_init(void)
 	if (rdmsrl_safe(MSR_INTEGRITY_CAPS, &msrval))
 		return -ENODEV;
 
-	ifs_device.misc.groups = ifs_get_groups();
-
 	if (!(msrval & BIT(ifs_device.ro_data.integrity_cap_bit)))
 		return -ENODEV;
 
diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
index ee636a76b083..2007d8054f04 100644
--- a/drivers/platform/x86/intel/ifs/sysfs.c
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -141,7 +141,7 @@ static ssize_t image_version_show(struct device *dev,
 static DEVICE_ATTR_RO(image_version);
 
 /* global scan sysfs attributes */
-static struct attribute *plat_ifs_attrs[] = {
+struct attribute *plat_ifs_attrs[] = {
 	&dev_attr_details.attr,
 	&dev_attr_status.attr,
 	&dev_attr_run_test.attr,
@@ -149,10 +149,3 @@ static struct attribute *plat_ifs_attrs[] = {
 	&dev_attr_image_version.attr,
 	NULL
 };
-
-ATTRIBUTE_GROUPS(plat_ifs);
-
-const struct attribute_group **ifs_get_groups(void)
-{
-	return plat_ifs_groups;
-}
-- 
2.25.1

