Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF87A107BB
	for <patches@lists.linux.dev>; Fri, 24 Mar 2023 19:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679687978; x=1711223978;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sNVllBtmU8q7PqMLUiVSP/EAmHPB6Rm0X9oOm1Judio=;
  b=HPOoHj5+zCEg8MzZLEVWkUIDu2oVKQ+IQXK9NMEsEn7lucKEyy3/4nMe
   h3HvTLCQc9M7XPHl11jd9LqtWLQV8nZHJciqrl85S9EivRZ2QtqbZ9G50
   ZJdE+JMjKzQ7JMNp7EmewxERfkDxWobQpAde/XIcAlwqi4qdM6NAUnZfr
   /20vJGk9ZrWF2N6UsDrdhqgCl+x0Yr8WiNDe/bylcfdMf/kguSvbH0zWn
   fEEbuMKY7tpilRzIM3uWBtDEe+xyxZam1ttlCe4THtMXnfZHakdazUiaD
   QMM0eHl0/svLgU37viqm9mhXKU3RliW0IZOMdRBIeT+yYh4rPUxmSr0b2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="341443994"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="341443994"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 12:59:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="685298887"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="685298887"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 12:59:37 -0700
From: Tony Luck <tony.luck@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/cpu: Add model number for Intel Arrow Lake processor
Date: Fri, 24 Mar 2023 12:59:32 -0700
Message-Id: <20230324195932.241441-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

https://www.intel.com/content/www/us/en/newsroom/news/intel-technology-roadmaps-milestones.html
says this will be built on Intel 20A tiles and launch in 2024.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index cbaf174d8efd..b3af2d45bbbb 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -125,6 +125,8 @@
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
 
+#define INTEL_FAM6_ARROWLAKE		0xC6
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.2

