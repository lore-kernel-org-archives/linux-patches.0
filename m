Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028535;
	b=mAsh0axEAMd/dPVO+ZxS6dBqKqgunyiH/1A1qQ62Y3uZQBnSrA+Rv5QNzhP9xFTceMqL
	 s42bkHnzQQD7ylgB5JGouT8/VROBRynhg2on0d34GJMpixNvJdsU7IhtQCkK+mLB4IORn
	 G+HCokPeexBiLXqAy1Xcg8cfn5MrV43y5s7evtah+Ra8u2QC4fsa09m35STKBDipzU3pN
	 Ru3wVj02vSdwWkH0R5TsxV1oEbAipYHrSqFKVrgVY7x9jWX4abIIr4b+BqfoRQLMLPZp6
	 5Hzn85GqijCNE6IZTWXYMaewP7Y2jiIbfVB8pYJhB5WrgivX3mFVcwtDvEO1ndUxFjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/tNymkGKQIM7SQ3C7kqxtJviWRvQGK6RZiPp1RKNCJs=;
	b=4MQY6htIaHKeUJvxhUAkLYoIvmHajHTbwYwr/uQWNGFXKwDtylXFfr974/Gy6Rckxi4+
	 ypy1/iDmPO+oqeM1tvuhv+Ub5Or6sg0NipT6ORk9aRuv+GGD2YFcYIC9UUANNtZSuyrx8
	 AqJRxRPB7R/vFdSROofunSt0Tr2r73IP/cqxIfsmZ+bFxY6lJgIYH+C0VFGZupQMpzE3L
	 qsfZv104pX1lV7xIgJyMU2tLsx5HKr4s1Kf6Y5aUa9b2l64tYhwkCCb5gkwvMlhpVAFC8
	 6YWp5aoHyFB0aj5102LCUi4kBIhVdPGOuRJ8YVXfIRt9TJlGYgPlhIONvodrJ7r86tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bqku0WFy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D5B606A325;
	Wed, 18 Nov 2026 19:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bqku0WFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF131F000C4;
	Wed, 18 Nov 2026 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028535;
	bh=/tNymkGKQIM7SQ3C7kqxtJviWRvQGK6RZiPp1RKNCJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqku0WFyO7aNcXTtuDH7kc11Q5fSGoMt2WZ4ob3GnAhEgsBPLYCi8/p+z4eY4NNYI
	 d0SM5+Nrd7sQLro9N7p3/ssN14h/xPRzHkicVyEotnzN9exgR0TF3F59I142G7RgcR
	 q87n5bThAJeygtoknD7FbOOB3PMTScfl7RvBnjT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Jann Horn <jannh@google.com>,
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0031/1756] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Date: Wed, 18 Nov 2026 15:35:58 +0100
Message-ID: <20261118150009.107095037@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 8146c6478224d8f6395c6b08a19c344a56d79867 ]

Commit ca3d76b0aa80 ("mm: add merging after mremap resize") combined
merging with expansion of mremap()'d VMAs, however it also unintentionally
disallowed the expansion of unmergeable VMAs.

Previously it was possible to expand a mixed mapping which mremap() had
already ensured was a legal expansion.

This is clearly seen in the mremap() logic, as it checks
vma_is_fixed_mapping() to determine legality of an expansion rather than
vma_can_merge().

Additionally, copy_vma() allows for a failed merge to result in a new VMA
being instantiated if MREMAP_MAYMOVE is specified.

However, this is not attempted, as a failure in vma_merge_extend() is
assumed to be an -ENOMEM failure.

Since vma_merge_extend() is used exclusively by mremap() to perform a merge
and/or expansion, resolve the issue by invoking vma_expand() for
unmergeable VMAs there.

Explicitly assert that the VMA is both non-fixed and a mixed mapping.
This provides double insurance against broken changes in future.

Note that khugepaged_enter_vma() (which vma_merge_new_range() runs) is
redundant in this case, as a mixed mapping is not subject to khugepaged.

Also update the VMA userland tests to add a required predicate.

Link: https://lore.kernel.org/20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Luiz Capitulino <luizcap@redhat.com>
Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted VMA handling to use direct vm_flags checks and the existing vmg.vma merge-state field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 6f165bf041031..6f50712eb9b6d 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1550,12 +1550,28 @@ struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
 					struct vm_area_struct *vma,
 					unsigned long delta)
 {
-	VMG_VMA_STATE(vmg, vmi, vma, vma, vma->vm_end, vma->vm_end + delta);
+	const bool can_merge = !(vma->vm_flags & (VM_PFNMAP | VM_DONTEXPAND |
+						  VM_MIXEDMAP)) &&
+			      !is_vm_hugetlb_page(vma);
+	const unsigned long start =
+		can_merge ? vma->vm_end : vma->vm_start;
+	VMG_VMA_STATE(vmg, vmi, vma, vma, start, vma->vm_end + delta);
 
-	vmg.next = vma_iter_next_rewind(vmi, NULL);
 	vmg.vma = NULL; /* We use the VMA to populate VMG fields only. */
 
-	return vma_merge_new_range(&vmg);
+	if (can_merge) {
+		vmg.next = vma_iter_next_rewind(vmi, NULL);
+		return vma_merge_new_range(&vmg);
+	}
+
+	/* Mixed mappings are permitted to be expanded, not merged. */
+	VM_WARN_ON_ONCE(vma->vm_flags & (VM_PFNMAP | VM_DONTEXPAND));
+	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_MIXEDMAP));
+	vma_prev(vmi); /* Reposition to start of VMA. */
+	vmg.vma = vma;
+	if (vma_expand(&vmg))
+		return NULL;
+	return vma;
 }
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb)
-- 
2.53.0



