Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1FE383C6A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302056; cv=none; b=ThdGEKEWWEzs2TBNccJ8IBqGdlLi6aCDF/AgWI1MrJn0+V0SLWYm00IusXP5OZgbU1zf9NkreUEdHdLJmDcpNiSwpYBzaUKRuLCX0xXcGCipVoBew9rqoo9uKeS6zh1Cm7N/uW8TeQ7Jf+RN7gMLCbM/i0S2K7DIozVlxW+SZ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302056; c=relaxed/simple;
	bh=xL8DLBm95JRmbvTjEu5Y8UwLbOL+CgKUQBKyb3vKajk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK0Xno2QO+B3qFxkizp/vLCFDNSS2NKFdquLPsXHYbdzZG2uY1lVd5nTyYekmMQyC88dTkxcnhcwRIqNRJ6RivOj5mGeFfELTfQkx986L8L97itFWnsKZvn3FLlmBk9NTXVZKcm3nR+kd5DrXQ7ZddHgdrRcH6+pi8e6y30BfFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DeJtTzVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DeJtTzVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9A1C19424;
	Sat, 28 Feb 2026 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302055;
	bh=xL8DLBm95JRmbvTjEu5Y8UwLbOL+CgKUQBKyb3vKajk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeJtTzVktPJgsVFceyjpPEAXTfwQV/iKVY2OTC/Zih74aAJOM+vBNzMIzHfFFxa5P
	 cdU5958j8jSNT5UDYmMx7Hh22Hv8NVydQN33AKuzoMayOj2Y8gsirSsuwqZXoXSSYL
	 l2liUvYs8wIkakh2ppgd7pYnnXEiGXn9GxoYUzVFY3BlwQ25/8ErPG/GQ4IjooEa9+
	 1SyO5SVLTxA0sYu3GhwFHjH+dLa6wkfcnPbbS96M+nptYkwh+1NZl3oZy/fGezB5Jq
	 Lodt0kvEy5PU2eY2zLUVZI1SV7qHlffwpG3qiqNuVkM5vlIZ1Pct+4bYhb3tm8v/Gn
	 mt8Ra5iBXmNVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/283] x86/xen: make some functions static
Date: Sat, 28 Feb 2026 13:02:53 -0500
Message-ID: <20260228180709.1583486-31-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 337c628ab74d1bbfe5377bbd8d31c858baf5fbc6 ]

Some functions and variables in arch/x86/xen are used locally only,
make them static.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <20240710093718.14552-2-jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: 0949c646d646 ("Partial revert "x86/xen: fix balloon target initialization for PVH dom0"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/mmu.h     |  4 ----
 arch/x86/xen/mmu_pv.c  | 11 ++++++-----
 arch/x86/xen/xen-ops.h |  1 -
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
index 6e4c6bd622033..11fa577af6b48 100644
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -17,10 +17,6 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 
 void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
-pte_t xen_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
-void  xen_ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
-				  pte_t *ptep, pte_t pte);
-
 unsigned long xen_read_cr2_direct(void);
 
 extern void xen_init_mmu_ops(void);
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 88a722954f3f7..23f30ca52816c 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -173,7 +173,7 @@ static int alloc_discontig_frames(unsigned int order)
  * looking at another vcpu's cr3 value, it should use this variable.
  */
 DEFINE_PER_CPU(unsigned long, xen_cr3);	 /* cr3 stored as physaddr */
-DEFINE_PER_CPU(unsigned long, xen_current_cr3);	 /* actual vcpu cr3 */
+static DEFINE_PER_CPU(unsigned long, xen_current_cr3);	/* actual vcpu cr3 */
 
 static phys_addr_t xen_pt_base, xen_pt_size __initdata;
 
@@ -350,16 +350,17 @@ static void xen_set_pte(pte_t *ptep, pte_t pteval)
 	__xen_set_pte(ptep, pteval);
 }
 
-pte_t xen_ptep_modify_prot_start(struct vm_area_struct *vma,
-				 unsigned long addr, pte_t *ptep)
+static pte_t xen_ptep_modify_prot_start(struct vm_area_struct *vma,
+					unsigned long addr, pte_t *ptep)
 {
 	/* Just return the pte as-is.  We preserve the bits on commit */
 	trace_xen_mmu_ptep_modify_prot_start(vma->vm_mm, addr, ptep, *ptep);
 	return *ptep;
 }
 
-void xen_ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
-				 pte_t *ptep, pte_t pte)
+static void xen_ptep_modify_prot_commit(struct vm_area_struct *vma,
+					unsigned long addr,
+					pte_t *ptep, pte_t pte)
 {
 	struct mmu_update u;
 
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 607f3a42fe3b1..af418489335cd 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -23,7 +23,6 @@ void xen_copy_trap_info(struct trap_info *traps);
 
 DECLARE_PER_CPU_ALIGNED(struct vcpu_info, xen_vcpu_info);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
-DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
 extern struct start_info *xen_start_info;
 extern struct shared_info xen_dummy_shared_info;
-- 
2.51.0

