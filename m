Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590349;
	b=zD2L7aSxSKX6cU//ZES3FaMRogXn6psXkbsBRdLbiYnm/zVCg1EzlXzRp12pjqgRkIQV
	 czs6ZmBy8uvxZvxcRA8LIfat3tmt0P3lqwXlNXsPvwQQ1oIZ5RQ0I9KT0G1iPb4JVb5vt
	 VLWx4GylrhUj9vJD5jMyORtdj4a3B3CTrdSYzI5AX9evnmFde5K2rTGc0B8gsPI4l3JWs
	 F0nnL/h8t7XK+oPjAf7rt/AdOweSp66JuWlw3bgxXVjjzC45Iz6NTZZAFQzYfclWQECVL
	 YftrswSHS7LYK82vc4LgFMeD1F6EDtXJQns5D4z68Mo+k8nYCv7BeH60AJTYTi+A9iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URNiMelhMh9mgc5dL7z+priDSx9ptDB3vmHy0Nld92U=;
	b=qMyc20/S0HRYYByWBq4NDiRNEey76FZ5QT/shtB6NGY40sRGCYmcnd5KUm7mxereFJn3
	 Nh0j9xYqiEtFNYqJ9JawaJs+A7ltbJo3foYMxcioENG14+NbZUwhSJ7bgLq1PJaDu+LFE
	 VGBtB9evucjRdU2chLodi0ucSuxorFOLRhsgvJ0Ek4stDjCXgcUtqdSIPGwK6Wg0jaR3m
	 KyXGIT1grGsj6/M+/l5GjBwj0CL+IzrsdJq8q7HS/wEjYnqK+7cMc0qWzYwlNsM6ay0dm
	 SXk63g9qeGM/T4sOCj7uY0DP4zZuD/mntgms+9fbpaXYukYRbjd5YwJ9QsHxwSuVcRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nY4f59G6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76627606A89F;
	Fri, 13 Nov 2026 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nY4f59G6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2321F000C4;
	Fri, 13 Nov 2026 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590349;
	bh=URNiMelhMh9mgc5dL7z+priDSx9ptDB3vmHy0Nld92U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nY4f59G6F5NW7wzqoLkH/4nqjuTZkpYYolOXJX76apTK0YTAl+E+h55atVZqYF3Da
	 RT+Ti92e3D/JUzEhmyR6o9wYArj1+EcD7iRsN/npNIdOFVOQe+iTEJ20sFkSM2jKvl
	 Np0xlpy4EITtIkPILCmcnjblzp1T8JSNp7aAbwag=
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
Subject: [PATCH 6.18 319/686] mm/vma: update VMA iterator state on error in new VMA merge
Date: Fri, 13 Nov 2026 10:47:32 -0500
Message-ID: <20261113153831.745475508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d1627a8ef32b1..dadf7d69182c2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1046,6 +1046,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	struct vm_area_struct *next = vmg->next;
 	unsigned long end = vmg->end;
 	bool can_merge_left, can_merge_right;
+	bool move_iter_back = false;
 
 	mmap_assert_write_locked(vmg->mm);
 	VM_WARN_ON_VMG(vmg->middle, vmg);
@@ -1083,23 +1084,30 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
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
@@ -1190,7 +1198,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 	if (!ret && vmg->copied_from)
 		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
 	if (ret)
-		return ret;
+		goto nomem;
 
 	if (remove_next) {
 		vma_start_write(next);
-- 
2.53.0



