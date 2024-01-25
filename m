Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FB417731
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 08:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171006; cv=none; b=VSDeVdxbPqd2hgOjBc8YI8qRnF3NqcU2N6+2wn+bT+hDjZ7cwqWmmSWMw108Uwbgqr43ZSH9DszhhO9GSLC35R4JcFvmLq27cn73SWa7sEB77kzICtA9itiCh0e04iJKx2/wwr6kiVTHbKEp9mz8kQamT/YNeccaOMrRztVgnuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171006; c=relaxed/simple;
	bh=33Nygko1fox8iV52wVuBrn97aPDqalW86iUYduaw+zg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e8T0guhTi2Qm8Jf3EjRLT4SdHeWmsBlcNvAZWIl7S65vhcngyZ35IfWV2e9c0pwM/ZZlrlZsL56ZMVq9wZdJj0spjfxKDCHR2CSoUKBFpC0VbOCQ59tzuIVhg5IKuRZc5d43rGILOwUi/iBWttBCFu+UnfZ7SF5XYspNBxAUfxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m4swk/Qy; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m4swk/Qy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706171006; x=1737707006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=33Nygko1fox8iV52wVuBrn97aPDqalW86iUYduaw+zg=;
  b=m4swk/QyswG6OJZzdpQHvtqnJSDsn/+jM8LDJLcLTwnaQUSbSt9qqr+j
   r6o/VZAvabX7CldQhzu7PYwfls5nHwov6YIXEIqmC5QmsGB/jqqckwv9/
   xESNgeBHrIJm0DPhPa0skS+0xqU4P7/Bk9XSH+vhYmh5iyGUiTVKkjP9b
   5WVu8EetH7aYX3qnO19UJ6bXue4tYSnSc+0b+/eC7IqR6c+xJD0hhiJzp
   +mmm2KlCADWJTY0hqLg0GEBJbosKytlUQcDWPsLouPegCMo8LEiigRWtM
   x5q3Iu6lq7UVdvoCKiI03iPw0wY4PfkOA+rvYz2EzlOO+VsJd5O7leJ5Y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="1987177"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="1987177"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 00:23:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="876975929"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="876975929"
Received: from araj-ucode.jf.intel.com ([10.23.0.11])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 00:23:23 -0800
From: Ashok Raj <ashok.raj@intel.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	markgross@kernel.org
Cc: Jithu Joseph <jithu.joseph@intel.com>,
	rostedt@goodmis.org,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	LKML <linux-kernel@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	pengfei.xu@intel.com
Subject: [PATCH 3/5] platform/x86/intel/ifs: Add current batch number to trace output
Date: Thu, 25 Jan 2024 00:22:52 -0800
Message-Id: <20240125082254.424859-4-ashok.raj@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240125082254.424859-1-ashok.raj@intel.com>
References: <20240125082254.424859-1-ashok.raj@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the current batch number in the trace output. When there are failures,
it's important to know which test content resulted in failure.

#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
#              | |         |   |||||     |         |
     migration/0-18      [000] d..1. 527287.084668: ifs_status: batch: 02, start: 0000, stop: 007f, status: 0000000000007f80
   migration/128-785     [128] d..1. 527287.084669: ifs_status: batch: 02, start: 0000, stop: 007f, status: 0000000000007f80

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 include/trace/events/intel_ifs.h         | 9 ++++++---
 drivers/platform/x86/intel/ifs/runtest.c | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/intel_ifs.h b/include/trace/events/intel_ifs.h
index 8462dfb7a020..8ce2de120f2d 100644
--- a/include/trace/events/intel_ifs.h
+++ b/include/trace/events/intel_ifs.h
@@ -10,23 +10,26 @@
 
 TRACE_EVENT(ifs_status,
 
-	TP_PROTO(int start, int stop, u64 status),
+	TP_PROTO(int batch, int start, int stop, u64 status),
 
-	TP_ARGS(start, stop, status),
+	TP_ARGS(batch, start, stop, status),
 
 	TP_STRUCT__entry(
+		__field(	int,	batch	)
 		__field(	u64,	status	)
 		__field(	u16,	start	)
 		__field(	u16,	stop	)
 	),
 
 	TP_fast_assign(
+		__entry->batch	= batch;
 		__entry->start	= start;
 		__entry->stop	= stop;
 		__entry->status	= status;
 	),
 
-	TP_printk("start: %.4x, stop: %.4x, status: %.16llx",
+	TP_printk("batch: %.2d, start: %.4x, stop: %.4x, status: %.16llx",
+		__entry->batch,
 		__entry->start,
 		__entry->stop,
 		__entry->status)
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index c8352ffb9195..21dc0046fd9b 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -176,7 +176,7 @@ static int doscan(void *data)
 	wrmsrl(MSR_ACTIVATE_SCAN, params->activate->data);
 	rdmsrl(MSR_SCAN_STATUS, status.data);
 
-	trace_ifs_status(start, stop, status.data);
+	trace_ifs_status(ifsd->cur_batch, start, stop, status.data);
 
 	/* Pass back the result of the scan */
 	if (cpu == first)
-- 
2.39.2

