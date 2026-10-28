Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213849;
	b=h4lrhLa1cskS6KvzOkX6+CDpbcSESNtbiLm1PIiSP8Ru2+4Yy/N8qKchFmvItxZzyOdQ
	 jibTwrlBD8Cy9SY9z9dQ/YE/+6qMCph54iPHzKm9iBbmQsASdrXg8HKpykfUOtWJCYHsW
	 vFb8zDYBnH1cbjgS/KNM1kRk2SEGNf/zujLe5dCWROKbQEJaR2myRUgxSEsinlugGDvNV
	 IpRdiC0t840CA33XHTKyMJeOezQjI0xWn8ZKyPEVGs+HnJlohvqHKHobHRXWrqzlFpXCL
	 pCOJqQpcI88CsT/zjMT1RHWTbeYNOTIqTeG8mMNfP8M1WVXaUOOQYAVQomzqTPs1Zfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yaJq9NdDEcvjiKGUISjuI3uadDfLyJD0FvA1qvyB6Z4=;
	b=s4OAF5KPclJUO9fnG3S9XI6Gv5lTrujn+k/s7ZSoAAh+oXurR2kIaG2HUH5BKXzllC48
	 BykCxN4L4oBKuzscLomr5BwsDcuKvhLN7x5gx4OvePn3Hf2xxOgYFQgwBq09WcwGhz6+4
	 BEiLng3+cE0R2K/Tgyi44r18BOThBBBsZX+QCyLl5/fozUhXQ7DGWzhhTnm07ydyGftEg
	 zEc/KfKc2g23ZalGJBJwM+zIN2orx76/bshQqoF8tdQy+t2Vx4+n3UN69Mx58kN3m/R35
	 zAOSdMAnt6y7LZQHhn9hr0+kIIiikHnKGeG57QEKJB/Qz4fAROx2xIfciSRtCZEp6hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WhXm+B44;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A77606A31E;
	Wed, 28 Oct 2026 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WhXm+B44
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22331F031E2;
	Wed, 28 Oct 2026 18:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213849;
	bh=yaJq9NdDEcvjiKGUISjuI3uadDfLyJD0FvA1qvyB6Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhXm+B44AWoJb5HIXC1p3k+o5sTpkw25yu6MNC24YyxFRT7TvTRZ5bH/lXVtFSf9/
	 P+/tvDilQonasVC8QYG8hrV+BXlBfu/nhtrnPPr4dZ7jibJYXounIDn8G9aoruvXgZ
	 DAh8dUjo9SJlemtUH3htgu6eN/cfaM5idKpwAzzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Pavel Emelyanov <xemul@virtuozzo.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0651/1887] userfaultfd: fix checks for huge PMDs
Date: Wed, 28 Oct 2026 17:45:47 +0100
Message-ID: <20261028170514.225556825@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

[ Upstream commit 71c186efc1b2cf1aeabfeff3b9bd5ac4c5ac14d8 ]

Patch series "userfaultfd: fix races around pmd_trans_huge() check", v2.

The pmd_trans_huge() code in mfill_atomic() is wrong in three different
ways depending on kernel version:

1. The pmd_trans_huge() check is racy and can lead to a BUG_ON() (if you hit
   the right two race windows) - I've tested this in a kernel build with
   some extra mdelay() calls. See the commit message for a description
   of the race scenario.
   On older kernels (before 6.5), I think the same bug can even
   theoretically lead to accessing transhuge page contents as a page table
   if you hit the right 5 narrow race windows (I haven't tested this case).
2. As pointed out by Qi Zheng, pmd_trans_huge() is not sufficient for
   detecting PMDs that don't point to page tables.
   On older kernels (before 6.5), you'd just have to win a single fairly
   wide race to hit this.
   I've tested this on 6.1 stable by racing migration (with a mdelay()
   patched into try_to_migrate()) against UFFDIO_ZEROPAGE - on my x86
   VM, that causes a kernel oops in ptlock_ptr().
3. On newer kernels (>=6.5), for shmem mappings, khugepaged is allowed
   to yank page tables out from under us (though I haven't tested that),
   so I think the BUG_ON() checks in mfill_atomic() are just wrong.

I decided to write two separate fixes for these (one fix for bugs 1+2, one
fix for bug 3), so that the first fix can be backported to kernels
affected by bugs 1+2.

This patch (of 2):

This fixes two issues.

I discovered that the following race can occur:

  mfill_atomic                other thread
  ============                ============
                              <zap PMD>
  pmdp_get_lockless() [reads none pmd]
  <bail if trans_huge>
  <if none:>
                              <pagefault creates transhuge zeropage>
    __pte_alloc [no-op]
                              <zap PMD>
  <bail if pmd_trans_huge(*dst_pmd)>
  BUG_ON(pmd_none(*dst_pmd))

I have experimentally verified this in a kernel with extra mdelay() calls;
the BUG_ON(pmd_none(*dst_pmd)) triggers.

On kernels newer than commit 0d940a9b270b ("mm/pgtable: allow
pte_offset_map[_lock]() to fail"), this can't lead to anything worse than
a BUG_ON(), since the page table access helpers are actually designed to
deal with page tables concurrently disappearing; but on older kernels
(<=6.4), I think we could probably theoretically race past the two
BUG_ON() checks and end up treating a hugepage as a page table.

The second issue is that, as Qi Zheng pointed out, there are other types
of huge PMDs that pmd_trans_huge() can't catch: devmap PMDs and swap PMDs
(in particular, migration PMDs).

On <=6.4, this is worse than the first issue: If mfill_atomic() runs on a
PMD that contains a migration entry (which just requires winning a single,
fairly wide race), it will pass the PMD to pte_offset_map_lock(), which
assumes that the PMD points to a page table.

Breakage follows: First, the kernel tries to take the PTE lock (which will
crash or maybe worse if there is no "struct page" for the address bits in
the migration entry PMD - I think at least on X86 there usually is no
corresponding "struct page" thanks to the PTE inversion mitigation, amd64
looks different).

If that didn't crash, the kernel would next try to write a PTE into what
it wrongly thinks is a page table.

As part of fixing these issues, get rid of the check for pmd_trans_huge()
before __pte_alloc() - that's redundant, we're going to have to check for
that after the __pte_alloc() anyway.

Backport note: pmdp_get_lockless() is pmd_read_atomic() in older kernels.

Link: https://lkml.kernel.org/r/20240813-uffd-thp-flip-fix-v2-0-5efa61078a41@google.com
Link: https://lkml.kernel.org/r/20240813-uffd-thp-flip-fix-v2-1-5efa61078a41@google.com
Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 992a0a16846f7..998c7075c62a5 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -642,21 +642,23 @@ static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
 		}
 
 		dst_pmdval = pmd_read_atomic(dst_pmd);
-		/*
-		 * If the dst_pmd is mapped as THP don't
-		 * override it and just be strict.
-		 */
-		if (unlikely(pmd_trans_huge(dst_pmdval))) {
-			err = -EEXIST;
-			break;
-		}
 		if (unlikely(pmd_none(dst_pmdval)) &&
 		    unlikely(__pte_alloc(dst_mm, dst_pmd))) {
 			err = -ENOMEM;
 			break;
 		}
-		/* If an huge pmd materialized from under us fail */
-		if (unlikely(pmd_trans_huge(*dst_pmd))) {
+		dst_pmdval = pmd_read_atomic(dst_pmd);
+		/*
+		 * If the dst_pmd is THP don't override it and just be strict.
+		 * (This includes the case where the PMD used to be THP and
+		 * changed back to none after __pte_alloc().)
+		 */
+		if (unlikely(!pmd_present(dst_pmdval) || pmd_trans_huge(dst_pmdval) ||
+			     pmd_devmap(dst_pmdval))) {
+			err = -EEXIST;
+			break;
+		}
+		if (unlikely(pmd_bad(dst_pmdval))) {
 			err = -EFAULT;
 			break;
 		}
-- 
2.53.0



