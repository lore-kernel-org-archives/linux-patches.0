Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6327915C158;
	Sun,  7 Sep 2025 20:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277136; cv=none; b=eR6JmvaDPsgLVp0YrNn+3aKdGbWGsxuu+PgRhtiq+secI20D7p7pfMUEgNyFpGLEC3kiISXjqkYhvNKPJ7+Wrk3iRQxrrTpP//CV0pyeov3FWW4IIG7h97xbkQ7yMIVWAo4QWX+YKSYnVzH9nCal2xddFSfTfWeduOItZoqRFK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277136; c=relaxed/simple;
	bh=GRVXnYNeIP6qDnU2DmDYy3OgRumlM3C7ndEK8Ev/6/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/48i9X/+EgEv1/pl/qUgj3tD4flTQyhgXk0X+HaBzmOboJ3tHH/TPocnLV4ScDVcR81hifFjdmA1NzeAQP8yDvtICM2Ajig9MaIWlqmA1ffnTK07Cx08UKo6FoQ3hzb9Phv8ZLS6PiHsAreTkK3ZqJhqHhMmL3Cy1KvcG3KRzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/Wo+8Vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/Wo+8Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D715C4CEF0;
	Sun,  7 Sep 2025 20:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277133;
	bh=GRVXnYNeIP6qDnU2DmDYy3OgRumlM3C7ndEK8Ev/6/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/Wo+8Vnf+v8+NEMeyHsbMKe9U6dMDGVwrKluClK38j2yZNuSk0pJW5C6cCm41Zap
	 h3fQd+M0KPCo6AMEi9UWNFCNixiFoDKfF1bSd3XJWlc7hSGMiifjAtF88X57kQRwtj
	 TMHtErphVFZiAJINrQbseKSfvIZ28HoEhxlmtnZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Yoo <harry.yoo@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
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
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 097/175] x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()
Date: Sun,  7 Sep 2025 21:58:12 +0200
Message-ID: <20250907195617.141179680@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo <harry.yoo@oracle.com>

commit 6659d027998083fbb6d42a165b0c90dc2e8ba989 upstream.

Define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to ensure
page tables are properly synchronized when calling p*d_populate_kernel().

For 5-level paging, synchronization is performed via
pgd_populate_kernel().  In 4-level paging, pgd_populate() is a no-op, so
synchronization is instead performed at the P4D level via
p4d_populate_kernel().

This fixes intermittent boot failures on systems using 4-level paging and
a large amount of persistent memory:

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

It also fixes a crash in vmemmap_set_pmd() caused by accessing vmemmap
before sync_global_pgds() [1]:

  BUG: unable to handle page fault for address: ffffeb3ff1200000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
  Tainted: [W]=WARN
  RIP: 0010:vmemmap_set_pmd+0xff/0x230
   <TASK>
   vmemmap_populate_hugepages+0x176/0x180
   vmemmap_populate+0x34/0x80
   __populate_section_memmap+0x41/0x90
   sparse_add_section+0x121/0x3e0
   __add_pages+0xba/0x150
   add_pages+0x1d/0x70
   memremap_pages+0x3dc/0x810
   devm_memremap_pages+0x1c/0x60
   xe_devm_add+0x8b/0x100 [xe]
   xe_tile_init_noalloc+0x6a/0x70 [xe]
   xe_device_probe+0x48c/0x740 [xe]
   [... snip ...]

Link: https://lkml.kernel.org/r/20250818020206.4517-4-harry.yoo@oracle.com
Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Closes: https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com [1]
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/pgtable_64_types.h |    3 +++
 arch/x86/mm/init_64.c                   |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -41,6 +41,9 @@ static inline bool pgtable_l5_enabled(vo
 #define pgtable_l5_enabled() 0
 #endif /* CONFIG_X86_5LEVEL */
 
+#define ARCH_PAGE_TABLE_SYNC_MASK \
+	(pgtable_l5_enabled() ? PGTBL_PGD_MODIFIED : PGTBL_P4D_MODIFIED)
+
 extern unsigned int pgdir_shift;
 extern unsigned int ptrs_per_p4d;
 
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -224,6 +224,24 @@ static void sync_global_pgds(unsigned lo
 }
 
 /*
+ * Make kernel mappings visible in all page tables in the system.
+ * This is necessary except when the init task populates kernel mappings
+ * during the boot process. In that case, all processes originating from
+ * the init task copies the kernel mappings, so there is no issue.
+ * Otherwise, missing synchronization could lead to kernel crashes due
+ * to missing page table entries for certain kernel mappings.
+ *
+ * Synchronization is performed at the top level, which is the PGD in
+ * 5-level paging systems. But in 4-level paging systems, however,
+ * pgd_populate() is a no-op, so synchronization is done at the P4D level.
+ * sync_global_pgds() handles this difference between paging levels.
+ */
+void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
+{
+	sync_global_pgds(start, end);
+}
+
+/*
  * NOTE: This function is marked __ref because it calls __init function
  * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
  */


