Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09717215064
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886870; cv=none; b=QUsDk1qbRmAvEW/v7h8at3COToUvbzja7rnG2yqNqrRcXcI/gwyOs4NIEIOd9SHdigr6oQRgeRTGqbUecraMPQDv2xOuXOkQUv+h6HPRUKLP+PZO0Lp67aG9EBDe5zSc80HPJVuIe4ZJNh5isRBSWE3a/bVyf77Z5pISTjwvgT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886870; c=relaxed/simple;
	bh=rmmM2/1ELIlDH8mRrn9+En13+yPbD0Vwms0V/5K0CoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRTsdw8hVFKGPz5X6ZInePpZGxjVNzcYxVKcuY+omDZBqcy4ka/mztE1WZuqwQS/z/VcQDQmuRXwaNWiVuUFe5U1tHHV3Z0CishRKUduRB8dLyZnd/sU7gNvo0wmJ4IR3HZMEh6uaSTdnBP4bcO7geE7uiSbcYRNQODvl8SaACg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nh/euah6; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nh/euah6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886869; x=1777422869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmmM2/1ELIlDH8mRrn9+En13+yPbD0Vwms0V/5K0CoM=;
  b=nh/euah6MRDPHfHxz9KvRa1CR69jpOvQEIpv/gDJsqaaB9wxtSLH/a+w
   20jOFroNe6Ocz/WaiwTK4HMVjF9JO6WxheJD0WW/Bzj44bYYZttiRpL7E
   dEm4VrPYpDKK4zMhC0+RDZ5nIGzaKgGyjdhPSj9ymP1P8xMgIvYaP2hFe
   0gVl1RODQ/mTIkWJ8PAg9Mq3oJ/p0HnOCpGznixT/yRzO4aqQzGZvWG57
   HybvnmvNV+83tPJxUV1OE/2iZTy9Ip8jgBX1F2JVfSwCarLsyg8Vi2j9n
   An2ZLc0KDlCfGab5fXbb0Lgw3OIzFlQKkVCukJrZ47umGRypm4elvy5KT
   w==;
X-CSE-ConnectionGUID: GNTpovxVRfSUxHNA8Y3p5g==
X-CSE-MsgGUID: 3ZaaRZI4Tma106MFTfGyRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148267"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148267"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:21 -0700
X-CSE-ConnectionGUID: KmXTL6uSSHWQ1l1tmdxnaA==
X-CSE-MsgGUID: 45MHkHiHTT+uBvpYlgDLoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133394060"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:21 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 24/31] fs/resctrl: Add type define for PERF_PKG files
Date: Mon, 28 Apr 2025 17:33:50 -0700
Message-ID: <20250429003359.375508-25-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Creation of the default info file for monitor resources requires
an RFTYPE_RES_ define and for fflags_from_resource() to map from
the RDT_RESOURCE_PERF_PKG resource to the RFTYPE_RES_PERF_PKG value.

Add the define and case in fflags_from_resource().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h | 2 ++
 fs/resctrl/rdtgroup.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index aaa74a17257d..623a9fadc18a 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -250,6 +250,8 @@ struct rdtgroup {
 
 #define RFTYPE_DEBUG			BIT(10)
 
+#define RFTYPE_RES_PERF_PKG		BIT(11)
+
 #define RFTYPE_CTRL_INFO		(RFTYPE_INFO | RFTYPE_CTRL)
 
 #define RFTYPE_MON_INFO			(RFTYPE_INFO | RFTYPE_MON)
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5e0d1777f162..544fa721e067 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2191,6 +2191,8 @@ static unsigned long fflags_from_resource(struct rdt_resource *r)
 	case RDT_RESOURCE_MBA:
 	case RDT_RESOURCE_SMBA:
 		return RFTYPE_RES_MB;
+	case RDT_RESOURCE_PERF_PKG:
+		return RFTYPE_RES_PERF_PKG;
 	}
 
 	return WARN_ON_ONCE(1);
-- 
2.48.1

