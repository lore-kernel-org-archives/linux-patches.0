Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD66C1CD1B
	for <patches@lists.linux.dev>; Tue, 21 May 2024 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716307812; cv=none; b=jcCmNIrulTZyXwG573+7IRmcZwOZIa6zezhnAARLAj3R/eFtWST+9HAJGzxqzNY6OdqHPteNZsuxebYPD/FKLv4Z1t4g3xt2gjEYSs/pBxrhEYTSATVwg6L0AWxz6lmQ6BNDzCB/cCus7HTPKP/+dSeQQfHvLeuqgKBHCN0H6Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716307812; c=relaxed/simple;
	bh=68M2NDRggCs0VFE9AYWoncMfFrGsX4y4CaXof55Z9lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BENtRuRiKFWqbKQQBxDAE6KHrUVQTxFF7rEP3sBbKXAnFMSP9A5GFD1VOb6BqkPY69325Qz4Uc2cgeyxAw3I4apbPQmAsbIBduEKsnXR1Y7OCvVR1GP850VYHrgp1/NfD4WIjNgjsAu9QdVYXB9oDK9dJn1nbkiO84hr1n82WPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iH22YBEn; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iH22YBEn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716307811; x=1747843811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=68M2NDRggCs0VFE9AYWoncMfFrGsX4y4CaXof55Z9lY=;
  b=iH22YBEnb+PRB7VhHisRWVd/ppgozKGHIjA9Lc98Ar94uHikSVJHP+aw
   1YXakqH7sL9mJlPbzeRzUgyAH1YofgQkrpRpnk0vroCNSqqtrUOiGBhB7
   LkQN+YNIGFYw2IJ2nE49L0S2aDATFgGfOo4ukNMrI9TAki7jy5m3T+uAK
   UDxnXbjyRuSbPSLhxQSjPgtCDxkUheGlTOaBVNsnHhhrQR7Z0ryKC3ew6
   JByO+Pme9gJ+3vMRO7Pcg8pcB0PuNBz586vZ3wVzyOX5tAdunSH6lG8CP
   2b/ro0jPeZadRjY8LiiFjOKkHTO2JrF5EhD/jxvER5P4rS4LJH+8fKmu/
   Q==;
X-CSE-ConnectionGUID: QTmcoVpfRAi5Y5O5GfXmhQ==
X-CSE-MsgGUID: dVZESAwhQAObk/kzgnsCYg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12357961"
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="12357961"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 09:10:11 -0700
X-CSE-ConnectionGUID: a8tXbICTTXeHaECMbbl+Zg==
X-CSE-MsgGUID: m5Lpxi2PS32s4xtVNbvnjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,178,1712646000"; 
   d="scan'208";a="33129766"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 09:10:10 -0700
From: Tony Luck <tony.luck@intel.com>
To: andy@kernel.org
Cc: ak@linux.intel.com,
	arnd@arndb.de,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	mjguzik@gmail.com,
	patches@lists.linux.dev,
	peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	tglx@linutronix.de,
	tony.luck@intel.com,
	trenn@suse.de,
	ubizjak@gmail.com,
	x86@kernel.org
Subject: [PATCH v6.1 16/49] x86/platform/intel-mid: Switch to new Intel CPU model defines
Date: Tue, 21 May 2024 09:10:01 -0700
Message-ID: <20240521161002.12866-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <Zkyrtgj7yQR8H-Bz@smile.fi.intel.com>
References: <Zkyrtgj7yQR8H-Bz@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

N.B. Drop Haswell. CPU model 0x3C was included by mistake
in upstream code.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
---
 arch/x86/platform/intel-mid/intel-mid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 7be71c2cdc83..f83bbe0acd4a 100644
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
@@ -55,9 +56,8 @@ static void __init intel_mid_time_init(void)
 
 static void intel_mid_arch_setup(void)
 {
-	switch (boot_cpu_data.x86_model) {
-	case 0x3C:
-	case 0x4A:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_ATOM_SILVERMONT_MID:
 		x86_platform.legacy.rtc = 1;
 		break;
 	default:
-- 
2.45.0

