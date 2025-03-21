Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045B223642E
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 23:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742598991; cv=none; b=qEBunqaBogSsdTTOvAj+DNlm3K2z7mvyaiQ3dIG4Y+9aAfVvYsmL9nJ1QpVjwvCNDPn2OmPVP7xh7wCFnIMp5065KRqAGNVWrBG5mb3FoDHN/UMh4AS1dtsV5hMG5dkwVVw/q2e9nJfF6XLmO68iO3P7TPTnEMZMYuc9ktz1vYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742598991; c=relaxed/simple;
	bh=iQ4XRfxumCrPk7mdvf5ER8BlfKFGvFPe6nhxNpLfbL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSLH1d7sO2SX97iHSCXiBpNR6TxtiSwJmojtKgJ73YQQxeayLEZ1BJ2jAMQ7XQ1GN4oeZOKP4xV7DxqqIJ//CNcmdWHq8c/YSHIcfXiDKirqMN6XQAGY1zGmVhyWIV4kuipnQSebxa+8nbdpewInhozyAbctOgIZxXFk8Yh4z8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hmUkkChe; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hmUkkChe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742598990; x=1774134990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iQ4XRfxumCrPk7mdvf5ER8BlfKFGvFPe6nhxNpLfbL4=;
  b=hmUkkChe9B/o/Cw8DoG9TdLKggW0hOvM3SU0pFBQiHRlBJZ0jc3SMpkE
   KzmhhHg2Sghi8ycExiHeNdmf38F8NzN6t2YTLlLjYl1Pn9bjCbnZQEZNS
   OIpsOfM7c96c3v24not/Uh22pWcvl3KOUKt3DWDbq+W1JX6Gq8uWd4Tng
   91meLFxaGzFtIWrAg7fK7A7vPFsEB0yQn8JVkHz8ICTuyW0vsSmC73T9q
   mmjRFVRqk7hN3kqEg1Wpu8JBxNcXgtpOi0T2ef4aEdLh61zyZ4i+HXbfu
   kJoZLrsPtEGQ/ryzOAe/7KywwyOLorRunCvDUsQlGWoo7bvR7jmY2wGZA
   A==;
X-CSE-ConnectionGUID: 0DWKdeEjSuaJAhD4n1D7WA==
X-CSE-MsgGUID: Ef4d5ybySWWyij3QmrVTsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="43604649"
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="43604649"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:25 -0700
X-CSE-ConnectionGUID: BrTXd7TkSlSdWQOmQPpMvQ==
X-CSE-MsgGUID: qg9vHMitRYO1/cE0Bsq3Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,266,1736841600"; 
   d="scan'208";a="128354336"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 16:16:25 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 15/16] x86/resctrl: Enable package event monitoring
Date: Fri, 21 Mar 2025 16:16:05 -0700
Message-ID: <20250321231609.57418-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250321231609.57418-1-tony.luck@intel.com>
References: <20250321231609.57418-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All the code to support this is in place. Unconditionally enable
the package resource during early initialization so that domain
lists are built.

Enumeration of the package events happens at first mount, if there
are no package scoped events, then this resource is disabled.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 28692c6ec425..593e838fe5b6 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -293,6 +293,8 @@ int rdt_get_intel_aet_mon_config(void)
 
 	INIT_LIST_HEAD(&r->evt_list);
 
+	r->mon_capable = true;
+
 	return 1;
 }
 
-- 
2.48.1

