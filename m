Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9AB8626D
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643310; cv=none; b=LtL7YGfe40PqKSJs8uSsl6OTLKOZegxibbLgOyRtUcg0Z6fnaDmy2UO54Mxlc8eXYpTd1EclbUhKTTysPmV5KQAwiDkkyJ16M6k4HtniBlOnomFqUFJsM3b/Go4Yz1gE7i9BON4fF4ca6UFVX05scLRlS1dl4RnjH6pEyo8GBU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643310; c=relaxed/simple;
	bh=PH4S/Ii609Lmbnp6CowHBve2HoFhBNoMQHmg9A/lKU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhdJWvR5VYhIU1ZFl3IblkxfZ9aOLgKbdb0uE+gsyCYxPLZ7/tVSXTUFGROoWmSvxjVEhMWEp81BTnQ3S0kzVNBvenjZrUupcBugjwwIpENVeUEGygMLzJH+tF1tJT7VEIVzvLgchJsMcMB2FHZii58Myp4Txe/zwQnn69xKvZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z8g66aIj; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z8g66aIj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643307; x=1743179307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PH4S/Ii609Lmbnp6CowHBve2HoFhBNoMQHmg9A/lKU0=;
  b=Z8g66aIjd6Kauiau8mPV1y2rO7efyUff0Uo4MGiDbJgJW6nZoQrNPlpT
   KinvVYuKrzG2pzwHMQkdN/INlMPVyH7tPqbq/DmOlpaQBpJElNvlDEQv0
   4xJOtdNwdPyT6wZKzIplTv3cKcGVbPN6p0TyF1xQeuLMwbhixdqSl0l4a
   HAKNjNpkEibI6wgWvA1X7LUHGVF9gVu8gOmaVWoPCIKphV36tSmvCS9P2
   4Z/LtkAtG99GqvI2NDJ0TFbF/sE/USNV+I75kiSD6ALGTH3iaWyR68TtW
   WkB/j4INBwJiDjGlLOjU0tWPHPbefjYp6okZG9gPp/M1JrgTHH1tBQDuh
   Q==;
X-CSE-ConnectionGUID: l/CHItH9QkyEFaXvuxCo4A==
X-CSE-MsgGUID: +iRVVWWMR0q8EfbOnIvLkw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294742"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294742"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726012"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 20/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/match.c
Date: Thu, 28 Mar 2024 09:27:14 -0700
Message-ID: <20240328162820.242778-20-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/match.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 2243083f0bc2..8651643bddae 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -25,7 +25,7 @@
  * asm/cpu_device_id.h contains a set of useful macros which are shortcuts
  * for various common selections. The above can be shortened to:
  *
- * X86_MATCH_INTEL_FAM6_MODEL(BROADWELL, NULL);
+ * X86_MATCH_VFM(INTEL_BROADWELL, NULL);
  *
  * Arrays used to match for this should also be declared using
  * MODULE_DEVICE_TABLE(x86cpu, ...)
-- 
2.44.0

