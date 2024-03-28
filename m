Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575D7130E5D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643321; cv=none; b=hUGxyPaoPY8wICKBKkh6g6ql9qJ8QPu9RJL9ysSiCctad6SCfr5Gyrot957TJfZ/HlDekThKpVz51XrDyuUkpYgLIDaSL/+sp0kmly+Eofi3dGNsBm0XoHMNoEQGTb0yNhR1C/E4HbTIfmpIsPznzyppC1XVlz+ZnuCWtumJO/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643321; c=relaxed/simple;
	bh=d6oEEkZiXpUwThcVd9DaoNme+tX9GdjYQA7hJsSQwr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMiyCuF031d3bLFzLgRd4/rf8vcGUy+LKhZLsVne9RyUcX2jd/dVkLhFATIppzdG+4AuRFVoOwvWjlqB1Hh1RKlI+eiLRGtIzZ65JNlgKvvVX9n6kbvIpP/X6vynGwsGOwZE3rzVo4/GL7w0oY5WnrwWpr9IZr62++yngvxHri4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kqX0iESp; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kqX0iESp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643317; x=1743179317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d6oEEkZiXpUwThcVd9DaoNme+tX9GdjYQA7hJsSQwr0=;
  b=kqX0iESpYLGrQqXvAO39cdKkK00qYic5lSiZrrcAfZ6xxCT14VN5udea
   krrF4Gnc1VuEr+KIYjvut928qc4fdWikgwXU4lTZZA/8Xyle3+xn8g2mM
   vq3bgAO/zUPcvkwpLE8uMKHg57L5g0U8h5EizQos2JZ0quc6lEPD4fpfA
   Uxy6t62j3xzbCv6P4+ZsM9+5Unx2zu2ZL28zZ79g98EimfwayzaY9IUR8
   IeiLRXlOtwo3TeaCPWjNgbToFnL+0hGrqRm8EJFKyG8RevNsHi+H1++FP
   77YWo/PqNLtt2zCyB3OoPdrkLRRyxcg5CH26A9xqRklhabrnUqtsZBQD0
   w==;
X-CSE-ConnectionGUID: uB9/TVZ0Rn63yHsSLehmTA==
X-CSE-MsgGUID: +7q3gv9+SWehAyjpMOE5NQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294794"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294794"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726159"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 63/74] x86/cpu/vfm: Update drivers/staging/media/atomisp/include/linux/atomisp_platform.h
Date: Thu, 28 Mar 2024 09:27:57 -0700
Message-ID: <20240328162820.242778-63-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328090459.242500-tony.luck@intel.com>
References: <20240328090459.242500-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../atomisp/include/linux/atomisp_platform.h  | 26 ++++++++-----------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index 487ef5846c24..59f71659b2d8 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -18,6 +18,7 @@
 #ifndef ATOMISP_PLATFORM_H_
 #define ATOMISP_PLATFORM_H_
 
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 
@@ -217,22 +218,17 @@ void atomisp_unregister_subdev(struct v4l2_subdev *subdev);
 int v4l2_get_acpi_sensor_info(struct device *dev, char **module_id_str);
 
 /* API from old platform_camera.h, new CPUID implementation */
-#define __IS_SOC(x) (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL && \
-		     boot_cpu_data.x86 == 6 &&                       \
-		     boot_cpu_data.x86_model == (x))
-#define __IS_SOCS(x,y) (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL && \
-		        boot_cpu_data.x86 == 6 &&                       \
-		        (boot_cpu_data.x86_model == (x) || \
-		         boot_cpu_data.x86_model == (y)))
-
-#define IS_MFLD	__IS_SOC(INTEL_FAM6_ATOM_SALTWELL_MID)
-#define IS_BYT	__IS_SOC(INTEL_FAM6_ATOM_SILVERMONT)
-#define IS_CHT	__IS_SOC(INTEL_FAM6_ATOM_AIRMONT)
-#define IS_MRFD	__IS_SOC(INTEL_FAM6_ATOM_SILVERMONT_MID)
-#define IS_MOFD	__IS_SOC(INTEL_FAM6_ATOM_AIRMONT_MID)
+#define __IS_SOC(x) (boot_cpu_data.x86_vfm == x)
+#define __IS_SOCS(x, y) (boot_cpu_data.x86_vfm == x || boot_cpu_data.x86_vfm == y)
+
+#define IS_MFLD	__IS_SOC(INTEL_ATOM_SALTWELL_MID)
+#define IS_BYT	__IS_SOC(INTEL_ATOM_SILVERMONT)
+#define IS_CHT	__IS_SOC(INTEL_ATOM_AIRMONT)
+#define IS_MRFD	__IS_SOC(INTEL_ATOM_SILVERMONT_MID)
+#define IS_MOFD	__IS_SOC(INTEL_ATOM_AIRMONT_MID)
 
 /* Both CHT and MOFD come with ISP2401 */
-#define IS_ISP2401 __IS_SOCS(INTEL_FAM6_ATOM_AIRMONT, \
-			     INTEL_FAM6_ATOM_AIRMONT_MID)
+#define IS_ISP2401 __IS_SOCS(INTEL_ATOM_AIRMONT, \
+			     INTEL_ATOM_AIRMONT_MID)
 
 #endif /* ATOMISP_PLATFORM_H_ */
-- 
2.44.0

