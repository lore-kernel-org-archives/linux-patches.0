Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347C81A3BAD
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 20:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520763; cv=none; b=cd7ZiRLH14p/FF20WpS4DBiyhW8sORhAPe6vD0jypqEKUmpR3xrFbXn+Sx+2raQRdaU06xu3LQAyfKNacqrVd5hPttuxeiZVrTd8njLLPztoxtt5JH7U/e1v9j2ILgAbQFuCjDUc37XGkuGZYg7u6ShSGa2jGCEAQpxJs6smnU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520763; c=relaxed/simple;
	bh=2l7f6lDOELlYeE6YGD7wOuDWjXUX38xsa3dzLbcLFzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdUP3rh91kKBcG3iyYZd1rkVLsirdjC291uzSkk+4oPIvV2y/CQM9HeplqSqo8w4fOmDwbXvZHLWj82OKCgvkErQz6DaPdRVXHBAPw5q0BDC9D4rlay2htlHiacarlv+ab1aOxOeyE/lBmujY+7dxEQAXP/Y7qSByUk30OSlIAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yz4+C6rw; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yz4+C6rw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719520761; x=1751056761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2l7f6lDOELlYeE6YGD7wOuDWjXUX38xsa3dzLbcLFzk=;
  b=Yz4+C6rwc/wTR7aIBHJ3Oy5jJtYa8Km/lxWKwXd9tmvu3O3HixKw2TK7
   AzIr9ozSymmL1ZqIwqV9k/5kQexmNCHGuzm8u9Mcc9M8JqriCZ2lGaY/6
   k9AlFwFZvWgFOkfiLfnZSzPd4XmVqgPHgQYugJ8GfB5/EDgHoVhOWsCS7
   0in0r95nTilfQDl32MY/pDGkpfsfUiC17IVH5d5wavl6m2byy9Dg2DoYK
   NkXitiKyWxE3ohWWSLgK0oFRq8Oeny9S5E0yNlXqZqueny2KHAESZ5MFH
   wUZgzVD/dpTTgC9c2OyLLt8HsM6U/V8nSdCcH0rJ5JNpdWFOZHToS9N8g
   g==;
X-CSE-ConnectionGUID: iXRQL4P6RfOFL9kdwBnC/g==
X-CSE-MsgGUID: VqBGqavSQfmokRYOvJPlBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16809866"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16809866"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:12 -0700
X-CSE-ConnectionGUID: yQOysJ53SZiHJid5yxJCbA==
X-CSE-MsgGUID: P+X4VGxoRjGh8DmBrBCsFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="82052933"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v22 18/18] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Thu, 27 Jun 2024 13:38:56 -0700
Message-ID: <20240627203856.66628-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627203856.66628-1-tony.luck@intel.com>
References: <20240627203856.66628-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With Sub-NUMA Cluster (SNC) mode enabled the scope of monitoring resources
is per-NODE instead of per-L3 cache. Backwards compatibility is maintained
by providing files in the mon_L3_XX directories that sum event counts
for all SNC nodes sharing an L3 cache.

New files provide per-SNC node event counts.

Users should be aware that SNC mode also affects the amount of L3 cache
available for allocation within each SNC node.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 Documentation/arch/x86/resctrl.rst | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
index 627e23869bca..a824affd741d 100644
--- a/Documentation/arch/x86/resctrl.rst
+++ b/Documentation/arch/x86/resctrl.rst
@@ -375,6 +375,10 @@ When monitoring is enabled all MON groups will also contain:
 	all tasks in the group. In CTRL_MON groups these files provide
 	the sum for all tasks in the CTRL_MON group and all tasks in
 	MON groups. Please see example section for more details on usage.
+	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
+	directories for each node (located within the "mon_L3_XX" directory
+	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
+	where "YY" is the node number.
 
 "mon_hw_id":
 	Available only with debug option. The identifier used by hardware
@@ -484,6 +488,29 @@ if non-contiguous 1s value is supported. On a system with a 20-bit mask
 each bit represents 5% of the capacity of the cache. You could partition
 the cache into four equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
 
+Notes on Sub-NUMA Cluster mode
+==============================
+When SNC mode is enabled, Linux may load balance tasks between Sub-NUMA
+nodes much more readily than between regular NUMA nodes since the CPUs
+on Sub-NUMA nodes share the same L3 cache and the system may report
+the NUMA distance between Sub-NUMA nodes with a lower value than used
+for regular NUMA nodes.
+
+The top-level monitoring files in each "mon_L3_XX" directory provide
+the sum of data across all SNC nodes sharing an L3 cache instance.
+Users who bind tasks to the CPUs of a specific Sub-NUMA node can read
+the "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes" in the
+"mon_sub_L3_YY" directories to get node local data.
+
+Memory bandwidth allocation is still performed at the L3 cache
+level. I.e. throttling controls are applied to all SNC nodes.
+
+L3 cache allocation bitmaps also apply to all SNC nodes. But note that
+the amount of L3 cache represented by each bit is divided by the number
+of SNC nodes per L3 cache. E.g. with a 100MB cache on a system with 10-bit
+allocation masks each bit normally represents 10MB. With SNC mode enabled
+with two SNC nodes per L3 cache, each bit only represents 5MB.
+
 Memory bandwidth Allocation and monitoring
 ==========================================
 
-- 
2.45.2

