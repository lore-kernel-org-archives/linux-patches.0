Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0E333EB1B
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715073; cv=none; b=MdM9QBq4JX3GULbWdmr8A7GyV1UQu5qlefkEDwZqOoXkDWGw3nLe9t9Ehp+laTXtboIlIsb1At9jrhI/x3etByrR/nMgIcVlLMkraMOsgZn5bmiqor94WKy7RDgZM0D4gxbGgDltd0qUK3F/lFf9i3okqf0DJ9/mEacQr2m7sVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715073; c=relaxed/simple;
	bh=gf7CpiVBMV8TkYcnM8i16uDQlFIz7QT1NCE3HrlDU7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASwbWidhV8D+ma9I2wJAbKFZoIFBSuHZKvQT/xB8VpHEOQ9cHcwmmKjWSQIW2eTkrLV/QajsvyYwspXm5YnHNZLyEvDYA/GEXHgnT97VhEyhvDvyxg5T2IljVEl/lat48tFuu5sXwFD0dRRH3lQPVJZnO5jBnl95Wc3UG6DtOYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gpodz6B3; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gpodz6B3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715071; x=1789251071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gf7CpiVBMV8TkYcnM8i16uDQlFIz7QT1NCE3HrlDU7U=;
  b=Gpodz6B3eM8jxBh9jgK8D8ykridmX/yk/9Nem9/m02RorWzTdbU75iJN
   Rn/PsVMM7g9ZhddAD0roOiaa1/4zb2Pc9KbSrjQB5weplhVQ4JZv0VXWL
   HT1PoQw1CPOaBipm5u1ZoLdq/C/fpxOVFBNkVCEQuTXRkEsKFgHQHluBQ
   bVMAvC4SJyg/tFYS3VEsr/I7QnNRcwo2bjjGhN6KdQnJIDI1l1b05Chds
   4V5JjZwDJ+l+sDjDZBiR8Gt774E3fkIOmwstipLWaYR0lv7YbPRkf8zFf
   MkQqidEeX2GR7ECBsnBfQ2skOACBMmKTkNVOMWs+3pDJvFliMrqvgZ6tm
   w==;
X-CSE-ConnectionGUID: LJHbbZCOQCmWSM7D1fQuIg==
X-CSE-MsgGUID: A0LNhCXdS5GiJXoeZfmzgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002733"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002733"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:06 -0700
X-CSE-ConnectionGUID: ee8Xo1RhTsiIV2VrlerXAA==
X-CSE-MsgGUID: lCLnyLLsSJKH2BkZMgcvZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265172"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:06 -0700
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
Subject: [PATCH v10 12/28] x86,fs/resctrl: Add an architectural hook called for each mount
Date: Fri, 12 Sep 2025 15:10:33 -0700
Message-ID: <20250912221053.11349-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enumeration of Intel telemetry events is an asynchronous process involving
several mutually dependent drivers added as auxiliary devices during
the device_initcall() phase of Linux boot. The process finishes after
the probe functions of these drivers completes. But this happens after
resctrl_arch_late_init() is executed.

Tracing the enumeration process shows that it does complete a full seven
seconds before the earliest possible mount of the resctrl file system
(when included in /etc/fstab for automatic mount by systemd).

Add a hook at the beginning of the mount code that will be used
to check for telemetry events and initialize if any are found.

Call the hook on every attempted mount. Expectations are that
most actions (like enumeration) will only need to be performed
on the first call.

resctrl filesystem calls the hook with no locks held. Architecture code
is responsible for any required locking.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            | 6 ++++++
 arch/x86/kernel/cpu/resctrl/core.c | 9 +++++++++
 fs/resctrl/rdtgroup.c              | 2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index de66928e9430..6350064ac8be 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -511,6 +511,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 void resctrl_online_cpu(unsigned int cpu);
 void resctrl_offline_cpu(unsigned int cpu);
 
+/*
+ * Architecture hook called at beginning of each file system mount attempt.
+ * No locks are held.
+ */
+void resctrl_arch_pre_mount(void);
+
 /**
  * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
  *			      for this resource and domain.
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7219004e896f..05b9fd415d78 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -720,6 +720,15 @@ static int resctrl_arch_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+void resctrl_arch_pre_mount(void)
+{
+	static atomic_t only_once = ATOMIC_INIT(0);
+	int old = 0;
+
+	if (!atomic_try_cmpxchg(&only_once, &old, 1))
+		return;
+}
+
 enum {
 	RDT_FLAG_CMT,
 	RDT_FLAG_MBM_TOTAL,
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 4f992b497092..223fd8b761e6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2720,6 +2720,8 @@ static int rdt_get_tree(struct fs_context *fc)
 	struct rdt_resource *r;
 	int ret;
 
+	resctrl_arch_pre_mount();
+
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 	/*
-- 
2.51.0

