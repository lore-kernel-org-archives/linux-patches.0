Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77493D2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 21:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680643293; x=1712179293;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tZgC+Au9D4mBfsgau/I2b0cV3O9QOcG/WflEJjkj6Ao=;
  b=YToeayht5VGIJ2oQ+LOTkvoYOga+YFBczDOxEBGCr2ghO52dzO++O5LU
   9oLfHcc34h23cZTlp89zuIlgRt9r6gvjCOBDfc2iMATu5Z0ZZeTCL0kQP
   qK1K5/sA9Lu07T5EWZscvT+Vt4trVZFT++HMsDeZtAAAg0rtFZ9uXgdci
   FRCyQ6kZaeO6mIJauQkf8pMBRcsUUQHa0nB4fiY9PSsRapoTETnS8w+aK
   eKXovfkr6cE4HWv13qeZ7IcCVOU7xbd/yu6Y3+MwDGhKi4mag4IFYF5kz
   ZsEvomq2yoNUjBZNa4uGdnPTLN5xivMTWnjNqJjbhXQjlV2Etdw3u1rmC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="322692637"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="322692637"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 14:21:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="689043487"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="689043487"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 14:21:31 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add Xeon Emerald Rapids to list of CPUs that support PPIN
Date: Tue,  4 Apr 2023 14:21:24 -0700
Message-Id: <20230404212124.428118-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This should be the last addition to this table. Future CPUs will
enumerate PPIN support using CPUID.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8cd4126d8253..80710a68ef7d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -121,6 +121,7 @@ static const struct x86_cpu_id ppin_cpuids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, &ppin_info[X86_VENDOR_INTEL]),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, &ppin_info[X86_VENDOR_INTEL]),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, &ppin_info[X86_VENDOR_INTEL]),
 	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL, &ppin_info[X86_VENDOR_INTEL]),
 	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM, &ppin_info[X86_VENDOR_INTEL]),
 
-- 
2.39.2

