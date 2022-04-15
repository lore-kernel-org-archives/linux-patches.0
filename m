Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352307B
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 02:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C1AC385A5;
	Fri, 15 Apr 2022 02:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1649988830;
	bh=HsSQiCzVou7pdy0n3uzXUYPUGgfLQFTxEX9aiaeWYA8=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=e9snAHju5jwScKCgUygtfIkII0Acd/DRIgk2wTJ1l4Gu+u23mxGMaYdnt/OD6BtjU
	 wwaUxNM8y0U27bq9nbGrMM7Ewruz3purAdgexvfYJxmnMOp9cNv8Cka1iEdRWWmLvq
	 LY8MjHFy47MBDWSew5Kcnieh8TuASIooAt6ITbSY=
Date: Thu, 14 Apr 2022 19:13:49 -0700
To: vbabka@suse.cz,nigupta@nvidia.com,lkp@intel.com,quic_charante@quicinc.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
Subject: [patch 09/14] mm: compaction: fix compiler warning when CONFIG_COMPACTION=n
Message-Id: <20220415021350.02C1AC385A5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: compaction: fix compiler warning when CONFIG_COMPACTION=n

The below warning is reported when CONFIG_COMPACTION=n:

   mm/compaction.c:56:27: warning: 'HPAGE_FRAG_CHECK_INTERVAL_MSEC'
defined but not used [-Wunused-const-variable=]
      56 | static const unsigned int HPAGE_FRAG_CHECK_INTERVAL_MSEC =
500;
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it by moving 'HPAGE_FRAG_CHECK_INTERVAL_MSEC' under
CONFIG_COMPACTION defconfig. Also since this is just a 'static const
int' type, use #define for it.

Link: https://lkml.kernel.org/r/1647608518-20924-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Nitin Gupta <nigupta@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-compiler-warning-when-config_compaction=n
+++ a/mm/compaction.c
@@ -26,6 +26,11 @@
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
+/*
+ * Fragmentation score check interval for proactive compaction purposes.
+ */
+#define HPAGE_FRAG_CHECK_INTERVAL_MSEC	(500)
+
 static inline void count_compact_event(enum vm_event_item item)
 {
 	count_vm_event(item);
@@ -51,11 +56,6 @@ static inline void count_compact_events(
 #define pageblock_end_pfn(pfn)		block_end_pfn(pfn, pageblock_order)
 
 /*
- * Fragmentation score check interval for proactive compaction purposes.
- */
-static const unsigned int HPAGE_FRAG_CHECK_INTERVAL_MSEC = 500;
-
-/*
  * Page order with-respect-to which proactive compaction
  * calculates external fragmentation, which is used as
  * the "fragmentation score" of a node/zone.
_
