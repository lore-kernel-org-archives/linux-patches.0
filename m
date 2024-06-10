Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBF2152169
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044549; cv=none; b=hJGsMCSM1MOAR5p51mly7rElE1s4kV/NnXcTovhIEJIcCzY11HwCmyllgFMWd21h44VmffO5IgFaprduJI4GukMnZBORoJeRgG2q4KOZuHlT1NPoQeZF3cJAmgFouylZLjbKL4cL82csBhXxE4Cmhpi9+1Z4CRh5nvMiVzTKipE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044549; c=relaxed/simple;
	bh=trkSesWB4tFV2q3Q20dRF9Du3uBUDy6ngniRBxlmqCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKCONwGmU6G0KfK7+qVMQaAX0C0mGeP6wYFooDY2TmHPkmtIVLK2OlJSykOuU5chpwq0aplvAiXUPuIUbHyUDmPZX71FiBU661m+sdweCNJJtTKSiMvGvhHSJYK1cMgRfQDMT1WdSFwaVZjN2WbPv/QyNNDEE3Lkcqmr7lQ6ZU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EK+7QKIn; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EK+7QKIn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044548; x=1749580548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=trkSesWB4tFV2q3Q20dRF9Du3uBUDy6ngniRBxlmqCg=;
  b=EK+7QKInAXCBMuCuKMXgDSASaaxQvYjNi9orXuYS1Arok4qxSSB08oOe
   a92vtl0+ZtDkT3KPxTOpKIOEGmlMrBnjukTBIVXA93t5ra5jwbOz1RPAf
   LLJoblMEwE8RXe8Q2qkDroXbojzBzexcMzfzDXg+yMSwdQBxGT7vqD0/g
   nb/3cCFF8j3nCKsPIHPrWsyl2aDQTuNl1mt7JRp6QlYGbJNHEZ/q92kmA
   PoVBxLsFAQiXv2X6KAraqOiq9ZCW/YfG4FWu1PnqMpRfm7n9YxAPPemd/
   y9IuuOcUL2pyglWGU+1zXO7cJdGOGKulSFCmVQEOl/zYLCuvRoqepDHEI
   Q==;
X-CSE-ConnectionGUID: NY95VqoAQGiMods79p6qMA==
X-CSE-MsgGUID: I4EpC+22TT2t/b92gmnX0A==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004840"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004840"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
X-CSE-ConnectionGUID: 3q3p+jN1QD+YKEm54Rc/Sw==
X-CSE-MsgGUID: ow8kalNWRJG1e76SUtn8Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576582"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
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
Subject: [PATCH v20 11/18] x86/resctrl: Allocate a new field in union mon_data_bits
Date: Mon, 10 Jun 2024 11:35:21 -0700
Message-ID: <20240610183528.349198-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
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

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index d29c7b58c151..77da29ced7eb 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -133,14 +133,20 @@ struct mon_evt {
  *                     as kernfs private data
  * @rid:               Resource id associated with the event file
  * @evtid:             Event id associated with the event file
- * @domid:             The domain to which the event file belongs
+ * @sum:               Set when event must be summed across multiple
+ *                     domains.
+ * @domid:             When @sum is zero this is the domain to which
+ *                     the event file belongs. When @sum is one this
+ *                     is the id of the L3 cache that all domains to be
+ *                     summed share.
  * @u:                 Name of the bit fields struct
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
2.45.0

