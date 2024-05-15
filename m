Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E0315B570
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811815; cv=none; b=lD7VlyJoWk51nS1AVLC4pvLjZHXqtd0uvl3zdAvtYOOXIvXtH2ba+2JGkTbXWHZyz2nu6R8n+Vwzedy8IoOS+o92MCDkbBXGyRnq4WaTWGOVCenOj/l7hAIH5ffuAsUlwWMkCcbj5KLRIE1cC+55qLuf9JCC3aKcEl+p2/o7YxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811815; c=relaxed/simple;
	bh=3LjmC1IavTCrqU6x6ALfLuDQU7+uE9sxvD5LaeTkgqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jkif8HGTCmfK7bkjdlwjb9ZcsxOaxDoeS2S9Xc+3VNM6Xmm+v7bAb6zx/2mrnWYVLBjVjRjDYIT1ZOAQcL0X5y1PzLDMsoMNHTn4keujTVYqcqDR1XelfPXBFlDf5nsVEM3ADFLdYa5v6G8cVTLHR+DC+0qrSOp4WxTw3Lv/kDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lizKP0TB; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lizKP0TB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811813; x=1747347813;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3LjmC1IavTCrqU6x6ALfLuDQU7+uE9sxvD5LaeTkgqo=;
  b=lizKP0TB1TAdjplKGewOzjCeyGA+Epuwu4neR0Tna8XczksA79wSXSKU
   HkhklFrDxUq4uq9z370+FbTq5torBKqiZgGyi0NjBzZHoDhQcLWQ+uZDK
   qemfkfpKqdcnr4Fnp0InGHIJB+D/k/s3Yux1HO9pKoY+V4dW7FjP5ga5V
   PjEtBrKmkaUcZ5WF7dcVVb9yNLboNhCpRwMBh2Teg0dJ8HLqhG2qIZP/Q
   kzNExRxSMZH74M9PoG08FTVlCnsr+l7Aj5SVSpJ1o9/zhtP5oYP76w9Uj
   scGW0pZxTYKmBUJ3B46C1BKgMQNKWgLrclMBbKbFSo6LX74ODaoMLZzAR
   Q==;
X-CSE-ConnectionGUID: COJThN1fSw6fs0YAuvEH1A==
X-CSE-MsgGUID: Kx6ey5WvRiOTwkdYqy5ZSw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671575"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671575"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:32 -0700
X-CSE-ConnectionGUID: cUco/v6aSz+kVgr8ZEa+LQ==
X-CSE-MsgGUID: x3Km09sKQUyQrI1z/lE6Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989126"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:32 -0700
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
Subject: [PATCH v18 00/17] Add support for Sub-NUMA cluster (SNC) systems
Date: Wed, 15 May 2024 15:23:08 -0700
Message-ID: <20240515222326.74166-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series based on top of Linus upstream commit 33e02dc69afb ("Merge
tag 'sound-6.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound")

The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
that share an L3 cache into two or more sets. This plays havoc with the
Resource Director Technology (RDT) monitoring features.  Prior to this
patch Intel has advised that SNC and RDT are incompatible.

Some of these CPUs support an MSR that can partition the RMID counters
in the same way. This allows monitoring features to be used. Legacy
monitoring files provide the sum of counters from each SNC node for
backwards compatibility. Additional  files per SNC node provide details
per node.

Cache and memory bandwidth allocation features continue to operate at
the scope of the L3 cache.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Changes since v17: https://lore.kernel.org/all/20240503203325.21512-1-tony.luck@intel.com/

Reinette: This is still using the per-domain display_id field as
discussed. Would a better name make the intent clearer?

Patch 7 in previous version included virtually all of the new changes.
But that meant it was doing a lot of thinngs in a single patch
(including reverting a dozen lines from patch 6!)

So this series breaks patch 7 into nine pieces (0007..0015) for
better documentation in commit comments of the changes, and hopefully
easier review.

Patches 0001 ... 0005:  Unchanged
Patch 0006:             Dropped change that was reverted in v17.0007

Next nine are the split of the original patch v17.0007
Patch 0007:             Added bigger commit comment describing where
                        this part of the series is heading and why.
Patch 0008:             Added justification for new display_id field in struct rdt_mon_domain
Patch 0009:             Split out a helper from mkdir_mondata_subdir()
                        so real changes in patch 0011 are easier to see.
Patch 0010:             Comment stealing a bit from union mon_data_bits.evtid
Patch 0011:             Save display_id instead of a random d->id in
                        meta data for monitor files that must sum SNC nodes
                        Don't call mon_event_read() to initialize "sum" files
Patch 0012:             Set domid for "sum" files to the display id, not
			to whatever SNC domain ID is in use here. Don't
			call mon_event_read() for "sum" files.
Patch 0013:             No change (apart from being split out from old patch 7)
Patch 0014:             Because of change in patch 0011 to save the
                        display_id can no longer look up a domain using
                        rdt_find_domain(). Instead search r->mon_domains
                        for a match with d->display_id or d->hdr.id
                        Drop extra arg to ___mon_event_count() also
                        the "tmp" variable in __mon_event_count()
Patch 0015:             Put #include <linux/cacheinfo.h> in alphabetical order
			When SNC is disabled, keep the old check that
			the current CPU is in the domain being read.
			For the SNC case add comment about reading
			monitor values from any CPU in the same L3 domain.

Patch 0016:             Took alternate SNC detection algorithm from:
                        https://lore.kernel.org/all/20240327200352.236835-11-tony.luck@intel.com/
                        as it is simpler. But merged in the sanity
                        checks that make sense.
			Converted the X86_MATCH*() usage to new model
			that supports Intel families other than "6".
Patch 0017:             No change


Tony Luck (17):
  x86/resctrl: Prepare for new domain scope
  x86/resctrl: Prepare to split rdt_domain structure
  x86/resctrl: Prepare for different scope for control/monitor
    operations
  x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
  x86/resctrl: Add node-scope to the options for feature scope
  x86/resctrl: Introduce snc_nodes_per_l3_cache
  x86/resctrl: Prepare for new Sub-NUMA (SNC) cluster monitor files
  x86/resctrl: Add and initialize display_id field to struct
    rdt_mon_domain
  x86/resctrl: Add new fields to struct rmid_read for summation of
    domains
  x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
  x86/resctrl: Allocate a new bit in union mon_data_bits
  x86/resctrl: Create Sub-NUMA (SNC) monitor files
  x86/resctrl: Handle removing directories in Sub-NUMA (SNC) mode
  x86/resctrl: Sum monitor data acrss Sub-NUMA (SNC) nodes when needed
  x86/resctrl: Fix RMID reading sanity check for Sub-NUMA (SNC) mode
  x86/resctrl: Sub NUMA Cluster detection and enable
  x86/resctrl: Update documentation with Sub-NUMA cluster changes

 Documentation/arch/x86/resctrl.rst        |  17 +
 include/linux/resctrl.h                   |  89 +++--
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/kernel/cpu/resctrl/internal.h    |  78 ++--
 arch/x86/kernel/cpu/resctrl/core.c        | 422 ++++++++++++++++++----
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  70 ++--
 arch/x86/kernel/cpu/resctrl/monitor.c     | 106 ++++--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  26 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 267 +++++++++-----
 9 files changed, 779 insertions(+), 297 deletions(-)


base-commit: 33e02dc69afbd8f1b85a51d74d72f139ba4ca623
-- 
2.44.0

