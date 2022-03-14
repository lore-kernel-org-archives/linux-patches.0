Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211B966D6
	for <patches@lists.linux.dev>; Mon, 14 Mar 2022 16:57:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CEF15210F9;
	Mon, 14 Mar 2022 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1647277052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OxXwFHPNzH5Csyhh4StleU/1uE5aiwhYDOtjRtBM8Cs=;
	b=0ErJaYnJIqPZaBs+I1ty5OXDQBllInMcDso1OSQDpnCeJkCEXe7GqvvyWmjf+G0Ck8EpZq
	THeQvMj89rYiWZJr2WTsfi9C8G6XAyWK+h8AKNfmzR0kvtSAanOzUmj5c2N3scVIuzeHEX
	QJNQv4P7ni52vdAIkhatE2h2GKNORFs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1647277052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OxXwFHPNzH5Csyhh4StleU/1uE5aiwhYDOtjRtBM8Cs=;
	b=AODhh5jhdKhN6dl7oIOx9NiQoT4GhrtmrFrIQBE0M+KjDBi84wWkT8rAT2dKpvytrDlFxN
	I4pKIJVhsE4A+9Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE9E013B9A;
	Mon, 14 Mar 2022 16:57:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id sGz1KfxzL2I+PAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 14 Mar 2022 16:57:32 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 2/2] mm/early_ioremap: declare early_memremap_pgprot_adjust()
Date: Mon, 14 Mar 2022 17:57:24 +0100
Message-Id: <20220314165724.16071-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314165724.16071-1-vbabka@suse.cz>
References: <20220314165724.16071-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1262; h=from:subject; bh=7vyyC8zALJ4SuHOC5Gb+d+1XDIpeD1sRQmLdSzD1PtI=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBiL3PzVFbcI0UT/MAE1ZzpBx7qovtYTchrj7J6OO9A KzJzkROJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYi9z8wAKCRDgIcpz8YmpENlUCA CnUgCA9PKggdYKeRUblvVPEAL3cg75UMqK2D+sXbmrCKeEMZirLx+xgKARoMUzXfBZitHGZi4D8hJX BRGNHk5hZQLVf38pO+jRObxiNsfBmmjGlfyuDpaGlgaqlGVSHhEafjY5gP5gJi9qeasT+/fr049qec CRbPIB3BQCX4jEgd2XC94yWG/KEj5fGgHpM7/Fgw/dVqvlVWcPE+jXhGvFOcY2UwUD1Dm06+3FBvA1 KX74PDGs8wueuKxRMLySgslgOriAT+mYgB6nfsjqok4BB0mzVqVaRsAyQTePmDTiD49PnKHfFTfOYG Kn60Kbud5m9Nj6JHTnt4qzdgThG3oe
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The mm/ directory can almost fully be built with W=1, which would help
in local development. One remaining issue is missing prototype for
early_memremap_pgprot_adjust().

Thus add a declaration for this function. Use mm/internal.h instead of
asm/early_ioremap.h to avoid missing type definitions and unnecessary
exposure.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/early_ioremap.c | 1 +
 mm/internal.h      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/mm/early_ioremap.c b/mm/early_ioremap.c
index 74984c23a87e..9bc12e526ed0 100644
--- a/mm/early_ioremap.c
+++ b/mm/early_ioremap.c
@@ -17,6 +17,7 @@
 #include <linux/vmalloc.h>
 #include <asm/fixmap.h>
 #include <asm/early_ioremap.h>
+#include "internal.h"
 
 #ifdef CONFIG_MMU
 static int early_ioremap_debug __initdata;
diff --git a/mm/internal.h b/mm/internal.h
index d80300392a19..e3e2a3c5f655 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -154,6 +154,12 @@ extern unsigned long highest_memmap_pfn;
  */
 #define MAX_RECLAIM_RETRIES 16
 
+/*
+ * in mm/early_ioremap.c
+ */
+pgprot_t __init early_memremap_pgprot_adjust(resource_size_t phys_addr,
+					unsigned long size, pgprot_t prot);
+
 /*
  * in mm/vmscan.c:
  */
-- 
2.35.1

