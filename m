Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19913CA9E
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302413; cv=none; b=JtOuzKscgYJCafHb3EYMQXgGnNol4VuODjwtRXOXwOo+pX+wFzSjIekwWUMZSrS4UOEyEdqjLSOMD7xstEU4DX7chnx1OnMHSzWU8WwHjq8m+BW0EJknQfxZN/JYDnA+ibYxQvnD4ILlZ+V0pP7AtuiTHTPkM6bTqFB6r+1KpTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302413; c=relaxed/simple;
	bh=8M2SFiR0eeJoB2hyu0DFxRJsXGAe0l8jRLt1CWXdxW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzsVHe/W8/tUNWzWaiIL/a6epZShxTeSbX/nTq08reJntEyWMSwt+p1JJGCoO24YpVkkeBjlrTIZ+RcQleujjQzW11FafeD6W+/dmtPEwaeAuvOXqa9iWx7BmzHhWKzJGe7wose3ezB9jz7jdu8edPkhZu1xbAg7JkTk3ueye+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RDQoqMJq; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RDQoqMJq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302411; x=1744838411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8M2SFiR0eeJoB2hyu0DFxRJsXGAe0l8jRLt1CWXdxW0=;
  b=RDQoqMJq4pSy77UKB89nmt4EyVvAGpVBb7qXwttjN299tAL7odXeUkRC
   g6CwOkRcoxibUaGoKMEUy6nSiUAU3pQ1PaaT0puCv30lX63RVqTtAI4Kx
   Oh7bftI35uRSwI1sQ/u7OjJVs/Ic25X3Anjlt6hPgxXP10rKo6OYeZBSb
   sT3U69wlm8CwbJDbPAD5yomtkbg60jEwgu8XjYjJ9wNaEKKNGU3eG+8OU
   ggrXKBuo9yR1VEiU3wKDgBZy8DHpKOoSrwWzRCzCrIO8P9tCITXhbO8fJ
   QXpw95fDocGtxuS8/dbTIR5oqXZXFtu6ar+Bv9wKkdX+WcpBdlfgvMgC2
   Q==;
X-CSE-ConnectionGUID: ybmlvvGdSQaSOnSTWY8UOA==
X-CSE-MsgGUID: RNhJ7YeESc+6I8F+nuEwZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914801"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914801"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
X-CSE-ConnectionGUID: iND14f7QToa7on9st+VdjQ==
X-CSE-MsgGUID: 6rz3qIp8TzWCVNBgXrPYcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22871991"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:01 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 28/74] x86/cpu/vfm: Update arch/x86/kernel/tsc.c
Date: Tue, 16 Apr 2024 14:19:30 -0700
Message-ID: <20240416211941.9369-29-tony.luck@intel.com>
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
 arch/x86/kernel/tsc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 0f7624ed1d1d..a0ad786b4aac 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -26,6 +26,7 @@
 #include <asm/x86_init.h>
 #include <asm/geode.h>
 #include <asm/apic.h>
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/i8259.h>
 #include <asm/uv/uv.h>
@@ -682,7 +683,7 @@ unsigned long native_calibrate_tsc(void)
 	 * clock.
 	 */
 	if (crystal_khz == 0 &&
-			boot_cpu_data.x86_model == INTEL_FAM6_ATOM_GOLDMONT_D)
+			boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT_D)
 		crystal_khz = 25000;
 
 	/*
@@ -713,7 +714,7 @@ unsigned long native_calibrate_tsc(void)
 	 * For Atom SoCs TSC is the only reliable clocksource.
 	 * Mark TSC reliable so no watchdog on it.
 	 */
-	if (boot_cpu_data.x86_model == INTEL_FAM6_ATOM_GOLDMONT)
+	if (boot_cpu_data.x86_vfm == INTEL_ATOM_GOLDMONT)
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-- 
2.44.0

