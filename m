Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BBB17BBB
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 08:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171007; cv=none; b=mni/GN4O/B/PkfvBEOmg3RvgCpjKA0wlSjKnw4Kwfahj22kucQIAS7sVqT/OGhzClxZLpnW1BzHJeHBFwL0/cDS9srypbRgT99uqNV4RSYVhgMqFZ67HZX3IliSS6Wqnc66+yzTj9q/55I75YIpV/mjlXug9cDxwI92B0ilYF2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171007; c=relaxed/simple;
	bh=DgRKwx7erCsCqZ7Amarz6wtLdWuV8+Tw6mXgX2EWNu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IJgqAfChSyPcfEO4odf/Ywj+SGIfaqwTuoIenjXPKbm38J/WwGI+gwOwmKdJ84To5hkuNL/bTxKdgWd8P6q7lY1pugcJN0xWK2kCQAMbAdJms3Q3B4cz6ZwWYqofnKWQvnriGUdFUrjU0XccM8RqsGW0uTepLWnW+z0T3sF1zRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jhNnIw+V; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jhNnIw+V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706171007; x=1737707007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DgRKwx7erCsCqZ7Amarz6wtLdWuV8+Tw6mXgX2EWNu4=;
  b=jhNnIw+V8OJ5vI/Tp39R6RF+o/PWUDUWlUA1IA11E4QfxgZcB/tth/Ki
   bq5aoxotzgAgP6SzarSypt1+bczH4eXvIlf0+m+VRIR8wlug/YOaCpUK/
   RE7m8rHDdAMc9OVKN+89rOLsYAoNYZRqnOOF7wsEpBMjnhfdEqvUvElex
   tHJDKLPMJxF8W5Qn5RgVr8g29IIOSg/jyGTapgPe7duW2dt411cHyGFOf
   TZv9ARe8Hvlc7CVP4uQYD8GxO608lIzmVGj0mRPwCRufgmHmMrbAg7CPE
   t/Gil2v4/IfPDWbgEn2a+ItFDHnYDr11uyCGFZB6LomRy2ja2/RZ0a5W6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="1987189"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="1987189"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 00:23:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="876975935"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="876975935"
Received: from araj-ucode.jf.intel.com ([10.23.0.11])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 00:23:24 -0800
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
Subject: [PATCH 5/5] platform/x86/intel/ifs: Add an entry rendezvous for SAF
Date: Thu, 25 Jan 2024 00:22:54 -0800
Message-Id: <20240125082254.424859-6-ashok.raj@intel.com>
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

The activation for SAF includes a parameter to make microcode wait for both
threads to join. It's preferable to perform an entry rendezvous before
the activation to ensure that they start the `wrmsr` close enough to each
other. In some cases it has been observed that one of the threads might be
just a bit late to arrive. An entry rendezvous reduces the likelihood of
these cases occurring.

Add an entry rendezvous to ensure the activation on both threads happen
close enough to each other.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/runtest.c | 48 +++++++++++++-----------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index e3307dd8e3c4..95b4b71fab53 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -140,6 +140,29 @@ static bool can_restart(union ifs_status status)
 	return false;
 }
 
+#define SPINUNIT 100 /* 100 nsec */
+static atomic_t array_cpus_in;
+static atomic_t scan_cpus_in;
+
+/*
+ * Simplified cpu sibling rendezvous loop based on microcode loader __wait_for_cpus()
+ */
+static void wait_for_sibling_cpu(atomic_t *t, long long timeout)
+{
+	int cpu = smp_processor_id();
+	const struct cpumask *smt_mask = cpu_smt_mask(cpu);
+	int all_cpus = cpumask_weight(smt_mask);
+
+	atomic_inc(t);
+	while (atomic_read(t) < all_cpus) {
+		if (timeout < SPINUNIT)
+			return;
+		ndelay(SPINUNIT);
+		timeout -= SPINUNIT;
+		touch_nmi_watchdog();
+	}
+}
+
 /*
  * Execute the scan. Called "simultaneously" on all threads of a core
  * at high priority using the stop_cpus mechanism.
@@ -165,6 +188,8 @@ static int doscan(void *data)
 	/* Only the first logical CPU on a core reports result */
 	first = cpumask_first(cpu_smt_mask(cpu));
 
+	wait_for_sibling_cpu(&scan_cpus_in, NSEC_PER_SEC);
+
 	/*
 	 * This WRMSR will wait for other HT threads to also write
 	 * to this MSR (at most for activate.delay cycles). Then it
@@ -230,6 +255,7 @@ static void ifs_test_core(int cpu, struct device *dev)
 		}
 
 		params.activate = &activate;
+		atomic_set(&scan_cpus_in, 0);
 		stop_core_cpuslocked(cpu, doscan, &params);
 
 		status = params.status;
@@ -270,28 +296,6 @@ static void ifs_test_core(int cpu, struct device *dev)
 	}
 }
 
-#define SPINUNIT 100 /* 100 nsec */
-static atomic_t array_cpus_in;
-
-/*
- * Simplified cpu sibling rendezvous loop based on microcode loader __wait_for_cpus()
- */
-static void wait_for_sibling_cpu(atomic_t *t, long long timeout)
-{
-	int cpu = smp_processor_id();
-	const struct cpumask *smt_mask = cpu_smt_mask(cpu);
-	int all_cpus = cpumask_weight(smt_mask);
-
-	atomic_inc(t);
-	while (atomic_read(t) < all_cpus) {
-		if (timeout < SPINUNIT)
-			return;
-		ndelay(SPINUNIT);
-		timeout -= SPINUNIT;
-		touch_nmi_watchdog();
-	}
-}
-
 static int do_array_test(void *data)
 {
 	union ifs_array *command = data;
-- 
2.39.2

