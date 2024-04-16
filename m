Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0175814534D
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 21:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302418; cv=none; b=byWTazQs4RdYwwYOZzwOYww88d2to6B8oyJMM4OE60UDYZOga7yRIQuINpk99w6QG/KdSeGIJpTUtX5fDA+0FBIr33+2SblxstbXmu/6ksbOTfapi6RrneINy/yagSLYr52IZePy0ajRcO1BNNWTCWtDpn29fpoUJ+6Z0mSZyjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302418; c=relaxed/simple;
	bh=xXGsSwUGJv8u8+15mKqC9kFQ7leMnNCPWaElrpBEOfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVbnYJrIMbHxTMfGq9eVdyytqb9vF0KfCqTAAyuB+sSOBDaUhf7IuKmVKQPcC1mnHlmu5CojsP+y7Fy4tIDRU+6wWmRy36mnf8/VfdAzL14aip+2ZNePDmOPxG6unZ0p2xGNongAn0adHMLu6gt0fz9X4SO/wpVbdT8Hob1Cy4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GZFh9Aj/; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GZFh9Aj/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713302416; x=1744838416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xXGsSwUGJv8u8+15mKqC9kFQ7leMnNCPWaElrpBEOfk=;
  b=GZFh9Aj/ttq+xmNwLVIPGN2Uh+qjde1Qoo6jSGrmmxrwJwrWn0ZOL32m
   YnYGJL4N4fPjgyMIhahTFYTcSU1MlCP/n43FF/qR/UfYq0u1iuVwY5NR5
   3Diu2LIL9E6k9FzzdW1PzHX6ZvliZhsdMSYu7F3jS1+0xnvJ7ow43a0dy
   8DCKfPPVpd3RvHJRVW0cbKLwyel3GGqx/n1kBRLFJX3GamYQNEVVvaLen
   I0XxUI6pNfmY+V6a76ii0mPtSD9uAlWi1IghpIHn5qqiacPYp96XzT6Fw
   m4Ygaofj4YI0BzFT4vy7CVnCqAE2r5a7QktI5imoTos+ibvACWwyRvMLP
   g==;
X-CSE-ConnectionGUID: vLdZ58ioREm+SkPbU+LzZQ==
X-CSE-MsgGUID: /zpgzg5IRuqRffQShVIyfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19914841"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="19914841"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:02 -0700
X-CSE-ConnectionGUID: Jm8oSg1tRlK6S7/S47jH1w==
X-CSE-MsgGUID: gh/5s8S/RRSa2dSQM2BjNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22872053"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 14:20:02 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 36/74] x86/cpu/vfm: Update arch/x86/platform/intel-mid/intel-mid.c
Date: Tue, 16 Apr 2024 14:19:38 -0700
Message-ID: <20240416211941.9369-37-tony.luck@intel.com>
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
 arch/x86/platform/intel-mid/intel-mid.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 7be71c2cdc83..8b8173fb0a43 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -22,6 +22,7 @@
 #include <asm/mpspec_def.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/cpu_device_id.h>
 #include <asm/io_apic.h>
 #include <asm/intel-mid.h>
 #include <asm/io.h>
@@ -55,9 +56,9 @@ static void __init intel_mid_time_init(void)
 
 static void intel_mid_arch_setup(void)
 {
-	switch (boot_cpu_data.x86_model) {
-	case 0x3C:
-	case 0x4A:
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_HASWELL:
+	case INTEL_ATOM_SILVERMONT_MID:
 		x86_platform.legacy.rtc = 1;
 		break;
 	default:
-- 
2.44.0

