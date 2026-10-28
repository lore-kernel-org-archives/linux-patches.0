Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216705;
	b=RkLsYSyF4y+WQjPyoTgxFy2HfPgiOmnqMBTh3YhlPlXEvOzNbV4MH635hWpb3QNi4Wg9
	 jw0uYVDvRcnMio1PkYm7YxwhBEEzdEfxhwVjGodTzLaVUmxYVBW6qHy3Y81RLa0sMj6xe
	 LggGZyti59LPlle4vBWMJITjXBh3FmEkxNsQYsJvxLCZ/y8Kg7oZosCB2p0unVFqWSGyS
	 oSO0HS2KgnQ0Q8Pb4v88wTvhwHY/8HCcOY3Baw9jsPrtSAnHWg/niGq8bKlV/gquQbOa6
	 SygpKzF4Vzi9yTmOc9VywsZEyI6TA8J8heQaOpwRDETff5KpfxkoKbUKVhGtUEunBAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=urt70yWYOn2S4aLQaed4vyRtn+omh/rJ6TJLk6mxdOo=;
	b=JbQyCkxfkPxwn9AzsFYjZ3zFAW1bfGZCYBxuJ0HL8QZn2lW0+0yOG/8xQKq1grKDLbUZ
	 kyDS2EdsLXKxilM+lF9cP0Z3BHGJTNeUAiI0KLIh2CjrqoKP7S1ivzfI7Q7BWYdPsBlct
	 hhJXKpa4hW7p8NDR3qnoocgwC7jxB/6ARlh07JBvNeI54wSsDOhx2rvdkW1crdjA8gwMX
	 h/b3TTDZSH+QyGk+Ej4qZb2nqywd0qI4mSQNL30T99a0ZkI/e3iTRWyIX5bzFDxF+LD6m
	 K9QND9qtJD9m7hzf5ZdikgHpFgS5FOrD1DNEVxUetqffM3OM97wpE24ngMz0gFqyxxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7LFhcq7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64891606A31E;
	Wed, 28 Oct 2026 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7LFhcq7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B361F01825;
	Wed, 28 Oct 2026 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216705;
	bh=urt70yWYOn2S4aLQaed4vyRtn+omh/rJ6TJLk6mxdOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7LFhcq7SEW1Rtle09VeSd/bJO9H11P37hthtvIYeckzBcgBhDWbJEv6qvjfg9Viv
	 JCjpxBRT3EB5f+6YTWb3R8PfRZPSYhx8Tn2e0K93ukXyihnCjbGYN4uSDf3HK/Yekj
	 nq7jW1fnioWiRNt/bPoNrezPVym+a8B6kUhAMYmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1597/1887] misc: sgi-gru: remove interrupt-context page-table walks
Date: Wed, 28 Oct 2026 18:01:33 +0100
Message-ID: <20261028170535.812451757@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@arm.com>

[ Upstream commit 928a8e9f523df845fc496bcb9811013b67aabec5 ]

The GRU TLB miss handler walks a process's page tables without holding
page-table locks or a reference to the mapped page. It also uses a kernel
page-table accessor on user page tables and supports only PMD-level large
mappings on x86-64.

Remove the direct walker. Send interrupt faults directly to user polling
mode so the existing call-OS fallback retries them in process context.

Remove the mmap-lock failure statistic that can no longer be incremented.

Fixes: 142586409c8b ("GRU Driver: page faults & exceptions")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20260730111316.3672672-2-usama.anjum@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/sgi-gru/grufault.c  | 101 ++++---------------------------
 drivers/misc/sgi-gru/gruprocfs.c |   1 -
 drivers/misc/sgi-gru/grutables.h |   1 -
 3 files changed, 12 insertions(+), 91 deletions(-)

diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index b836936e97471..c2f38e650b66b 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -166,13 +166,8 @@ static void get_clear_fault_map(struct gru_state *gru,
 }
 
 /*
- * Atomic (interrupt context) & non-atomic (user context) functions to
- * convert a vaddr into a physical address. The size of the page
- * is returned in pageshift.
- * 	returns:
- * 		  0 - successful
- * 		< 0 - error code
- * 		  1 - (atomic only) try again in non-atomic context
+ * Convert a user virtual address to a physical address in process context.
+ * The size of the page is returned in pageshift.
  */
 static int non_atomic_pte_lookup(struct vm_area_struct *vma,
 				 unsigned long vaddr, int write,
@@ -192,87 +187,25 @@ static int non_atomic_pte_lookup(struct vm_area_struct *vma,
 	return 0;
 }
 
-/*
- * atomic_pte_lookup
- *
- * Convert a user virtual address to a physical address
- * Only supports Intel large pages (2MB only) on x86_64.
- *	ZZZ - hugepage support is incomplete
- *
- * NOTE: mmap_lock is already held on entry to this function. This
- * guarantees existence of the page tables.
- */
-static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
-	int write, unsigned long *paddr, int *pageshift)
-{
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
-	pmd_t *pmdp;
-	pte_t pte;
-
-	pgdp = pgd_offset(vma->vm_mm, vaddr);
-	if (unlikely(pgd_none(*pgdp)))
-		goto err;
-
-	p4dp = p4d_offset(pgdp, vaddr);
-	if (unlikely(p4d_none(*p4dp)))
-		goto err;
-
-	pudp = pud_offset(p4dp, vaddr);
-	if (unlikely(pud_none(*pudp)))
-		goto err;
-
-	pmdp = pmd_offset(pudp, vaddr);
-	if (unlikely(pmd_none(*pmdp)))
-		goto err;
-#ifdef CONFIG_X86_64
-	if (unlikely(pmd_large(*pmdp)))
-		pte = *(pte_t *) pmdp;
-	else
-#endif
-		pte = *pte_offset_kernel(pmdp, vaddr);
-
-	if (unlikely(!pte_present(pte) ||
-		     (write && (!pte_write(pte) || !pte_dirty(pte)))))
-		return 1;
-
-	*paddr = pte_pfn(pte) << PAGE_SHIFT;
-#ifdef CONFIG_HUGETLB_PAGE
-	*pageshift = is_vm_hugetlb_page(vma) ? HPAGE_SHIFT : PAGE_SHIFT;
-#else
-	*pageshift = PAGE_SHIFT;
-#endif
-	return 0;
-
-err:
-	return 1;
-}
-
 static int gru_vtop(struct gru_thread_state *gts, unsigned long vaddr,
 		    int write, int atomic, unsigned long *gpa, int *pageshift)
 {
 	struct mm_struct *mm = gts->ts_mm;
 	struct vm_area_struct *vma;
 	unsigned long paddr;
-	int ret, ps;
+	int ps;
 
 	vma = find_vma(mm, vaddr);
 	if (!vma)
 		goto inval;
 
-	/*
-	 * Atomic lookup is faster & usually works even if called in non-atomic
-	 * context.
-	 */
-	rmb();	/* Must/check ms_range_active before loading PTEs */
-	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &ps);
-	if (ret) {
-		if (atomic)
-			goto upm;
-		if (non_atomic_pte_lookup(vma, vaddr, write, &paddr, &ps))
-			goto inval;
-	}
+	if (atomic)
+		goto upm;
+
+	/* Order the caller's ms_range_active check before loading PTEs. */
+	rmb();
+	if (non_atomic_pte_lookup(vma, vaddr, write, &paddr, &ps))
+		goto inval;
 	if (is_gru_paddr(paddr))
 		goto inval;
 	paddr = paddr & ~((1UL << ps) - 1);
@@ -569,19 +502,9 @@ static irqreturn_t gru_intr(int chiplet, int blade)
 			continue;
 		}
 
-		/*
-		 * This is running in interrupt context. Trylock the mmap_lock.
-		 * If it fails, retry the fault in user context.
-		 */
+		/* Address translation may sleep, so retry the fault in user context. */
 		gts->ustats.fmm_tlbmiss++;
-		if (!gts->ts_force_cch_reload &&
-					mmap_read_trylock(gts->ts_mm)) {
-			gru_try_dropin(gru, gts, tfh, NULL);
-			mmap_read_unlock(gts->ts_mm);
-		} else {
-			tfh_user_polling_mode(tfh);
-			STAT(intr_mm_lock_failed);
-		}
+		tfh_user_polling_mode(tfh);
 	}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 97b8b38ab47df..b8139c27bc7f8 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -54,7 +54,6 @@ static int statistics_show(struct seq_file *s, void *p)
 	printstat(s, intr_cbr);
 	printstat(s, intr_tfh);
 	printstat(s, intr_spurious);
-	printstat(s, intr_mm_lock_failed);
 	printstat(s, call_os);
 	printstat(s, call_os_wait_queue);
 	printstat(s, user_flush_tlb);
diff --git a/drivers/misc/sgi-gru/grutables.h b/drivers/misc/sgi-gru/grutables.h
index 640daf1994df7..3348552925c61 100644
--- a/drivers/misc/sgi-gru/grutables.h
+++ b/drivers/misc/sgi-gru/grutables.h
@@ -182,7 +182,6 @@ struct gru_stats_s {
 	atomic_long_t intr_cbr;
 	atomic_long_t intr_tfh;
 	atomic_long_t intr_spurious;
-	atomic_long_t intr_mm_lock_failed;
 	atomic_long_t call_os;
 	atomic_long_t call_os_wait_queue;
 	atomic_long_t user_flush_tlb;
-- 
2.53.0



