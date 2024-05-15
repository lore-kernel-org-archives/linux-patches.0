Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DF115B96E
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811819; cv=none; b=Lc1JQOzoDXT2oghaPuplZR1y0reQKAcNJM+6NuPyV3fodt4JNQ662MuPP9MSZ74XPj45Syp8cZLA2zBQiAc+sIuhcMn+XZvWhVBbwPknEyBGBYWwClWLbMKnLWugcbLyAc8sx8Q8/QJCQ//dzhbCPzQ5csPdejWQ/exf0Du1hqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811819; c=relaxed/simple;
	bh=8vvxnIKvUMKP3JQZuwFtDwcmDJe7AfWCgztSHDNn+mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvoEMkmGmLPj+Ms8iFmDWv0UVtv0O7S5NfXDbV+WOVzh6ubdqTnHuNHV3dap7E4iyJ0tDuNFkG0zx1aeYJc1YOHkYQNfTIMi66S+THDirxm1F60f9zsl+UQU6/9JYEMfFIqSdBtX/w9xAHLjpJIFWP18YX4VPTbFF1cspZTPVtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPDuJaep; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPDuJaep"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811818; x=1747347818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8vvxnIKvUMKP3JQZuwFtDwcmDJe7AfWCgztSHDNn+mY=;
  b=VPDuJaepudN4wVEUMCPklqcgxtyfYg6t6RH9DSwUB8Drx8q5ktvVwsD7
   W1TA1jUUS1S5a/8/xQGr+l6YxmyWS+i30OuzanwBsFLjRqGcZVqCQXSF2
   oTfcUV8NlNJuapKl4ZI9+JUNieiVYDYaXisK6QDvyBa9Un7otOSVJ8tMs
   EQ9OVNZ+8/8hQ0RQEQ3bYV5BSFEuP2+y50aktbRQ6QfgzIMFo7BC8crcL
   fuAIUQ9738dO+LXClfRLLQbjRcnHUWvMZGgcsF8Cub3ZtwDwL55mly0hV
   J3nuD+unXBg1HfZctjKoqZdQBcA9UOZ778GEReHrmO8QAGRP8OclK4L7w
   g==;
X-CSE-ConnectionGUID: nbUrruklSkC5oD5i80vLwQ==
X-CSE-MsgGUID: DK8m96CTT7KxlP/N9PtPGg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671619"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671619"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:34 -0700
X-CSE-ConnectionGUID: EXfBz1KxTbuQXWYCIHgcWg==
X-CSE-MsgGUID: t52p1nKpS/O+p/zmAOAwYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989147"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:34 -0700
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
Subject: [PATCH v18 05/17] x86/resctrl: Add node-scope to the options for feature scope
Date: Wed, 15 May 2024 15:23:13 -0700
Message-ID: <20240515222326.74166-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently supported resctrl features are all domain scoped the same as the
scope of the L2 or L3 caches.

Add RESCTRL_NODE as a new option for features that are scoped at the
same granularity as NUMA nodes. This is needed for Intel's Sub-NUMA
Cluster (SNC) feature where monitoring features are node scoped.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 1 +
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index aa2c22a8e37b..5c7775343c3e 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -176,6 +176,7 @@ struct resctrl_schema;
 enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
+	RESCTRL_NODE,
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index b4f2be776408..395bac851f6e 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -510,6 +510,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 	case RESCTRL_L2_CACHE:
 	case RESCTRL_L3_CACHE:
 		return get_cpu_cacheinfo_id(cpu, scope);
+	case RESCTRL_NODE:
+		return cpu_to_node(cpu);
 	default:
 		break;
 	}
-- 
2.44.0

