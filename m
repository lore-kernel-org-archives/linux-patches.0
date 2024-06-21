Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E2D16EC13
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009550; cv=none; b=J3bhEfZ9A3g/zsz28zg7Mpxe8CeonQ+o3x0ucxoGCMpiAuyamGATXEh0v4NRHcQ7+QNnEHGA9x45uKx+5YaJY3t2I6X750spgTL8LytVI/9i7bGSCnJJU83v1akCKXoR0HgZnEkwDFsPmXdfhM4JG9x6LKN8fH9OZzgwg/DscPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009550; c=relaxed/simple;
	bh=HVGr1OMYqhxJeiEX1KZV6JwYta6GuW+t70Bcbb/KPK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L0hCkXU6cm7PvRWya846WY3oPP+hkEf5zhuyH/rLIGPwc8a4XcW+GLiL14SA0p0u9WDVNlfUgvdyJumdOAKE81a5XTHSIgdBZY7vEtm3ZZVNZfFeX+UQDsZW/7cdRikdp14Yi9NpVLNVt+UL/XszM9SHi2U5rE+Rtg1rby8E3pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eIErnzmV; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eIErnzmV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009548; x=1750545548;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HVGr1OMYqhxJeiEX1KZV6JwYta6GuW+t70Bcbb/KPK4=;
  b=eIErnzmVeY6QGduGzuD70CAZ4LCeHL/cBSOgm14q4Chpwh0kT4iH6z28
   xZ/oxPIOt5DvvJqGdgNXBik3zrFXjxp5jQ14l1kWorA3fzSXceWTM2lZL
   X2yW2hcVXwk7whQoEk7YTJ/Odqf1vcOTmQ9lnW6Y0Axc5VGbRgGAGWeNQ
   CQ0ic6OsLZbmaeSTkJK0diQ03nQdJookvwqcAIbOweQRbjqwEGzfcUCiL
   bQaFGtL0QRBp5tMa93FI3dotJEQZCpqCd2fl7ErYrO1tnAmDQ4+F+jBUW
   G1tEe/DpZ3+HHYGinE9rNQoZVuPlJMJ8uDg/OBLuFJ8Pwo78DlBvWHNOF
   g==;
X-CSE-ConnectionGUID: lMYdziQuSO6+Y55kdhvhOQ==
X-CSE-MsgGUID: gLHnzjoOTv+8PoltCT69gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691252"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691252"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:07 -0700
X-CSE-ConnectionGUID: X8g/Y5phSpOmRxgePK7FbA==
X-CSE-MsgGUID: +3kU1aNqTku6miIClVmkDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935633"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:06 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v21 00/18] Add support for Sub-NUMA cluster (SNC) systems
Date: Fri, 21 Jun 2024 15:38:41 -0700
Message-ID: <20240621223859.43471-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series based on top of tip x86/cache commit f385f0246394
("x86/resctrl: Replace open coded cacheinfo searches")

The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
that share an L3 cache into two or more sets. This plays havoc with the
Resource Director Technology (RDT) monitoring features.  Prior to this
patch Intel has advised that SNC and RDT are incompatible.

Some of these CPUs support an MSR that can partition the RMID counters
in the same way. This allows monitoring features to be used. Legacy
monitoring files provide the sum of counters from each SNC node for
backwards compatibility. Additional  files per SNC node provide details
per node.

Memory bandwidth allocation features continue to operate at
the scope of the L3 cache.

L3 cache occupancy and allocation operate on the portion of
L3 cache available for each SNC node.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Changes since v20: https://lore.kernel.org/all/20240610183528.349198-1-tony.luck@intel.com/

1	Add Reinette review tag
2	Add Reinette review tag
3	Add Reinette review tag
4	Add Reinette review tag
5	Add Reinette review tag
6	Remove extra space in "snc_nodes_per_l3_cache  == 1" (comment and code)
	Add Reinette review tag
7	Updated comment above supports_mba_mbps() with new condtion.
	Add invalfc() to give user better error message
8	Move #include <linux/cacheinfo.h> from internal.h to <linux/resctrl.h>
9	Replace kerneldoc comment for struct rmid_read with Reinette's version
10	Add Reinette review tag
11	Fix kerneldoc issues for mon_data_bits
		End all entries with period.
		s/@rid/@u.rid/ ditto for all other union members
	Add Reinette review tag
12	Change test for snc_mode to use "== RESCTRL_L3_NODE"
	Use snc_mode to pick d->ci->id vs. d->hdr.id
13	Change test for snc_mode to use "== RESCTRL_L3_NODE"
	Use snc_mode to pick d->ci->id vs. d->hdr.id
	Move/reword SNC comment to top of function
	Drop double space from commit comment
	Drop "also" from commit comment
14	Initialize rr.ci in mbm_update()
	Split long line in rdtgroup_mondata_show()
15	Add period to end sentences in two comments.
	Fix the "sum" case in __mon_event_count() to return
	success if reading from any domains succeeds.
16	Update comment for arch_mon_domain_online() to say
	that it is enabling RMID shaing mode.
	s/Enable RMID shared RMID mode/Enable shared RMID mode/
	s/This isn't very compatible/This isn't compatible/
	s/Tehcnically/Technically/
17	s/number CPUs sharing/number of CPUs sharing/
	Add Reinette review tag
18	s/each bit would only represent 5MB/each bit only represents 5MB/
	s/mainatined/maintained/
	Add Reinette review tag

Tony Luck (18):
  x86/resctrl: Prepare for new domain scope
  x86/resctrl: Prepare to split rdt_domain structure
  x86/resctrl: Prepare for different scope for control/monitor
    operations
  x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
  x86/resctrl: Add node-scope to the options for feature scope
  x86/resctrl: Introduce snc_nodes_per_l3_cache
  x86/resctrl: Block use of mba_MBps mount option on Sub-NUMA Cluster
    (SNC) systems
  x86/resctrl: Prepare for new Sub-NUMA Cluster (SNC) monitor files
  x86/resctrl: Add a new field to struct rmid_read for summation of
    domains
  x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
  x86/resctrl: Allocate a new field in union mon_data_bits
  x86/resctrl: Create Sub-NUMA Cluster (SNC) monitor files
  x86/resctrl: Handle removing directories in Sub-NUMA Cluster (SNC)
    mode
  x86/resctrl: Fill out rmid_read structure for smp_call*() to read a
    counter
  x86/resctrl: Make __mon_event_count() handle sum domains
  x86/resctrl: Enable shared RMID mode on Sub-NUMA Cluster (SNC) systems
  x86/resctrl: Sub-NUMA Cluster (SNC) detection
  x86/resctrl: Update documentation with Sub-NUMA cluster changes

 Documentation/arch/x86/resctrl.rst        |  27 ++
 include/linux/resctrl.h                   |  88 ++++--
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h    | 108 +++++---
 arch/x86/kernel/cpu/resctrl/core.c        | 312 ++++++++++++++++------
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  86 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c     | 253 +++++++++++++++---
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  27 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 278 ++++++++++++-------
 9 files changed, 861 insertions(+), 319 deletions(-)


base-commit: f385f024639431bec3e70c33cdbc9563894b3ee5
-- 
2.45.2

