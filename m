Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F9C2DB795
	for <patches@lists.linux.dev>; Thu,  8 Jan 2026 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894177; cv=none; b=YQYRerb9O1N2juoCWHLBI/SMuiEJcDXTa7NApoWcs2+5rBWAujoCheAWo5QWy5eV2H1Qc9O5SETgjKFFK3UOU9WSvWtdW5deBM4WKynJTGCmykDJyN3O9y75P9I7zlcA1mORubRUmCbWupxgdX96QRydkq0srZJtgjqsE2luhbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894177; c=relaxed/simple;
	bh=o8ofvUzhFZWpqAO9GpQetDVDebtxwiX9q97qWgrL+KI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NOvwjIWHx+dEzoxie1wxnUbhMt9ZZybW32b+Bn2nJfI3nMUzoEa5TOR2lWuEaDfkg9xc7Mtg6g7m7Briu9THG5VA8nuV6Pd8h+eVXAp0IK26YQY11NubFK3E0BlBoYdcB54oSr7IABRDdxn/hOQ6AV1frUDQRXkdyGmQpKq21wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fKzgsUXb; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fKzgsUXb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767894171; x=1799430171;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o8ofvUzhFZWpqAO9GpQetDVDebtxwiX9q97qWgrL+KI=;
  b=fKzgsUXbtri5vgzX+24dkV/E+8ALsvRn2evwcjavnwijVPymqpJYWkei
   8n7C3viV7havCCpmAzP4ltRKiKm/gUSzFyg4Bll13XYypIYWMxQ4Y9fck
   GU4acVKrAOUdVc2fkJI1qX5v4OsrdnVYbozHdH5X77TBvhD9I2aD07jjD
   a6u3+fy4QwVlhvdSeSFLgOlmldibkVt7K4a3WO+C6dWdi9xxGg1hZFU98
   BIYsEnQtRFr4snxt3djy1AQDXYfPJFDid0nux4tf3lwjEUGy9C4iCwEJD
   JNIywlX+fXuxXZJbud4/aX3D64algzclKPpWJup94BhrzLVTDTtlQiWMs
   g==;
X-CSE-ConnectionGUID: sOcbI2vcRYiIUYLLPWqUWg==
X-CSE-MsgGUID: ms8si0kBReCHSZGA0Bfr+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="79998990"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="79998990"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:42:47 -0800
X-CSE-ConnectionGUID: Wu6jgQoYSuaUrHJDL2T87A==
X-CSE-MsgGUID: 7djcy6A2SHWUXkXfwCGe4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="240751106"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.16])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:42:47 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [Updates to v17 PATCH 00/03] x86,fs/resctrl telemetry monitoring
Date: Thu,  8 Jan 2026 09:42:24 -0800
Message-ID: <20260108174227.11307-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updates to v17 series[0] to address Boris' suggestion[1] to use
DO_ONCE() instead of open-coding with atomic operations to only execute
some code once.

The substantive changes are in patch 13 where the open-coded "only once"
logic has been removed from resctrl_arch_pre_mount() and replaced using
DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount); in rdt_get_tree().

This change requires some trivial changes to patches 16 and 29 so that
they apply cleanly on top of the changes to resctrl_arch_pre_mount().

I dropped Reinette's Reviewed-by tag from patch 13 because of the
changes. But she commented[2]:
	"Placing DO_ONCE_SLEEPABLE() in rdt_get_tree() is fine by me"

Signed-off-by: Tony Luck <tony.luck@intel.com>

-Tony

[0] https://lore.kernel.org/all/20251217172121.12030-1-tony.luck@intel.com/
[1] https://lore.kernel.org/all/20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local/
[2] https://lore.kernel.org/all/36239cc0-0a25-40a9-86d1-57236aa087df@intel.com/

-- 
2.52.0

