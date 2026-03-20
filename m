Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C730131327F
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044236; cv=none; b=FAn1PrcdSuTuc3Nq5UX8F0hqIX9TN7dr53Ss1KhkANXDpQXmfjA1UU+4eYdVNZAteBLbh8pol5W6xUwSMCpq7o7a7fsv36Zm+JHVJ+OX3NwzNAHxk6jx1Eeag4WnYGC7ptC3gEY7D2z0zYmCojspHFJ9j3K1cnLuFEkOB+CEoCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044236; c=relaxed/simple;
	bh=2r426URiTXvlx3tT0QDuPcVGD3bn2C8Tq1rwhDsXsgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkmJXtfboHHlfcaPynHzaBP7vxZjmbjMc4ku66QL5gg67tvRZkksJbz/ks7Y4Vb8KnB7pjpdJdxR8cSdLrt/wtoBjnMhciHrhohhpm/Z03Azcs3S3dL8yy+isjzCq1cW/CzfhTM141biRH9cH5PKIeaogPbkBFWz9wHCEKfpaXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hh7t11LD; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hh7t11LD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044234; x=1805580234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2r426URiTXvlx3tT0QDuPcVGD3bn2C8Tq1rwhDsXsgo=;
  b=Hh7t11LDonCgD7L+mJO4WlLxolXuxorhSTsooRuVzGwlw4+EpV0kAB7z
   1nx3HA/slDApWt1Xj9R8PvZzhcCFEPBA6GaIctK1ywAJj2Zs1PRnllhoA
   MtwKmxmOWcJmVlOfiLexdmpfJIK1L2VBwuT91CV88SQWOHO9fK/Y09Xa7
   1Hw9XVbhqgdxuJ4AgBD7d0J6cBvlT4KOuL8vnqCeLr0lf3SSgLz2Yt8Lf
   0v0ULgjA4EcfB7Zqije/mbUY4c+akn1lvJRO5/W9b1hnnESoG2RStVVDj
   7NgWVbB+4IzDhXEltdzsBTibhVpENMhnXUyJstEJvLLOqNzM/XvezxkoE
   w==;
X-CSE-ConnectionGUID: n+OBjUzGSvucFCYAw1e0MA==
X-CSE-MsgGUID: 5b9YEK1sQXm0kQO3z15HEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758333"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758333"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:53 -0700
X-CSE-ConnectionGUID: /BRBff0JSgi+kMQRwu62aw==
X-CSE-MsgGUID: 0iA09wfkTOOGB4Jo0h3t0Q==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:53 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v2 01/14] MAINTAINERS: Update resctrl entry
Date: Fri, 20 Mar 2026 15:03:11 -0700
Message-ID: <a6090f1b67b395bddc842dce12582f5db18fd70b.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The x86 maintainers handle the resctrl filesystem and x86 architectural
resctrl code. Even so, the x86 maintainers are not part of the resctrl
section and not returned when scripts/get_maintainer.pl is run on resctrl
filesystem code. With patches flowing via x86 maintainers resctrl should
also ensure it follows the tip rules.

Add the x86 maintainer alias, x86@kernel.org, to the resctrl section to
ensure x86 maintainers are included in associated resctrl submissions.

Add a reference to the tip tree handbook to make it clear which rules
resctrl follows.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v1:
- Add reference to tip tree handbook to follow similar change to other
  tip subsystems:
  https://lore.kernel.org/all/20260305212215.3188399-1-dave.hansen@linux.intel.com/
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 77fdfcb55f06..622d17046db5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22134,11 +22134,13 @@ F:	tools/testing/selftests/net/rds/
 RDT - RESOURCE ALLOCATION
 M:	Tony Luck <tony.luck@intel.com>
 M:	Reinette Chatre <reinette.chatre@intel.com>
+M:	x86@kernel.org
 R:	Dave Martin <Dave.Martin@arm.com>
 R:	James Morse <james.morse@arm.com>
 R:	Babu Moger <babu.moger@amd.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+P:	Documentation/process/maintainer-tip.rst
 F:	Documentation/filesystems/resctrl.rst
 F:	arch/x86/include/asm/resctrl.h
 F:	arch/x86/kernel/cpu/resctrl/
-- 
2.50.1

