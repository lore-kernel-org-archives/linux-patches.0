Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A41E13C9AF
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302413; cv=none; b=HIuA8Pd82q5tHSPd9no5oMQkgUv2/xXNxw3M0PvtVfXrsThd2XrpDumpac2axffrZEfQERBfkuD0jzgPkiHHdKKLtQVMXsBGb4zm4mSHSi9lalHiMPop7+gQeHmniwxJk1pRdGUS+ZtNeq2NlOk7cmDcmXPhoIyVAVZ+4C3fzMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302413; c=relaxed/simple;
	bh=MGAFX/pQ0txb1l1dIq0DhSgBPKYTlahDlBrDWyImM3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHLoXpj2B93Bq8u0wx6cv0UkCxSO4O2hqImaqyZMFbrVADxC4Ujaj4brnnJ1/VfA1vf3HBRaDnS1aLk+mFtJ7kuQoCxXKUDD9cOAljfvdQo4yzVavDS72QlYvbwUr3pEK2dLcof2vGosvcuuU8D8bkRoEyiILOFs/HE54TNtaY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J60imUnt; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J60imUnt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302411; x=1744838411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MGAFX/pQ0txb1l1dIq0DhSgBPKYTlahDlBrDWyImM3Q=;
  b=J60imUntcIhNfuZtJYopf38WekuzTTgmfyxzbUNfvWPP0D64ZSwuz7gJ
   iCRrf67KQmy2Sssx664+/v5Y8dThTxgiC0hZK6lXddZ4F3zQKx3J3YSHo
   fQsmMN/Ce7vjEhT4r6AS6z6w0YaQkOXDn2swuLGLwYsefWkojewOD2z+z
   RHGnbVn4o/wfJ/oI3eFPOvkuGORFfXIMhuAxg7vq8Wz710kP5IKEoQQSu
   uvA7rShMwTmiQ4cJGmKPptFMCk/rD9eT3jg/Q74Lonn7qXVuv7lzdezXg
   xgYwWAduKTbbHVyoT8ZFeKfY8aPm3Ed9D5peZHGKZqQ3+c+0Fc+jo3Qnq
   w==;
X-CSE-ConnectionGUID: noSTxjy9TtO2Gascj7hbvA==
X-CSE-MsgGUID: YCHJ4sGgTZ26d2hmnKkEEg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914796"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914796"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
X-CSE-ConnectionGUID: jJhUFNV0TXWPBYnGE9mawA==
X-CSE-MsgGUID: nzYOSGRJRrGUEhXD/tAq2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871983"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 27/74] x86/cpu/vfm: Update arch/x86/kernel/smpboot.c
Date: Tue, 16 Apr 2024 14:19:29 -0700
Message-ID: <20240416211941.9369-28-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416211941.9369-1-tony.luck@intel.com>
References: <20240416211941.9369-1-tony.luck@intel.com>
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
 arch/x86/kernel/smpboot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a58109583c47..8dc83b16845b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -438,9 +438,9 @@ static bool match_pkg(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
  */
 
 static const struct x86_cpu_id intel_cod_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X, 0),	/* COD */
-	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X, 0),	/* COD */
-	X86_MATCH_INTEL_FAM6_MODEL(ANY, 1),		/* SNC */
+	X86_MATCH_VFM(INTEL_HASWELL_X, 0),	/* COD */
+	X86_MATCH_VFM(INTEL_BROADWELL_X, 0),	/* COD */
+	X86_MATCH_VFM(INTEL_ANY, 1),		/* SNC */
 	{}
 };
 
-- 
2.44.0

