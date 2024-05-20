Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7C613B7B3
	for <patches@lists.linux.dev>; Mon, 20 May 2024 22:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716245210; cv=none; b=FVyU9Ni+ODxNSZE3GOO4ieJ8GScUUzF2SHYybzNHYbCyyYnmG0rkEzZ5LDMQ7GV3RNCdSS/hMh0IHB96nFumjrjK20HZOEQbR1tCJvLOHend4iWSH0bRtaVg98ncUXVI69JkP1BFWbk4yHh5FHzlizM4ceOJs5SRtpGuXV+z83Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716245210; c=relaxed/simple;
	bh=3WkOU6MGepSbNzlZYklRMkoGMRR4hELasBxQk7ecM/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG020iv2fesPs07ptk9YconZz1b//v4subjYLLMK8mBK8F6w2N75knISMLgSUNRqF6r6jDZfyLdPeLJHriRMKxhZnBYTBcMN6nfejAAOaBZ5K2u7ZCstjZnWndUm6EK99uOe7sKXhtIZFQPDBLcIvjT8hgoOB9bLS+vdooYMWuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GTSJygzv; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GTSJygzv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716245208; x=1747781208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3WkOU6MGepSbNzlZYklRMkoGMRR4hELasBxQk7ecM/M=;
  b=GTSJygzvDHHjCW97TyjwgVPk+Kjdr3un2z/iesNlg8lZplPnYSYwuEkr
   6w8kItCExa6rT9nHvh/IRUTZKL018Wu5POZyPTWGmcNqXAin4o603uj6e
   joLsdUCk0H+/lGL9jPwfyqdbCLJueCLbmGIA9fYHvKN54DzUBrT/WkGmd
   X4PGcM5EYUbqDP/V4WERrHmhl2vSmbl+jHhj3W0k9HdvAlw6REBTAyOYr
   7rozdJ/tcm3ipyyD6Gz0PG1pRR+kH7TgMJQB4qgYhygQ/Rg23r4OQD0Lf
   xGxkyQ1Sm/6eSD14deCl37Bji6lXMa8XWPJN5zQjWOgQ6JzFMhoBgoQom
   w==;
X-CSE-ConnectionGUID: 7PNE+oAlQrqp1a1+WhgTnA==
X-CSE-MsgGUID: ey25gafVR2SId2YdhRc/Uw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12199803"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="12199803"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
X-CSE-ConnectionGUID: jFJhqsSdRmmykK9g8P5rJQ==
X-CSE-MsgGUID: 8mxoelrKRayXkmN67REZ2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32593463"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:46:38 -0700
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v6 27/49] crypto: x86/twofish - Switch to new Intel CPU model defines
Date: Mon, 20 May 2024 15:45:58 -0700
Message-ID: <20240520224620.9480-28-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>
References: <20240520224620.9480-1-tony.luck@intel.com>
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
 arch/x86/crypto/twofish_glue_3way.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 90454cf18e0d..82311249048f 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -12,6 +12,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include <asm/cpu_device_id.h>
+
 #include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
@@ -107,10 +109,10 @@ static bool is_blacklisted_cpu(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return false;
 
-	if (boot_cpu_data.x86 == 0x06 &&
-		(boot_cpu_data.x86_model == 0x1c ||
-		 boot_cpu_data.x86_model == 0x26 ||
-		 boot_cpu_data.x86_model == 0x36)) {
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_ATOM_BONNELL:
+	case INTEL_ATOM_BONNELL_MID:
+	case INTEL_ATOM_SALTWELL:
 		/*
 		 * On Atom, twofish-3way is slower than original assembler
 		 * implementation. Twofish-3way trades off some performance in
-- 
2.45.0

