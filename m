Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E3F34CFD6
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 18:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781547918; cv=none; b=jP8w4nFIzl4vbUgjC5mV67hrLnYRvKv9gZhkA3/p9qRVW4NJ2KfhcATYVovOwPW3epQmDUEp2TVoKqgnGPv9BKBD4JnWl4YAn9j2sAbH3ba6uT0Z+k5usRZoDY4Z1QyXgXsNfhRtA/AhhytTyIuRrcMfaLie9aWLhtpBcL2lUHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781547918; c=relaxed/simple;
	bh=MrhqPa7j2JGoW5KXGgtohMR/jOgI/vkqvszj5jCodoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxNCKPp2wtFfJtDlHWXYlC/xLU3h3393v1XUBneETwIqFUth81r0mz2HE9GPfcC5wZadHnTzLe+6PBTOxEXUSy56DhN3AuDkpHkdjqlbsoUc1GFD7nCSUxCRwalxUG4uffNguxg3QDUiNzBRxAXkCPF6wpaHL1f1l3knFyqnAxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QXQ9Oy+1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QXQ9Oy+1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781547916; x=1813083916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MrhqPa7j2JGoW5KXGgtohMR/jOgI/vkqvszj5jCodoM=;
  b=QXQ9Oy+1tFEcwST7rugJQXndNMYiN94qKspoGRHX9wK4LkcIqkJNICdx
   q4udnu4G8XqsLzVUHu2cZCRfZ8yR9rkhMnA2dzPAWRMzLsR0OPmnGyi1q
   NRLTSPhrv52b55KEYR0wx9jj1oX0GLAr9WuqBPS7vDaQ0LFdQoxR/9PPZ
   8nQPJlKtD7kspMtcUN6DKD/GWqq3mDUD0Ns7UyKoPo+hsP20pmdi7EDAa
   3HdNRO5s/Z3tuBuXrfoLY49c6r3IilmgQWzmOS4lGIVK58BvaS+mdfl4d
   tEyJQOpQszWzKXDaxPkGPDUxtniFtWNtVm6M1CTIJLReNpGkgfzeczG11
   Q==;
X-CSE-ConnectionGUID: UZGmZNxtSUugoGkiS06shg==
X-CSE-MsgGUID: m6x7aVWZQiurfNFWygAc/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11818"; a="93790029"
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="93790029"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:11 -0700
X-CSE-ConnectionGUID: dxyYtQtPTuyOlPZ6USejjA==
X-CSE-MsgGUID: 0uKHzxPJQqGZmRRq/+KssQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,206,1774335600"; 
   d="scan'208";a="247620653"
Received: from spandruv-desk1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.121])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:25:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>,
	x86@kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 12/16] platform/x86/intel/pmt: Register enumeration functions with resctrl
Date: Mon, 15 Jun 2026 11:24:53 -0700
Message-ID: <20260615182457.14725-13-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615182457.14725-1-tony.luck@intel.com>
References: <20260615182457.14725-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
call PMT functions directly.  Register the telemetry enumeration function
pointers at pmt_telemetry module .probe(), and unregister them at module
.remove().

Note that checkpatch complains about the #include of <asm/resctrl.h>.
This is needed rather than <linux/resctrl.h> to get the function stub
definitions when CONFIG_X86_CPU_RESCTRL=n.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
v8:
	Move register/unregister calls to .probe()/.remove()

 drivers/platform/x86/intel/pmt/telemetry.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
index daa6da9bad2a..fa4033f94d2f 100644
--- a/drivers/platform/x86/intel/pmt/telemetry.c
+++ b/drivers/platform/x86/intel/pmt/telemetry.c
@@ -25,6 +25,8 @@
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
 
+#include <asm/resctrl.h>
+
 #include "class.h"
 
 #define TELEM_SIZE_OFFSET	0x0
@@ -365,6 +367,8 @@ static void pmt_telem_remove(struct auxiliary_device *auxdev)
 	struct pmt_telem_priv *priv = auxiliary_get_drvdata(auxdev);
 	int i;
 
+	intel_aet_unregister_enumeration();
+
 	mutex_lock(&ep_lock);
 	for (i = 0; i < priv->num_entries; i++) {
 		struct intel_pmt_entry *entry = &priv->entry[i];
@@ -405,6 +409,8 @@ static int pmt_telem_probe(struct auxiliary_device *auxdev, const struct auxilia
 		intel_pmt_get_features(entry);
 	}
 
+	intel_aet_register_enumeration(THIS_MODULE, intel_pmt_get_regions_by_feature,
+				       intel_pmt_put_feature_group);
 	return 0;
 abort_probe:
 	pmt_telem_remove(auxdev);
-- 
2.54.0

