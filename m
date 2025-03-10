Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAEF23237F;
	Mon, 10 Mar 2025 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628973; cv=none; b=VgbLfgrGd518Nh+e1tRTWaIF7/om9qHgS5PmMs9IPKrlAKdqnGbJVO88QA0f4EMeXE35aiwFonqQjYvYLi1s3bJDLbx0/uV/N5abuVza6Ns+4DFZQmJtZs06fIphOapGdt/evNaDkQ2tz2uHBE9GY/0TIGyAjWAWitLofqCcvuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628973; c=relaxed/simple;
	bh=ZutNzzngMgTAnYPLvdDbCB/QgNkQ5NJjjrpEEJsBed4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQb6IsEy5mKzpe2meYp4+BIsSyI08i6QFIwraHpTNDTY1svNtAVmOqxJxFbSPd+0/yYCzfH32GbojHQWJpYVn1i8OMw/c93B98z31e6kGSYdzj1yNisQmZFLyzzZgCKFNPwzdLwioC6hXfizvJGXTVYfxZebirt6S4YKsFUhcbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7SdPTpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7SdPTpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B4EC4CEE5;
	Mon, 10 Mar 2025 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628973;
	bh=ZutNzzngMgTAnYPLvdDbCB/QgNkQ5NJjjrpEEJsBed4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7SdPTpCZcijpAjyKXCjyHgTx4pJiwLWXz5SwA5bpf0evT0BMkcLF3/rBRdnvw8tx
	 6GRjeNDub6gLiWCIUnTmaXhuT7oOGhDdba1yUIUytoA6/PDBnQkd4/1JoCP2fjhx35
	 q4gPwgZZBxxk511XihH5xZmvbhoXLdYtJq7ldQqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rapoport <rppt@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/620] memblock: drop memblock_free_early_nid() and memblock_free_early()
Date: Mon, 10 Mar 2025 17:59:39 +0100
Message-ID: <20250310170550.849723265@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit fa27717110ae51b9b9013ced0b5143888257bb79 ]

memblock_free_early_nid() is unused and memblock_free_early() is an
alias for memblock_free().

Replace calls to memblock_free_early() with calls to memblock_free() and
remove memblock_free_early() and memblock_free_early_nid().

Link: https://lkml.kernel.org/r/20210930185031.18648-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 29091a52562b ("of: reserved-memory: Do not make kmemleak ignore freed address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/init.c                  |  2 +-
 arch/powerpc/platforms/pseries/svm.c |  3 +--
 arch/s390/kernel/smp.c               |  2 +-
 drivers/base/arch_numa.c             |  2 +-
 drivers/s390/char/sclp_early.c       |  2 +-
 include/linux/memblock.h             | 12 ------------
 kernel/dma/swiotlb.c                 |  2 +-
 lib/cpumask.c                        |  2 +-
 mm/percpu.c                          |  8 ++++----
 mm/sparse.c                          |  2 +-
 10 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 833fcfc20b103..81fda8c583ae1 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -527,7 +527,7 @@ static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size,
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_free_early(__pa(ptr), size);
+	memblock_free(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
diff --git a/arch/powerpc/platforms/pseries/svm.c b/arch/powerpc/platforms/pseries/svm.c
index 87f001b4c4e4f..f12229ce73014 100644
--- a/arch/powerpc/platforms/pseries/svm.c
+++ b/arch/powerpc/platforms/pseries/svm.c
@@ -56,8 +56,7 @@ void __init svm_swiotlb_init(void)
 		return;
 
 
-	memblock_free_early(__pa(vstart),
-			    PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+	memblock_free(__pa(vstart), PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	panic("SVM: Cannot allocate SWIOTLB buffer");
 }
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 48f67a69d119b..5c1fd147591cb 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -875,7 +875,7 @@ void __init smp_detect_cpus(void)
 
 	/* Add CPUs present at boot */
 	__smp_rescan_cpus(info, true);
-	memblock_free_early((unsigned long)info, sizeof(*info));
+	memblock_free((unsigned long)info, sizeof(*info));
 }
 
 /*
diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
index bce0902dccb40..6d4a955847140 100644
--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -165,7 +165,7 @@ static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size,
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
-	memblock_free_early(__pa(ptr), size);
+	memblock_free(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index f3d5c7f4c13d2..f01d942e1c1df 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -139,7 +139,7 @@ int __init sclp_early_get_core_info(struct sclp_core_info *info)
 	}
 	sclp_fill_core_info(info, sccb);
 out:
-	memblock_free_early((unsigned long)sccb, length);
+	memblock_free((unsigned long)sccb, length);
 	return rc;
 }
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 307cab05d67ec..41f95cf22cb81 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -442,18 +442,6 @@ static inline void *memblock_alloc_node(phys_addr_t size,
 				      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
 }
 
-static inline void memblock_free_early(phys_addr_t base,
-					      phys_addr_t size)
-{
-	memblock_free(base, size);
-}
-
-static inline void memblock_free_early_nid(phys_addr_t base,
-						  phys_addr_t size, int nid)
-{
-	memblock_free(base, size);
-}
-
 static inline void memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
 	__memblock_free_late(base, size);
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 5c7ed5d519424..59d44d8f6161d 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -247,7 +247,7 @@ swiotlb_init(int verbose)
 	return;
 
 fail_free_mem:
-	memblock_free_early(__pa(tlb), bytes);
+	memblock_free(__pa(tlb), bytes);
 fail:
 	pr_warn("Cannot allocate buffer");
 }
diff --git a/lib/cpumask.c b/lib/cpumask.c
index c3c76b8333846..045779446a18d 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -188,7 +188,7 @@ EXPORT_SYMBOL(free_cpumask_var);
  */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
-	memblock_free_early(__pa(mask), cpumask_size());
+	memblock_free(__pa(mask), cpumask_size());
 }
 #endif
 
diff --git a/mm/percpu.c b/mm/percpu.c
index e0a986818903d..f58318cb04c02 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -2472,7 +2472,7 @@ struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
  */
 void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
 {
-	memblock_free_early(__pa(ai), ai->__ai_size);
+	memblock_free(__pa(ai), ai->__ai_size);
 }
 
 /**
@@ -3134,7 +3134,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)
-		memblock_free_early(__pa(areas), areas_size);
+		memblock_free(__pa(areas), areas_size);
 	return rc;
 }
 #endif /* BUILD_EMBED_FIRST_CHUNK */
@@ -3256,7 +3256,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
 		free_fn(page_address(pages[j]), PAGE_SIZE);
 	rc = -ENOMEM;
 out_free_ar:
-	memblock_free_early(__pa(pages), pages_size);
+	memblock_free(__pa(pages), pages_size);
 	pcpu_free_alloc_info(ai);
 	return rc;
 }
@@ -3286,7 +3286,7 @@ static void * __init pcpu_dfl_fc_alloc(unsigned int cpu, size_t size,
 
 static void __init pcpu_dfl_fc_free(void *ptr, size_t size)
 {
-	memblock_free_early(__pa(ptr), size);
+	memblock_free(__pa(ptr), size);
 }
 
 void __init setup_per_cpu_areas(void)
diff --git a/mm/sparse.c b/mm/sparse.c
index 27092badd15bd..df9f8459043ef 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -451,7 +451,7 @@ static void *sparsemap_buf_end __meminitdata;
 static inline void __meminit sparse_buffer_free(unsigned long size)
 {
 	WARN_ON(!sparsemap_buf || size == 0);
-	memblock_free_early(__pa(sparsemap_buf), size);
+	memblock_free(__pa(sparsemap_buf), size);
 }
 
 static void __init sparse_buffer_init(unsigned long size, int nid)
-- 
2.39.5



