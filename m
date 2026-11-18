Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014994;
	b=IoCqS+Ph4bxzWcVrxnH6NL6ARubxFsyO99lYpvuRHRwus3G316TuqQhaCbH5hAkzKEpv
	 rYyNreYQnLLDDeNGu9qrqJbX6iUeBY4JX197uVkxl+WeWOvrFw8MkuU6k9tgz5ozbk+mx
	 xv8Q57XJ8k88nkFLUswLy1TziolOOhkoT1uUixQKCncqWDEbCv6zxdfWkqYIgb7pyn5o1
	 m1vFbHi7KS4mbKU+PDTNTcUBbARR1F+v5yL9CX2XCPNC/wcxZUEDMi80nmr+PUoXfKQJ/
	 Spvy2spHqO13yYLnqYuRR5w+sd4i7qFSAlUDu/b5lIcCXoLMbBoo9MLbOVj1E0kIMDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eDsdFcLSF8jU5rEGDVioVYGMFOt0Z48VoOiAosXb2LY=;
	b=EghKbFG7ggNrLOr7Wej+5z1+sfBws7gLoE0pwFVB4z9oKm4aburmRdAWTguW4p0sg7hH
	 CcyYE/6Yj2wnH0cTY9fYBsgkZhI4MZu61VV04XGTCST2cYiuymMCbxh0lpRuVimOmHk3w
	 ATQwnZmagCNop2pNilk5mjYWDZJCajjWVHw0YIJ1H+bF3ZMrqLe45qx73voWcsSztRUdd
	 AVKnfO7aA3O2yVz5VNaWtWNjx/XMpX9o3Q08AeYsKaw/Ih9h10rV1zN84lQoqgCvMDd1w
	 sb8XjbWep4KCVJa2RGJx8nDyfvD6B7B7mfoQsso7nA0xkxmwj7lwHjwke5hvuhUPGEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cwyr9AMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60810606A31C;
	Wed, 18 Nov 2026 15:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cwyr9AMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C341F000C4;
	Wed, 18 Nov 2026 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014994;
	bh=eDsdFcLSF8jU5rEGDVioVYGMFOt0Z48VoOiAosXb2LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cwyr9AMh2iX/DfjWnfrLr3pbV/FPlhI/mJupgBwuoBb68YLwwV/102PS7VTM3gS8M
	 eyn1sj1MpFHDf3ty2sANAWojJh2+Ye8apy5mP0vyCId60wDwjYEvHgATcmgKCI70lS
	 uWnWR/x+4JengrlS8uKR1jAG1p3I7zOirVciSWYA=
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
Subject: [PATCH 7.3 0015/2651] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Date: Wed, 18 Nov 2026 15:20:55 +0100
Message-ID: <20261118150248.543295897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced vma_can_merge() and vma_is_fixed_mapping() with equivalent flag checks and is_vm_hugetlb_page(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vma.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index e382fd32f0fff..9863668b9d6bc 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1882,12 +1882,28 @@ struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
 					struct vm_area_struct *vma,
 					unsigned long delta)
 {
-	VMG_VMA_STATE(vmg, vmi, vma, vma, vma->vm_end, vma->vm_end + delta);
+	const bool can_merge = !vma_test_any(vma, VMA_PFNMAP_BIT,
+					   VMA_DONTEXPAND_BIT, VMA_MIXEDMAP_BIT) &&
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
+	VM_WARN_ON_ONCE(vma_test_any(vma, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT));
+	VM_WARN_ON_ONCE(!vma_test(vma, VMA_MIXEDMAP_BIT));
+	vma_prev(vmi); /* Reposition to start of VMA. */
+	vmg.target = vma;
+	if (vma_expand(&vmg))
+		return NULL;
+	return vma;
 }
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb)
-- 
2.53.0



