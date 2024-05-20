Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17881386CC
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245201; cv=none; b=aRE/P23QI13NxzMPWSLI/dmqE44my7EM4Dk/WwI4TzPqPsPtj5hgVCpRDUuRMan0epeqk0knPjGApPLrf9T/G+lh+lVYIta9atT6gLm8mM+2KisNaOSCBhTbK1yHzq0JbxqKYtot8IqrQ+K0yL+qwuiYfRQbxMrf7jlgZbvL0mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245201; c=relaxed/simple;
	bh=R7lJm8y1wTPr9sOO4og3VXb29EESiuJx3kDAU5wPuLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLBlFJo4znEIytTfLB1sJlfVj5dM/U6p771YcVM1dOebit5ZPd/hoHPfw/8tnbqzFTctoCEQoK2URM7bnwoZN2a8CqVNercABuTSvwdvcesSW1a0BTzE1332xqamVGVuWNl7cVxTrDjlDzKfPtU+lI4m+i3euqon0A46ky8gMhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MesBzzB8; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MesBzzB8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245200; x=1747781200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R7lJm8y1wTPr9sOO4og3VXb29EESiuJx3kDAU5wPuLo=;
  b=MesBzzB8OdXwT4SrVHlbCUXvqRrBP/B9Aq7RvGIx8pbjq7I9jHVUdvAt
   FdeN4QREgnU+CC1VrEJNeR9n4T0mWbKMUNGNTNlEjx0pTpc2fvCJ5nVQJ
   /P0cGNPrBuW1DYTCZlgktNSSsVKkJJbFYBNfLpzQt1iSk93t0Pq8+dIhv
   5LpBPcetOpkVG2Y3XY81Inm1B8n4x0UxCPqsxztrhzD0OtnFUxYSHJ5b0
   3pkcQjb+pOvc7e/RaisGr+Gk2NJN8gDK8PwL05fdLIhIQiRKqn+WBCsy8
   3I0uwV17/gbXj89wdRTD7G59YvBv2jR+TUkjsT+4nevtXRu6Sdq6emvDa
   g==;
X-CSE-ConnectionGUID: nQxo/5f+Tbu58g7iYeXSPg==
X-CSE-MsgGUID: OvArpG34SrSmUZnJhV26iQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199553"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199553"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
X-CSE-ConnectionGUID: m5auZqylSLesyZVyyHIuXg==
X-CSE-MsgGUID: Q5vCGZJGRheBZu3aCQ6ysQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593396"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:35 -0700
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
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 05/49] media: atomisp: Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:36 -0700
Message-ID: <20240520224620.9480-6-tony.luck@intel.com>
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

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 .../atomisp/include/linux/atomisp_platform.h  | 27 ++++++++-----------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index 0e3f6fb78483..fdeb247036b0 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -18,7 +18,7 @@
 #ifndef ATOMISP_PLATFORM_H_
 #define ATOMISP_PLATFORM_H_
 
-#include <asm/intel-family.h>
+#include <asm/cpu_device_id.h>
 #include <asm/processor.h>
 
 #include <linux/i2c.h>
@@ -178,22 +178,17 @@ void atomisp_unregister_subdev(struct v4l2_subdev *subdev);
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
2.45.0

