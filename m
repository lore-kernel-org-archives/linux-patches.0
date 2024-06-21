Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A10C16F90F
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009559; cv=none; b=K4OU6+8rr1mIhhYuDf6HL8U3tsLj3/2U1+3Ok+11E8kBnKEycgZHi+X4sk2R/iXhNOgGLXWl7SEVRU/xSe3yy5FioZj9ebz7Oq3yzkpIhDwM5TsZfyaZj9yuEYG+UNNd6veAbFcsaK5IFg4d1+Z3CS8z9jwyAe87hXKaN5HzjX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009559; c=relaxed/simple;
	bh=2HI2djpBm7b6x8ejUNIVOM+tcNyaLikrAcPXTqclelQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKM/HjydiJltNc2+tRjdXdyYutdxfTuUN5mXDaj9s7G2itaKLzgkRFaxz3AjnP1CRCpFypHvwehfauvkPIoheW64Gf+DJRAfDIfLCh9bpMSznSLLz+lZeIf6sQjO5RjIrPQIa7+C1ci8w8CiNi0ZFX4jok8j7OnMBf9Fkci6ggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VQDhI0sB; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VQDhI0sB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009557; x=1750545557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2HI2djpBm7b6x8ejUNIVOM+tcNyaLikrAcPXTqclelQ=;
  b=VQDhI0sBs930vLB/zU8ifEeMoUZOa+bK4doEIcUvyju8PORJlJkyTrmW
   UCKxo7lh7S9jJwHeByQ/9LM1ulwgRdo/3hj0HtojYq2R2wF3XV8klD3t+
   HmM4jcoZmGZc4/5JHbsdp1Uyw8P+MJpCfANxgLSppr7rctWC6llVSKTfG
   DNjKqOaE2e12cE9n/n/t8c1JUU7Ksfhu2AvjS+x/Yu4hCI7s1irPCDn0h
   HiQ6RAF/5zXcuQrSWxvCL/OnAZmnovMnE4Z2xAtzrkKNuyfxeUwi0bIW5
   dKze44evqHtga6s6vTW1absSbuRcn6l3h4uQ1he0a1UpYzUHtg9PEEM4S
   Q==;
X-CSE-ConnectionGUID: k9hPb1w8Q8u40VvS7vnthQ==
X-CSE-MsgGUID: XL2+Ou7DRambLYHo6DRTTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691327"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691327"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:08 -0700
X-CSE-ConnectionGUID: QoLzKqoTQF+05xwAV2MzcA==
X-CSE-MsgGUID: Mt3GppfxRiWmMul5Agm0Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935672"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:08 -0700
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
Subject: [PATCH v21 11/18] x86/resctrl: Allocate a new field in union mon_data_bits
Date: Fri, 21 Jun 2024 15:38:52 -0700
Message-ID: <20240621223859.43471-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621223859.43471-1-tony.luck@intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
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
index d04018b8b571..f66c7f12e91e 100644
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

