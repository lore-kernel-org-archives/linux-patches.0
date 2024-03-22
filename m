Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B05241C6A
	for <patches@lists.linux.dev>; Fri, 22 Mar 2024 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711124258; cv=none; b=foRwJhOEoSRqlTv0Uo8mSV02qWB2jUQGMK5m8/3CQ40PVuI+cmfdxA0Xj1ZiPfatXi9SbdGwiIbvdUmlBO+PtESWWbhXNBgRB2a/cto3gsSM0YBZ8fILzcYcQgNOD+wzqhKI5WaFIwYXIHllwVtyyrWMvfv0h3Z+urV6p950upM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711124258; c=relaxed/simple;
	bh=T+W3SilTy8pWsd3RdVENdE7OnC2iyjXqQEYQLOJ+SZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NKpyjk+R0uoCamt+SE0yTOTqwsjTEYMKEecYv7hmFGvxatIuXwZIOjUDqDmdsiKyqo+FbbsbNOv6Md4or25YgbryI8mKbmsC35stlQG/9wv593VwRo5nQKpEgxpHRTUOsez+CZhJ8PZl5e5uVACUxmYbBncQ1spYdb2fdz0NJIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S6YN9ARP; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S6YN9ARP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711124258; x=1742660258;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=T+W3SilTy8pWsd3RdVENdE7OnC2iyjXqQEYQLOJ+SZk=;
  b=S6YN9ARPEZT7YC8W9DNKYlkMr+6Ng8Pt75uDKF7Ai3Y4DZEN0fKBJeMY
   whpkkanrTAz34qAdEUSiNAiqRUHA7Cy9snmh1BcRifiySVEcNG8gSlFe8
   3zQjqwThO4sRPjxfNSW2WH8/HcwApNJk+kfe8wTFbhg9ahBRis12HBEi0
   sPA+qeU2j4ZTIiU3CFR16K1MiVIEH0Qkbyk0Rpv4Kl2fz7NXcxLV9TQNX
   fFUJLfqNG6Fc8GIErXB9/kzJ3SyJAQm0k/vE653zn8TqAjo6KivZo+p8U
   yPrPjHEDV/8Q/baq/fNH0OdEzVI/ozI25saYObEQrkD4ucijFhaU3c5P/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="23635553"
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="23635553"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 09:17:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="15618725"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 09:17:37 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add model number for another Intel Arrow Lake mobile processor
Date: Fri, 22 Mar 2024 09:17:25 -0700
Message-ID: <20240322161725.195614-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This one is the regular laptop CPU.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index b65e9c46b922..d0941f4c2724 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -127,6 +127,7 @@
 
 #define INTEL_FAM6_ARROWLAKE_H		0xC5
 #define INTEL_FAM6_ARROWLAKE		0xC6
+#define INTEL_FAM6_ARROWLAKE_U		0xB5
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
 
-- 
2.44.0

