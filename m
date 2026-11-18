Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028530;
	b=ihe1qpC/Ug+FT+aWbLWsWpaY1AeGftSJqGoK5kh5KwgM6sslI3X86K992Ohq+a7d6PcK
	 fvhBfD7vG12FqNGwV38kbgb9Cag/+qK+iWl/5RkePTLBRLVmRpDPobe5uOuleKFiOrEzZ
	 yhLPawpBCtTAu6btqf/6IzK8sb/Gu7N/frDRlmsl+SRD6KPlAT0rVMS5WCSsgJ4BEo+ER
	 kTgQoi2LTShS/oc+4Q6W+vVt4zwO6Jc4lWsasrNx47Gl5HlRZrK2rfiMbmwispsB8qifq
	 zhk2K8bJrxOTaLto2UnKv5PZ5fSrEcbmsTLQyMnpZyA8/VKj7h3V/RDvtyS2Q4yqaVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2FBuJieJ2R679vak9RTe3n+1Ly3mKHdsOrXp37Etf0k=;
	b=QilkAzG1LYxzwjTHixG+WMo2vv2e8ucAF11TYUYrZuhMeUaflnvNUxliPaZk93G4tI3G
	 AkWNn0Oaom8lhFDFmyyuZCgBxUcgO8vQaTBENTxlmSyvCmeK0LfgDxVKgCpCgqSkKvBb/
	 8qzPm1ahWmiXVo+3Wj0JXP/y55wpzabv9Q+iB1wxf48IJ+uj755Zoh51UxGDE2BmzTmgQ
	 4ZCfl7PtMMsgO4cMKnn7e4Qly26ddQxAbEV8Zp3r0NpjKZvKPadDJq1Vi3s8YcaVMhxwz
	 ognFVCvWdHdS8r+zmeXIzLP9IB10Y6fNa2ww7mfkrICaaqJ0sGfg6wwEttfKhms43WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5FqRvb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E368606A31C;
	Wed, 18 Nov 2026 19:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5FqRvb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDE91F000C4;
	Wed, 18 Nov 2026 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028530;
	bh=2FBuJieJ2R679vak9RTe3n+1Ly3mKHdsOrXp37Etf0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5FqRvb1FdrIsbPgYDmwTHHK5AyY5o8zigLTgtIkzLGjxLxDbC5VeKp51eYfCeET4
	 rbf185uJQCq3+4ijuvQT0njojZD2Xbi5Zyu3GfL+HXZSd3ihUZhgonLBgQ31EJ3K9Z
	 5Q9Vne5q34a4zZQhPaBPMP94iIpZvCjqH0aZGNhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Jinyue <jinyue.li@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0029/1756] mm/vma: update VMA iterator state on error in new VMA merge
Date: Wed, 18 Nov 2026 15:35:56 +0100
Message-ID: <20261118150009.036627822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 168ed9c5d5ec2fd326715eba5750c2b69e559ff3 ]

Commit cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs") shared
code between vma_merge_new_range() and vma_expand().

However in doing so, it failed to correctly restore the VMA iterator when
vma_expand() errors out.

This is a problem when the immediately preceding VMA is mergeable and
vmg->just_expand isn't specified, at which point the VMA iterator is moved
to the previous VMA.

(Note that vmg->just_expand is a special case for brk(), where the
iterator will already be positioned at the VMA to be expanded.)

Resolve things by restoring the VMA iterator on error. Use
vma_iter_next_range() to do this, so it will correctly stop on the gap
after the previous VMA, rather than skip to the next VMA after it (this is
a new VMA merge, so is being applied at a gap).

To isolate the error handling, return early when a merge isn't
possible (what the vmg->target check was doing before), then handle the
merge success/failure case explicitly.

While here, update vma_expand() to jump to the nomem case when
dup_anon_vma() fails, so vmg->state is correctly updated.

This doesn't impact anything in practice, but is the correct course and
since it's part of the error path that this patch addresses, it makes sense
to update it also.

Users are very unlikely to have observed the issue this patch addresses in
practice, as it is near-impossible to fail an allocation for an anon_vma,
but a process under memory pressure that receives a fatal signal could
trigger it.

This issue was originally reported by Li Jinyue for which I am grateful. He
indicated this was uncovered by a private syzkaller instance.

Link: https://lore.kernel.org/20261027-fix-new-merge-bug-v1-1-7023a787e6b9@kernel.org
Fixes: cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Li Jinyue <jinyue.li@linux.alibaba.com>
Closes: https://lore.kernel.org/all/20261025093921.1011927-1-jinyue.li@linux.alibaba.com/
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
[ sashal: Retained merge descriptor cleanup on expansion failure because the caller reuses the descriptor for retries. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 85660d67b7942..6f165bf041031 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -931,6 +931,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	pgoff_t pglen = PHYS_PFN(end - start);
 	bool can_merge_left, can_merge_right;
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
+	bool move_iter_back = false;
 
 	mmap_assert_write_locked(vmg->mm);
 	VM_WARN_ON(vmg->vma);
@@ -968,33 +969,38 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 			vmg->end = end;
 
 		/* In expand-only case we are already positioned at prev. */
-		if (!just_expand) {
-			/* Equivalent to going to the previous range. */
-			vma_prev(vmg->vmi);
-		}
+		if (!just_expand)
+			move_iter_back = true;
 	}
 
+	if (!can_merge_left && !can_merge_right)
+		return NULL;
+
+	if (move_iter_back)
+		vma_prev(vmg->vmi);
+
 	/*
 	 * Now try to expand adjacent VMA(s). This takes care of removing the
 	 * following VMA if we have VMAs on both sides.
 	 */
-	if (vmg->vma && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->vma, vmg->flags);
-		vmg->state = VMA_MERGE_SUCCESS;
-		return vmg->vma;
-	}
+	if (vma_expand(vmg)) {
+		/* Error occurred, restore iterator. */
+		if (move_iter_back)
+			vma_iter_next_range(vmg->vmi);
 
-	/* If expansion failed, reset state. Allows us to retry merge later. */
-	if (!just_expand) {
-		vmg->vma = NULL;
-		vmg->start = start;
-		vmg->end = end;
-		vmg->pgoff = pgoff;
-		if (vmg->vma == prev)
-			vma_iter_set(vmg->vmi, start);
+		/* If expansion failed, reset state. Allows us to retry merge later. */
+		if (!just_expand) {
+			vmg->vma = NULL;
+			vmg->start = start;
+			vmg->end = end;
+			vmg->pgoff = pgoff;
+		}
+		return NULL;
 	}
 
-	return NULL;
+	khugepaged_enter_vma(vmg->vma, vmg->flags);
+	vmg->state = VMA_MERGE_SUCCESS;
+	return vmg->vma;
 }
 
 /*
@@ -1032,7 +1038,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 		vma_start_write(next);
 		ret = dup_anon_vma(vma, next, &anon_dup);
 		if (ret)
-			return ret;
+			goto nomem;
 	}
 
 	/* Not merging but overwriting any part of next is not handled. */
-- 
2.53.0



