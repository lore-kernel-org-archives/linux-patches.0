Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9682528E8
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069268; cv=none; b=fYWS1OfSaZSaiO/T5aO/MT22SLTT6Xofls0KSSYkrBX90I8XB6MDvnPs8UvqAAabTLYWpucPDO8ZB2589p7p+983l8+SKqSDKmHYfxj24aVcVtupFhEXDcn37NA0G08StmMMWuYTKgH1n1hoq7RHblGLNkcJeYkuJZTHbOiWdpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069268; c=relaxed/simple;
	bh=sJ8ho4sQaoe/V4caQsu5Rg0O+TjhTAyA8IQqtw/iH0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMXcj9sRd/Bz/aTB1pfR0NLPs4cCSTS5GS4AzU8+QNnZD6ImrcEwmb9uYXLp/EH/hna/FzZHwyf7mj6aljVy2Bs0qvmbI4IEWVeTPIN8kbFM6VwoKQMORNuvKCjMo7rJinRDQa46D6VeoeWm6huFtwixUDwKqZwsOrinCALCX10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hNURZKIz; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hNURZKIz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069266; x=1775605266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sJ8ho4sQaoe/V4caQsu5Rg0O+TjhTAyA8IQqtw/iH0U=;
  b=hNURZKIz38bMRZrBWPwtFkmzIHtqZOVZPiWwFqS5xawPMLitsLF7PXYf
   a5CD7DAYAyWZ4EdyW6gP2y+OfOkvC3NRRB16dP12qmBPfjWDoZTQlg5Ws
   9htrPjCdEJ8cHYMXp3tAyxCZDMIiGj3edeHwKUbmisIgtAll2pQnxn6h3
   01JqqPXrBh4ID3AQcK5Y24+d//OBwYjomZXHBM0XOybHwm7PXJgJA9lbs
   KvunBjiL2V2FNmH6wEwJwgiq4VxQ3gaYY48qTq0acHzCyYnmbNl1g93Sk
   IHNetxB4PXmFYNtwAzftWfzpZkAmrGGISOvNRcblRB1uhGC1rmV5Jj2nX
   w==;
X-CSE-ConnectionGUID: tpAXQvdiSlG4VQX2uqe43Q==
X-CSE-MsgGUID: 7aXeHAR9QQuVFo/C9YvJwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193278"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193278"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:56 -0700
X-CSE-ConnectionGUID: JNpsx4/FS8Gcy2CVvtLVAQ==
X-CSE-MsgGUID: jAKkrK7HRy+j1Nr2T3NT1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315518"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:56 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 22/26] fs/resctrl: Add type define for PERF_PKG files
Date: Mon,  7 Apr 2025 16:40:24 -0700
Message-ID: <20250407234032.241215-23-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Creation of the default info file for monitor resources requires
an RFTYPE_RES_ define and mapping from the resource id.

Add the define and case in fflags_from_resource().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h | 2 ++
 fs/resctrl/rdtgroup.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 4a840e683e96..b7bc820da726 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -253,6 +253,8 @@ struct rdtgroup {
 
 #define RFTYPE_DEBUG			BIT(10)
 
+#define RFTYPE_RES_PERF_PKG		BIT(11)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 34fcd20f8dd7..cae68e8b9f86 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2175,6 +2175,8 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
 	case RDT_RESOURCE_MBA:
 	case RDT_RESOURCE_SMBA:
 		return RFTYPE_RES_MB;
+	case RDT_RESOURCE_PERF_PKG:
+		return RFTYPE_RES_PERF_PKG;
 	}
 
 	return WARN_ON_ONCE(1);
-- 
2.48.1

