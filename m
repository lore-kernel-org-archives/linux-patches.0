Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B1914D6FB
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943048; cv=none; b=qKLTqos/IjuFta1ReVWZRYG08kHyOX5QaNuzcs1BnnoP71bhTyL+Dc3w8Q7Zozki1E5zi7qDKK6rOrm/IRMMuLVwXvi8zAOO9xZzlnDMjSaxHGUTxIkcoIm/QsFk0y3zOHRac8UPcIrvm6U+DIGR9pp3h71QP7nv5i07102SVjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943048; c=relaxed/simple;
	bh=j6VXfKkHgF7ZyzHZ2Ll+dz8fG0uzNqJxRFoI19lkgis=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IxKBsguUzHT9LEHFwRn3Ye/Ji1zOLJ/8rIipDGHSLZXsCY3Z3daW1V8wIH25lJ+SBsMR1PvXYnl9fSKjUeDpdURg6yI/fgXJVU0OTaHMFnE+5EPNe/vYmbsr/s+hxXZc+KgLXm23zncPHPH1KgzC2iYa0HyXgU+DhXC4w5+fKlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJ0ILenp; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJ0ILenp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712943047; x=1744479047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j6VXfKkHgF7ZyzHZ2Ll+dz8fG0uzNqJxRFoI19lkgis=;
  b=aJ0ILenpXflygYPATNyjwNaZxCUNGcyqEEA6CAWFDNEehFEHsfQLug/E
   csrakJAwY9cHAUeP3/CXa/B1KIcmYFDEwUhnWBQwEKFXFCHm6dhYy6NK1
   tCCxU5IHRdb3y5nT2t3JzGQsDEAGe091KtMDgBifqYFUypHlzIArdkEt6
   XcQWaLcCxR6qaWq6VDGXnFGI9+1ZBkJ6cM3Qe5zQleu8eqcxCyuSggfCk
   K6kO8FQ/FdjaxmaCV50AWoxzzfAqZuT3mon7YDqRLcIBrnaFWYIXFQRrU
   fCgbllg41MIMolrSnienAAn1+1ITbG6nT80BzLPdRDZhS+IjQmSqh8hzQ
   A==;
X-CSE-ConnectionGUID: 5NsmGd37TNqWL2AaJB3w/Q==
X-CSE-MsgGUID: 8ouNk4SfRaGXOLOXuqVAqg==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="11365684"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="11365684"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:30:42 -0700
X-CSE-ConnectionGUID: UuBykGrERsmnkS9tg+FQhA==
X-CSE-MsgGUID: 03gP47ICSL2Vn6ax703TzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="21780772"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:30:42 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: ilpo.jarvinen@linux.intel.com,
	hdegoede@redhat.com,
	markgross@kernel.org
Cc: linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	sathyanarayanan.kuppuswamy@intel.com,
	ravi.v.shankar@intel.com,
	patches@lists.linux.dev
Subject: [PATCH 1/3] platform/x86/intel/ifs: Classify error scenarios correctly
Date: Fri, 12 Apr 2024 10:23:47 -0700
Message-Id: <20240412172349.544064-2-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240412172349.544064-1-jithu.joseph@intel.com>
References: <20240412172349.544064-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Based on inputs from hardware architects, only "scan signature failures"
should be treated as actual hardware/cpu failure.

Current driver, in addition, classifies "scan controller error" scenario
too as a hardware/cpu failure. Modify the driver to classify this situation
with a more appropriate "untested" status instead of "fail" status.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
---
 drivers/platform/x86/intel/ifs/runtest.c | 27 +++++++++++++-----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 95b4b71fab53..282e4bfe30da 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -69,6 +69,19 @@ static const char * const scan_test_status[] = {
 
 static void message_not_tested(struct device *dev, int cpu, union ifs_status status)
 {
+	struct ifs_data *ifsd = ifs_get_data(dev);
+
+	/*
+	 * control_error is set when the microcode runs into a problem
+	 * loading the image from the reserved BIOS memory, or it has
+	 * been corrupted. Reloading the image may fix this issue.
+	 */
+	if (status.control_error) {
+		dev_warn(dev, "CPU(s) %*pbl: Scan controller error. Batch: %02x version: 0x%x\n",
+			 cpumask_pr_args(cpu_smt_mask(cpu)), ifsd->cur_batch, ifsd->loaded_version);
+		return;
+	}
+
 	if (status.error_code < ARRAY_SIZE(scan_test_status)) {
 		dev_info(dev, "CPU(s) %*pbl: SCAN operation did not start. %s\n",
 			 cpumask_pr_args(cpu_smt_mask(cpu)),
@@ -90,16 +103,6 @@ static void message_fail(struct device *dev, int cpu, union ifs_status status)
 {
 	struct ifs_data *ifsd = ifs_get_data(dev);
 
-	/*
-	 * control_error is set when the microcode runs into a problem
-	 * loading the image from the reserved BIOS memory, or it has
-	 * been corrupted. Reloading the image may fix this issue.
-	 */
-	if (status.control_error) {
-		dev_err(dev, "CPU(s) %*pbl: could not execute from loaded scan image. Batch: %02x version: 0x%x\n",
-			cpumask_pr_args(cpu_smt_mask(cpu)), ifsd->cur_batch, ifsd->loaded_version);
-	}
-
 	/*
 	 * signature_error is set when the output from the scan chains does not
 	 * match the expected signature. This might be a transient problem (e.g.
@@ -285,10 +288,10 @@ static void ifs_test_core(int cpu, struct device *dev)
 	/* Update status for this core */
 	ifsd->scan_details = status.data;
 
-	if (status.control_error || status.signature_error) {
+	if (status.signature_error) {
 		ifsd->status = SCAN_TEST_FAIL;
 		message_fail(dev, cpu, status);
-	} else if (status.error_code) {
+	} else if (status.control_error || status.error_code) {
 		ifsd->status = SCAN_NOT_TESTED;
 		message_not_tested(dev, cpu, status);
 	} else {
-- 
2.25.1

