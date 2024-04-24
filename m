Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9154E184132
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982529; cv=none; b=GWv5gFlrA5OCgbnQzmjn/Vj6SMgSRec5JuAxWwjxlCY82Ntafe8IiYuJUHjVN++/P/UM0kHe6puy4w77BtbtOCnMJpbX52WyofeRTpyNT0tdtAvkRTkoFHPUEsemZOSFiX1kvGClfE2ANXQselFrtTWWPl0zaYM0XxMZxSkmEnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982529; c=relaxed/simple;
	bh=FfXHVVXxAXvXhf26U3fzvKJ4+8iaBCg597mpHe5hnu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwRFSVlIubQiqgvJGDyFQOoxZm6ioRqJLhaW8HHVZAMcvqkTyVpaN9JyjAAcLmzjsZCFXlrStg39dK84xEyMDYKY+I0tRlrLHEnEfjist7aXBxE/5VduL37W3jg0HSc01jrItEO9ZuVoVAHEzh57ZSKLBzZY4aVMGx4xo9Ciuo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hgXn7qCD; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hgXn7qCD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982527; x=1745518527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FfXHVVXxAXvXhf26U3fzvKJ4+8iaBCg597mpHe5hnu0=;
  b=hgXn7qCDc0h3IBLXPb6FA93obqeikFDXKFQSm6p9EXctEoOc6Onohrj3
   pSIKMJvAGubAiW+zzRrwD3z0bL1oogeIMMZ/lPBPsfPiNNwMSz3pQuCbP
   SbtSTCjts5q4HdahIorzaUdmu0mtcT3SQHBdh5u+vEq9MzQDodJhCAT4x
   o4YZaYgI6DyKguzPtK04o4/ZtwIKxXyp848BT4nDPuQLLPjd5EUal3sSn
   OwSSXPhnEhYVJVIvzIES58wfmp/nqFVgaeNvLG4iceyzq8Ts8UIB6Mejw
   Qdr8PRMKScLZspGMZxB5vgB7tf1ERuYEcoHWdRNUKPA54edPsPnGz42oh
   w==;
X-CSE-ConnectionGUID: 3p8Hf0+CSvW2UJfKyQhXBQ==
X-CSE-MsgGUID: 9LC0+7kMTeCiLcx4KJQkdw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9482082"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9482082"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:19 -0700
X-CSE-ConnectionGUID: bO0fFlafRrua07hw4U++9g==
X-CSE-MsgGUID: WU2AeidrSl6GnEj/OycV3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262793"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 41/71] x86/mm: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:18 -0700
Message-ID: <20240424181518.41946-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
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
 arch/x86/mm/init.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 679893ea5e68..fadc3fc3ee41 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -261,21 +261,17 @@ static void __init probe_page_size_mask(void)
 	}
 }
 
-#define INTEL_MATCH(_model) { .vendor  = X86_VENDOR_INTEL,	\
-			      .family  = 6,			\
-			      .model = _model,			\
-			    }
 /*
  * INVLPG may not properly flush Global entries
  * on these CPUs when PCIDs are enabled.
  */
 static const struct x86_cpu_id invlpg_miss_ids[] = {
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE   ),
-	INTEL_MATCH(INTEL_FAM6_ALDERLAKE_L ),
-	INTEL_MATCH(INTEL_FAM6_ATOM_GRACEMONT ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE  ),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_P),
-	INTEL_MATCH(INTEL_FAM6_RAPTORLAKE_S),
+	X86_MATCH_VFM(INTEL_ALDERLAKE, 0),
+	X86_MATCH_VFM(INTEL_ALDERLAKE_L, 0),
+	X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_P, 0),
+	X86_MATCH_VFM(INTEL_RAPTORLAKE_S, 0),
 	{}
 };
 
-- 
2.44.0

