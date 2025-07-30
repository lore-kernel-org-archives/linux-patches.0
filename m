Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359302DC327
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753887892; cv=none; b=TvI9/t2dzR8gALQ61x8djVcGSesTAHOoGWCbf3sam62lAlhUlr1KouxwVLd0WVmlJ/Dn2HyZLiBIlSbfILxFslZge3lcrXuix/d3bB+0//It/MlkHnFyJB/3u1Y1/FePuKMPmC0vVGmEXH9zzyqZHQ9k+y8V1fRAG8t3QV9I2l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753887892; c=relaxed/simple;
	bh=IFeN1OhhFn+3eLasZljCENSXgJDuLKu4+TIi644UZ6c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MQC87UQF7aey0Sl5XznGC6DfgI2IPcrGbSn0y1iW4jPtqxhkwcp2cMkfwoe92HHSoz+xXU07CTw0JJS9FYvSVXKWMl+YeHZbYZnbAoMJcIaidgkUIarZQlL8xG3+IaXN/mfCzni52+DYEJv8WUpUbfXfy9WPr4L5xdMObXHgZSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e0I9aSxs; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e0I9aSxs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753887890; x=1785423890;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IFeN1OhhFn+3eLasZljCENSXgJDuLKu4+TIi644UZ6c=;
  b=e0I9aSxsdLhJ82XRQU3cUex9oEvN5V5akH9jrcl6jRtJB7h8/P4QyEPD
   Pwgs3ZmELyaY5mMs/klpplzWkcivJi+FOz6rwTq7JCd7ZX8ZJnxY7mpw5
   K4NVlPSCswk+c4C2yW+Q7dev9RsSYhS3COZkwQxMpU+8S/GBw2OBn8mCH
   dl7vkV0pkaSKSz78Z7CYnS8HjRZ/k9Lpt5LHBSEXAZ3WqwlPJQpdWNzs7
   VIuLEK7GlCf19PA7x6LudNhzpjVxj9Jnzk0dWDssI6QWsV5FIAv13TFlk
   fClsOjSIPpYOEgAhQ5OggGe1vBvRPZJuQ8cDC3PbEoKUr2uvFfyIiQpGJ
   A==;
X-CSE-ConnectionGUID: EXPsthyWQKWu8TPpR2LSVg==
X-CSE-MsgGUID: vXlELR8hSPm9yWrfoDjM2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="56062163"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56062163"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 08:04:50 -0700
X-CSE-ConnectionGUID: yCpgktWgRVafhil8fBGXeg==
X-CSE-MsgGUID: kpe1VNXjTi2g2YUMZUJFRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="163352600"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.223])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 08:04:50 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add CPU model number for Wildcatlake
Date: Wed, 30 Jul 2025 08:04:37 -0700
Message-ID: <20250730150437.4701-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wildcatlake is a mobile CPU.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index be10c188614f..5367dcbf5b30 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -150,6 +150,8 @@
 
 #define INTEL_PANTHERLAKE_L		IFM(6, 0xCC) /* Cougar Cove / Crestmont */
 
+#define INTEL_WILDCATLAKE_L		IFM(6, 0xD5)
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_ATOM_BONNELL		IFM(6, 0x1C) /* Diamondville, Pineview */
-- 
2.50.1

