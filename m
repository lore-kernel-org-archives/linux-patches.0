Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8E113175E
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643322; cv=none; b=hED+yjF64naH098RxUHMDLU7JZRM0im8NdPgqf7SBS1Y2G/qsL18sYwETkYtWPWVt8YVWh8y2/OsILd4wQNk9OWPxEMNplllSaQT4x3Z6rORPOW+3ap3e0kbBKa0U820Y3pYbm4D8HRZtaMEiMuih08sQHsBLqQVgyv8GdnyPEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643322; c=relaxed/simple;
	bh=xXGsSwUGJv8u8+15mKqC9kFQ7leMnNCPWaElrpBEOfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkVrSwZOU0pzc9y9AtSqkb3U6UmwsKPpK+NApbx6CHO/p+txdkv9/82ulkW9ggp2LyKgzU9p87KsYLDaA+QH9xYwrBqt5KvzL1tfYOHGurPcOMczx2DlfbNhH3/a4LDeY0FwdJQO0DBfFD7zS+vYGGmIA20GJQRFqN1rj4A9wRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JWz56nOS; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JWz56nOS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643318; x=1743179318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xXGsSwUGJv8u8+15mKqC9kFQ7leMnNCPWaElrpBEOfk=;
  b=JWz56nOSoJyZGXf3WOsvVdFVu5HMpmLL0a7/yRq00PZShuIVRuLczivC
   PbQJ5BkH265dxYjm1zu1cSqTJWRtakFWb5p5EV0MUy7x2yAVSL2dE/rxd
   60Qf0z7OrzIl0WPaWxn5UPXS5T4FzRYAjt/gHWReEbWhju6IC6YQVNq2W
   Yol1gLHcwe3CeveDWa7RwjVH31/+3Y79kFDCNdJVgKVJ0VT+dAqy425gy
   qmjr0c8V5b56eXyKorSmepQymM5N4saAqG8EB+rU1deoN16NanpkQPEuH
   JefPbGjARQyDFbJ6p20fV2Ul6siasWV3H81VFjDViw+LLKgA6e3Q8cUoB
   A==;
X-CSE-ConnectionGUID: U1/EpQbZS/SEUOEoXn1tlQ==
X-CSE-MsgGUID: 1FX61jWDSfuj1KLkTym5sQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294801"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294801"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726180"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:24 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 68/74] x86/cpu/vfm: Update arch/x86/platform/intel-mid/intel-mid.c
Date: Thu, 28 Mar 2024 09:28:02 -0700
Message-ID: <20240328162820.242778-68-tony.luck@intel.com>
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
 arch/x86/platform/intel-mid/intel-mid.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 7be71c2cdc83..8b8173fb0a43 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -22,6 +22,7 @@
 #include <asm/mpspec_def.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/cpu_device_id.h>
 #include <asm/io_apic.h>
 #include <asm/intel-mid.h>
 #include <asm/io.h>
@@ -55,9 +56,9 @@ static void __init intel_mid_time_init(void)
 
 static void intel_mid_arch_setup(void)
 {
-	switch (boot_cpu_data.x86_model) {
-	case 0x3C:
-	case 0x4A:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_HASWELL:
+	case INTEL_ATOM_SILVERMONT_MID:
 		x86_platform.legacy.rtc = 1;
 		break;
 	default:
-- 
2.44.0

