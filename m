Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82DD1F63F7
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733502715; cv=none; b=u198Kjv+gpzo5gfJH1C7CscK6azvSpkUoD32AQb0Qso93SQd01sOoP1+4Jq6YIDzgYS0nrYC4tVrR1I9jrJQPGYU92Heu65eCMr/ck9xG0ivW3Qur7wngqbBELx77EFrDoNVr1UcsNwKTFyodFDpuCBiGr7CqD4yIqBxtw2jytY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733502715; c=relaxed/simple;
	bh=ZDJMo0u8Si0285Zl0KUnk0ZmV5wCKWgexdFgojmThyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GPApf1sDLil66Y5Ym2iZbIts6glwkDf3jpo7CwT73sNSAoOIYAGShoGjdin40szrYFbH/1cPdnK5fPvAgOQ7SSW+hqpeQHmgV0Mk4v0QT+6jqWtkfupJFR4Ay0ANArFP3J5bCp3J6OYz+Xc9myQAv8R95wxMAXzm9464QC1EUI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G9h4Qf+9; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G9h4Qf+9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733502714; x=1765038714;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZDJMo0u8Si0285Zl0KUnk0ZmV5wCKWgexdFgojmThyk=;
  b=G9h4Qf+98dhIuQh1+4UW17PxK77mkjq2ey3tN5w8hFgV9hLtvmMLkwcw
   F9ZkstqFSsA4Jj+vsDgxC7MQ80h4HIUkO3kZ9VgFRZr/JnzuZrsmhakEz
   nTMpboZ4/6zjLqtts+1IKiLIfhnJMIfHg3/D2lJySCyrOxs2+LpugvcqW
   1rJy9lq9ec0DrIEEXq8nU0a81T7rIpGRWO/WV55uNJSjNMSzrxmQlUxtu
   tHsl/hPgkTm04wIrnVOAEBorfMIUaClpvKsxEkfbApwnM2C+myMUtdaST
   HU6+QfhMWUf4AE44Wt46un8vVXvGFUgCUOU3n9pi1YrYoZdF8hCpC/I+N
   g==;
X-CSE-ConnectionGUID: CI9AaYgQRW6g8CzNbYth5w==
X-CSE-MsgGUID: QN6B3vW4SHmtBjlWwUV+jA==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="44470370"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="44470370"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:53 -0800
X-CSE-ConnectionGUID: swQFZBx+SFelYcNoLuFU+Q==
X-CSE-MsgGUID: 05oRb8uNSG6s4x9z/65y7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="95258498"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 08:31:53 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v11 0/8] x86/resctrl: mba_MBps enhancement
Date: Fri,  6 Dec 2024 08:31:40 -0800
Message-ID: <20241206163148.83828-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Background
----------

The resctrl filesystem supports a mount option that allows users to
specify a memory bandwidth limit in MiB/s for each domain of a CTRL_MON
group.  The underlying implementation uses data collected from the local
memory bandwidth monitoring event for the CTRL_MON group and all of
its MON subgroups as input to a feedback loop that adjusts the memory
bandwidth allocation control percentage up or down to keep the group
within the limit set by the user.

Problem statement
-----------------

Hard coding the local memory bandwidth monitoring event has the following
issues:

1) Some systems may support total memory bandwidth monitoring but
not local.  The user cannot use this mount option on such systems.

2) For large workloads that span NUMA domains using local bandwidth
monitoring will not throttle jobs correctly.

3) Users may have a mix of large and small workloads and may want to
use different input events per CTRL_MON group.

Solution
--------

A) Provide a new user interface to choose which event is used for each
   CTRL_MON group.

B) Allow systems that only support total memory bandwidth monitoring to
   use total bandwidth event.

Changes since v10:
Link: https://lore.kernel.org/all/20241122235832.27498-1-tony.luck@intel.com/

Patch	Change
-----	------

2	s/filesystm/filesystem/
	Reformat block comment above definition of mba_mbps_default_event using
	more of 80 column width

3	s/Update_mba_bw()/update_mba_bw()

Added Reinette's Reviewed-by tag to parts 2-8

N.B. v6.13-rc1 introduced a locking change in commit f1be1788a32e ("block:
model freeze & enter queue as lock for supporting lockdep") that throws
a lockdep splat when mounting the resctrl filesystem (with certain
CONFIG options).

Proposed patches that fix this are here:
Link: https://lore.kernel.org/all/20241206111611.978870-2-ming.lei@redhat.com/
Link: https://lore.kernel.org/all/20241206111611.978870-3-ming.lei@redhat.com/


Babu Moger (1):
  x86/resctrl: Introduce resctrl_file_fflags_init() to initialize fflags

Tony Luck (7):
  x86/resctrl: Prepare for per-CTRL_MON group mba_MBps control
  x86/resctrl: Modify update_mba_bw() to use per CTRL_MON group event
  x86/resctrl: Compute memory bandwidth for all supported events
  x86/resctrl: Make mba_sc use total bandwidth if local is not supported
  x86/resctrl: Add "mba_MBps_event" file to CTRL_MON directories
  x86/resctrl: Add write option to "mba_MBps_event" file
  x86/resctrl: Document the new "mba_MBps_event" file

 Documentation/arch/x86/resctrl.rst        | 10 +++
 include/linux/resctrl.h                   |  2 +
 arch/x86/kernel/cpu/resctrl/internal.h    |  9 ++-
 arch/x86/kernel/cpu/resctrl/core.c        |  9 ++-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 70 +++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c     | 94 +++++++++++------------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 43 +++++++----
 7 files changed, 171 insertions(+), 66 deletions(-)


base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
2.47.0

