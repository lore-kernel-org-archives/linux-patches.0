Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779BD17CA03
	for <patches@lists.linux.dev>; Fri, 31 May 2024 20:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187834; cv=none; b=atOLCZo1F2XNiYlgetPHuSryywdDXYtgOOQl2+2VIE2qLyTZ9f//wHGLidQDDaVzrv5o7urGwnV0oxZooO8d5rx2g93n/UuoulxzFyn2MJGtp9u3M+68n8gMCB9+Ku77DlLzbiYOTV/AcIrtZ0YTbqF3918tA7CSyr11ZbbvX4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187834; c=relaxed/simple;
	bh=geUk9QqAqwdlj+xo+azEieXJI7qruG0IFBgwbdK8oXA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tIZnzw0inuzrBRV6huAq8PWCqBOW08iTyp1O4fSmbTgBk3AYTsGWrtbzFWz41nvF3NUCO4IjhsPMtsXzZVNJq0mwXirTFDzlxOvNu4i9W04N7ETu55JCb1eEMucsKIxCBNnwFi7OfwhdTWnC48cLP3xR1hu+IMQOmjdT/y7F8yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IBenSTy+; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IBenSTy+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187831; x=1748723831;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=geUk9QqAqwdlj+xo+azEieXJI7qruG0IFBgwbdK8oXA=;
  b=IBenSTy+JtsR/3cJc7DjXhXXQpgSywrleZF3Tqy4eAcDVkj9cjrwVpji
   Ilb4TYj4Q3opZ9R6f4igfm9dQpM9tO2JxRgcbJk07z53d0Aq71NARkzju
   mC8Ny0jpw+h92VrLn2ROtzueDYMpyNzvsQvLvnPGakGT/HA8ypPoD2HbP
   GsC1hxPcz1DNqBmazY1HxWF7U8v33qsQwVF0LssgcPBlAC/CE+EovWKtD
   NMabTviFTtIO+i1O9OeTy1Hv3AkTaM3l4qkNNwmzWc20uM2e0PcRwNcZq
   nnMC2asiGWemLATQYfwmuxPX+JQ6hztHPwSoiZ2/a5g/yKyiuXQZq2uyo
   Q==;
X-CSE-ConnectionGUID: cH1Zm4TkRKeVfu0twclN7Q==
X-CSE-MsgGUID: u9F90v0kQrKWD3ZrRMNHNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13871820"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13871820"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:11 -0700
X-CSE-ConnectionGUID: hklv9mXdTW6bg5dHxhtUkg==
X-CSE-MsgGUID: 3ppO/1SoRwKVKqp7VUakQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36355361"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 00/11] New Intel CPU model defines for x86/platform
Date: Fri, 31 May 2024 13:36:56 -0700
Message-ID: <20240531203706.233365-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These patches were part of the v6 patch bomb converting everything.
Link: https://lore.kernel.org/all/20240520224620.9480-1-tony.luck@intel.com/

This reposting as requested by maintainer to make it easier to
pick up and apply.

Changes since that post:

Combined two telemetry patches into one and fixed shorlog tag
Combined two pmc patches into one and fixed shorlog tag

The ISST patch may now be irrelevant as Srinivas has done
the conversion. I put it as the last patch to make it easy
to skip.

Signed-off-by: Tony Luck <tony.luck@intel.com>


Tony Luck (11):
  platform/x86/intel/pmc: Switch to new Intel CPU model defines
  platform/x86: intel_telemetry: Switch to new Intel CPU model defines
  x86/platform/atom: Switch to new Intel CPU model defines
  platform/x86: p2sb: Switch to new Intel CPU model defines
  platform/x86: intel_turbo_max_3: Switch to new Intel CPU model defines
  platform/x86: intel_ips: Switch to new Intel CPU model defines
  platform/x86: intel-uncore-freq: Switch to new Intel CPU model defines
  platform/x86: intel_speed_select_if: Switch to new Intel CPU model
    defines
  platform/x86: intel_scu_wdt: Switch to new Intel CPU model defines
  platform/x86/intel/ifs: Switch to new Intel CPU model defines
  platform/x86: ISST: Switch to new Intel CPU model defines

 arch/x86/platform/atom/punit_atom_debug.c     | 11 ++--
 drivers/platform/x86/intel/ifs/core.c         | 15 +++--
 drivers/platform/x86/intel/pmc/core.c         | 46 +++++++--------
 drivers/platform/x86/intel/pmc/pltdrv.c       | 16 +++---
 .../intel/speed_select_if/isst_if_common.c    |  8 +--
 .../intel/speed_select_if/isst_if_mbox_msr.c  |  2 +-
 .../platform/x86/intel/telemetry/debugfs.c    |  4 +-
 drivers/platform/x86/intel/telemetry/pltdrv.c |  4 +-
 drivers/platform/x86/intel/turbo_max_3.c      |  4 +-
 .../intel/uncore-frequency/uncore-frequency.c | 56 +++++++++----------
 drivers/platform/x86/intel_ips.c              |  3 +-
 drivers/platform/x86/intel_scu_wdt.c          |  2 +-
 drivers/platform/x86/p2sb.c                   |  2 +-
 13 files changed, 86 insertions(+), 87 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.0

