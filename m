Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E803B377029
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577755; cv=none; b=ojH/webobEkBe3ZeEBgLv42waWcsKJvtDNY+ESPb0WQd5HJnIsYndluTt/U7hHoBvo/1gPiQM5U4w7QW+wQMfRd6kzmFUlip8mcmJ+O9FsS0BVXX6jVfmJB62ZU9V4nNb/YKtUN0N1MnFB3c43fq7KtiGHTK9bQxndkrz/s0yUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577755; c=relaxed/simple;
	bh=v12I4fNHeG9jvYo3wUAhnOp8GtSP5lv3bu1tJwepx+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nz75935jWWCHS42m+Cwf5qJNodclcb+MPScNaCe1x7+ofI+5CJODpJFWGbWwCUQIxmawiuYeEMYxiVNXH/fHm5XiBpIw5cw/LmYsYCIPbOqXQW9co0VwCjRal1Mbv26Y3VwRxLcQeg6nCBK/X5YkMzIhP1ahoHmtsSiSEn3oxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ki7BF/nE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ki7BF/nE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577748; x=1807113748;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v12I4fNHeG9jvYo3wUAhnOp8GtSP5lv3bu1tJwepx+o=;
  b=Ki7BF/nEXh8qkjlCOEoLs1KH9DG2owFDYNWIfaaIYQIrDZUeXRPeTYIz
   o6M9XywKuJNUl1gbmw70WFjKKIzdNbPPBEart7aIdX+xOVOaIRYKAORvv
   F0QoRH0KLRbuq5VcJgTDQ/eRxE15DLJXMAOpj8bKCuTxRqoHBk9/ztIzz
   xDBBar/SvAQvIG8SFpiMNvHk72TlNk32DNHHpbm/BKKILrqtopMFqoU+J
   mqiwuunW7G2vtLuBPF5TVCt7vP4M7D3UaBeGZ2fMPO96Ohy6biXatvZdv
   XROvlt8zVi8Km1WhzPrOjmIhOAjxPko0pLVaEoOI8TFIxwPA4gG+estQF
   A==;
X-CSE-ConnectionGUID: zL6uj0WZSBWxf6LFcjdXAQ==
X-CSE-MsgGUID: wgTf1Ln/Q0CAYUBpXAjWnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432665"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432665"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
X-CSE-ConnectionGUID: OWVnNBT+QpWoGLOU0SsroA==
X-CSE-MsgGUID: R9UhNcoCSlOivPNisG032Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119037"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 03/13] fs/resctrl: Avoid "may be used uninitialized" warning
Date: Tue,  7 Apr 2026 09:02:00 -0700
Message-ID: <56fa3b5937ec6fda4eec162393463d8dbfc1abe4.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Building resctrl with extra checks ("W=12") produces the following warning:
 .../include/linux/ucopysize.h:22:17: warning: ‘buf’ may be used uninitialized [-Wmaybe-uninitialized]
   22 |                 __check_object_size(ptr, n, to_user);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 .../include/linux/ucopysize.h: In function ‘pseudo_lock_measure_trigger’:
 .../include/linux/ucopysize.h:10:13: note: by argument 1 of type ‘const void *’ to ‘__check_object_size’ declared here
   10 | extern void __check_object_size(const void *ptr, unsigned long n,
      |             ^~~~~~~~~~~~~~~~~~~
 .../fs/resctrl/pseudo_lock.c:754:14: note: ‘buf’ declared here
  754 |         char buf[32];
      |              ^~~

__check_object_size() ensures the provided buffer is within a valid location
but does not read from the uninitialized buffer. Even so, initialize the
buffer to silence the warning to help resctrl have a cleaner build.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/pseudo_lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
index fa3687d69ebd..e1e9134474f4 100644
--- a/fs/resctrl/pseudo_lock.c
+++ b/fs/resctrl/pseudo_lock.c
@@ -750,8 +750,8 @@ static ssize_t pseudo_lock_measure_trigger(struct file *file,
 					   size_t count, loff_t *ppos)
 {
 	struct rdtgroup *rdtgrp = file->private_data;
+	char buf[32] = {};
 	size_t buf_size;
-	char buf[32];
 	int ret;
 	int sel;
 
-- 
2.50.1

