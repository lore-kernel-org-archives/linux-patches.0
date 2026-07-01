Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73428349CC1
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 21:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782941765; cv=none; b=trgQEWK289q5FjvFxAr6mvvF4WGkM+D/MORFqFZ4iV1KaNR80TbdZ5rOrSYjiRqwQBxUUXuneqp0xqdcgQIJUNs62XIieDoODjDlOtCKm+AmPRk099izBvF3SNM+Dfr9CElmfUbmNzVdgDUNiXvgQ0FEKiaevbPznAi+k4MH4CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782941765; c=relaxed/simple;
	bh=U+YdMyIyk3aFs0PlrDaXF634IpRNbN5O5XURQbU/Rlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWb+xnINeiPnpS8H4MSToqhVq9/d34ggnjD+YCXBRj6mcgryCVsCFoKRfBHPggDjldEZXerdWcTNVZLgJHOmLrE3WE9IyDW+/BDqMuiOH5IczU7jiW6RjWAO9vhipdpv3RfoKEMYczvpUfIhH75sUutdsTmpqSrPt6Rj/mxLnXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RqhmVFck; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RqhmVFck"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782941763; x=1814477763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U+YdMyIyk3aFs0PlrDaXF634IpRNbN5O5XURQbU/Rlk=;
  b=RqhmVFckKd2s8JzdSkZUy856HO0C2Wp705Y4eWn8EQPzep0GAsjCYjnb
   FpQGFnIi4fpkMb1fkMleMkqZiNpR2SUW+crsdVfCYlT6LhVVfEt5pCNM3
   fAhVOkn8+LXjZFB6f4ud4tk6IHsCmwZ+esfZvXWnJrWzVw56Oe42I6tNT
   V7smvm0fsnQb17OXpb7FlO6bU6OQFeAOWW1APBd0HSCK+w6ApbKMhkX0X
   eGk0wZGGie9n6Pnbw9GSH3vxUsX6dxepDRx2IwK43pHybYQIusg0aY/k+
   wwNN6GJ9HYDrBMqHQrIAfpBRtHLELHvM0huOw7d2tsU9GtXklT6bIiHDM
   w==;
X-CSE-ConnectionGUID: 4VbG3Ly2Qs6inMreGV/xbw==
X-CSE-MsgGUID: wvizj1gdRgmBzhr89XciDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="94285760"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="94285760"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:02 -0700
X-CSE-ConnectionGUID: NN+V7teeS12RofuBU+8hYg==
X-CSE-MsgGUID: LJhtunJJTrKLB5wYOdHSnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252242523"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.120])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 14:36:01 -0700
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
Subject: [PATCH v9 02/12] fs/resctrl: Remove redundant calls to resctrl_arch_mon_capable()
Date: Wed,  1 Jul 2026 14:35:43 -0700
Message-ID: <20260701213553.15222-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260701213553.15222-1-tony.luck@intel.com>
References: <20260701213553.15222-1-tony.luck@intel.com>
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
index efadadfe4ed5..ac1a5af00bc5 100644
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

