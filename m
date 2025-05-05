Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D669026D4CD
	for <patches@lists.linux.dev>; Mon,  5 May 2025 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746466718; cv=none; b=IoWbAlzAiIMrYTCbEqdXyl9kS4NMXQPUWP/eJpmkOjCN32AKOBHlUhO1Wdj6Pf7rxNu0l9+M6LaLDTziQbs4O15KFI5dILfrYrAC0uo0wyEqi8N16B0pLERkjjjQ5z7JnVip2sZU8/V0zNMVlnx5GIi6XvzWkNtRVPFjW1bY0J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746466718; c=relaxed/simple;
	bh=Mzf4z3JjeUDeBLBOc9nbGSbBtSvIhz9Znl+rjIhT6PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjWXLAHCpC6r2aCb4kAyObG63jVeQ7QBy75uDu75e8pJ/jpKgJ0JmcdIToYRIMEMCMfrmpCmN858JkEFHqRHzVqRPMjWd5Qx4ZqmXEkFj/I3OR+89b6nqbr6ivdlO2ocKjduWRU/Jz4pjXBndXPfKEcWetioJ7Nl5e5FblT+3KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SPgqdkxD; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPgqdkxD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746466717; x=1778002717;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mzf4z3JjeUDeBLBOc9nbGSbBtSvIhz9Znl+rjIhT6PU=;
  b=SPgqdkxD2ritFXTfbTjll5At4uMciXgEhJbYvpTuTYAWDmE9svTzdgD7
   wXlJ+awh7EhdqiBqogE4AN93wOT7kvEYh5qEHuJ0Z0EPRbm+qKhgifxyt
   wW1LnXgrsmUFFKdhnmjxlnhgjmbJLGeovIr2BxsGDXpaflf886i3Ac3lt
   xziFAlRYC+BMzxCzBWnHQXqdc2nVyQmOwd2CaSYmhgZHOWCjg7FiJwyR/
   m6u+Ax/Zco+bjPgpAAVw3UzGD5BH/rMx0O9Dp0AIKW79/pMxRUlcXKUSo
   6Q7SbxkU5hg7NRfJGV6YJF3yfNc70biGLFF76/936YXCnGBPTkn5qeEXm
   w==;
X-CSE-ConnectionGUID: eB+peN8jT22xp0kM0Sorzw==
X-CSE-MsgGUID: 8QNTGaZWTQa53PZ0tjrHcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="47991520"
X-IronPort-AV: E=Sophos;i="6.15,264,1739865600"; 
   d="scan'208";a="47991520"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 10:38:28 -0700
X-CSE-ConnectionGUID: cQ6n0HIDSqaaMSj/gcpTBA==
X-CSE-MsgGUID: ht8awrqQTrukANsIgRozgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,264,1739865600"; 
   d="scan'208";a="140092233"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 10:38:28 -0700
From: Tony Luck <tony.luck@intel.com>
To: rafael@kernel.org
Cc: lenb@kernel.org,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 3/3] ACPI: Add documentation for exposing MRRM data
Date: Mon,  5 May 2025 10:38:19 -0700
Message-ID: <20250505173819.419271-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250505173819.419271-1-tony.luck@intel.com>
References: <20250505173819.419271-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initial implementation provides enumeration of the address ranges
NUMA node numbers, and BIOS assigned region IDs for each range.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/ABI/testing/sysfs-firmware-acpi | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-firmware-acpi b/Documentation/ABI/testing/sysfs-firmware-acpi
index 5249ad5a96d9..fffba38f9ce1 100644
--- a/Documentation/ABI/testing/sysfs-firmware-acpi
+++ b/Documentation/ABI/testing/sysfs-firmware-acpi
@@ -248,3 +248,24 @@ Description:
 		  # cat ff_pwr_btn
 		  7	enabled
 
+What:		/sys/firmware/acpi/memory_ranges/rangeX
+Date:		February 2025
+Contact:	Tony Luck <tony.luck@intel.com>
+Description:
+		On systems with the ACPI MRRM table reports the
+		parameters for each range.
+
+		base: Starting system physical address.
+
+		length: Length of this range in bytes.
+
+		node: NUMA node that this range belongs to. Negative numbers
+		indicate that the node number could not be determined (e.g
+		for an address range that is reserved for future hot add of
+		memory).
+
+		local_region_id: ID associated with access by agents
+		local to this range of addresses.
+
+		remote_region_id: ID associated with access by agents
+		non-local to this range of addresses.
-- 
2.48.1

