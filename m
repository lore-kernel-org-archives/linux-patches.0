Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBE323534F
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069260; cv=none; b=dEPOJOb6GUgW4EsZjnj1+02Jx0Zc0kSY5U+dBcvtFPlcrJcoohpN+Vv8MyGPMgorRzFSYRfZCEYzhqyI+PqSf/nchuWRo0jC4kYNYdUhuBprg+KQ+xnhVgMlYamvWtHpqroOUaS3f1qjKUxDoc0C6DN1zxu3sOKu5wPMjnagg+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069260; c=relaxed/simple;
	bh=VfHjgFdJazMMHE4237qTcYtk4/5M6s7Jls2ygjhzuhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT3z7R73+h0ROZmSVuYgMR9bGDDFa5ZnCJ9+M/w6ypfPgDHiW1wPqPv3Jp+uckp2KagEdLUvMyjUbZUo4KzplrjPBORslZ95ppfb/T58D/ig3dfVvp+B9IbULCtNi1Xf43J7nULvq7blZId/eVc1eLsvAfu/rKuWJfIIsj++3J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F4ZBg1Zh; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F4ZBg1Zh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069259; x=1775605259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VfHjgFdJazMMHE4237qTcYtk4/5M6s7Jls2ygjhzuhE=;
  b=F4ZBg1ZhtkqqNJE725B3udzGWtV2P6FQ2sOC99o6WMTPyv3ckBEjCeoB
   hy2eAHpb+s31iUfb7/bBQ2hFsjPxATffjjn9KiE7gcc5jhYb8k/gbCPHw
   e8JBwu8SlMXoxRg6X100aku4IcE5JGKcyqiF8DWGWhmK9R2DP4ey5koob
   89ZAv3d42EzAaiLqlb/byrWKHjgTT1684SWTkybbmf/i5PnLrrvkCIJ+r
   mZoiCImkUvuddCZu8Tx6kIC65ORkG7pxi6qF5I7cIRxApkxQj5t2wJ1cv
   zssdX0AekQi2JKOHzUJUD0liU8XI/LJPH8/MVsPkLE9ltUAEF7GBW2rH4
   w==;
X-CSE-ConnectionGUID: zCIC6IUHQ06NoU+53zsh3g==
X-CSE-MsgGUID: uXgD6a2oQPerf+Z+DlVXMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193202"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193202"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:51 -0700
X-CSE-ConnectionGUID: 6t46yy/eQMyJZyQ/RpVa7g==
X-CSE-MsgGUID: ar7dh7HIRLOECgKO229nEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315483"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:50 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 12/26] fs/resctrl: Add hook for architecture code to set monitor event attributes
Date: Mon,  7 Apr 2025 16:40:14 -0700
Message-ID: <20250407234032.241215-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Architecture code knows whether an event can be read from any CPU, or
from a CPU on a specific domain. It also knows what format to use
when printing each event value.

Add a hook to set mon_event.any_cpu and mon_event.type.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h |  3 +++
 fs/resctrl/monitor.c    | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0fce626605b9..8ac77b738de5 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -418,6 +418,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
+int resctrl_set_event_attributes(enum resctrl_event_id evt,
+				 enum resctrl_event_type type, bool any_cpu);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 1efad57d1d85..5846a13c631a 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -863,6 +863,18 @@ static struct mon_evt all_events[QOS_NUM_EVENTS] = {
 	},
 };
 
+int resctrl_set_event_attributes(enum resctrl_event_id evt,
+				 enum resctrl_event_type type, bool any_cpu)
+{
+	if (evt >= QOS_NUM_EVENTS)
+		return -ENOENT;
+
+	all_events[evt].type = type;
+	all_events[evt].any_cpu = any_cpu;
+
+	return 0;
+}
+
 int rdt_lookup_evtid_by_name(char *name)
 {
 	int evt;
-- 
2.48.1

