Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDA93803F4
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044244; cv=none; b=ppc8f436kk57RvBjCMTsDDVd0oh1SDWUz2bSqrx3DdfFlKHsA5ghOQqXPPWrAo1RIQ6HZHxdSpwlTrzNMP6iZbshEMx/k7KeX3QHdJwbiBX0nxtRNEEAedlE5iF6v7fTi7/xvDubhc8ajcFG3CnwT3sjWdizUVjPwZl+/GJaxZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044244; c=relaxed/simple;
	bh=zOWxlg7FblfuC6kp+IHmTGlYUnlqsa+9riVd1/eAi4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hc9wntpgAEo12/ICtn+q37X0KNFmaQx0FL1bBrPodh4wlU5/iFF+xv4nabNfCeZ6AbVZNMuGkWPz0g00l50Vy8wISGj6ojzmHU1YY/U2nbe2OvT8pDgA1K1CbhwIUCcewEIDHTT3nTV6lxW6aC1RNGBwakys+HlrtbVfVomi60c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HK121tmI; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HK121tmI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044243; x=1805580243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zOWxlg7FblfuC6kp+IHmTGlYUnlqsa+9riVd1/eAi4w=;
  b=HK121tmIhUeTExwU2YVbEyKLgsBSseHgRHudvGX4nBJNmZ4Tpt4xkAXK
   qWuoRPdvrajRBg03sA7QgZi5jBWMF6Q+txuHhoSHyT0B24PdJbPNxfKHm
   UoOwUirGAUYDcWQAmap+ppgpDmnyGPFrKPqrsZBhyJLdJ1a5/eZ7f6EWn
   la+00DRPNmlqKN6717Ov9K165kNejWMo72RmUeJ19ZnBvAEOGdDHTC0Ed
   crSxb6zBc+v3dQ3C278Ho38q2kzK67LtS0TFKrm5q7NohHd5lZ/yLDyHs
   JgvrfRCpzI7hrrlRRKWiW1YKY/NCmcJFyukw/FOVxqIwRcUGD/XV1XR1D
   w==;
X-CSE-ConnectionGUID: +19w7eaySUGJYz44wmBgHw==
X-CSE-MsgGUID: DsVIqDo4SdGixiMnEv4WFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758439"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758439"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:57 -0700
X-CSE-ConnectionGUID: Mhd5f3P5TbyKpgkA7EVB+Q==
X-CSE-MsgGUID: UEjAPUgZSJiy0I5UejOINw==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:56 -0700
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
Subject: [PATCH v2 11/14] fs/resctrl: Use stricter checks on input to cpus/cpus_list file
Date: Fri, 20 Mar 2026 15:03:21 -0700
Message-ID: <744ddfbc6365832a5707b4d1631158f42e121401.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Callbacks handling writes to resctrl files are called via
kernfs_fop_write_iter() that ensures that the resctrl callback is never
called with a NULL buffer. Even if user space issues a write() with a NULL
buffer and zero count the resctrl callback receives a valid buffer
terminated with '\0' and the number of bytes parameter set to zero.

The NULL buffer check at the beginning of rdtgroup_cpus_write(), while
making no assumptions about caller behavior, is not useful. An empty
buffer is transformed into an empty cpumask that is passed through entire
flow that results in no changes.

Ensure that the user provided buffer contains some data before attempting
to parse it using the same check as other resctrl files (the familiar
"nbytes == 0"). The custom is for resctrl file callbacks to fail on an
empty buffer and this brings interactions with the cpus/cpus_list file in
line with this custom. The risk is that if there exists a user space that
uses empty writes to this specific file then those successful interactions
will start failing.

Exit right away if there was no failure yet no cpumask could be created
from the input. It is of no use to pass an empty cpumask through the
entire flow, just return with success to short-circuit the existing
behavior.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/rdtgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 6fa5c8f14e3a..5f3d89c7757c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -515,7 +515,7 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	struct rdtgroup *rdtgrp;
 	int ret;
 
-	if (!buf)
+	if (!buf || nbytes == 0)
 		return -EINVAL;
 
 	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
@@ -555,6 +555,9 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 		goto unlock;
 	}
 
+	if (cpumask_empty(newmask))
+		goto unlock;
+
 	/* check that user didn't specify any offline cpus */
 	cpumask_andnot(tmpmask, newmask, cpu_online_mask);
 	if (!cpumask_empty(tmpmask)) {
-- 
2.50.1

