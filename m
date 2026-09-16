Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0C24E2F35
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 23:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600421; cv=none; b=mzfK5/Ln4Z7pkHWIselXlY72VHIOp/Jem67/n5Jjx5nkhmLwMS/UQGlaJcZZk0Th7K3C1E0VpD9cEcUWNzTgvoGyIIKSTC+U6fbhzpYNlyDF5YXAJ75oUEQOGc8z8swzrWVF+F/o04LRTExceCJGolTRZQNrOii+y/KsnjJ7n+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600421; c=relaxed/simple;
	bh=3COoBJ2+XbV4ydXsJZZTt7bAu++18o363OAblyVTZkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/tQEcP4b6wl8mcTuwRXGeA9F54ro9OoXdUsmeF+lYD9Lbfj69pzd64ib0Vm1mhyT5MulaisVrDe8gp3vCKb+DKBBZE0Bwgm/emzzxqU8c+QPe/KSLgFnTxRDrqNrNtAtxqyJpmOq3d2o7Ti8jNCeeI4XiPnBL0m/AHZLG1O2zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m11jGAyZ; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m11jGAyZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789600419; x=1821136419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3COoBJ2+XbV4ydXsJZZTt7bAu++18o363OAblyVTZkE=;
  b=m11jGAyZbx7zpWNaSHGxipO8eeiWeJq39gnksPEo0vX1y1egVczuxU7D
   onGe16CYPJA6gXaFixMWgc+ZOpstAEwDLrnrZl9Af41X7QyTHWeYKdwIR
   Yf45+7f2CYsBAG7BEBt/rYbwNyA9TUzd9yPH+UiuxElHnNxsPb2mtsY5B
   zAlw0o+bgs5PYuz+F9RivxiCc+4RHm9Kd2lahZSM42UcIUa1jZp8Z28aR
   qJOXRt8YBnPDxsGUj6I0xarCQZGJ2ppgZUeTUMEZcVJOcXwSkIUqJTxOa
   IIcOKDMbomG+n1RhQF2XoZKTy8SKNQHIMBrj01HW7M4uz+NF7PAtQbB2w
   w==;
X-CSE-ConnectionGUID: GrASvlPrR+2rdBK91ijP9w==
X-CSE-MsgGUID: F6dgHWtYRsiAqq9OB2QcMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="93861394"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="93861394"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:34 -0700
X-CSE-ConnectionGUID: rsgGC0vKTka6Vtn/z02tKA==
X-CSE-MsgGUID: EyNweaciT+yQWTG5F7LE9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277231454"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.219])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 16:13:34 -0700
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
Subject: [PATCH v12 09/25] fs/resctrl: Remove redundant calls to resctrl_{alloc,mon}_capable()
Date: Wed, 16 Sep 2026 16:13:04 -0700
Message-ID: <20260916231320.14502-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231320.14502-1-tony.luck@intel.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl_mon_capable() indicates whether any monitoring resources
are enabled on the system. It does this by scanning all resources.

Redundant calls to resctrl_mon_capable() in hot code paths should
be eliminated. There are two prime examples:

1) mbm_handle_overflow()
This function is called once per second from worker threads running on
each L3 domain. resctrl_mon_capable() is clearly redundant because worker
threads are only created if the MBM monitoring feature is enabled.

2) is_rmid_match()
This is called for every task on the system so making it less expensive is
appealing.  resctrl_mon_capable() is redundant because the function also
checks "r->type == RDTMON_GROUP" and this type of group can only be created
on systems that support monitoring.

3) is_closid_match()
The call to resctrl_alloc_capable() is not just redundant, it is wrong.
On systems that only support monitoring it results in no tasks reported
in the "tasks" file of the resctrl root directory.

Remove the call to resctrl_{alloc,mon}_capable() from each of these functions.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v12:
	updated is_closid_match() per report by Sashiko
	s/resctrl_arch_mon_capable/resctrl_mon_capable/
	Removed unnecessary line break.
---
 fs/resctrl/monitor.c  | 2 +-
 fs/resctrl/rdtgroup.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 362737e13cd3..02e81fc82b14 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -888,7 +888,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	 * If the filesystem has been unmounted this work no longer needs to
 	 * run.
 	 */
-	if (!resctrl_mounted || !resctrl_mon_capable())
+	if (!resctrl_mounted)
 		goto out_unlock;
 
 	/*
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 79977200b1a0..c0b86ce05e50 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -685,13 +685,13 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
+	return (r->type == RDTCTRL_GROUP &&
 		resctrl_arch_match_closid(t, r->closid));
 }
 
 static bool is_rmid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_mon_capable() && (r->type == RDTMON_GROUP) &&
+	return (r->type == RDTMON_GROUP &&
 		resctrl_arch_match_rmid(t, r->mon.parent->closid,
 					r->mon.rmid));
 }
-- 
2.55.0

