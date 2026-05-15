Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF563815F3
	for <patches@lists.linux.dev>; Fri, 15 May 2026 19:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778873995; cv=none; b=XjY94RNQ/jJQW28GaU1iSE75+OV9s/GxyhOSN4R2Vu+JLyTGMGS4D9+IMl65goFnADSLnITdhsD2eleGgphwPrhfPksKFFmg29luJlRLvFrqGOiTWT2GtEEG/C0gBsmoJLt7mZbLrEO72ozjEt4Iw+6XeSW9Rtke38ASdqsgnMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778873995; c=relaxed/simple;
	bh=fpupJjx8Ob0z6xFVGlShdQvQmaTfW9HLNv4R/BFJBVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7x3UUm7rmf73dS3QDQRxqmjooqVUbw8ssghKiA7O9wh6EV1BQGV2S2KBhfefBX2uZW14DKiML0uUe9pspPBhe/FzcI1hfPm7C/tLn+w3v7yJgMzQ8I4p9e63OsbfbagxXI7Rc8UKj6TcoWdqRt01fepOAxxopiB5rWA5+0gZBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XdQ8lUzB; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XdQ8lUzB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778873994; x=1810409994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fpupJjx8Ob0z6xFVGlShdQvQmaTfW9HLNv4R/BFJBVg=;
  b=XdQ8lUzB0mSGpoixO0LpUcqYVJG7Kw5sE6CkpUoIC/Un/jYKo2RpqlQV
   bPIr3auULP8VFrn8KZg08tds08aCJNmBfrA+4cgUQ96eJDn6UhMUpgJ7m
   OlSFXcpYPpCIk6/1lQBMjdNlDAAjCTLHtAgtfbi8fGgSAS+oWULbnEWez
   1gWEhAeknS2ZX/bPdEQKkyM01b94tiySQp2BPu2wsTln9IHOVi/vTWWkN
   1Hdg4b6AFYG/lyuQtnfRx1kzTWleP0PldowsnZ0XqdF1YwZel9HpZFMqV
   /hYCl6etLE5uovV0BAAbv2bhCmf9WiX/2NVUhIUloNiJjvPQNPKIxEs8y
   g==;
X-CSE-ConnectionGUID: yhvRKZRrSOiFWHqrXSPwpA==
X-CSE-MsgGUID: 4Q9s9RpkSqGA6YfUlobyWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11787"; a="78972234"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="78972234"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:51 -0700
X-CSE-ConnectionGUID: eg5nlDUJTBaCSl2Ip2h8rA==
X-CSE-MsgGUID: wxSx8Ty2S6axW/EV7/e1TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="237916571"
Received: from hanvin-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 12:39:51 -0700
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
Subject: [PATCH v2 3/5] fs/resctrl: Fix use-after-free during unmount
Date: Fri, 15 May 2026 12:39:42 -0700
Message-ID: <20260515193944.15114-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515193944.15114-1-tony.luck@intel.com>
References: <20260515193944.15114-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reported[1] this issue:

  During unmount or failure teardown, resctrl_fs_teardown() calls
  mon_put_kn_priv() (which frees all mon_data structures) followed
  by rdtgroup_destroy_root() (which destroys kernfs nodes). However, the
  RDT_DELETED flag is never set for rdtgroup_default.

  If a concurrent reader (e.g., rdtgroup_mondata_show()) invokes
  rdtgroup_kn_lock_live(), it drops kernfs active protection and blocks on
  rdtgroup_mutex. resctrl_fs_teardown() (holding the mutex) proceeds to free
  the private data and destroy the nodes without waiting for the reader.

  When the mutex is released, the reader wakes up, observes that RDT_DELETED is
  not set for the default group, and dereferences the already-freed of->kn->priv
  pointer.

Set RDT_DELETED for the default group (if there are any tasks waiting).

Fixes: 60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
---
 fs/resctrl/rdtgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 506b40dc9430..97d1a3648b9e 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -593,6 +593,13 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
  */
 static void rdtgroup_remove(struct rdtgroup *rdtgrp)
 {
+	/*
+	 * Groups created with mkdir() have an extra hold, that doesn't
+	 * apply to the default group. It is stacically allocated, so
+	 * does not need to be freed.
+	 */
+	if (rdtgrp == &rdtgroup_default)
+		return;
 	kernfs_put(rdtgrp->kn);
 	kfree(rdtgrp);
 }
@@ -2965,6 +2972,7 @@ static void resctrl_fs_teardown(void)
 	mon_put_kn_priv();
 	rdt_pseudo_lock_release();
 	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
+	rdtgroup_default.flags = RDT_DELETED;
 	closid_exit();
 	schemata_list_destroy();
 	rdtgroup_destroy_root();
@@ -2990,6 +2998,12 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	/* Avoid races from pending operations from a previous mount */
+	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = setup_rmid_lru_list();
 	if (ret)
 		goto out;
@@ -4265,6 +4279,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
 
 	ctx->kfc.root = rdt_root;
 	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
+	rdtgroup_default.flags = 0;
 
 	return 0;
 }
-- 
2.54.0

