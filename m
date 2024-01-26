Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FADF50A82
	for <patches@lists.linux.dev>; Fri, 26 Jan 2024 22:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706308733; cv=none; b=J14LaHKGbeqiD8lpDpNAFhJ1wNKgfrSzQdUrUTV1j0frSuRT7yR5ATJxa4FyAMG3HHnDEAtINqOWWeH542W4MOFs142bTaWBC9bYMz8YxwaW6iRrTaj/oK1EYFnD22arEvvFO8g8ZVRPCXi73GNqGdvN0v5YBRiuqGbiZ6Ci21Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706308733; c=relaxed/simple;
	bh=ejTtG9IVvU1pMsWd87GPfoDZ/SXanaRDlw9oN2DlbHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oV/eE4XaOWy98/2KDs7bEo/XqFl89xhJ0Dl9E5B7kK4JLqNcnMPrfzjc7FhiXx3yAaO862r/wsd+6ekyR0TtFgX0fPvdLdChk5OsYUdJX2ijnfC21g9hIFptt2dgZ9ehinwvQH1979/jA55cRZp6b80iEhFQIULL5NfNlOFo77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zj8tTela; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zj8tTela"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706308731; x=1737844731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ejTtG9IVvU1pMsWd87GPfoDZ/SXanaRDlw9oN2DlbHc=;
  b=Zj8tTelaXZ0oxrnsh2HQDSJYkh1dTH+GjN28enbu9ZTRmNCtw2SSARnF
   toeP0KXJl92b/WskttkbFBnK9Ef15f9qLOgH/7XeRgJO4OyOyIl+lD8sq
   /SNNNNVjBRe9X7HqxJrksbRD+xzczwnZL799r7k0IbSPJpkCWw8agWa47
   I3fgjmBbMzFaQPt8nSEiWAUxxvvwcM1frZshraBOwHXWUCJK8ZmZC5x0x
   wwcpZkoohIuyRxoqGXGYXypvjiluFZWM65HNtWiVFXsu5+qAAGs5SQs5S
   ecOxLZ5zFPX0AJ63oBMsxHBbF4YC48UNWrbAJYcwDC96k6b037ONnG7T9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9707706"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9707706"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 14:38:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="35560260"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 14:38:48 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: [PATCH v14 5/8] x86/resctrl: Add node-scope to the options for feature scope
Date: Fri, 26 Jan 2024 14:38:34 -0800
Message-ID: <20240126223837.21835-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240126223837.21835-1-tony.luck@intel.com>
References: <20231204185357.120501-1-tony.luck@intel.com>
 <20240126223837.21835-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently supported resctrl features are all domain scoped the same as the
scope of the L2 or L3 caches.

Add RESCTRL_NODE as a new option for features that are scoped at the
same granularity as NUMA nodes. This is needed for Intel's Sub-NUMA
Cluster (SNC) feature where monitoring features are node scoped.

Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Peter Newman <peternewman@google.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 1 +
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 058a940c3239..b8a3a11b970d 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -170,6 +170,7 @@ struct resctrl_schema;
 enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
+	RESCTRL_NODE,
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index d7c0651d337d..27523841f9fd 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -500,6 +500,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 	case RESCTRL_L2_CACHE:
 	case RESCTRL_L3_CACHE:
 		return get_cpu_cacheinfo_id(cpu, scope);
+	case RESCTRL_NODE:
+		return cpu_to_node(cpu);
 	default:
 		break;
 	}
-- 
2.43.0

