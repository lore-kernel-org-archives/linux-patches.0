Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47C3317145
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044237; cv=none; b=ZV1KAGs8jHcmwywY4fkeoxnjY9o2I1UDi8X1k3L68FpgGS20cekJS1HQnO5uRB14ljh4tQpGSpf6nseOFMHNhGemNHXBc8FWif/1IziRh97RXPzsf+8qyRe6cjWNuzUtmpe189slB8SyU5mXR3wSA1a+vRl3P0FzfoS7Diz9k5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044237; c=relaxed/simple;
	bh=v12I4fNHeG9jvYo3wUAhnOp8GtSP5lv3bu1tJwepx+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5rNnjE4OQORDynbkmd1yy7EBt1QWYpcubvMO66rhPWNlkWDIQrhyiORhk/BczJVhUSbEKhPcnwjynKR4D6X/eGurbYgwYXKtOz6G8ruJLj/gTMN+PunNhwJnTVYSk2nmqI2ziYBIAY28Up6StvC+v+bmokmQgHvKGncdvHsFd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mlpmhmmy; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mlpmhmmy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044235; x=1805580235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v12I4fNHeG9jvYo3wUAhnOp8GtSP5lv3bu1tJwepx+o=;
  b=MlpmhmmyRLgPYDN8wiFowur77AlKkbq/Cb7wy80O8pez7DPC6Wu7j8+y
   urNMFCZ0ZanGeby+pXkeXzXybU/ditDTjivmRGT2vZiMrro1CIfcj9PZz
   Ta/zs2dJMkyrggovFQBVP8u3xa74VALOWwU4GLzVF/GAm2/TQdk7wNK96
   hBzMblWacQ4OvZBMwuK0ouZbVLcF7iLzOI+Iz3phOV4Za1ZX+JTXHL4AS
   /sNNsY3L5OMP8OsIweERPIIcGc9nlXn5asTciZoX36UrZuNbPQTAqZR+u
   zWmyNZlJoXpq5XoY/wkonIpJ3iefwP0UPgrm7VY9WmOYuQ0aCdSXnTFsJ
   A==;
X-CSE-ConnectionGUID: FFd7yib7Rom8RDJMNQoF9w==
X-CSE-MsgGUID: CYm1CUbiTG6y63YlA2hGhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758355"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758355"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:54 -0700
X-CSE-ConnectionGUID: juNpR+9uSgqXmYawAE9nYA==
X-CSE-MsgGUID: cLgOUIwQQSaNyYlEim28OQ==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:54 -0700
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
Subject: [PATCH v2 03/14] fs/resctrl: Avoid "may be used uninitialized" warning
Date: Fri, 20 Mar 2026 15:03:13 -0700
Message-ID: <0e64fcf4e6be27a1144e569f591f2bbd54eb7ccf.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
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

