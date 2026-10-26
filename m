Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051851;
	b=bKGd5QSdh62sNKjg1XRZueU0d3LHWJvAbso0EyFSvv3zn6tHwo5As9D5zxCi06jea1mc
	 Q7OduAAkWsZ6nFl6bAMHcVoEID7yuBnuFVKg4d1TMa9mx2CDeNpq4SDh11RaC8nLvQji0
	 xbztq20af8etwcHEc/uInwS4Eexj5yQUYnHpAI3LtblAaintX2KcQ73B3GXSp9F7BB8kd
	 ARO0+Q1JQee/PEETimkPC/GPedDR3TuX0xYc6gpc2fLltG7UwF/T1A70vJMmA1UprBPmL
	 D2Abm3UegG0dQHbSGoBICWrTy0Hjqd0hESr/zyqYGMbDlK39QuQ+2F0FVUwZXL3WD2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051851;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cfsbNZH8dxqbw6ZIqSUSYszTlHdENBNZz+ePXNzsHEQ=;
	b=PHh3E4SxvCi0ahGuhM1MXtU4iMrPy8R332RXAqnb4+B3PTmAJHtynTF06prkqS530JZ2
	 bNPTWZgosRKbJ6vpr+eI9D0GPkWI4m8/I/6D29Pike4OqhMi7GOUH30Vg9oMGVL9TZ5TP
	 SzhBjUY+XU4498oo31MJmF+Xscobc4GSAC/jBGARwxqaMs3LPNAUKhuv9QwUysXaXjPLA
	 7B9RgIenY3zRzwAPwshtk2WomtSxQjCe/yU5jrgRyL6KULQu18A9Yd4zS5EpKssqlxJoT
	 RAfpYvsxft1f+Go87jTb7psRlwmf3uBD9dkjxM1CSzMUf0+qd3aeOABTuElHhySfDCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PQiPooOH;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC568606A320
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 21:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC568606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PQiPooOH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793051850; x=1824587850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Bla+IdO8QMVJJhHlQiWFw7MSz3t+j7wrvVW49vh0tY=;
  b=PQiPooOHC7sKzspRJQQxrNTydt4H/9carxX8wMZVoOJRezQC+PQrkAAe
   xLwbs7WKeWPBg8w8G/OWj+BKBGmPGEqcaF4F9ajVYI9ZVmSdfoyRAgzE7
   8oCvvCe9XutBqNqtKDv6M9M+gIO6HoVxc/yhVqvXmuxJz1my7kCIozeo8
   aEpSK/U93u7/ZlL7UVgq3lk5rdpBk3BcWdKyNo2Du6a5G07m9jNh2fYze
   c0P7RQGKeL2YcrvAwsSKYAoWPQgqEzW/iM54Z5PejzJ7j+kTOUrR43TX8
   AYBreAoGyZbA4d2l8mEnYNL1iPl2x+kNmWN+b3iti4o2miDvXyxEjqNUY
   A==;
X-CSE-ConnectionGUID: FuKE1FebS5+LNE8pYIzJDg==
X-CSE-MsgGUID: Pa+11CY4TV+wJko/+v3hIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1766383"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1766383"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:28 -0700
X-CSE-ConnectionGUID: qtwsauRlQzSDmFSlLCwFRA==
X-CSE-MsgGUID: +VrZkh01SfKu3oqMW6SAow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4240258"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.204])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:27 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 2/8] x86/resctrl: Add L2CAT quirk for Intel Panther Lake
Date: Mon, 26 Oct 2026 14:57:12 -0700
Message-ID: <20261026215718.16810-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026215718.16810-1-tony.luck@intel.com>
References: <20261026215718.16810-1-tony.luck@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel CPUs enumerate Resource Director Technology (RDT) allocation
features in CPUID leaf 0x10 if the feature is symmetric across all CPUs
and in CPUID leaf 0x28 if the feature is asymmetric.

But the P-core on Panther Lake enumerates L2 cache allocation in leaf
0x10, even though the feature is asymmetric between P-core and E-core.

Use set_rdt_options() to disable the symmetric enumeration.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7951cfd20da4..709075ffc706 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -1128,6 +1128,9 @@ static __init void __check_quirks_intel(void)
 	case INTEL_BROADWELL_X:
 		intel_rdt_mbm_apply_quirk();
 		break;
+	case INTEL_PANTHERLAKE_L:
+		set_rdt_options("!l2cat");
+		break;
 	}
 }
 
-- 
2.56.0

