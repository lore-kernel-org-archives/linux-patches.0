Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2621C17B4FF
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982515; cv=none; b=Ed3c0zz6eqGe8nIz015HAnv0xV2m1T+CfYE0P6yX6h5RxZjnlqEq6phfn6wPpVbJ3WO+Uw5D4H4UR/I5XKEmeaU04QyPZ0ZfCBILjE/d1sBNMFFwE7pwGLLxWSwc92ovSybDUniQILfyAccENK9NnLjbTJKXji1WJWl/i78v6e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982515; c=relaxed/simple;
	bh=Cso0970iBLZBpku05aR/BgRRak+5ImAGQIo7igDchxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3v6k8S7+Ypwt/ksxtpvEBG5rRUFnaHOpTyPIl3bruhD4nYkbdfuNvl34QF9YRsshI7srUWcLqmTKtsTub5mmoI+1VxekTTgSe9YSrq8dREd+vNrX4axXMDvHsheVFgCMpuJsrgMKTFAdmr0H3CWJ7TxWxX1apd7Y0IMSiJX09g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dIyQRkLv; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dIyQRkLv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982514; x=1745518514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cso0970iBLZBpku05aR/BgRRak+5ImAGQIo7igDchxw=;
  b=dIyQRkLv8TYgCqEVtHsb9Ev/HX4imTtqSt/VdVYDihtrr6bfWhGbIBM2
   elveqJQV4+ZKctHMN2zFbozZQFasvndlnLy15VMAWUr0dkbkd/4f28sFD
   wpzI9G8yEjt206fOWWln65j66pFM10cZZH1Q7ziy7Fm2zNx91bJZ2/KVl
   yRDsvaLzo9tTg0aZHRI4qzqmzhvf1FbdrPs0DDZ0i6rlXFHPlEWoHpw9L
   DRjUs2IQNXcdIqZEyp97w0EiZXmOqs3256XFbl8WKFbtoihq0ehLUos8Y
   Pmt7d/wra1cFAdkSsuo2RJHKMw0SUQdq8mKZmL7RwFwkp8Qkp435DAu2R
   A==;
X-CSE-ConnectionGUID: VJsLM1BPRYqxteuf2LlNCg==
X-CSE-MsgGUID: Mt0KZCA+TSO/KSokbOxJlA==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9481897"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9481897"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:02 -0700
X-CSE-ConnectionGUID: iOx5Qyl8QySbjZH69dcisA==
X-CSE-MsgGUID: ykNmD1OOReqb0Xu6qi2FvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="29262662"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:15:02 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 22/71] perf/x86/intel/uncore: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:15:02 -0700
Message-ID: <20240424181502.41576-1-tony.luck@intel.com>
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
 arch/x86/events/intel/uncore_nhmex.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_nhmex.c b/arch/x86/events/intel/uncore_nhmex.c
index 92da8aaa5966..466833478e81 100644
--- a/arch/x86/events/intel/uncore_nhmex.c
+++ b/arch/x86/events/intel/uncore_nhmex.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Nehalem-EX/Westmere-EX uncore support */
+#include <asm/cpu_device_id.h>
 #include "uncore.h"
 
 /* NHM-EX event control */
@@ -1217,7 +1218,7 @@ static struct intel_uncore_type *nhmex_msr_uncores[] = {
 
 void nhmex_uncore_cpu_init(void)
 {
-	if (boot_cpu_data.x86_model == 46)
+	if (boot_cpu_data.x86_vfm == INTEL_NEHALEM_EX)
 		uncore_nhmex = true;
 	else
 		nhmex_uncore_mbox.event_descs = wsmex_uncore_mbox_events;
-- 
2.44.0

