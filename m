Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63858204F66
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222922; cv=none; b=lWET/7GSH/rUq65ki1BCgVnY/5Q44IWY59Akkn4W8pG7pB1zmhcJ8MNsORgoZnRmAAU4KNafUF67JR9e+XFw9K6EOJnmIPHZqht5cgIDwHK5/eRO4CSEgtUS4CURWnDgxWGWryq0LyIJ/pxDgRtomDDw68fatzzOXy5UvDme/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222922; c=relaxed/simple;
	bh=Iuf6Xk0m12VH4JrneWbnqoZPwuhneMbLQmLINWp5Ogo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rGyw0mUZEMuKhC889LaneraEOlUq/ddDNgJ0hy4svwLBE5tE8fmSVrMQbHff4xaRzbNW0ul1ULo4UFmH74FKWx37ewlb+u8uDKttPhmNkZNktJMEq5+SBd11KfXI00FYitVp997c8Ig8Kwe8twDLP7VtOv8q5aGeWphlmHH2zys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TAUFosc6; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TAUFosc6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730222920; x=1761758920;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Iuf6Xk0m12VH4JrneWbnqoZPwuhneMbLQmLINWp5Ogo=;
  b=TAUFosc6wjWG1OsjRth9tO2V6negNiyxsOSEq7y9DkeOgnFZL26daMUz
   jmJeZDYqyUTXn8ED0sofOgPc95E+Bs3y1LsFwVyxpgI5KYPCS0Kpp9WnC
   UurXO0FKrOV91Vgd3jInSJA/CG3q9joX8Qt+qUNs1dGNDVABw/6B8AdbT
   ECtS5c1Qz+4Fb+iqnIOBb9jgnRGyJE3sVU3LS91KCFg/i0XK8xF+04ros
   LXPb3ENhOEK4bKZwNOLDiP/3DVJ7XuWRKOn0bjj1jMWzPOD5swI8ar6yh
   yUsnOhU7wIt7pNJ09LtojKsW9F5Q12nt3jme4OVKpK6mYDFwl1gtq86+x
   Q==;
X-CSE-ConnectionGUID: 9LJZh5E7QhOOC8GxmjzPkg==
X-CSE-MsgGUID: WyIKBprRQ3iAm0nXPAVCvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="17515634"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="17515634"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:39 -0700
X-CSE-ConnectionGUID: NNDEMe48S12WU0V7De+VXA==
X-CSE-MsgGUID: /ZNosftBQlWVME4l10itHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="81585594"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 10:28:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
Subject: [PATCH v8 0/7] x86/resctrl: mba_MBps enhancement
Date: Tue, 29 Oct 2024 10:28:25 -0700
Message-ID: <20241029172832.93963-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support to choose the memory monitor bandwidth event independently
for each ctrl_mon group when resctrl is mounted with the mba_MBps
option. Users may want this for applications that are not localized to
NUMA boundaries.  Default behavior still uses local memory bandwidth
when that event is supported by the platform.

Side benefit[0]: Systems that do not support the local bandwidth monitor
event but do support the total bandwidth event can now use the mba_MBps
mount option.

Changes since v7[1]:
--------------------

Almost a complete rewrite based on the new user ABI of a file
in each ctrl_mon group to select the event instead of a mount
option that applies to all groups.

Some of the code from the v7 patch0001 was salvaged and is now
split between patches 0002/0003 in this series. Patch 0002
addresses comments from Reinette[2] with additional sanity
checks, use of WARN_ON_ONCE() and early return from functions
where these checks fail.

I moved the refactor of mbm_update() to a separate patch to
make it easier to review the changes to compute bandwidth for
all memory bandwidth events.

Signed-off-by: Tony Luck <tony.luck@intel.com>

[0] My original objective!
[1] https://lore.kernel.org/all/20241003191228.67541-1-tony.luck@intel.com
[2] https://lore.kernel.org/all/bb30835f-5be9-44b4-8544-2f528e7fc573@intel.com/

Tony Luck (7):
  x86/resctrl: Prepare for per-ctrl_mon group mba_MBps control
  x86/resctrl: Compute memory bandwidth for all supported events
  x86/resctrl: Refactor mbm_update()
  x86/resctrl: Relax checks for mba_MBps mount option
  x86/resctrl: Add "mba_MBps_event" file to ctrl_mon directories
  x86/resctrl: Add write option to "mba_MBps_event" file
  x86/resctrl: Document the new "mba_MBps_event" file

 Documentation/arch/x86/resctrl.rst        | 10 +++
 include/linux/resctrl.h                   |  2 +
 arch/x86/kernel/cpu/resctrl/internal.h    |  6 ++
 arch/x86/kernel/cpu/resctrl/core.c        |  5 ++
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 71 ++++++++++++++++++
 arch/x86/kernel/cpu/resctrl/monitor.c     | 91 ++++++++++++-----------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 28 ++++++-
 7 files changed, 167 insertions(+), 46 deletions(-)


base-commit: 81983758430957d9a5cb3333fe324fd70cf63e7e
-- 
2.47.0

