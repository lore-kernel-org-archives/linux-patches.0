Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284358;
	b=00DIFhPa1DBtLkZSjBfrtH0FpUbiXgbacFPsSu5UUuHLF4gfVgJRbQcbxHVG8wp/dRXl
	 fe/wG+NByWM1cSUGr7+u/qeoTHCOOWAGEuNUqSdu8olN9ptLXOX5rfSkJUe20qBfga3Hs
	 uap8KtyTtFIQSsCd91IGDJsHFLNQFABrfeiNzSea+AfcYuYf1YnBoDbnEryWphd01d+Bb
	 nmm1wy0z/Pdcrz7XPnC1JULore7NhPYYuoCaFf5KkQs+MCCGyf8/AOAgA1tfXXhKpSUhO
	 7QBKegyMfmMd5JhxMSTt+8schswzmjIuxwq03tLhFEBz/NRpU1hL6N8oBAwe4oZ3gbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284358;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=D6I+9mOh63hZoFlVcPImYCerGlblTsLsV4DNO+WiNiQ=;
	b=WVMX24VmcZxKXK0W2r1xa4mnd9jlbtTByVUn4lMNSRk4HzdDzOnQTcFyR/eEdKyQCG/h
	 JIsWCk6TwX3ps25l/0W/3w5DcAWtax8ez+bSNA2UXn/Aks4iHFIZfZWiKnCV2MOxk2Bch
	 xpH6SpwzEfYKoo7RWXvSGZUUWCny1adr1nkoMvFma9/GNb/LYeImvUUqfXJPpKddBdPe6
	 2QZM68g2e36wftm6Hz+LgUEIJPZr9rJkIIUz8T20WW95m4mnQEyIbS+JcbqVoeTX+KxYQ
	 Kjr8Vgv8tFqUYr1ysfX0he7VdJG0VKtv/rXXJ8uq3U3H5YUBezr674cVHlzJQWAGN/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bxEOLT6z;
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6DF606A334
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 04:19:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF6DF606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bxEOLT6z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794284356; x=1825820356;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M1DlmdfP/qnqzTDgZw6h2TGWtbHGaNHnFQKtmH0THtY=;
  b=bxEOLT6zdBGGyLuXYgByQly6SSbQ4nGHpoP+3CTfb65vz47YKlicZJoQ
   yUeWqYSMokzJEZZUEO/24GpuwSoCDy1dSn2iJudQqptSZCfJwPhuauUdo
   qDe2Mugf/LWWIOBlVM83niJSN75xPh7oOzSBHKL+of+M67q9vRdH7/yzO
   w7XBgdpsLzx+tgJkSQbAym9ExV2Zpr5UhW/+icYfIwZXzwgUSPrPWUj+v
   SZTEg38X2Aq0bPFrVc45XjIDvqabuz8IdF/cXUAG03zVq7MU1u4tM0yWV
   0f3Y19ggNlsgjIDRXG9cjytyPerJu4bN656rX7sA+v/WG58sIPjkPzu8M
   Q==;
X-CSE-ConnectionGUID: 4ncQa+jKTO2o02j5lCyHhw==
X-CSE-MsgGUID: vKtkV+ZrQxODhy3FzelRYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="2901284"
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="2901284"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:14 -0800
X-CSE-ConnectionGUID: 203t+MEKTmimaDAVzZuetw==
X-CSE-MsgGUID: 6Q/XI7PzR9mFU4x8bWf6KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,205,1787036400"; 
   d="scan'208";a="7856905"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 20:19:14 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: ben.horgan@arm.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	fenghuay@nvidia.com,
	ruanjinjie@huawei.com
Cc: tony.luck@intel.com,
	yu.c.chen@intel.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	tan.shaopeng@fujitsu.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v3 0/8] arm_mpam: resctrl: Separate MPAM domains
Date: Mon,  9 Nov 2026 20:19:00 -0800
Message-ID: <cover.1794283825.git.reinette.chatre@intel.com>
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

Thank you very much to Ben, Jinjie, and Shaopeng for reviewing and testing RFC v2.

Changes since RFC v2:
  - RFC v2: https://lore.kernel.org/lkml/cover.1792443633.git.reinette.chatre@intel.com/
  - Patch 1 is new. It adds find_mbwu_mon_comp() to replace the duplicate
    code found in resctrl_arch_cntr_read() and resctrl_arch_reset_cntr(),
    as suggested by Jinjie.
  - WARN when domain allocation fails. (Ben)
  - Squash three patches into the patches they build on. (Ben)
  - Move "Require a component for each monitoring event" ahead of the
    structure split so the check it adds precedes its first user.
  - Fix the mpam_resctrl_get_mon_domain_from_cpu() function comment that
    still referred to the control component.
  - Add tags from Jinjie and Ben.
  - Please see the individual patches for their detailed changelogs.

Changes since RFC v1:
  - RFC v1: https://lore.kernel.org/lkml/85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com/
  - Give each type of domain its own structure instead of duplicating the
    shared one, set up each domain independently instead of undoing one
    domain when setting up the other fails, add additional verification
    checks.

The MPAM driver represents a resctrl domain with a single structure,
struct mpam_resctrl_dom, that holds both a control domain and a
monitoring domain. On a system that supports both allocation and
monitoring, one instance is created for each domain and its two
domains are added to the resource's control and monitoring domain
lists.

Holding both domains in one structure requires control and monitoring
to be done at the same scope, and ties each control domain to a
monitoring domain. This does not fit the proposed support for multiple
controls per resource [1]. There, each control of a resource, for
example a "min" and a "max" memory bandwidth control, has its own list
of control domains while the resource keeps a single list of
monitoring domains. With one structure for both, every control domain
would come with a monitoring domain of its own, which does not reflect
the resource.

This series gives control and monitoring domains their own structures,
set up and torn down independently as CPUs come online and go offline,
in preparation for supporting multiple controls per resource. Along
the way it stops failing CPU online when a domain cannot be set up,
and adds checks when setting up a monitoring domain.

  1     Share the lookup of the component counting an event
  2-3   Preparatory cleanups of domain allocation
  4     Do not fail CPU online when domain setup fails
  5-6   Preparation for separate domain structures
  7-8   Separate the control and monitoring domain structures

Transitioning this submission from RFC to PATCH after gaining more
confidence in the changes thanks to Jinjie and Ben's reviews and testing.

The series was rebased onto v7.4-rc2 since the for-next/mpam branch
of the arm64 tree does not exist at this time.

[1] https://lore.kernel.org/lkml/d258a32f-12d5-464d-abe9-4720fb3e44b3@intel.com/

Reinette Chatre (8):
  arm_mpam: resctrl: Add a helper to find the component counting an
    event
  arm_mpam: resctrl: Use find_component() when allocating a domain
  arm_mpam: resctrl: Rename ctrl_comp in mpam_resctrl_alloc_domain()
  arm_mpam: resctrl: Do not fail CPU online when domain setup fails
  arm_mpam: resctrl: Split control and monitoring domain setup into
    helpers
  arm_mpam: resctrl: Require a component for each monitoring event
  arm_mpam: resctrl: Give the monitoring domain its own structure
  arm_mpam: resctrl: Rename struct mpam_resctrl_dom to
    mpam_resctrl_ctrl_dom

 drivers/resctrl/mpam_devices.c  |   2 +-
 drivers/resctrl/mpam_internal.h |  11 +-
 drivers/resctrl/mpam_resctrl.c  | 384 ++++++++++++++++++--------------
 3 files changed, 220 insertions(+), 177 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.56.0

