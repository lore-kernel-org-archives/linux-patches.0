Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC233F8ED7
	for <patches@lists.linux.dev>; Fri, 15 May 2026 18:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778868151; cv=none; b=e/MM9d6mJTh44u3Il+f5xdWysMpyY/guYXw4/lSD4dsF4ku0RBrS6B7XFderqPD3Qtnt4n+KRSs2Kur5u/3Fqzd47oFJF74ogs2kEFi4YmuGN1mLiVKAO3yVuvTlesO3oaOd7eZ1TajdaQSzPn6zvX8sKztdSPUumDG9N8kbs1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778868151; c=relaxed/simple;
	bh=UmTfFE+A8IHNMuTFop8CJTADQ1vA8qvrVIqGodjLgHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f0i8djoolRjmWAEgZLP+cY5YvLTdthRdQYEnJ6jZOOET3JgiCA2zwU+qLy3Xb34bhpZofPIACdwrN/9GQgAmpcC6FooHyk5LAGJzk0OJZX1XTdCrXZJYCbppag6cMTnzphMxi1Fev1wORYvi4i62zlnmdNXEa4cYXD/KZk8+ivs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZfOf1v/q; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZfOf1v/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778868150; x=1810404150;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UmTfFE+A8IHNMuTFop8CJTADQ1vA8qvrVIqGodjLgHU=;
  b=ZfOf1v/qkrafPOmP9zVBkC/kOAUIDsmspqIDow1lPDerqWqhgkuA4WkU
   DQOZ9Eh9obSXspd4qtCmBiMvkQqDXSI5FS5O7aCLs76b+T54u3n+Zr+Z9
   qhbKkKLlvjVDYRSioXR/i0413hDhdYCRlSJYlwYYgY9XIs7jTDSc3u/Wv
   HbYv+VQVssGPOqtrPXUZdNUVxtoxflOIK7DvyFkwAuMnCZVGF6IYuWp8p
   FT0chHljmU69wxQRNUZKRir7ZgTWQTgAsrVOrWprf2jVKgCbYMujw9wP8
   Z17eFMiFcENCz6R+0jYRkZNR40OCkJr7OqUFZSTD+eQo7KZBIphewGnVt
   A==;
X-CSE-ConnectionGUID: Aynv9X7XQFiL0ByKmCVHCw==
X-CSE-MsgGUID: MVk6ZrZQS4SxJqk65vk01w==
X-IronPort-AV: E=McAfee;i="6800,10657,11787"; a="83443421"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="83443421"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 11:02:30 -0700
X-CSE-ConnectionGUID: Jnm4ighcQOiwUEeztoQ6pg==
X-CSE-MsgGUID: 4BYze9ERTnyc8jh9vUOy4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="237892315"
Received: from hanvin-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 11:02:30 -0700
From: Tony Luck <tony.luck@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add Intel CPU model number for rugged Panther Lake
Date: Fri, 15 May 2026 11:02:23 -0700
Message-ID: <20260515180224.13818-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Derivative of Panther Lake with P-cores and low power E-cores intended
for use in harsh environments.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 950bfd006905..66d964afe18a 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -29,6 +29,7 @@
  *		_N,_P	- other mobile parts
  *		_H	- premium mobile parts
  *		_S	- other client parts
+ *		_R	- ruggedized for harsh environment
  *
  *		Historical OPTDIFFs:
  *
@@ -151,6 +152,7 @@
 #define INTEL_LUNARLAKE_M		IFM(6, 0xBD) /* Lion Cove / Skymont */
 
 #define INTEL_PANTHERLAKE_L		IFM(6, 0xCC) /* Cougar Cove / Darkmont */
+#define INTEL_PANTHERLAKE_R		IFM(6, 0xE5) /* Cougar Cove / Darkmont */
 
 #define INTEL_WILDCATLAKE_L		IFM(6, 0xD5)
 
-- 
2.54.0

