Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DFC12FB37
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 21:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611797; cv=none; b=iFE8HtSYVp/LDDkGq8DDVzd707An9CmBpYUVP93r4OA7ZweNI1PUrx9NJqx7fbalrO/zONao5X6bdet/20+zGNzGcm9xKZu3+MvhyKICyo0CdqTYhLUgrYRZvzZ6B+x1Wl/fw3YmHULH19lUX3nJmtM24fUgrX0DI8s0C4roNL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611797; c=relaxed/simple;
	bh=fJdyJmm169ahsAE7AU4WeTiO841LkwbRErK0K/CR60c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8RpiJjWMplVXIR6tLl0I92vdpnIzb2yjs9pQtXYs8tk4rTrF1UQELTLYGGVwTlOPcW1GIERzLzIozmTyjX09I2H+3U8chpaaWdNT5UW8vSMgzbdLXKvmqUmnLxNfc+3D3OrVQme59LtvYqhU20mNUUvT6kFLF6yJ9XyZeInmi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ph7vuQXt; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ph7vuQXt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719611796; x=1751147796;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fJdyJmm169ahsAE7AU4WeTiO841LkwbRErK0K/CR60c=;
  b=Ph7vuQXtLGhbX4ZnQCkHjm4NnYfumTj0Eu7M8ADDj8+X3BHwhrNVigCQ
   4cMa3+vcUAPdZNGOFZh/xc+0PWzKOSnhGeACI0SOgrgWf622MRsXuYucl
   HBtusIx0toBIGnHdDtUl4XlYyEpV8B5jesOk8YnDVeOhtAJX+9+kOGKLp
   w5Qaa4xypFtBP4pbLz1VI+mPfvEBSNqydam2HYUbujv2ceLz2qZlUFxjV
   b2WBIQAN21QyXubWPUwYXy0axFtXGUHU6uIW59XNgfSuBnEhKdUKiEata
   Hj9p5J5JinzfXe1Z1I4gBsAVMV21ttVsJeq2b3JBr896YAuJDQ4e5JgZI
   g==;
X-CSE-ConnectionGUID: hZ74Cx8dT3KCl3sro9OMqg==
X-CSE-MsgGUID: 08WoEP5WTS+Rc/SwQfN2Uw==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="16762613"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="16762613"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:28 -0700
X-CSE-ConnectionGUID: 4wtQ1trrTLqlAJ4amq0hMA==
X-CSE-MsgGUID: 6iY7GJ+QSei8td+K2IZEDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="68065669"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:56:27 -0700
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
Subject: [PATCH v23 12/19] x86/resctrl: Allocate a new field in union mon_data_bits
Date: Fri, 28 Jun 2024 14:56:12 -0700
Message-ID: <20240628215619.76401-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240628215619.76401-1-tony.luck@intel.com>
References: <20240628215619.76401-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When Sub-NUMA Cluster (SNC) mode is enabled the legacy monitor reporting
files must report the sum of the data from all of the SNC nodes that
share the L3 cache that is referenced by the monitor file.

Resctrl squeezes all the attributes of these files into 32-bits so they
can be stored in the "priv" field of struct kernfs_node.

Currently only three monitor events are defined by enum resctrl_event_id
so reducing it from 8-bits to 7-bits still provides more than enough
space to represent all the known event types. But note that this choice
was arbitrary. The "rid" field is also far wider than needed for the
current number of resource id types.  This structure is purely internal
to resctrl, no ABI issues with modifying it. Subsequent changes may
rearrange the allocation of bits between each of the fields as needed.

Give the bit to a new "sum" field that indicates that reading this file
must sum across SNC nodes. This bit also indicates that the domid field
is the id of an L3 cache (instead of a domain id) to find which domains
must be summed.

Fix up other issues in the kerneldoc description for mon_data_bits.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 681b5bdcd2f9..13d862221f9c 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -127,19 +127,25 @@ struct mon_evt {
 };
 
 /**
- * union mon_data_bits - Monitoring details for each event file
+ * union mon_data_bits - Monitoring details for each event file.
  * @priv:              Used to store monitoring event data in @u
- *                     as kernfs private data
- * @rid:               Resource id associated with the event file
- * @evtid:             Event id associated with the event file
- * @domid:             The domain to which the event file belongs
- * @u:                 Name of the bit fields struct
+ *                     as kernfs private data.
+ * @u.rid:             Resource id associated with the event file.
+ * @u.evtid:           Event id associated with the event file.
+ * @u.sum:             Set when event must be summed across multiple
+ *                     domains.
+ * @u.domid:           When @u.sum is zero this is the domain to which
+ *                     the event file belongs. When @sum is one this
+ *                     is the id of the L3 cache that all domains to be
+ *                     summed share.
+ * @u:                 Name of the bit fields struct.
  */
 union mon_data_bits {
 	void *priv;
 	struct {
 		unsigned int rid		: 10;
-		enum resctrl_event_id evtid	: 8;
+		enum resctrl_event_id evtid	: 7;
+		unsigned int sum		: 1;
 		unsigned int domid		: 14;
 	} u;
 };
-- 
2.45.2

