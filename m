Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D0718C32E
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 23:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732319920; cv=none; b=AyBXCipv55kNUa7UvmkhZiwzBRRtuSNtvaru5OQoZl2vyfG+HteJdn59g3zhYODfUlQZMq7KBtYWs4GtTOSdoNR0l6wa3vvjHg1gAbLolauHaHHIkDrmO3efqlCIWBFGNRs+qgUve4tI8ycez1AP1Ch/8VB1hprFLWYtdhE4/dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732319920; c=relaxed/simple;
	bh=o+mwQMPsaauq5Ql/+1lz438tDG5xJU/RZpT/OtYWvjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EQ02GAUTSZNspecRG9vM9OZTmoC4/aT+f1MPsqnguFLMygB8mj/0TlWXxHSwYm/gBk9IMX2yjRguiWlAqZhB6+HS2+liYkr957DvNh7pxe6QaLF/miJ4hUQDesP7hdFwG2p3FLIxM1/ecayiwePQdkOHFbC/azLA6Euad7RGpj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MH7NTbYh; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MH7NTbYh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732319918; x=1763855918;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o+mwQMPsaauq5Ql/+1lz438tDG5xJU/RZpT/OtYWvjI=;
  b=MH7NTbYh6w4+HxX3gESayOKtTnOeFGeKQtGYqy2wZGiKYYzJW1UlJhSF
   urv/4jle+a3+NA1ZYz1JVcFMkb42sYywigrhZZt5gi2hlQkHMrZAbkPsl
   Dmw45+rxkB/bmDzuIouwp9ls0SCbGtY6szluviXfwbV8+ehtwyi1ba+Va
   BDEfwyJsXKCtCw3lAsJlM6SUJfl4zpV921ooMaN5RV/ttftUmyGZ/MYoQ
   3g9oe/Onc56iJx6Zxfk6v3bZ2p8QR/F6N4Ce3uReB/pW6/DqC8iaK3ZIK
   JkXOI/8yGZX5Q8KCg/pknXsytGoTSqFAOA7YJQN7GxK7rYf7MMo8StWHB
   g==;
X-CSE-ConnectionGUID: IG51atclT8eIeY3/5s4pQw==
X-CSE-MsgGUID: kKniTAyVT2aBsphjE+THIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32642682"
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="32642682"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:38 -0800
X-CSE-ConnectionGUID: 3fxpL0GwQg6+YaryFbjgPQ==
X-CSE-MsgGUID: 1utxzdK8RbWxoq1xurkgfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="90850888"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:37 -0800
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
Subject: [PATCH v10 0/8] x86/resctrl: mba_MBps enhancement
Date: Fri, 22 Nov 2024 15:58:24 -0800
Message-ID: <20241122235832.27498-1-tony.luck@intel.com>
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

Changes since v9
Link: https://lore.kernel.org/all/20241114001712.80315-1-tony.luck@intel.com/

Globally s/ctrl_mon/CTRL_MON/ in commit comments.

Patch	Change
1	* Moved "Reviewed-by:" tag after Signed-off-by tags
	* Added comment that I dropped the __init attribute that
	  was in Babu's original patch
2	* More detail in commit comment
	* Added block comment above definition of mba_mbps_default_event
	  global variable
	* Fixed bug reported by Reinette that changes to event used
	  for default group persist across unmount/mount. Did this
	  by moving initialization from rdtgroup_setup_default to
	  set_mba_sc() to catch both mount and unmount.
3	* Write commit commemt with problem & fix sections
	* Add note to commit comment that check for is_mbm_local_enabled()
	  is deleted by this patch.
	* Delete redundant check of is_mbm_local_enabled()
4	* Write commit commemt with problem & fix sections
	* Reword legacy comment to avoid "we".
5	* Merged old patch 9 into this patch
	* Write commit commemt with problem & fix sections
6	* Remove "historical" paragraph from commit comment
	* Add note that "mba_MBps_event" file is only visible
	  when the "mba_MBps" mount option is in use.
7	* Remove "historical" paragraph from commit comment
8	* No change

Signed-off-by: Tony Luck <tony.luck@intel.com>

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
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 45 +++++++----
 7 files changed, 173 insertions(+), 66 deletions(-)


base-commit: adc218676eef25575469234709c2d87185ca223a
-- 
2.47.0

