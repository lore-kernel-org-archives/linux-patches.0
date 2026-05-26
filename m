Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D7036212C
	for <patches@lists.linux.dev>; Tue, 26 May 2026 22:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832922; cv=none; b=WWEomA7/xA6sXhPozPDQerCwEB+baAaa1HvDzm0MPvj9QmfxEe5II4tjQYgyI5V6t0kzs6MBRtv2tutUzwYnfIu6Miz/bkfsMy6b6JgyzUzkXope2pa9mZPTYIikTmBleCmmgi/8waZF9ENAPDaA7F2jkewcfJqgS1g2479MGuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832922; c=relaxed/simple;
	bh=3W3ubDmw5FgXUQSv2Ll3SosLpBskPihTpn9tjtjNg68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CqMwY60jlVkmu0xbjfaVTt9Juo0NRCY47IgkIx9e45glCUz+DcGLb5ovyer5xDewvs7M+IVSoKhIdY3m0AFma7zR2QmI9/znu1wS/6DLDAJO+yvjY4iWqum3IOHzqlvgfNioUmOnfnPh+kyZ5sNZzbsEPtGi5n2/6Gy1wcDMkmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UENrJw7R; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UENrJw7R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779832921; x=1811368921;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3W3ubDmw5FgXUQSv2Ll3SosLpBskPihTpn9tjtjNg68=;
  b=UENrJw7RGencVgLXsjbD+dbyyBkuFBYZXeefHMUXnxiKx2kKW1qn/fn0
   N2CsLkJw9pCSFh1H5vXVorKe9PK2QuKppeGWkgwwseK6Jm7nZ3hBjmIUv
   2fwFa0p8LDqp1zrtaSa8f3ajdPYi2r8Yz1lcboXJ/Yhf1pJRVwNMb/Qqu
   TDbfhaIps3H0iuRzW+4yxOx1loqHdJFi4Fuvm56LE+hwTVb/LwNhi47PP
   G8aOnV03PMyUUzzm51wFn3mJb4IF8+dEiRUftWK8lIhcnPeKWExMXwFGJ
   BSGsKkQ2w3yKYQdUibO7XhCunVEu4wFq0vlH3baqFf09yaPXmItv3H/ZG
   A==;
X-CSE-ConnectionGUID: WnZrwhiHQBmrJ4a49X2L+g==
X-CSE-MsgGUID: lquEaYW+SNa8KY4DNu6adw==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80846261"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="80846261"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:02:01 -0700
X-CSE-ConnectionGUID: 9JMnC7CiQm60KIQdPmoo2Q==
X-CSE-MsgGUID: n8JR+M8bRbyO8oHH8NPGtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="246076930"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:02:00 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH RESEND v3 0/9] x86,fs/resctrl: Fix long-standing issues
Date: Tue, 26 May 2026 15:01:49 -0700
Message-ID: <cover.1779832265.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

V3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/

Sashiko encountered failure while reviewing the original V3 submission of
this series. This partial submission is only intended for Sashiko so that
it can consider the patches missed during V3 review.

Reinette Chatre (3):
  fs/resctrl: Prevent deadlock and use-after-free in info file handlers
  x86/resctrl: Ensure domain fully initialized before placed on RCU list
  fs/resctrl: Fix UAF from worker threads when domains are removed

 arch/x86/kernel/cpu/resctrl/core.c      |  18 +-
 arch/x86/kernel/cpu/resctrl/intel_aet.c |   5 +-
 fs/resctrl/ctrlmondata.c                |  38 ++--
 fs/resctrl/internal.h                   |   3 +-
 fs/resctrl/monitor.c                    | 100 ++++++----
 fs/resctrl/rdtgroup.c                   | 244 ++++++++++++++++++++----
 6 files changed, 301 insertions(+), 107 deletions(-)

-- 
2.50.1

