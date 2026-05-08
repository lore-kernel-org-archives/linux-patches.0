Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7403CFF40
	for <patches@lists.linux.dev>; Fri,  8 May 2026 18:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778264513; cv=none; b=DOk7/VpuNs2tinZpMTHX3cL7D8RGVnd4kzgkUoPvHe8w4h8l0TVJnN4Me1hc62Sd28b3TK4pYFgg63n8DMdlTnJFvwAyQDq8oz+ajl3r/aVBzoAyWWK+OGVHQYNGtDIMobVELF3T/V3eblxQTomQ1XV/RG25Iiya/XaHUG9aCy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778264513; c=relaxed/simple;
	bh=k6A3ZUpU/Ys/URHWsSBJxfnT8LSTRRhtMAx8tDA9Q0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CtTiVIf5Sg8m7d6mztVX+x5MWYUwTxjtef0Ky6uxgdrAAlhTUy9x+70hhKiSbMGndAacIIpvTmpscqHVzPyx0i+SfXVCiEFXidV/UlPXUu5Ye81E4/qEO84RKpkJ2jeK2PgAf5enVk38FHFRxqo9+PJk5gJv/bOvFPrmFtd5EjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MNrdXp+P; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MNrdXp+P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778264512; x=1809800512;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k6A3ZUpU/Ys/URHWsSBJxfnT8LSTRRhtMAx8tDA9Q0k=;
  b=MNrdXp+Pm08X8EvRe54RySZ6EiD0eSPa3zwRe1Ab6a4W8nletrafpmYg
   gkJKgE/Qcsg0SpTD2tHvTKgtVybUdDQOKjEoXLSYfOsKHJKUb5OuqH2Uy
   Jt2FRaTvu5CSNXCbxYiZjj/uvHKNy6q54LgfNOtVxNlOHk3P2Zq8Z1nG3
   LqjJQFBxs2vFlB1TlpnfphEdOA09KMOWjv6/scdopR7Wv6AXXfHgqd5Lj
   HbZTMy6yiVLF5QtKiMJEIcCU22xLFIz89JoSMPl+4IJVAqV83M3KjzGTx
   bSEIm/QbdQjDjHgRB8IMkh0m0yrvADaftJUmz7j9tjdeAQXdS6q8+pgEc
   w==;
X-CSE-ConnectionGUID: rJSHKsGJSwOmEXMPtxWTqw==
X-CSE-MsgGUID: t9NZHzoiQ+O5W94nw+parQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="79264130"
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="79264130"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 11:21:49 -0700
X-CSE-ConnectionGUID: /WCE5CrgTqy2+nCpjmtyYA==
X-CSE-MsgGUID: tIG88zQERy6TskzGkRQmfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,224,1770624000"; 
   d="scan'208";a="233776422"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.98])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 11:21:48 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 0/4] fs/resctrl: Fix three long-standing issues
Date: Fri,  8 May 2026 11:21:39 -0700
Message-ID: <20260508182143.14592-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reported[0] a deadlock during mount, and a use-after-free when an
L3 domain is removed during CPU offline. Reinette found a memory leak
in the mount error path while refactoring code for a solution to the
mount hang.

Patch 1 just reorders some code so that fixes can be applied without
adding additional forward declaration of functions.

Patch 2 fixes the memory leak found by Reinette

Patch 3 fixes the mount deadlock[1]

Patch 4 fixes issues with CPU offline.[2]

N.B. Reinette did all the work for patches 3 & 4, so I listed her
as author an me as Co-developer. Those patches need her sign-off.

[0] Sashiko report:
Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com

[1] This is v3 of the deadlock fix. Previous version is here:
Link: https://lore.kernel.org/all/20260504220149.157753-1-tony.luck@intel.com/

[2] This is v2 of the CPU offline fix. Previous version is here:
Link: https://lore.kernel.org/all/20260501213611.25600-1-tony.luck@intel.com/


Reinette Chatre (2):
  fs/resctrl: Fix deadlock for errors during mount
  fs/resctrl: Fix issues with worker threads when CPUs are taken offline

Tony Luck (2):
  fs/resctrl: Move functions to avoid forward references in subsequent
    fixes
  fs/resctrl: Free mon_data structures on rdt_get_tree() failure

 fs/resctrl/monitor.c  |  55 ++++++
 fs/resctrl/rdtgroup.c | 440 ++++++++++++++++++++++--------------------
 2 files changed, 287 insertions(+), 208 deletions(-)

-- 
2.54.0

