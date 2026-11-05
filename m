Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793837629;
	b=my/y82QPo9ShobiMKH998N2I7C/ycbpbN8+bdBaWxb8NyLiXLXAuxoBORRc3JoBaR+xc
	 e2EdiGrf7sRH6zh5av+Swnq9NYdBlm9awuxCawikY8gXWFx6Bw6uIjjfLWrwiqVGM36DT
	 zZsjWkwbIUNqcwVz0vvbilBWDqaSHzG37E7Ivn3KPvnSNIvFKcTk0aHcAQ7pQeTqK/vop
	 tmStqf6bTpuzVDUGCU6yR4U2Meu3G/lN8ybc2P5wYOL4EHNnMaHSFm3Pl0RT1/VwOzrKv
	 wVSpWR1GhlfBXPKOLHLBjd2scw1LhGwGXgdA4pJD4Ubh3m6Ffq63CnACBSrLCCYCcEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793837629;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=9DVfCCkh/EktKe2pkVPRqOHiv8FK8+JVOnopPbeiz1w=;
	b=rE2xrV5nyUwgqqAcSKTzTkPDM0AyF6r3aRCCZWWdPzJdbWASzxP2Fk7MakWGN2joxGnQ
	 odbRfWIHLYV3zYlVM35blKGo8OiU7HLlDISFfsPmcsukEqaFAwgETiUxCwJnorcNurFSR
	 tDdY4upnEtOi5uIvAWH5obzRrkw3lH9eo8btKURxUdIO1DGT7od5dGew/O1R2VSfcQULT
	 a3ZJjBrwxjfdHGC2tK+xzGHR4yhR4nD7N6TGK3zz70gNVuRpjZ3QdMlhd+hgkrolz5JDF
	 V7RbFw1/AHh/xYNUAdbs4DWL2hCHuYXtQCevUqokw65iViVaBaACHGqk/5kDlJjB4bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lo5pqFOu;
	arc=none smtp.remote-ip=192.198.163.10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4542A606A31B
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 00:13:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4542A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=lo5pqFOu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793837628; x=1825373628;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Yf2GlWn2dSaLa9rtLPPTI4NXuKqaVUSaPojZsn5jfJw=;
  b=lo5pqFOuUSWftBtcVz60vs7HN0In4wjPq2GsTykfzJJoegg839SbDj7g
   tFHbqYdo8TzfK4ntGly44EgKFJQWQA/ijpOGQcezDSOyz7235zOEwdzMR
   QgyVr4msms7IpMeRK13ZwmU8OJwzUP9cMX5AO0aMfaiK1mOAUkoeGCn/o
   49x473acDGmCsPXZ/+2chz2aFhOt4qxJujScCQgcm1hvoOA0HEtk0CQYr
   JIxylZIWGn+m8HpeLqrE7s/Wh0vo90p8j3ZallykWF6mECYecEtAI3QMm
   /LuI/MGxwcH6RiWfJwbkMAVRycSqDetiDjfDMYjqNiJsDQI3X0NnpQDY7
   g==;
X-CSE-ConnectionGUID: SaUkv//oQdKWus96IqMuUA==
X-CSE-MsgGUID: XmsExRK4QXO83pFTe2Hjkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2512736"
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="2512736"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:13:47 -0800
X-CSE-ConnectionGUID: cueGtaKsS5OhlnqFWJkuMQ==
X-CSE-MsgGUID: V9Jiae/JSmW5ff0JQLDPng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,196,1787036400"; 
   d="scan'208";a="7168837"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 16:13:47 -0800
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
Subject: [PATCH v3 0/5] x86,fs/resctrl: Cleanups in preparation for multiple controls support
Date: Wed,  4 Nov 2026 16:13:28 -0800
Message-ID: <cover.1793834224.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
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

Changes since v2:
  - v2: https://lore.kernel.org/lkml/cover.1791406459.git.reinette.chatre@intel.com/
  - Rebase on v7.4-rc1.
  - Add tags. All patches now have at least two Reviewed-by tags.
  - No other changes.

Changes since v1:
  - v1: https://lore.kernel.org/lkml/cover.1788452481.git.reinette.chatre@intel.com/
  - Rebase on x86/cache branch of tip with HEAD at:
      50e5282df427 ("x86,fs/resctrl: Add event group descriptions for Intel Diamond Rapids")
  - Rework all changelogs. Most now explain why each change is safe and why it
    is needed independent of the multiple controls work. (Ben)
  - Make subject lines more specific and fix the prefix of the patch removing
    the non-linear bandwidth delay mapping.
  - Keep the informational message printed when an Intel system with non-linear
    MBA delay values is encountered, rewording it and adding the missing
    newline. Match the related warning to the same wording. (Chenyu)
  - Group the memory bandwidth property assignments during Intel MBA enumeration.
  - Clarify in kernel-doc that the MSR_IA32_L{2,3}_QOS_CFG scope property only
    applies to cache resources.
  - Add Reviewed-by tags from Chenyu and Ben.

Hi Everybody,

For resource allocation resctrl assumes there is only one way to allocate
portions of a resource. That is, every resource supporting allocation has a
single control in the schemata file that user space can use to allocate
portions of that resource.

All architectures supported by resctrl already support, or will soon support,
multiple controls per resource. For example, the memory bandwidth resource may
have a "maximum bandwidth" as well as a "minimum bandwidth" control.

Adding support for multiple controls to resctrl is a major endeavour. The goals
are described in [1] and summarized in the Linux Plumbers Conference 2025
slides [2]. The implementation is in progress, with the most recent PoC
available at [3].

This series contains the preparatory cleanups from the PoC that are ready to be
merged independently of the remaining work:
- Remove the unused support for non-linear Intel MBA delay values, including a
  user space configuration check that can never fail.
- Make the scope of MSR_IA32_L{2,3}_QOS_CFG a private x86 property instead of
  a resctrl filesystem cache property.
- Drop an unnecessary helper and an unnecessary function parameter.

The only intended functional change is a reworded informational message
printed if an Intel system with non-linear MBA delay values is encountered.

Changes since previous postings can be found in the individual patches.

[1] https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/
[2] https://lpc.events/event/19/contributions/2093/attachments/1958/4172/resctrl%20Microconference%20LPC%202025%20Tokyo.pdf
[3] https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/

Reinette Chatre (5):
  x86,fs/resctrl: Remove unused non-linear bandwidth delay mapping
  x86,fs/resctrl: Remove unnecessary non-linear MBA configuration check
  x86,fs/resctrl: Move MSR_IA32_L{2,3}_QOS_CFG scope property to x86
    resource
  fs/resctrl: Drop unnecessary is_mba_linear() helper
  fs/resctrl: Drop unnecessary parameter from
    resctrl_io_alloc_parse_line()

 arch/x86/kernel/cpu/resctrl/core.c     | 72 ++++++++------------------
 arch/x86/kernel/cpu/resctrl/internal.h |  4 ++
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  4 +-
 fs/resctrl/ctrlmondata.c               | 15 ++----
 fs/resctrl/rdtgroup.c                  |  7 +--
 include/linux/resctrl.h                |  7 ---
 6 files changed, 33 insertions(+), 76 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0

