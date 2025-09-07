Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4411F63CD;
	Sun,  7 Sep 2025 20:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277735; cv=none; b=Y51qFIgQGLwehElnqmwWH3waYLq1RM96RYPhBKDbU3Fgti0TEN4ljEKY2qQAw+8rkKRYbgUnHQjDuclHYfd4cSHGiFermb7oKXgmT8pchGy6V4t7Kj+oUWm+4pDZui0udJQnq//0lNLCHHu4Jm2xNEUrYZcx4BzZOYdV6Cbp9OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277735; c=relaxed/simple;
	bh=ruWDmjHHBrkickPoN0mPtKofWVIFIYB/e+9bINUBjFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqMUZexpRq3HqWSyvSYCBJVoOj+6WT5CUFP1Od/1S0URxXd7mrvgK6MjtyXIQNL9j3KdaUmpU4VpK+3qVL21Des91cLK1lfkuPgPWT+6kroHZ/iP8GDZ47f3xF+WdRZXWKWQkLRFxutifXXs9jgqARPYZfL4duCkktr/PbmNry4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrefEDJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrefEDJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C34DC4CEF0;
	Sun,  7 Sep 2025 20:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277735;
	bh=ruWDmjHHBrkickPoN0mPtKofWVIFIYB/e+9bINUBjFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrefEDJKk95Saw88wH5BqgvsJ1nnsoBSeqGwSS/nf9iG7UIcNEZmL+zHkSlsxRVNc
	 cCUzkfYNKkA/Hwvo2cj9NzFHL7sRe1Q7DzZeZldq+2OTO5eI0vzwSMTgkgaZQX3RMJ
	 0uGyQKSzwqsiifIN87DkAoLybvXLf/FwW+ErVmtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Yoo <harry.yoo@oracle.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	bibo mao <maobibo@loongson.cn>,
	Borislav Betkov <bp@alien8.de>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jane Chu <jane.chu@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <joro@8bytes.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Thomas Huth <thuth@redhat.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 106/183] mm: move page table sync declarations to linux/pgtable.h
Date: Sun,  7 Sep 2025 21:58:53 +0200
Message-ID: <20250907195618.309230196@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo <harry.yoo@oracle.com>

commit 7cc183f2e67d19b03ee5c13a6664b8c6cc37ff9d upstream.

During our internal testing, we started observing intermittent boot
failures when the machine uses 4-level paging and has a large amount of
persistent memory:

  BUG: unable to handle page fault for address: ffffe70000000034
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP NOPTI
  RIP: 0010:__init_single_page+0x9/0x6d
  Call Trace:
   <TASK>
   __init_zone_device_page+0x17/0x5d
   memmap_init_zone_device+0x154/0x1bb
   pagemap_range+0x2e0/0x40f
   memremap_pages+0x10b/0x2f0
   devm_memremap_pages+0x1e/0x60
   dev_dax_probe+0xce/0x2ec [device_dax]
   dax_bus_probe+0x6d/0xc9
   [... snip ...]
   </TASK>

It turns out that the kernel panics while initializing vmemmap (struct
page array) when the vmemmap region spans two PGD entries, because the new
PGD entry is only installed in init_mm.pgd, but not in the page tables of
other tasks.

And looking at __populate_section_memmap():
  if (vmemmap_can_optimize(altmap, pgmap))
          // does not sync top level page tables
          r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
  else
          // sync top level page tables in x86
          r = vmemmap_populate(start, end, nid, altmap);

In the normal path, vmemmap_populate() in arch/x86/mm/init_64.c
synchronizes the top level page table (See commit 9b861528a801 ("x86-64,
mem: Update all PGDs for direct mapping and vmemmap mapping changes")) so
that all tasks in the system can see the new vmemmap area.

However, when vmemmap_can_optimize() returns true, the optimized path
skips synchronization of top-level page tables.  This is because
vmemmap_populate_compound_pages() is implemented in core MM code, which
does not handle synchronization of the top-level page tables.  Instead,
the core MM has historically relied on each architecture to perform this
synchronization manually.

We're not the first party to encounter a crash caused by not-sync'd top
level page tables: earlier this year, Gwan-gyeong Mun attempted to address
the issue [1] [2] after hitting a kernel panic when x86 code accessed the
vmemmap area before the corresponding top-level entries were synced.  At
that time, the issue was believed to be triggered only when struct page
was enlarged for debugging purposes, and the patch did not get further
updates.

It turns out that current approach of relying on each arch to handle the
page table sync manually is fragile because 1) it's easy to forget to sync
the top level page table, and 2) it's also easy to overlook that the
kernel should not access the vmemmap and direct mapping areas before the
sync.

# The solution: Make page table sync more code robust and harder to miss

To address this, Dave Hansen suggested [3] [4] introducing
{pgd,p4d}_populate_kernel() for updating kernel portion of the page tables
and allow each architecture to explicitly perform synchronization when
installing top-level entries.  With this approach, we no longer need to
worry about missing the sync step, reducing the risk of future
regressions.

The new interface reuses existing ARCH_PAGE_TABLE_SYNC_MASK,
PGTBL_P*D_MODIFIED and arch_sync_kernel_mappings() facility used by
vmalloc and ioremap to synchronize page tables.

pgd_populate_kernel() looks like this:
static inline void pgd_populate_kernel(unsigned long addr, pgd_t *pgd,
                                       p4d_t *p4d)
{
        pgd_populate(&init_mm, pgd, p4d);
        if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
                arch_sync_kernel_mappings(addr, addr);
}

It is worth noting that vmalloc() and apply_to_range() carefully
synchronizes page tables by calling p*d_alloc_track() and
arch_sync_kernel_mappings(), and thus they are not affected by this patch
series.

This series was hugely inspired by Dave Hansen's suggestion and hence
added Suggested-by: Dave Hansen.

Cc stable because lack of this series opens the door to intermittent
boot failures.


This patch (of 3):

Move ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to
linux/pgtable.h so that they can be used outside of vmalloc and ioremap.

Link: https://lkml.kernel.org/r/20250818020206.4517-1-harry.yoo@oracle.com
Link: https://lkml.kernel.org/r/20250818020206.4517-2-harry.yoo@oracle.com
Link: https://lore.kernel.org/linux-mm/20250220064105.808339-1-gwan-gyeong.mun@intel.com [1]
Link: https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com [2]
Link: https://lore.kernel.org/linux-mm/d1da214c-53d3-45ac-a8b6-51821c5416e4@intel.com [3]
Link: https://lore.kernel.org/linux-mm/4d800744-7b88-41aa-9979-b245e8bf794b@intel.com  [4]
Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: bibo mao <maobibo@loongson.cn>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pgtable.h |   16 ++++++++++++++++
 include/linux/vmalloc.h |   16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1695,6 +1695,22 @@ static inline int pmd_protnone(pmd_t pmd
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+/*
+ * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
+ * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
+ * needs to be called.
+ */
+#ifndef ARCH_PAGE_TABLE_SYNC_MASK
+#define ARCH_PAGE_TABLE_SYNC_MASK 0
+#endif
+
+/*
+ * There is no default implementation for arch_sync_kernel_mappings(). It is
+ * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
+ * is 0.
+ */
+void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
+
 #endif /* CONFIG_MMU */
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -220,22 +220,6 @@ int vmap_pages_range(unsigned long addr,
 		     struct page **pages, unsigned int page_shift);
 
 /*
- * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
- * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
- * needs to be called.
- */
-#ifndef ARCH_PAGE_TABLE_SYNC_MASK
-#define ARCH_PAGE_TABLE_SYNC_MASK 0
-#endif
-
-/*
- * There is no default implementation for arch_sync_kernel_mappings(). It is
- * relied upon the compiler to optimize calls out if ARCH_PAGE_TABLE_SYNC_MASK
- * is 0.
- */
-void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
-
-/*
  *	Lowlevel-APIs (not for driver use!)
  */
 


