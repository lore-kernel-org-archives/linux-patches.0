Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B773D221F06
	for <patches@lists.linux.dev>; Fri, 23 May 2025 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748020753; cv=none; b=G8PiBR6PSHbM1e+TWS2Rgkz3WecX7bXNBBmvmTQpcDGfYXLzjwiwxhyPc9Cemjd34kum/Ie9eSNMazW+btr4bnHeV/pUczMmMbWdFQ9gQznceaud0UmdsjPk2sYJUH+VYSZMCSNnEuQyK/22pnJOUw4+PT61ReF2LqMMOBiO4EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748020753; c=relaxed/simple;
	bh=JFhrayBhJRC4b/wXiM0S9wcKDa4EYnZywdbZUgnJV1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oqYWHJdAV9ncD4CzNQR269haTJt1nUSJsLg1frwuaUXqYmXkRrXf01JN0+tZ/6trgBa2XO4wCoTKaDf23V+r3oM+ftGzUtTjxzpCvnvJkGFwGx41cezWDO+aSKfrjS1IIYdmiY1N8wa0KFlV0hf43Pg8zBIPjp99Ym5tHNCTWyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d7hDl9Sg; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d7hDl9Sg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748020751; x=1779556751;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JFhrayBhJRC4b/wXiM0S9wcKDa4EYnZywdbZUgnJV1A=;
  b=d7hDl9Sg3oFcZS0woQhcwtvQDUZNNnbB2nxAx29eKZbBBuu1rH/ZGHfL
   g4DxicckNEwsKOjDI9RKRB6zzEOon5L0kTgivss9gquok8SxfVvG+3P/p
   hySNWyGhsnlc9ollo2SpM5GO6iw1t3uGfxXVdt1cY9GBpdP3WOT5ChmeQ
   J9ATO7s6spTx85MMakYqFUjtktqgEapnPAzgn7UT+2uHrGO1+Z8ct3TuW
   PD0RxN4cu5rghTA68kpFNmj/j9aMWwliIXU8hQGyePQ6NBBke9+JViqiY
   qM3gWQLxoLYbBtIyQgMy64jEfb/TuvRptPuX87Da6AOg3Ao3yihpbhKXO
   g==;
X-CSE-ConnectionGUID: OX92E/W+TPKCh19BVC1L8Q==
X-CSE-MsgGUID: bAdtINbnTKO4WJNPsAIG8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="60740028"
X-IronPort-AV: E=Sophos;i="6.15,309,1739865600"; 
   d="scan'208";a="60740028"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 10:19:06 -0700
X-CSE-ConnectionGUID: SzLbJRTkRoWK5B/6NfJo+g==
X-CSE-MsgGUID: looBECrOQrasZJMLHF3bZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,309,1739865600"; 
   d="scan'208";a="146383529"
Received: from dev.sc.intel.com ([172.25.103.134])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 10:19:06 -0700
From: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
To: tony.luck@intel.com,
	rafael@kernel.org
Cc: anil.s.keshavamurthy@intel.com,
	yu.c.chen@intel.com,
	lenb@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] ACPI/MRRM: Fix default max memory region
Date: Fri, 23 May 2025 13:20:01 -0400
Message-ID: <20250523172001.1761634-1-anil.s.keshavamurthy@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Per the spec, the default max memory region must be 1 covering
all system memory.

When platform does not provide ACPI MRRM table or
when CONFIG_ACPI is opted out, the acpi_mrrm_max_mem_region() function
defaults to  returning 1 region complying to RDT spec.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 drivers/acpi/acpi_mrrm.c | 3 ++-
 include/linux/acpi.h     | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_mrrm.c b/drivers/acpi/acpi_mrrm.c
index 2f22f013959a..26c1a4e6b6ec 100644
--- a/drivers/acpi/acpi_mrrm.c
+++ b/drivers/acpi/acpi_mrrm.c
@@ -14,7 +14,8 @@
 #include <linux/string.h>
 #include <linux/sysfs.h>
 
-static int max_mem_region = -ENOENT;
+/* Default assume one memory region covering all system memory, per the spec */
+static int max_mem_region = 1;
 
 /* Access for use by resctrl file system */
 int acpi_mrrm_max_mem_region(void)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index e72100c0684f..f102c0fe3431 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1101,7 +1101,7 @@ static inline acpi_handle acpi_get_processor_handle(int cpu)
 
 static inline int acpi_mrrm_max_mem_region(void)
 {
-	return -ENOENT;
+	return 1;
 }
 
 #endif	/* !CONFIG_ACPI */
-- 
2.47.1

