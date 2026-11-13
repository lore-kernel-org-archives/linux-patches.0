Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585668;
	b=3O4K0f+VFReXQBLtau9MEXjFUr7ZSMVSFTOqqf2kdXJGtkz8gnhkZKRBkLX9HJRi9zQa
	 8dMsOa3lOwIXJ6XHYlcRznRXiFLP2D4K+UPjqwbsgIiTX8e7lv+D7D1uLYNRER+I/6S1b
	 /EVluPeVjFIzXBDa777B/FzaMAxYhPxn12Joh3xCk0hSXQO1Adw4Lj0Kdwjb9JIx+OVAK
	 sraBcMtHPWS644v8WVWMyTdqzmYX7p5MOEgfOnazaaZfQVqjZDta7Mvc9cwWRNQ2PL6Wy
	 IyOzJvQuCkWetaeWuhdVEgEUCSxdSDloEX9o2yI6cg4BIUbQyzV9BQ4v9kaFhV7KPYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0mXSV08ngFosxzn0xzU47imkImMhgTrpXooanUD/IgI=;
	b=Ten8IZ/HC33sf5GTquM03BHc8zAbka+2pPx1i2muV+51Mj241R/uZDhkSPE9n438FXcK
	 C3uHckiSs1LX4Qi2L7Wyi8SLu0FwLKZvdHCvJ6RL2T0bgggZ+wrM5olbaX6ID20CkbabD
	 QTaabgb1g1t62uvd9CEiRMkGeRQEEqoL8RTuwRhJOs8NIXqfiHlMBTF2FFAkny+Z/C6BL
	 ZY7jzfR8DLTMrRKDbDvF2hAlBVAlPP0odvvdiQn2INr2ge5pyqfQm3HVueqMpPP2Esse0
	 r6AzITCCnS9dVBK1OTdNJEUohvKJwkgCTGpqnIOcNNx8TN2n9PBFvp6OJhv6tlAqX3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXgjc9JS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CBB606B2DB;
	Fri, 13 Nov 2026 16:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SXgjc9JS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA6C1F000C4;
	Fri, 13 Nov 2026 16:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585668;
	bh=0mXSV08ngFosxzn0xzU47imkImMhgTrpXooanUD/IgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXgjc9JS3XtE6xtGtvaQSSGvQygPCUKRu/00dmsqMKiCkWMbR6fThoSbTfH7SXpg0
	 rTlpXdY7vwIQ0iUf2Ea7ascrSYRHgWd4VEBJ/KRqd4wRiGi64VykJQdhXotNKiStPi
	 q7e5ub0uUtsh/w5SHk4yeMFbvOPLQ1wLdruAMguI=
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
Subject: [PATCH 7.3 239/507] mm/vma: update VMA iterator state on error in new VMA merge
Date: Fri, 13 Nov 2026 10:49:03 -0500
Message-ID: <20261113153802.705487287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index e2ce21afe44a6..2962670f27b5e 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1143,6 +1143,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	struct vm_area_struct *next = vmg->next;
 	unsigned long end = vmg->end;
 	bool can_merge_left, can_merge_right;
+	bool move_iter_back = false;
 
 	mmap_assert_write_locked(vmg->mm);
 	VM_WARN_ON_VMG(vmg->middle, vmg);
@@ -1182,23 +1183,30 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 			vmg->end = end;
 
 		/* In expand-only case we are already positioned at prev. */
-		if (!vmg->just_expand) {
-			/* Equivalent to going to the previous range. */
-			vma_prev(vmg->vmi);
-		}
+		if (!vmg->just_expand)
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
-	if (vmg->target && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
-		vmg->state = VMA_MERGE_SUCCESS;
-		return vmg->target;
+	if (vma_expand(vmg)) {
+		/* Error occurred, restore iterator. */
+		if (move_iter_back)
+			vma_iter_next_range(vmg->vmi);
+		return NULL;
 	}
 
-	return NULL;
+	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+	vmg->state = VMA_MERGE_SUCCESS;
+	return vmg->target;
 }
 
 /*
@@ -1293,7 +1301,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 	if (!ret && vmg->copied_from)
 		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
 	if (ret)
-		return ret;
+		goto nomem;
 
 	if (remove_next) {
 		vma_flags_t next_sticky;
-- 
2.53.0



