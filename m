Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051850;
	b=dJ00g/OWlFYqg74HslplPXpBL2GrXKO+LWMbzo31uZ5t7BGmyxfNJ5dCNX1MfEHUvqhV
	 cCilJgUZtRJXUYK1BSsk9FAd/tdMLznM8iXnXsrZ15YcfOAUVIs0IImHt0a6bxgHdEckd
	 zGokzMgp24QyOBoolR3azWvQe1gPOdQni0gCb+XPV0yjzn1tCKY4k7AC6OmQKd3DdsKzo
	 fJae+vUJCERYPh3sq2cwXU3f12ImT963u3xf5kpUt4X7anO6W0LI2qgyxxXCyA1v03HPT
	 SJBqP+DVVJjhzb44w/nVS4CBEcrOeUjEGxkedVIVg8loVMRCtu24oIfjeZvQv/HfC6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051850;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=UlQCSZlz3mraiMHesZOZluDRmw2/hRxcIdnKIMuj4sk=;
	b=xoO8avwS5H8nau2Cay/H78AuKaK0SWWiWMpF1oFWkQ5XNjYujfNRQ7eNwnZ8mwRPu9rq
	 TxuK+NeXb9t+LmSoePQuRuLnyIlg2MhDhPlc2rtgSTHGokYkDkl5EdURKJAKgMlTfpAMT
	 4hAxNaDmWXbAIsOMNMygxM5Z66ySoqgBy+R3tCUEqiLaUZRu6T8ZYqkgNsTGtONggAxSJ
	 8J42zUo4e7CV/IxQ25FbKeE9dqx/1h/Qpp9Pnb2KAIQju3TK90mBo0a0o/KQT9wgxVdsi
	 LlG/kwK3ZrUwImdd1QJdusBXGdN/l9uc28FrHhLvnVsNflh3yKRIju0Tq/Ox1yRp9bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jOtHJWx8;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D813F606A31F
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 21:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D813F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jOtHJWx8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793051849; x=1824587849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7Ew9CPQb/prJjMrGBjHYwl1mAHCM/QP+a/IXGDctMyo=;
  b=jOtHJWx8MTzXqBCf6f5IwaOgSeUfYcAe2JP0zegrzg/OLJD6KSwop6Db
   KfYzA4kzThaowc2sOXWPfmNmi0l3bL14bEY7vAUgPTJyqgkqXX7mpAiqn
   Qx4AN96DUmY9pbd/SZ+8bYqH7PKTlxj1No/P5u4vNJV38SXSkLKMHROOM
   3M5VBfKuWah7atrVsUm7T5cYxKh9iDZUQjZyNzcmbyAr4VEYWmY01Qh5s
   QNUYGvAKVW34CXQGGVjZwvs/dAHESXwSNSinbmKG2aykt51llA5f6PVVp
   /x3ZGWOXTybGDCvC2NbaW+y7NwAAP5PwYJEeVvqO9bmTU3152ycWWirlg
   Q==;
X-CSE-ConnectionGUID: ud9w7nkmRVGrDDpYUjx05g==
X-CSE-MsgGUID: kwIE35K4Rn2wF40CUHjZsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1766375"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1766375"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:27 -0700
X-CSE-ConnectionGUID: 8fJShNk5QC2feLZ7b9nF3A==
X-CSE-MsgGUID: O0Usa0doRbCcT5XKi9OSqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4240251"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.204])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 14:57:26 -0700
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
Subject: [RFC PATCH 1/8] fs/resctrl: Change UI of "max" file (merge back into earlier patches)
Date: Mon, 26 Oct 2026 14:57:11 -0700
Message-ID: <20261026215718.16810-2-tony.luck@intel.com>
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

Make the UI of the "max" file show values per-domain so no changes
in UI are needed when support for asymmetric controls (L2 on hybrid
CPUs) is added later.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/filesystems/resctrl.rst |  5 ++++-
 fs/resctrl/rdtgroup.c                 | 27 ++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 434e6f42db4a..de162280a0fe 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -397,12 +397,15 @@ with individual files:
 		the schemata file.
 
 "max":
+	Maximum values per domain in the same format as the schemata file.
+	Format of values depends on the type of the control:
+
 	When "type" == "scalar":
 		The maximum value that can be written to the control when writing
 		the schemata file.
 
 	When "type" == "bitmap":
-		The supported bitmap (in hexadecimal with 0x prefix) with
+		The supported bitmap (in hexadecimal without 0x prefix) with
 		all bits set.
 
 "tolerance":
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 416b73c57016..7119ad0029c1 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2465,15 +2465,28 @@ static int resctrl_ctrl_max_show(struct kernfs_open_file *of,
 				 struct seq_file *seq, void *v)
 {
 	struct resctrl_ctrl *ctrl = rdt_kn_parent_priv(of->kn);
+	struct rdt_ctrl_domain *d;
+	bool sep = false;
 
-	switch (ctrl->type) {
-	case RESCTRL_CTRL_SCALAR:
-		seq_printf(seq, "%u\n", ctrl->scalar.max);
-		break;
-	case RESCTRL_CTRL_BITMAP:
-		seq_printf(seq, "0x%lx\n", BIT_MASK(ctrl->bitmap.cbm_len) - 1);
-		break;
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+
+	list_for_each_entry_rcu(d, &ctrl->domains, hdr.list, lockdep_is_cpus_held()) {
+		if (sep)
+			seq_putc(seq, ';');
+		switch (ctrl->type) {
+		case RESCTRL_CTRL_SCALAR:
+			seq_printf(seq, "%d=%u", d->hdr.id, ctrl->scalar.max);
+			break;
+		case RESCTRL_CTRL_BITMAP:
+			seq_printf(seq, "%d=%lx", d->hdr.id, BIT_MASK(ctrl->bitmap.cbm_len) - 1);
+			break;
+		}
+		sep = true;
 	}
+	seq_putc(seq, '\n');
+
+	info_kn_unlock(of->kn);
 
 	return 0;
 }
-- 
2.56.0

