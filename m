Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B183D4503E5
	for <patches@lists.linux.dev>; Thu,  3 Sep 2026 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454637; cv=none; b=Y6bnfXOuAKXCVIGz8lSjG50uGlk8XZbdAHG/v4DT2JsMdGDjQxzWUrR0/jdEJzZENxkld7zD079atnWI4dwelcz8ibRTdeSFQKe2IQ5ILACf4irAzEUuBlJJY0JmTqAnj38H4G8LKTdCqej9j6ZU+PjYBvK5cndkJDBdBCGmclI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454637; c=relaxed/simple;
	bh=YqDDEIlLMHfLW49hrYAJHj/JIRwZMrC9RDUIQ6NbikA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eBVw1lxWksu/I4xkm/WRcvG0vOe4UGMxC/rmr+l1GsrFeK1e03wMeKS5nX8ex8kWLGc6rYH+2tqt2dFF3a2hsdqnpZ92dLpAG1Y8XY6Bizyumu+fkQyOxA8BKTY2EMEj+9a/rqDkK3ri2ALBFU0GjNFwy7YxX2ExdktSVSGnfdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jVAyiIGK; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jVAyiIGK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788454635; x=1819990635;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YqDDEIlLMHfLW49hrYAJHj/JIRwZMrC9RDUIQ6NbikA=;
  b=jVAyiIGKGR7c0tx29UH3cDV2YX4tt7c+Qo0zRq1/D4FVb/vcpi3UFqxM
   nI3EQWumtDDftLiM/DKFgS/uqNUcHM1RViWFX9IkUL8XItQXA7o8Q5435
   xMd66Np6kKBeM6oYEmq0OrMEB1km/DKCygNbQLnplqx1YkCvlgnU7qj0W
   G10wBM2+okC3JKQMTJM32EFMyy3Xu3on6jbdRll0Fd6tdMltvf4RYD/uF
   btsmFeOGBW0XDw3AOvJE9b1VeqchH108r71qi9eRooTw7UqTJYNz20fLX
   0d1DyvNcGfF/P7T2UOQzXoN7wXNK9rN9FngkRzrFSnjr/CQr1ORbcY3Kn
   w==;
X-CSE-ConnectionGUID: LGklEO6xQk6uVyYoAHqSiQ==
X-CSE-MsgGUID: Mh+MyDjlTTauhj60sRbWOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="100103960"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="100103960"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 09:57:13 -0700
X-CSE-ConnectionGUID: tV/rwvJQRiaAIrLT07Nczg==
X-CSE-MsgGUID: t/fTLb6RSrOWliDDV8ld7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="273554211"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 09:57:12 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH 0/5] x86,fs/resctrl: Cleanups in preparation for multiple
Date: Thu,  3 Sep 2026 09:57:02 -0700
Message-ID: <cover.1788452481.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Everybody,

For resource allocation resctrl assumes there is only one way to allocate
portions of a resource. That is, every resource supporting allocation has
a single control in the schemata file that user space can use to allocate
portions of that resource.

All architectures supported by resctrl already or will soon support multiple
controls per resource. For example, the "memory bandwidth" resource may have
a "maximum bandwidth" as well as a "minimum bandwidth" control.

Adding support for multiple controls to resctrl is a major endeavour. [1]
provides a description of the goals with a summary available in last year's
plumbers slides [2]. The implementation is in progress with most recent
PoC at [3].

The cleanups included in this series are the preparatory patches from the PoC
that trickled to the top, thus kicking off the support for multiple controllers
to resctrl.

While this is v1 of the series these patches did make an appearance in both
RFCs of the PoC. Changes since these postings can be found in the individual
patches.

[1] https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/
[2] https://lpc.events/event/19/contributions/2093/attachments/1958/4172/resctrl%20Microconference%20LPC%202025%20Tokyo.pdf
[3] https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/

Reinette Chatre (5):
  fs/resctrl: Drop support for different bandwidth delay mappings
  x86,fs/resctrl: Remove "arch_needs_linear"
  x86,fs/resctrl: Make MSR_IA32_L{2,3}_QOS_CFG scope architecture
    specific
  fs/resctrl: Drop unnecessary is_mba_linear() helper
  fs/resctrl: Drop unnecessary parameter from
    resctrl_io_alloc_parse_line()

 arch/x86/kernel/cpu/resctrl/core.c     | 69 +++++++-------------------
 arch/x86/kernel/cpu/resctrl/internal.h |  3 ++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  4 +-
 fs/resctrl/ctrlmondata.c               | 15 ++----
 fs/resctrl/rdtgroup.c                  |  7 +--
 include/linux/resctrl.h                |  7 ---
 6 files changed, 29 insertions(+), 76 deletions(-)

-- 
2.55.0

