Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60645199255;
	Thu,  6 Jun 2024 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682991; cv=none; b=UzirOJTudgHOKjQoPo+5Z0NyrIpLJAIU+KbYoin8ElU2GVgfC6NpKCG1emLiiAar+Rfof7962CwWpheSkFK6KMyNxOhJkEFxgKTpUszyUlNvkb0inJH6dBhGlQXxEaWRR2VpJtF1xne7QHT4bY26JUy8k+QcNI4ZumhEjRMB9XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682991; c=relaxed/simple;
	bh=zmo8dE6KFDV2bLUQ/6uiX3aRXuS31kqswjtEp3Xmkoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfEDk2fWabR9VkR+V8zbcEGsykl964IEmdLLeuY7CLGobjDLQ/AFFVLOgR09E2//+ldpj8jVNJILEZxeGV5fS8XfkyWfs1CYgecnam+LZnBWtiR/Nxj7fuZGXQ7eOS7TqFnbV0z+bM+XufmM6AMvz8TvPQLtoKgy6+kOlyRsqS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Go8K3aHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Go8K3aHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF2EC32782;
	Thu,  6 Jun 2024 14:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682991;
	bh=zmo8dE6KFDV2bLUQ/6uiX3aRXuS31kqswjtEp3Xmkoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Go8K3aHz/RfCUxfgckSFAlv5WrOJZSKws7a7aQvrRRFbf9iIicfaiYS0gRYU7C4Ka
	 XNmmMG7lQF8s8TKOw3u2b6OQHNPPOenou5kD17XE3XVErQz1VQ9Ih2f+Ko+ujewWjW
	 dT07SSGmh29/hiurt8Dn54krU6bILERVNuEZBJQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 142/374] ocfs2: correctly use ocfs2_find_next_zero_bit()
Date: Thu,  6 Jun 2024 16:02:01 +0200
Message-ID: <20240606131656.661546025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 30dd3478c3cd7d01cc5afc4952e885ba4eefb730 ]

If no bits are zero, ocfs2_find_next_zero_bit() will return max size, so
check the return value with -1 is meaningless.  Correct this usage and
cleanup the code.

Link: https://lkml.kernel.org/r/20240314021713.240796-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 28d2188709d9 ("selftests/harness: use 1024 in place of LINE_MAX")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/localalloc.c   | 19 ++++++-------------
 fs/ocfs2/reservations.c |  2 +-
 fs/ocfs2/suballoc.c     |  6 ++----
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index c803c10dd97ef..33aeaaa056d70 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -863,14 +863,8 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 
 	numfound = bitoff = startoff = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
-	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) != -1) {
-		if (bitoff == left) {
-			/* mlog(0, "bitoff (%d) == left", bitoff); */
-			break;
-		}
-		/* mlog(0, "Found a zero: bitoff = %d, startoff = %d, "
-		   "numfound = %d\n", bitoff, startoff, numfound);*/
-
+	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) <
+	       left) {
 		/* Ok, we found a zero bit... is it contig. or do we
 		 * start over?*/
 		if (bitoff == startoff) {
@@ -976,9 +970,9 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 	start = count = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
-	       != -1) {
-		if ((bit_off < left) && (bit_off == start)) {
+	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
+	       left) {
+		if (bit_off == start) {
 			count++;
 			start++;
 			continue;
@@ -1002,8 +996,7 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
 				goto bail;
 			}
 		}
-		if (bit_off >= left)
-			break;
+
 		count = 1;
 		start = bit_off + 1;
 	}
diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
index a9d1296d736dc..1fe61974d9f02 100644
--- a/fs/ocfs2/reservations.c
+++ b/fs/ocfs2/reservations.c
@@ -414,7 +414,7 @@ static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
 
 	start = search_start;
 	while ((offset = ocfs2_find_next_zero_bit(bitmap, resmap->m_bitmap_len,
-						 start)) != -1) {
+					start)) < resmap->m_bitmap_len) {
 		/* Search reached end of the region */
 		if (offset >= (search_start + search_len))
 			break;
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 166c8918c825a..961998415308d 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -1290,10 +1290,8 @@ static int ocfs2_block_group_find_clear_bits(struct ocfs2_super *osb,
 	found = start = best_offset = best_size = 0;
 	bitmap = bg->bg_bitmap;
 
-	while((offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start)) != -1) {
-		if (offset == total_bits)
-			break;
-
+	while ((offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start)) <
+	       total_bits) {
 		if (!ocfs2_test_bg_bit_allocatable(bg_bh, offset)) {
 			/* We found a zero, but we can't use it as it
 			 * hasn't been put to disk yet! */
-- 
2.43.0



