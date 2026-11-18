Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022506;
	b=Aq5kE6h820WLyIam27Mr6SJxzoHcs7SMjroTV8cniCMUqGK9ZW1zLfsp1YyAR+YLznSI
	 ueG0QEipmTPaH1wRd8RWh49giG8CbVyuVf1t6wQsjHxcCNWDvzUVqJ5oy3OnLKKNYscp3
	 ztXcNkrqBHu/dS4jtIiFZDm9Rd/tMKgEH0mmW6VGCBVCf6Lsy8m++kAp3aKOOKVn6Hc2E
	 ZjvAphylzYH+IdQRFgQyp3Kz5wLoc13Y4pOwKvwR59rzEX8wB0aAh3yu28Vr/jivfv2Bh
	 3LxyaMqBLsqcQpVEwCRi54ishVjOL2YxOWWmnaswEOl611vcWQ5KCbQEiujdD34xRmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eTdshrLFSH1xxygI4gW1CQ7bMu/6lHXjK+yRePvciIg=;
	b=V6RfMkdwFWFiHpWyudunB811eeMtL5K8zJA0uf6IAky1WJUST4AKSvMMJ1qI4c7t9IqZ
	 5ln7Si1IcvLs9h2set8CitVWmA1NpuH+X2XnOwnRsA3HRuCj5pSABvoSjjh4FbRPHZ7qf
	 oeWcPtpp6QyZfrD7YrOaDdEoFDw1dVbv7abFFzKI+1XjGQgCJJBgnLFi8DI69Cmiz0uNQ
	 NnKFHZakW50LjAkq2ZuPvUSRNZaUciZHpeStO/Ohjns3hN+J/7j18mfRIXuo6E8Jtun9S
	 bRS40BEFCFARRM9g0U5yqeHnVb0vjjHxu0VrPekRQlQIICcs7MNRUnz6VrygOwUDIcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiLJLZzi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59814606A32A;
	Wed, 18 Nov 2026 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiLJLZzi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBBF1F000C4;
	Wed, 18 Nov 2026 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022505;
	bh=eTdshrLFSH1xxygI4gW1CQ7bMu/6lHXjK+yRePvciIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiLJLZzi1y+jDGgXmM3AEzQodMoZ1dq0aV0EMkNthgrQi7k8YpZLOLYoFYYn+UKNG
	 IJG8zMKoXwxp7jfXRFYYuOSLMbYaSMncDwsOMgmZOT9SHt4P1ufLiWZO7CAXiccq41
	 dK8QC3xHvLkg49f96gkRc3/tTZxBSkBXBqhIMsPo=
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
Subject: [PATCH 6.18 0036/2151] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Date: Wed, 18 Nov 2026 15:29:31 +0100
Message-ID: <20261118150122.974316232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced newer VMA helpers with equivalent vm_flags checks using the existing is_vm_hugetlb_page() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 0d4f344956642..574585a800fc8 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1775,12 +1775,28 @@ struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
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
 	vmg.middle = NULL; /* We use the VMA to populate VMG fields only. */
 
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
+	vmg.target = vma;
+	if (vma_expand(&vmg))
+		return NULL;
+	return vma;
 }
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb)
-- 
2.53.0



