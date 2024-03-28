Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2FC131BD9
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643320; cv=none; b=Be/DS7GPimj5TcZXi9l7g1e1UegYB71jg8p0MevOGThp9getES56TUzFFIFE1t4F+xSA75PW6CHGepMgK+L363qdtbsR3nV0JMdMh7yNAFSwfXrfHl+qcreSbpns9jNK+4+tKOk+czn3CVoBmfc2JoDUlFkUYDRAlkWreFn1wHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643320; c=relaxed/simple;
	bh=LOzsD5IsD59gKdeksTuIW83sAKQTK/XFVhkG9cKUAsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWUeDaXOR5xPWd6AmH9h/NsimcXTvpEX2FzVc1qwbZa6+KP4iuY2rrQMyTVdzqExsVmLgzz2n6QcEaeXhRUmw/yKrayATbNhkUV8Fdw18m5caHqKpNXtmhXRcX6lWyCCkSBuTKwiyeWUeWWwi9xUHbgkpLKiMmq8w2RwlUK+u9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IVhx9n7I; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IVhx9n7I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643317; x=1743179317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LOzsD5IsD59gKdeksTuIW83sAKQTK/XFVhkG9cKUAsU=;
  b=IVhx9n7IlBnO2u3l7ebm4t60jw42V8VLH+fj2s8EoYU5y/Ac9caOhh0v
   /gucUlauUdExlotvwlqPhrbHb0RYOO5VXzFqOTCnmVbDvl8KNp0FmAt65
   IbXH7GUU0wXI1rJxNgJSen/sGuCWNdDZrBeAsLId4/X4CQfMopBCbfbro
   zXRjM58SatOnmv5BgZIrT4Ce2gYBt6mYQzvyIBhYZ/OJnoo8TlAaw0YCA
   kn3AcR6S+fPbf3JBFmEmHRbIp1osd4N9B8PbAZZJfhWr7QC9E3cMa6HbR
   7V8GqSAVkQozV95SaMJ6eJXd5M2XGqUi8xmM/458YJ1y5ytB0cilaZ/2K
   A==;
X-CSE-ConnectionGUID: ke0Do9vcTR6PX9T7eGAKbw==
X-CSE-MsgGUID: 8fUj9mjzSJWNVmAnYrEgAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294790"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294790"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726143"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 59/74] x86/cpu/vfm: Update drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
Date: Thu, 28 Mar 2024 09:27:53 -0700
Message-ID: <20240328162820.242778-59-tony.luck@intel.com>
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
 .../intel/uncore-frequency/uncore-frequency.c | 56 +++++++++----------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index b89c0dda9e5d..b80feaf5828f 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -197,34 +197,34 @@ static struct notifier_block uncore_pm_nb = {
 };
 
 static const struct x86_cpu_id intel_uncore_cpu_ids[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_G,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,	NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(KABYLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(COMETLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(CANNONLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ROCKETLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ARROWLAKE, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ARROWLAKE_H, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(LUNARLAKE_M, NULL),
+	X86_MATCH_VFM(INTEL_BROADWELL_G,	NULL),
+	X86_MATCH_VFM(INTEL_BROADWELL_X,	NULL),
+	X86_MATCH_VFM(INTEL_BROADWELL_D,	NULL),
+	X86_MATCH_VFM(INTEL_SKYLAKE_X,	NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_X,	NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_D,	NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_KABYLAKE, NULL),
+	X86_MATCH_VFM(INTEL_KABYLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_COMETLAKE, NULL),
+	X86_MATCH_VFM(INTEL_COMETLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_CANNONLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ROCKETLAKE, NULL),
+	X86_MATCH_VFM(INTEL_TIGERLAKE, NULL),
+	X86_MATCH_VFM(INTEL_TIGERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ALDERLAKE, NULL),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P, NULL),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S, NULL),
+	X86_MATCH_VFM(INTEL_METEORLAKE, NULL),
+	X86_MATCH_VFM(INTEL_METEORLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ARROWLAKE, NULL),
+	X86_MATCH_VFM(INTEL_ARROWLAKE_H, NULL),
+	X86_MATCH_VFM(INTEL_LUNARLAKE_M, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_uncore_cpu_ids);
-- 
2.44.0

