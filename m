Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDA535AC12
	for <patches@lists.linux.dev>; Thu,  7 May 2026 20:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778185060; cv=none; b=me/9egQ1zNF/uyOsAzs8/mamrFkhvWo6EvQKatg7Bq6f52AwWN2tkjHKeNF68dXMjhxOoL/A1Wwn2YayGyrnUISX1laH00iFfql37mnAPd0+86l1gHDtOGbHM/Yi8yKsU2IPDm/4jOXuZlrr9YSVTfAjIuOKbQJ7xeZCUlz6HBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778185060; c=relaxed/simple;
	bh=uGIsL3RxJYXZNXX7sBAJLI2zwIQ6CsJGJva/1K4hbFI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M/PXOJwQlG/S+0pGnzGH9hdFQZvcunT/TOQ6OBbmC9v5fQM0l8JLdcDInTI3o/oZMbxO0NYr5jVunKrp99dQJNBxNGpCFWR3blewQS6YNxDTQntFHyVvsrqn8JeUlBImmrERZt29J2QHoXHs7nomKg/F7BJZ+PIXtmXjYlKX5Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZyQPReMd; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZyQPReMd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778185057; x=1809721057;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uGIsL3RxJYXZNXX7sBAJLI2zwIQ6CsJGJva/1K4hbFI=;
  b=ZyQPReMdC3aOqoOthJkVivFob0S43ytFR6URvA7LbriDBvsx4bY5wFfo
   o6n5xP20ROtmW4gQmzaAe2cMF5rzkro6K3nYxkthMU4ciboqYrfH8pGYE
   eJdpjWzJbqXaupXvXw4m4jx6mxNu2xkqZa31vfhO/pRXJxLRzkvfZdqIS
   GFE9M/M22QWqe7WlmMwHdq2yhCwBzrxXGsR9YjdQwmGmD7Y8ptWAncNml
   k1E9MCZeJYR3HEIVCMyXowWG4a3xUeYpQU5OGAEdll6CAkq5E4MzaWcl8
   +oaZW6lGMVqM65sAio8avPgsKdHdC78PLt5WiM69AE0ueLw0JxLTu8VV5
   g==;
X-CSE-ConnectionGUID: mlKRbTqjSPi1zT4EjTcnEg==
X-CSE-MsgGUID: cSTlobXsS7OwNavhOIQKKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="90250057"
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="90250057"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 13:17:37 -0700
X-CSE-ConnectionGUID: EX2orJXjRI+YzkZMk6e9ng==
X-CSE-MsgGUID: uyswiTvoSp27bVLbbSV9qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="233506693"
Received: from vverma7-desk1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.220.9])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 13:17:36 -0700
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
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree() failure
Date: Thu,  7 May 2026 13:17:30 -0700
Message-ID: <20260507201730.16509-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
fails, the mon_data structures allocated by mon_get_kn_priv() are
leaked. Add mon_put_kn_priv() to the out_mondata error path to free
them.

Fixes: ee4f0ec938ad ("fs/resctrl: Simplify allocation of mon_data structures")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Assisted-by: GitHub Copilot CLI:claude-sonnet-4.6
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Did I really need AI to help, no. But I wanted to see if it can at least
save me from some typing. Here's the prompt I used (contains just as
much typed content as this change!)

  Reinette Chatre <reinette.chatre@intel.com> reported a problem in
  rdt_get_tree(). If the mkdir_mondata_all() succeeds, the some memory
  is allocated by mon_get_kn_priv(). If a subsequent call in rdt_get_tree()
  fails, then a call to mon_put_kn_priv() is needed to free any mon_data
  structures.

  Create and apply a patch to fix this. Research a suitable Fixes: tag.
  Give credit to Reinette for reporting. Add a correctly formatted
  Assisted-by: tag with AI model version. Keep the commit comment
  concise.

 fs/resctrl/rdtgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dfdaa6f9d8f..aad573b62fd7 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2879,8 +2879,10 @@ static int rdt_get_tree(struct fs_context *fc)
 out_psl:
 	rdt_pseudo_lock_release();
 out_mondata:
-	if (resctrl_arch_mon_capable())
+	if (resctrl_arch_mon_capable()) {
+		mon_put_kn_priv();
 		kernfs_remove(kn_mondata);
+	}
 out_mongrp:
 	if (resctrl_arch_mon_capable()) {
 		rdtgroup_unassign_cntrs(&rdtgroup_default);
-- 
2.54.0

