Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793740993;
	b=G72Ew60e2N3RRTp4ENL2BKLb4V07AxSYhcL7Il9aGxESemtcyrbT0177cniE2jxlNMcv
	 QBO9hzy3Uth7HRw1B31akR/kZqwksF4DN75pU4jdrgnLsG6qTBap+FpZrk20Twb0s5pR/
	 TdkKSWpuwDBofaU+I/IbpDIV7yUF0GROkWG1heUOWE1zXL4wVZ8Iwjfmud8VCic3lCNDl
	 r2K/QypGWZJVLEstwTwQS2ZXq5VR1k/RBc5LElc1mspYM9h8cUB6Lv35xu5ElWOZsBGWv
	 /mXsdTpWGIAYreR0BynORWIN8I6Tp6Cusyopl2KC18be6pG2KsyA1yxk/hUi+NpXBow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793740993;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8Nu7J0KBFtMCsRCGEGmNxni6Px2j5FiLpPRZYtcJB0Y=;
	b=yp9WtgZiFMW44bltk2xmaSf7J3sWctd3IDR8cDhZ5pooyy8RztZz+r9BlDQm/jqIzldt
	 kmYZuxH89+Sw48DlDQzei9G24Z+Rox5IWxBYP7hH7Lno8TMBsQPKTLSmchILSOgHYVa71
	 81LF8W/gTG3iaYFneVEcfNvI1N5hVx0DHAGF/X4uBGkmbPuJ9mdEm8UOGEzGyOHbx6VBg
	 HO3Q7nuYKaXmoGVtfGjtnevRIWpcw6sW5WcQieutp9XUJsK53a+4W2roLwOlzoGE2cDGA
	 PnC880HKbNbjWXaDKNUZKTkHIIqP2pSITcCKGUorbCQgE7USBNfRZhtcpgkE9EZvS2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CV9rUrLk;
	arc=none smtp.remote-ip=192.198.163.11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465A3606A326
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 21:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 465A3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CV9rUrLk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793740991; x=1825276991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M7+sa2bYaqMa4jrYPO7WU4aILkgg6QGwI9+jJfYVBOU=;
  b=CV9rUrLkpLc0+Mv9joPbDC0E5+ztI6od43tmojLe05xBjwhB4ndPI9yF
   tMIQQzXfbofqBdz8KBmkbmqpnyZjm+wYP4ZUAwuwn3EgIZmukdJgoaLzI
   /ujZUfnx5vEoA6noRnyX/SZpbEr0brs2zuWSmeFhmVTYsVO59r8fNbLV+
   X/jV3c/mAkvHz9Gp3Iu+4MbsSJy2iiaUSDxvQRJBmpYYAUFifidwPRmM9
   0ffbrubprsOUSgoPDWxflzAHH9sI34CoGo7GILqujK+2ST5AfIcnLE063
   6pZ/Omq0ZpD54jDfYA5rgec4r42KaoUpp+W4pGTw9iz9ooMsHNRhNELEH
   Q==;
X-CSE-ConnectionGUID: PDF+ZtW+QbaZ9MBoTnPWOw==
X-CSE-MsgGUID: t7K4mLQpRqOA8z9G0JOO0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2393458"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2393458"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:10 -0800
X-CSE-ConnectionGUID: HVCPJKodT7KEvgekt11EXw==
X-CSE-MsgGUID: AMUKOHwxTgaLqWPoml3y0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6624555"
Received: from rosenzwe-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.124])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 13:23:07 -0800
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
Subject: [RFC PATCH v2 01/11] fs/resctrl: Change UI of "max" file (merge back into earlier patches)
Date: Tue,  3 Nov 2026 13:22:44 -0800
Message-ID: <20261103212254.18314-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103212254.18314-1-tony.luck@intel.com>
References: <20261103212254.18314-1-tony.luck@intel.com>
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

Format chosen to match schemata file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/filesystems/resctrl.rst |  5 ++++-
 fs/resctrl/rdtgroup.c                 | 27 ++++++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 264a44001003..524ad062a6d9 100644
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
index feaaec18b835..57c050b05798 100644
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

