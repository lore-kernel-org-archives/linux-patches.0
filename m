Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216277;
	b=YQTVRyQYe6nhz/y7hmk0AGTLx39XFDFoJe/CK9kdOt61RHxbajk5exqO1PL52ho8acd1
	 hJEMyiE/BhbPnoqWXMEBjgsNcOtJG32cdzGzeCPjQdJIwH7jjjlqM/vOBKG74mM+ZHZFw
	 XfKt6pDEeA+DS+e8V0dqbGquA2Ds0HWY5cnJvn68eGmSO4jTsKlIwbKtxGuj/S5R5D7mh
	 E2UxDslbEN+L59Hk8frwy4M5mTOioBngQGBOd2oui44CEvl3OYdg38juhFfir3Fwy/Lrh
	 OsNJ59cj5JkBf6MkgnZv7jSvCJ3e9liNi0jH7orUfD5w0aeAzg6qqfS9cxzD9Ta9tVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bnpQWpQL0Bkt4CHUSHAEROU30VdA2qRgzOiRlwncpQw=;
	b=QXK8M1XZTHcgqaP3odiVb13ev8RQFhtbQGrifNhA38lCjy/PNmyOLQ1pcTBYMT5dyVOI
	 jnXTZzEWO7ETe/pQK3FLX8mXjE6PxgcBfgLgSj7Beqg9r4lbEEQuX1sk++uTmMz9oDsXF
	 6QSHBSnDIDOrYDI2gX6UhLiOuVDflOeYxzdoBdDcQnp3ft810YKeK4Xm87KvgIKYzbTkj
	 djjCMVXqiXqXd2IvS1a/QkPbT++Z6LfVgjHDWakB5Fj2d6uU+B9fO4C+ZbzsThsARcQkS
	 FWFndoFCKrJ0GGCNsXOUKje6JEzl/hylSfqT1vyC4T+kF+uRRAuI//9K/QBzlaNqSPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IyxazDWR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB07B606A31C;
	Wed, 28 Oct 2026 19:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IyxazDWR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CC71F01825;
	Wed, 28 Oct 2026 19:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216276;
	bh=bnpQWpQL0Bkt4CHUSHAEROU30VdA2qRgzOiRlwncpQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyxazDWR999DCBFV56gB/veZg8ktC+2m03DDHMiWPIly1kW3g4ST0IWdVgQpt/ks5
	 vheWI6y3lI1wjJBKomMhTGjP537pj9tHe6XxPVujoRr2fYNIMToGMdynme3aFiCFUQ
	 m7YqXsB5FhdE6FqVnvJqHdIFFCaNTMbrOHHMtWJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1500/1887] powerpc/kexec_file: Prevent kexec range truncation
Date: Wed, 28 Oct 2026 17:59:56 +0100
Message-ID: <20261028170533.593242984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit fa40f9dbdd4af53e7445d9135b5b207eb8adf372 ]

Sashiko AI review pointed out the following issue.

The __merge_memory_ranges() function incorrectly handles overlapping
memory ranges when merging them. Although sort_memory_ranges() sorts all
ranges by their start address in ascending order beforehand, the merge
logic remains defective in two ways:

1. It compares the current range's start against the previous element (i-1)
   instead of the running target index (idx)

2. It unconditionally overwrites 'ranges[idx].end' with 'ranges[i].end'.

This logic flaw leads to critical memory truncation when a larger memory
range completely subsumes subsequent smaller ranges.

For example, consider a sorted input array with three ranges:
  Range A (idx=0): [0x1000 - 0x9000]
  Range B (i=1):   [0x2000 - 0x5000] (completely inside Range A)
  Range C (i=2):   [0x6000 - 0x8000] (completely inside Range A)

1. When i=1 (Range B):
   ranges[1].start (0x2000) <= ranges[0].end + 1 (0x9001) is TRUE.
   The code executes: ranges[0].end = ranges[1].end, which erroneously
   shrinks Range A's end from 0x9000 down to 0x5000.

2. When i=2 (Range C):
   ranges[2].start (0x6000) <= ranges[1].end + 1 (0x5001) is FALSE.
   The code falls into the else block, creating a broken new range.

As a result, valid memory fragments [0x5001 - 0x5fff] and [0x8001 - 0x9000]
are completely lost from the kexec exclude lists, potentially allowing
the crash kernel to overwrite active memory, causing data corruption
or crashes.

Fix this by ensuring the start of the current range is compared against the
end of the active merged range (idx), and use max() to safely prevent the
outer boundary from being truncated.

Cc: stable@vger.kernel.org
Fixes: 180adfc532a8 ("powerpc/kexec_file: Add helper functions for getting memory ranges")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260729012948.2797865-4-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/ranges.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kexec/ranges.c b/arch/powerpc/kexec/ranges.c
index 563e9989a5bf0..d169a862158c7 100644
--- a/arch/powerpc/kexec/ranges.c
+++ b/arch/powerpc/kexec/ranges.c
@@ -20,6 +20,7 @@
 #include <linux/kexec.h>
 #include <linux/of_device.h>
 #include <linux/slab.h>
+#include <linux/minmax.h>
 #include <asm/sections.h>
 #include <asm/kexec_ranges.h>
 
@@ -101,19 +102,16 @@ static void __merge_memory_ranges(struct crash_mem *mem_rngs)
 	struct crash_mem_range *ranges;
 	int i, idx;
 
-	if (!mem_rngs)
+	if (!mem_rngs || mem_rngs->nr_ranges <= 1)
 		return;
 
 	idx = 0;
-	ranges = &(mem_rngs->ranges[0]);
+	ranges = mem_rngs->ranges;
 	for (i = 1; i < mem_rngs->nr_ranges; i++) {
-		if (ranges[i].start <= (ranges[i-1].end + 1))
-			ranges[idx].end = ranges[i].end;
+		if (ranges[i].start <= (ranges[idx].end + 1))
+			ranges[idx].end = max(ranges[idx].end, ranges[i].end);
 		else {
 			idx++;
-			if (i == idx)
-				continue;
-
 			ranges[idx] = ranges[i];
 		}
 	}
-- 
2.53.0



