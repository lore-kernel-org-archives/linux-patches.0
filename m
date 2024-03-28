Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F05B59B4E
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711643312; cv=none; b=G+/lGOhNICJeE3fQXhHzwB8DVFH8eOEQJUGjRfQtfooYAyNulIcpoETvY3VsqqUUUW0PErsnnACQezGQjlJPlv1mHfGQLCyRTkzetCwipzLGWDzBEN+0LEJ/icxQwWWfefMPf4DZcvpN77jBWyfM01R41yefgeSpHpXaG9UcJSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711643312; c=relaxed/simple;
	bh=Cyosn7hM3IeTtbbG0GJFCApjNoIXS85OOK7GlheZX7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCpggrpyukpRDMZOsnzbL3f1RYB0c43m6INQOT1C/vzmbtQ5kQyzuv09f5OIp/0sgR+yHqvijeZ7RYKsoxlw/k8MWD2ahZlCN8PqxqGenFzSjHHQ92+k3kcc/oPTkvxvkaOViMmovmBUAQkRbYTsIU3QFqJvsO4t3TMKwE5/eAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VCRoTWbK; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VCRoTWbK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711643309; x=1743179309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cyosn7hM3IeTtbbG0GJFCApjNoIXS85OOK7GlheZX7w=;
  b=VCRoTWbK/eJSyed50DuPBdzdZ7dtlbaA2pW8I1whE+0Hg47Hzy4qDNi9
   U9ms51qVT9AfNdfo4mM+Y1nGGaWHfQjVA1CpLuYxxuK6zEcBs50UnDhrO
   WiAi1mRvWps7kT8q8h7zpVO60TqHHS2XTtkQbp3avrh+zXEbNf2rQTjQZ
   BfEEMcemRVbFX+zfR+rgCA8hUjF4nYbEJMUUJx8ESPTYFZYWHIDoWuZzb
   IDjIS4tpvNj4Us3vhUYBoNHSeXuQr2ArvDPcLcTFqi9S/MszxCTvcUxs9
   dRZtCBoYnDXlTS6zaoP6zDUzwVUGNecYY+EHWNowhrBZHlFKD+bHPzlVN
   Q==;
X-CSE-ConnectionGUID: H+dXfDY2QrmwqOA6m7O1CQ==
X-CSE-MsgGUID: LuqrDsO+TriWPK69KS7X+A==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="24294747"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="24294747"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16726025"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 09:28:22 -0700
From: Tony Luck <tony.luck@intel.com>
To: patches@lists.linux.dev
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 24/74] x86/cpu/vfm: Update arch/x86/kernel/cpu/microcode/intel.c
Date: Thu, 28 Mar 2024 09:27:18 -0700
Message-ID: <20240328162820.242778-24-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/microcode/intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 5f0414452b67..64809f3271b0 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -21,6 +21,7 @@
 #include <linux/uio.h>
 #include <linux/mm.h>
 
+#include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
@@ -577,8 +578,7 @@ static bool is_blacklisted(unsigned int cpu)
 	 * This behavior is documented in item BDF90, #334165 (Intel Xeon
 	 * Processor E7-8800/4800 v4 Product Family).
 	 */
-	if (c->x86 == 6 &&
-	    c->x86_model == INTEL_FAM6_BROADWELL_X &&
+	if (c->x86_vfm == INTEL_BROADWELL_X &&
 	    c->x86_stepping == 0x01 &&
 	    llc_size_per_core > 2621440 &&
 	    c->microcode < 0x0b000021) {
-- 
2.44.0

