Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB0F22097
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 16:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776271007; cv=none; b=cWwtUTXF68SnIdHYOTU4jEEbUDqKC7Ju0jXOgdvCkQv5sBzTTqNiHtXf665I2VpauFGPbFxMYwuaL16Zmgv6yj/guZFAtCPWpLjDhzwFRyc51xdwL8rZGAtBHIy1HHwUViSMGQ8oE5P9hxNmQfIlYz3OstQ++j+qQB91VCStOq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776271007; c=relaxed/simple;
	bh=u5Zcyvxerh8GwFVpZ5dVjjOQxR9AjrqFpq1aiJdbY5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M6+HgS5mW9N/J1AOoUJ04TzTgs0tVvRzhLMzzlZrujtwUYGZ1NCM/6tVa1j6+dv6p+0+BuUslU2V5fBkGwB3NfQXbFpESvoJ53sc2KQry9HhcvObffmASoV2CoAzwJLMVkRLBJQJDNllu7wEqnLOr3n7X4oNDu8xna21M+SOqss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WqcKJ33s; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WqcKJ33s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776271005; x=1807807005;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u5Zcyvxerh8GwFVpZ5dVjjOQxR9AjrqFpq1aiJdbY5Q=;
  b=WqcKJ33s2+3SN626hNyy0S72lPJFRvZ/CMXrs5+TKa7XP0/HD8WLJ/37
   pqHuX6OL8ypPR7RiOgMeRR03H3Cc3ZmW6iM7ZxLVh7OZOJf0yvgHiclRl
   YTHnddF5kZEQxNnjPQfLlyhR0ipgV2+eIKJmVPmPnuU/lRxKFHWm0W9XB
   bvb/rergcLyudlztXIQFlzzkJ0dZsoy6zMCEgEVFBwyh2fazlst41+86x
   fzDvkWHCqeCsGQJthOKRLjFPUzy6f7dr96+kVkY0WJPi9GxcemACRqWwF
   hqJv7bdcqh1uduL/HqZnvs8TcFrhzvEGanlBwjiSQ2ltVYWDAvgOVTPDb
   g==;
X-CSE-ConnectionGUID: JGCX3hPqTXyjQpy7cy+AxA==
X-CSE-MsgGUID: 528LTVYISc2Vv/HGCM3taw==
X-IronPort-AV: E=McAfee;i="6800,10657,11760"; a="77438350"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="77438350"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 09:36:34 -0700
X-CSE-ConnectionGUID: aD0btk5zQ9eNDKJaeVX0mw==
X-CSE-MsgGUID: PbEaGu+VRiqsg1GPaSfW/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="227819829"
Received: from vverma7-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.158])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 09:36:33 -0700
From: Tony Luck <tony.luck@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Herman Li <herman.li@intel.com>,
	Zaid Alali <zaidal@os.amperecomputing.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] ACPI: APEI: EINJ: Fix EINJv2 memory injection
Date: Wed, 15 Apr 2026 09:36:20 -0700
Message-ID: <20260415163620.12957-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EINJ trigger actions for memory error injection often include access to
the target injection address. This address does not need to special
mapping.

The code to drop the target address from the resource list only checked
for V1 injection signature.

Add a test for the EINJ V2 memory injection signature.

Reported-by: Herman Li <herman.li@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/apei/einj-core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/einj-core.c b/drivers/acpi/apei/einj-core.c
index a9248af078f6..ba0ce71b7adb 100644
--- a/drivers/acpi/apei/einj-core.c
+++ b/drivers/acpi/apei/einj-core.c
@@ -401,6 +401,17 @@ static struct acpi_generic_address *einj_get_trigger_parameter_region(
 
 	return NULL;
 }
+
+static bool is_memory_injection(u32 type, u64 param2)
+{
+	if (is_v2)
+		return type & BIT(1);
+	else if (param_extension || acpi5)
+		return (type & MEM_ERROR_MASK) && param2;
+
+	return false;
+}
+
 /* Execute instructions in trigger error action table */
 static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 				u64 param1, u64 param2)
@@ -480,7 +491,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 	 * This will cause resource conflict with regular memory.  So
 	 * remove it from trigger table resources.
 	 */
-	if ((param_extension || acpi5) && (type & MEM_ERROR_MASK) && param2) {
+	if (is_memory_injection(type, param2)) {
 		struct apei_resources addr_resources;
 
 		apei_resources_init(&addr_resources);
-- 
2.53.0

