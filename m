Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD19A1ABEB7
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727982760; cv=none; b=AVci5WZ05YVYLN4I+g9/sZcjzhXNcPiJ4gVU1ewaf8BkNAW538JyfWtP62LCUmpkrpJUvIU7wEFxI29n325ci7jrTE01KnOJxSdODHxbaDY417MTQ6pR+IXJTRk7zEV5OxHe+rIMcY9feagidkfnFZZqSJ5gsYZk3mbVxz8XQwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727982760; c=relaxed/simple;
	bh=hvlsSwwXr3uVgXhII8AsI8In1V5uADcu6NhIrhrEW24=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LVUwSc2w4WYiv4Gi9D6ZKHz8Ioi+Jo4q9IdcjCHAV0pgvfXXQ2udtgEhFvbpXs1UO8M9uR83jxteBiDLiAXmecSgx3zKxn96sN6hTS1UqRLGqOGkytsUJY2oDTA8UXCrdZ/sWvFFZ2z4e9JSv6sHRmbx5/aPF+6idPyQa+/xbHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BpdniRrd; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BpdniRrd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727982758; x=1759518758;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hvlsSwwXr3uVgXhII8AsI8In1V5uADcu6NhIrhrEW24=;
  b=BpdniRrddpOmT855Dxa2S6a+CKRsrAYxZdefL0FIkgMeO7lXmQ0snF8W
   sWQqbshCpvXgXhJmKmWBV1xd3sFVeqF5amAxRloiu+6SnX1N0M9xeBV04
   TNI9cHPWYK19W4lod1/GfiUwtcD7sLe5GlKm0Y3aAA82e/GJ/a0PkI0Yz
   GIzTQPtuZliCmE1AgA+/pkR69KuJW7HcKdi4TuBo2Q5Y8SF8yzr8GKqmA
   k7OvY32zRs3qCcbUMqnc9Er4mCQ920R5LcydDCUkIk+niTN4D9yck2GDI
   zGDeVlSIzwTucEEGMHXiwxYa9CgoiYkfp4ZdBREksNJx5Rj+sEk9uK5FB
   Q==;
X-CSE-ConnectionGUID: ptYH+nZPTky3chekhVkc4Q==
X-CSE-MsgGUID: Ullu/isBQQODLFIme7kquA==
X-IronPort-AV: E=McAfee;i="6700,10204,11214"; a="27287489"
X-IronPort-AV: E=Sophos;i="6.11,175,1725346800"; 
   d="scan'208";a="27287489"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2024 12:12:35 -0700
X-CSE-ConnectionGUID: 9eE1duPJQdef+UdkRs0ajQ==
X-CSE-MsgGUID: DjuvuxPXS9eMuLAJp9H6hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,175,1725346800"; 
   d="scan'208";a="74031030"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2024 12:12:35 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 0/4] x86/resctrl: mba_MBps enhancements
Date: Thu,  3 Oct 2024 12:12:24 -0700
Message-ID: <20241003191228.67541-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[
	Bringing this old patch series out of hibernation since last December
]

Two changes relating to the MBA Software Controller(mba_sc):

1) Add a new mount option so the user can choose which memory
bandwidth monitoring event to use as the input to the feedback
loop.

2) Update the "mba_MBps" mount option to make use of total memory
bandwidth event on systems that do not support local bandwidth
event.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
Changes since v6: https://lore.kernel.org/all/20231207195613.153980-1-tony.luck@intel.com/

Peter Newman:
	s/"mbm_Local_bytes"/"mbm_local_bytes"/
	Added WARN_ON() to check non-null return from get_mbm_state()
	Don't allow both local and total mount options at same time

Reinette Chatre:
	Use flag (enable_mba_mbps) and value (mba_mbps_event) in
	struct rdt_fs_context. Then pass the value to r->membw.mba_mbps_event
	Ditto Peter's comment to block multiple uses of mount options.
	Use invalfc() for better error reporting to user
	Note in kerneldoc that mba_mbps_event only valid when @mba_sc is true
	Declare mba_sc_event_opt_name() as "const char *"
	Rework resctrl.rst patch based on comments

Babu Moger:
	Clean up calling sequence for set_mba_sc() to avoid dummy 2nd argument

Other changes:
	I split first patch into two parts:
	1) the periodic updates to use r->membw.mba_mbps_event to choose
	   the event
	2) The new mount option

	Also noticed code duplication in mbm_update() as the local
	and total clauses are now identical. Split that code into
	a helper function mbm_update_one_event()


Tony Luck (4):
  x86/resctrl: Make input event for MBA Software Controller configurable
  x86/resctrl: Add mount option to pick input event for mba_MBps mode
  x86/resctrl: Use total bandwidth for mba_MBps option when local isn't
    present
  x86/resctrl: Add new "mba_MBps_event" mount option to documentation

 Documentation/arch/x86/resctrl.rst     | 27 +++++++--
 include/linux/resctrl.h                |  2 +
 arch/x86/kernel/cpu/resctrl/internal.h |  1 +
 arch/x86/kernel/cpu/resctrl/monitor.c  | 80 ++++++++++++--------------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 51 +++++++++++++---
 5 files changed, 102 insertions(+), 59 deletions(-)

-- 
2.46.1

