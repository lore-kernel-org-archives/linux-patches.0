Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C05D213230
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 22:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744324346; cv=none; b=dpBz9dg6c8+Q2zAxTgYTXN9m1kk1amNCqG7tpc7W3qMiGxm+o0ZfsEMDszvbnwhAPECRmyTjzcYvhhj6GHL/YmYSZV4n0t7zkD2dieFMb2IUvhqufs/NkDC8EURffh/FD/I1N/pnOU/mvaNd5br6Bp+u5F3XK61TVfput78K5UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744324346; c=relaxed/simple;
	bh=Mzf4z3JjeUDeBLBOc9nbGSbBtSvIhz9Znl+rjIhT6PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FurA+UhVaQwvO/Ef4Z8N/h7ZaboWkIL5s7S4DSsXVpzY4JA7175GdPPY9BVRp2sYgAz60j9xTztxbS3nw5OzRO4CPqDP7SiPM9mIItYsmuklCe1KnbLA3g+Tv2ZUv04/eZgjXoqDpmoTCzzju0KvOV1OpWTVORlFaIKEwVn2WHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UZi4tkMy; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UZi4tkMy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744324342; x=1775860342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mzf4z3JjeUDeBLBOc9nbGSbBtSvIhz9Znl+rjIhT6PU=;
  b=UZi4tkMyfVq8lYMgxYh+RUnnGMzbaAa23MqYwFJDmv4cpWJaaHflyurY
   URcg4HO5Hwi9SRmNexEi0vwcD+WuPI4HYMfMks07cEVz/NapCQr4INmlc
   xhekvcHFG1JmRk3MNrBW9EBMnmGbouSka3vrqesl/ty0nDxQuU+KQMbm2
   CIu0pZlgfVgtWSrtFi8LdGyrPuBA+rpY8mhaLsVvM2RFkhUmupureoj+v
   +GkNJEl9EiZCNlkyaWYn4Gmmw15iJcb6znvA1ad27+MzM/D7doUQ1tVnw
   xUQYTwqYI1yHBX/a2z9GHiS5819FllsumotJCMGeXxcPCY19BlO9Jha8e
   A==;
X-CSE-ConnectionGUID: SAWq1/a+SxCH6OWC27bYcw==
X-CSE-MsgGUID: 0zRHaCtmSSyulU/67pS3hQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="56845640"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="56845640"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:32:17 -0700
X-CSE-ConnectionGUID: gl2gaP72QhigRiB89MR90g==
X-CSE-MsgGUID: zaO7X4RmSwSvUMSd1VjGkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="128988759"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:32:17 -0700
From: Tony Luck <tony.luck@intel.com>
To: rafael.j.wysocki@intel.com
Cc: lenb@kernel.org,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 4/4] ACPI: Add documentation for exposing MRRM data
Date: Thu, 10 Apr 2025 15:32:07 -0700
Message-ID: <20250410223207.257722-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250410223207.257722-1-tony.luck@intel.com>
References: <20250410223207.257722-1-tony.luck@intel.com>
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

