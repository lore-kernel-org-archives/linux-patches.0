Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B882318EE1
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547914; cv=none; b=KX+6L3T8fc884lcGE48QQNbQ9fMXUvWaH3N7k5NGQ0BfcGLI84zgaK+abiBJvjzTMsUi2rU69h3r6HP7vQ8fhMMOrRRMJd4a/WhtxpqQG/DUpj4e5C04xXp8y4E+7en2aZw6AoTEgLSOq1ZwqA462WXVRHd0VPwKuaBFSgXbu4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547914; c=relaxed/simple;
	bh=lLBCWvlZ8cRVEaDn3jj+Op8c5L4RsOuuqU3grwlC7Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDTQZlYLVxuUCbkFdt2uoE2RWRAa/VpDCoyG4KH8X6ICLkGaJWshItf1I1pPbNJQa5OaOJbpDXCDwGr4Rt8R0+nd7H4db9RbItYdQKr4BxiLwyWXO8fx2zvizeumuWAIF+yQ/HiBK1W7qLSypEDWYF+Nl4gk8kYg62xdYKtOZXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lk1zFG7P; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lk1zFG7P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547912; x=1813083912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lLBCWvlZ8cRVEaDn3jj+Op8c5L4RsOuuqU3grwlC7Es=;
  b=lk1zFG7PEuQ/fF6aILk8Zom8fdyVi+1XWyupvX/ziTTTYntB3UuNpbiu
   RhcK8BopG3EyLq/e2BiYnIDbQMpNA3cyWRs7H553m0013Yp3arrhCtGUM
   X11104eCDdTIS7iQuRHAFf0EzfCdx56uLk++i/1g77t1n4zFTgt8p5hO/
   FeX10bY4EnUHYaB+DTtGP+3KqQN4e8oQVQrikrU/fqo0EHWehGO2EeH6e
   xxVQqZydYH6oOf4sgWzJWmivqrHmNnpULBk7n1k7pRK5yURLDND6cVjkt
   0Zob6AsIO28I0FIpi1o/bmlwm4Do1c+Lbc80Dv0MZnrCCcvykRt+YcrCC
   g==;
X-CSE-ConnectionGUID: X8QdE6HpTeWS08dXqrOxfA==
X-CSE-MsgGUID: 09HuIPqmQJammqU6gL72uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93789968"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93789968"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:08 -0700
X-CSE-ConnectionGUID: zdkDylV3REKoxsGAobN91g==
X-CSE-MsgGUID: YZCwwsLGTQSiqHyWQesV1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620623"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:08 -0700
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
Subject: [PATCH v8 06/16] fs/resctrl: Remove redundant calls to resctrl_arch_mon_capable()
Date: Mon, 15 Jun 2026 11:24:47 -0700
Message-ID: <20260615182457.14725-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
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
v8:
	New patch

 fs/resctrl/monitor.c  | 2 +-
 fs/resctrl/rdtgroup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9fd901c78dc6..3df188bee433 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -848,7 +848,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	 * If the filesystem has been unmounted this work no longer needs to
 	 * run.
 	 */
-	if (!resctrl_mounted || !resctrl_arch_mon_capable())
+	if (!resctrl_mounted)
 		goto out_unlock;
 
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a8f84b653607..c671644f1e12 100644
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
2.54.0

