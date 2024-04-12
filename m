Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D7314EC42
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712943046; cv=none; b=uqmbi4D+AypuVJ6vi7gEfk1yJtFnTVXvKiSYYywEHwFmyo2IwR6H/S4S9VWt6gqPTWz24F6m3tXl3oMsnRdI+TLRBfrccJVacgjwz5K8Y/QhHfD1niGU3/eGaqgtenaJdTZibhEMf/v1yMqN21C4+ddfbHguHYG9TDb+oWjCfIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712943046; c=relaxed/simple;
	bh=hb1T/AMnFxGW6NVoOhdqTg0WCA55Yu+evYbrctjGsYM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bc74VmmA50ARVNPsTIfXA8om5l5o0KicI2qIm0C6ddTgeabti0sBR8PYS10n0MBT/s9yiJ5HLwTSMUbdKC1Au8SV7f1yTFCbZkQOwMti734htZ3HrFcnlwIjO3pFjh6LgtsburZZEClple/rN6MvRqVH5QxIew5vzAR+cHa6Nag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RkPvfj3J; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RkPvfj3J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712943044; x=1744479044;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hb1T/AMnFxGW6NVoOhdqTg0WCA55Yu+evYbrctjGsYM=;
  b=RkPvfj3JAjMzDLhWlyxdq6UXUEZpFKywEp9aTK8ZhGFkW9BPpA77XpxS
   A94shkZ/qEz6n3mWX3levV9j9K/tA37ErgNVvSU6tHlg/lSPIG9dOTOS6
   Sq2+zRoOYz19YBQGil0aNJgzusmqQMl+6SfkYprdBc2acLTw21+BP4Aky
   AyrDzwXrHpJTzh6PIODnWeCtnkbiqosvjr1Mp74hHatjjlb3e8egUUrHo
   UUcjaYipdag8iutn4it/Zi6w/cO9V01ZbTOKpv+6W4anl42XxNxAatj8P
   RDEI4KR44eBD5LPLdkqWFvdMGt02y37X3GcEw/zPOq0QQwOOUH/eKPt+x
   w==;
X-CSE-ConnectionGUID: Xo3kP9y2RX+6lDxCGB3FBg==
X-CSE-MsgGUID: nFVH50UVQOOV2guyOqTcMA==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="11365682"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="11365682"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:30:42 -0700
X-CSE-ConnectionGUID: En0Ouh47S5+YVMkwM27PTQ==
X-CSE-MsgGUID: 1djs1C0BRwiIyogfHSXtrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="21780768"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 10:30:42 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: ilpo.jarvinen@linux.intel.com,
	hdegoede@redhat.com,
	markgross@kernel.org
Cc: linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	sathyanarayanan.kuppuswamy@intel.com,
	ravi.v.shankar@intel.com,
	patches@lists.linux.dev
Subject: [PATCH 0/3] Miscelleanous In Field Scan changes
Date: Fri, 12 Apr 2024 10:23:46 -0700
Message-Id: <20240412172349.544064-1-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Hans/Ilpo,

Bunch of In Field Scan patches

Patch1 - Classify Scan controller malfunction as untested
Patch2 - Trace output format related
Patch3 - Disable irq during a particular load step

Jithu Joseph (3):
  platform/x86/intel/ifs: Classify error scenarios correctly
  platform/x86/intel/ifs: trace: display batch num in hex
  platform/x86/intel/ifs: Disable irq during one load stage

 include/trace/events/intel_ifs.h         |  2 +-
 drivers/platform/x86/intel/ifs/load.c    |  2 ++
 drivers/platform/x86/intel/ifs/runtest.c | 27 +++++++++++++-----------
 3 files changed, 18 insertions(+), 13 deletions(-)


base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.25.1

