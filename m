Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF1D2F1FD0
	for <patches@lists.linux.dev>; Thu,  8 Oct 2026 23:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791503001; cv=none; b=czXQHhXX9A+OuXfvEyfuMZYXrqKKkrdqeUgNYUOkQNbJu/XXSugN/2CUv8ee78Mo1UMBsKMkQDb/xjxBDANSSbG1KGkQFkwVETMTRsY1F0cyHDrXD4uDFZLgEtj+il4GY7tGnSSQfkjsgZDQYFmriP5QB/EFeeQe5RlGit8v8fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791503001; c=relaxed/simple;
	bh=3nMiyhUtIYQvLfGkQMvm7EcXxnwF4u2bOmBxXuZzKk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OYG48A6vxd1U1iLmnQnmipJTz2roKh+RQYXEwynz4bXbMpDdvJpuqMritQ+5JBH9Izh2MZtrpbxa9jrvfPjJfipXDFSRv7R9cSk+/8sv4j+XYivTL522yA3GQT2xdnrD9BZMaruO/RFAScONdTdYfZi9ebhVMdayy6XIjFsXF14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9uBTuM5; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9uBTuM5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791502999; x=1823038999;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3nMiyhUtIYQvLfGkQMvm7EcXxnwF4u2bOmBxXuZzKk8=;
  b=f9uBTuM5znyaU8eHr7c3jR7/OYdbof6o0V57AKlETe5ZTt0M9SI6uJAE
   2m1wl8I9FgyHD6EPNaREId4EfjGLF1DRx0ALxUZfIjW4PssCMWFwcDtx1
   r3KG03v2HSYUXlDFgDRXVU2A7B2Oxdl/D1HOOfSaiS/trCLL9eRVJ1MoG
   bRJ7uR8c0z03vhxis7TzjgxhEG0+njGfljhSFSuk/w97DEgKs3TSImzIO
   QM6nbSrolq+uc2zWHdodp3UIE03QXt2eFCh8FQKMnNmvw9fvGd+NyWIpB
   QcCTbhgAo3rNe2iFKttI/4X2rT7xoVK8UoZa6DsDqSDsS3b6Bh/Wr+apQ
   Q==;
X-CSE-ConnectionGUID: MA7chKLERkSGMuwG650vpQ==
X-CSE-MsgGUID: p5VO4a5NR8SFSMK4t4jN3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="298256"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="298256"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 16:43:19 -0700
X-CSE-ConnectionGUID: bjRjNBD/SFOE2qta/6k5AA==
X-CSE-MsgGUID: WbHT/xQbQFua+OuzXDxhuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="116406"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.126])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 16:43:19 -0700
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
	Tony Luck <tony.luck@intel.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] fs/resctrl: Ensure default group reports tasks on monitor-only systems
Date: Thu,  8 Oct 2026 16:43:11 -0700
Message-ID: <20261008234311.17702-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl can be mounted with monitoring support only, with no allocation
support. In that configuration every task that has not been explicitly
moved to a MON group remains in the default group, and CTRL_MON group
membership is decided purely by comparing a task's CLOSID against the
group's closid.

is_closid_match() also requires resctrl_arch_alloc_capable() to be true.
On a monitor-only system that is never the case, so the check breaks the
default group: it unconditionally returns false for all tasks, and
is_rmid_match() also returns false because the default group has type
RDTCTRL_GROUP rather than RDTMON_GROUP. Reading the root tasks file then
shows no tasks at all, even though every unmoved task belongs there.

Drop the resctrl_arch_alloc_capable() test from is_closid_match(). A
CTRL_MON group other than the default group can only be created when
allocation is supported, so for those groups the test is redundant. But
the default group always has closid == RESCTRL_RESERVED_CLOSID and is
present even without allocation support, so the test is wrong for it:
it is exactly the case this patch fixes.

Fixes: e6b2fac36fcc ("x86/resctrl: Use is_closid_match() in more places")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9
Signed-off-by: Tony Luck <tony.luck@intel.com>
Assisted-by: LLM
---

I fed your AI review to Claude and asked it to rewrite the changelog to
address all the issues your AI raised. Here's the summary Claude
provided:

   1. Opens with context (monitor-only mounts, default group, CLOSID-based membership) before
      describing the bug.
   2. States the problem/symptom concisely (one paragraph, not three restatements).
   3. Uses an imperative fix sentence ("Drop the resctrl_arch_alloc_capable() test...").
   4. Correctly scopes the safety claim: redundant for other CTRL_MON groups, but wrong for the
      default group - the actual bug.
   5. Drops the reviewer-facing "pre-existing issue" aside and "actively breaks" wording.
   6. Uses CTRL_MON/MON terminology from: Documentation/filesystems/resctrl.rst.
   7. Keeps tag order and includes: Assisted-by: LLM per coding-assistants.rst.

Claude put the "Assisted-by:" tag after my sign-off. The tip maintainer
documentation hasn't been updated to provide explicit guidance on where
this should appear. Looking at upstream commits people have picked
different spots, but immediately after the author sign-off seems common.

---
 fs/resctrl/rdtgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 68be9b903ac6..57ab090072c2 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -685,7 +685,7 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
+	return (r->type == RDTCTRL_GROUP &&
 		resctrl_arch_match_closid(t, r->closid));
 }
 
-- 
2.56.0

