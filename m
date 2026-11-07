Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065330;
	b=FWxgVgccHk+D/xuSTSUmLqBeIEmTT1UbdEiiQtKQjYTHvHJ2HzS2dqf7t39RcZX4vmKz
	 3Vp3L2DFT6pY8KHDqVgpwFKAaYxJs/C18Y+J37GrpnDL14kRJy1wCZSkcb8XRpMtnLrj7
	 C+PHZibAsZ1yi3nQrtMAqm8/Rk9xZyrrDYPGf2o43xuk8YGbAUB15gh5iDBvmK8T3iehO
	 UZC+D+BzSr/iidOJ6Xhc+/u1MeHzww/XXoGtPOfSQY5/N5CTDkVZhytdE+wDg4zFcvSZb
	 9xEXR6GWdEAHKbYxjlajOJ4lWL7YvHYjnGpeflHhfsgCLikwajT6iSV6tp/XgyC7b/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lJepvyNFRslW2gbG34q0wRJfs+56UuzFc1WduljReBc=;
	b=ADdeIvvZFUW64UcM6qYITlaExexjslmpiV4HEFusqibnQBbBcRZVwaK/R3XQX6YhR1xs
	 XvbDIIyLOCeZx9z4r+eoVnvz87DBLyrdmuPmAtsfVl3v4Z1pA7sdnBb46TQ6AiMe4KTis
	 F8lGvu052RuCMhX6YgVtXN/51mp0yxEKJRD/9lejrXacNKBH/tZskIXWTosVuGrokbYIj
	 wQN+ARsBRMsK4Kr87sXy1lldNnJUCUoFye8ItO3iRsoFzC808Q1KEWhv5fkdpnX3NVyMR
	 nDfuPGd2T2jT19BKTGiGNkm1lOuWKSKS8SowYmwp3xPoA/M22j2cIV/t8vUFb+W4nmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i3uaZK3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5157606A32C;
	Sat,  7 Nov 2026 15:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3uaZK3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AC31F0089F;
	Sat,  7 Nov 2026 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065329;
	bh=lJepvyNFRslW2gbG34q0wRJfs+56UuzFc1WduljReBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3uaZK3/rsyREpTjkIBzzZkonm1HyFn5so404LtSnZzHp40Nidghw0kmF6BFtMmSB
	 PnshS9WXYGr/M3GJz9Xo2w6ov0w1J1L0YnPMhTQGl4dys1Y1jwL6P7tdeIdvb7obWm
	 z5QCimPxFOb5SLg1GIn4uawEEWajy5PPrfsvJ/jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <mason@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1070/1257] mm/hugetlb: fix endless write fault on a leftover uffd bit
Date: Sat,  7 Nov 2026 08:56:06 -0500
Message-ID: <20261107135008.823065620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f61e1cf15fb44f9cf89d43d8ef01f926322bb1c4 ]

hugetlb_fault() resolves the uffd bit on a write fault only if the VMA is
registered for userfaultfd write protection, and hugetlb_wp() bails out
for any entry with the uffd bit set assuming hugetlb_fault() has already
resolved it.

When a read-only hugetlb entry with the uffd bit set is mapped in a VMA
that is not registered for uffd-wp, a write fault to it never makes
progress. If the access comes from the kernel, e.g. read(2) from
/dev/zero into such page, the task spins in the page fault handler,
ignores SIGKILL and keeps holding the locks taken by the system call.

Such entries should not exist, but an unprivileged user can create them,
for example with MADV_DONTNEED of a page protected with UFFDIO_RWPROTECT
or with UFFDIO_COPY in MODE_WP racing with UFFDIO_UNREGISTER.

Clear the uffd bit when the VMA is not registered for uffd-wp and let the
fault proceed to hugetlb_wp(), like do_wp_page() does for regular pages.

Note that a FOLL_FORCE write to a page protected with UFFDIO_RWPROTECT in
a private VMA that was made PROT_NONE now drops the RWP protection of
that page.

Original fix generated by an LLM and sent in private by Josef.

[rppt@kernel.org: massage commit message]
[david@kernel.org: convert comment into a TODO]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-6-42796911043b@kernel.org
Fixes: 60d5b473d61b ("mm/hugetlb: fix uffd wr-protection for CoW optimization path")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fb7205c703b3f..81e6c98d21a4e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6190,15 +6190,19 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_ptl;
 
 	/* Handle userfault-wp first, before trying to lock more pages */
-	if (userfaultfd_wp(vma) && huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
+	if (huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
-		if (!userfaultfd_wp_async(vma)) {
+		if (userfaultfd_wp(vma) && !userfaultfd_wp_async(vma)) {
 			spin_unlock(vmf.ptl);
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return handle_userfault(&vmf, VM_UFFD_WP);
 		}
 
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
 		vmf.orig_pte = huge_pte_clear_uffd(vmf.orig_pte);
 		set_huge_pte_at(mm, vmf.address, vmf.pte, vmf.orig_pte,
 				huge_page_size(hstate_vma(vma)));
-- 
2.53.0



