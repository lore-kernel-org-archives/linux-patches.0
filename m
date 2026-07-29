Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F493644A4
	for <patches@lists.linux.dev>; Wed, 29 Jul 2026 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346085; cv=none; b=KmIWpU1kYfKGeGKSHgvDbpitbMbJFj2+tYazjZAmH56Viym3/+60ObUeLpeW1G5laeovwE48ecB68ESVufqyFVu0XR822kGTu/5SJz/8qsLC0x++Dm076wjqnbHJONxsHbvw6idfy9TOkcXdT4umWwBcujsIqW3K5I9vcE7nlho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346085; c=relaxed/simple;
	bh=hUO8f05LdcMruosBIBFp5gAcYKl1fItecBvvXh1rAXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uy9hTwdav/wn1gVKvEHfh1GGUgc05kncrzzO7RIfvcSv+nDU9BkI5G5+bT1M4mYRVaPDWqWmg4XXk2WbaKl45E0WO2/2LVSqyU9HWolq+2IFQxpk7y8cPr1AWvOKj84u1jSfnl0kFG7pgdZRcPwrs3HWhFw1/sfcEr9r+i06dMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i+k9S+rx; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i+k9S+rx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785346083; x=1816882083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hUO8f05LdcMruosBIBFp5gAcYKl1fItecBvvXh1rAXs=;
  b=i+k9S+rxgi9B1hAuhiDUWNQYDZpmGXZMuR4+KmLNrbvmOrlWsaqtpMR1
   rxBEOVpQL2bThsOMHzvEP4jMqHrX6UPOjXLWQyraSWC7amffh5838zGTz
   VHczP1a7QieOBWp8tLHViYkyNtvj4YB14ZOy6hz6cRsCg0mo3+8zJ4VcN
   oEBw2VwajcQGBi62GOMNNpQDaBQqzgzlJJBQyP10T+xaT0x35bYHK+Yv2
   0eQFitcF77Q4hvKidrdepy8mdr59a9OquP+m2JNZbATS7BenBF2dspV9I
   QtMQj7YkmD0OgR6FukEMY4juqwXAXcLhpRnfF9j1hWMXaFBBm39nZDFGl
   Q==;
X-CSE-ConnectionGUID: nWgpvix/STualDkqGSbFHg==
X-CSE-MsgGUID: C93N+nrsSb6YYA6bX2a/Og==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="97473572"
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="97473572"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:00 -0700
X-CSE-ConnectionGUID: ymemxSBfTYKSATn86SwIFA==
X-CSE-MsgGUID: AUw94RNQR1ObsBxa2lQENg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,192,1779174000"; 
   d="scan'208";a="262024552"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.238])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 10:28:00 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 03/17] fs/resctrl: Remove redundant calls to resctrl_arch_mon_capable()
Date: Wed, 29 Jul 2026 10:27:38 -0700
Message-ID: <20260729172752.11561-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729172752.11561-1-tony.luck@intel.com>
References: <20260729172752.11561-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Architecture code provides resctrl_arch_mon_capable() so that file
system code knows whether any monitor features are supported. This
is used to decide whether to create "mon_data" directories etc.

Initially resctrl_arch_mon_capable() was an inline function providing
the value of the x86 architecture variable "rdt_mon_capable". I.e.
extremely low overhead and so it was used liberally as a sanity check.

The ARM implementation of resctrl_arch_mon_capable() is not inline and
chases a couple of pointers. Future changes to x86 implementation will
also make resctrl_arch_mon_capable() more expensive.

Redundant calls to resctrl_arch_mon_capable() in hot code paths should
be eliminated.

1) mbm_handle_overflow()
This function is called once per second from worker threads running on
each L3 domain. The call is clearly redundant because worker threads are
only created if the MBM monitoring feature is enabled.

2) is_rmid_match()
This function is called when a user reads a "tasks" file of a MON_GROUP.
The call is redundant because the function also checks "r->type ==
RDTMON_GROUP" and this type of group can only be created on systems that
support monitoring.

Remove the call to resctrl_arch_mon_capable() from both of these
functions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v10:
	Unchanged since v9

 fs/resctrl/monitor.c  | 2 +-
 fs/resctrl/rdtgroup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 73413cb128ea..6acf6106e6f1 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -888,7 +888,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	 * If the filesystem has been unmounted this work no longer needs to
 	 * run.
 	 */
-	if (!resctrl_mounted || !resctrl_arch_mon_capable())
+	if (!resctrl_mounted)
 		goto out_unlock;
 
 	/*
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dcbb0a964e8..8d6d65e6097e 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -691,7 +691,7 @@ static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 
 static bool is_rmid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_mon_capable() && (r->type == RDTMON_GROUP) &&
+	return ((r->type == RDTMON_GROUP) &&
 		resctrl_arch_match_rmid(t, r->mon.parent->closid,
 					r->mon.rmid));
 }
-- 
2.55.0

