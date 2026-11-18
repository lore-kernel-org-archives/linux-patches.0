Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038324;
	b=hLinSSSGXVWFejzIJnI8XlB4qoYRRPU+0R28kf6OY6nnzTjHAbFkgHi4UFTE/fxzl8SB
	 l4997O13ye9Lc2eBNvX8emvOFbALX/LPaYGWqQkhcM0gvBJ8Pr6Qp3/PKDRm8aLf+mrZN
	 WD+i5WJpRf9o74XgbRuGlpkoGp6OXHYNoSVqzoeDpqq1gES9N227jkO2g9VWYfOkMaU3X
	 fuc/MtWdxokb4ciolobHpXuUTKXvFZKw8Xml7fSCDg80b8AAxS5Q81nQBWiYuOa252QGI
	 iy4KE83n+Vkj/dxoyYxGIXREKdtH0W3qz3z+JXTC7Tv3KknQx+oGzQgKxvClFJZG70Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKEhpL1XHl3WpZIypYLt0WvZMAzkA4Y1UWdGDubEZnw=;
	b=M1f+V3eytMiZ3H8gi2ro04gozgRCXFKjZOp0uAfN07yzmG1Am5+j1pIFIFBzBc3JQxGW
	 U7B8jjd+ADUamvrBo+5m9CRxIqhByp4hpR2jEnhvPllCg453JR88UOv2AJCQW+WcTQJ1U
	 REp5CIdbN8aVfPZ8x32QK7b242FXI8p1PhBaVVIEXlAAhYNKRqZvQ3Owr9okdtq098xTZ
	 UpMsHzA6O6LNIl/R9VtkpuO4+Q6qkdvXYEOvLPOMYldnWqncbnlYrJ8QX0+tIST3fvSr1
	 mGldlo6my61XDltojDEBmfMD2R+UPFd91NUY4AYGKVQw7AMz79yKhh005llhuXyZF8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwaPUWma;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DD3606A325;
	Wed, 18 Nov 2026 21:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwaPUWma
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3151F000C4;
	Wed, 18 Nov 2026 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038323;
	bh=cKEhpL1XHl3WpZIypYLt0WvZMAzkA4Y1UWdGDubEZnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwaPUWmaG/bJGLcHiWMwnS9QsVS2qEM5jvinIiJWFr/UKYBjfFtDER22H1tF2ZvrH
	 wAE2FFCUUrHiuZsofwit05t80IDSmaGJwBIl/0ZLp5Gs7UXTdm9RPHL3SjaAcs0Sjk
	 exCM3h4ABuZmYbfUzRoH9jz9+pHg0x0uWhDnyfvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Rik van Riel <riel@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1705/3318] mm: disallow ioremaping ordinary RAM in generic_access_phys()
Date: Wed, 18 Nov 2026 15:38:47 +0100
Message-ID: <20261118150413.007723159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 4590752e20aa393cc0d4fe538c0747d14a98c97a ]

generic_access_phys() can end up getting called on CoW PFNMAP mappings,
resulting in it trying to ioremap anonymous folios, which especially
the x86 code doesn't enjoy, and which is in general just odd/wrong.

E.g., with a CoW mapping of a PCI BAR:

ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
  WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
  Call Trace:
   generic_access_phys+0x130/0x4d0 mm/memory.c:7178
   kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
   __access_remote_vm+0x58f/0x890 mm/memory.c:7256
   mem_rw+0x2a1/0x670 fs/proc/base.c:912

But more generically, we should disallow access to anything that looks
like ordinary RAM in the system: including allocating memory (e.g.,
alloc_pages) and mapping them in a VM_PFNMAP.

For pages with an online memmap, allow only pages marked as reserved
(PageReserved). This also includes memblock allocations, however,
distinguishing them from other MMIO is tricky, and nobody should really
be mapping them in a PFNMAP (except someone abusing /dev/mem, which we
do not care about).

So only allow access if there is no online memmap, or if the pages are
marked reserved. Reject other pages with -EINVAL.

Note that, just like other pfn_to_online_page() users, we won't care about
concurrent memory offlining; mapping memory that can concurrently get
offlined is highly dubious.

Link: https://lore.kernel.org/20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org
Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
Reported-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Closes: https://lore.kernel.org/r/20261001152524.171115-1-ngocthang2710.1999@gmail.com/
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted PFN access and cleanup to the existing follow_pte() API using pte_pfn(pte) and pte_unmap_unlock(ptep, ptl). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 6d4a1032ca61a..8376b7c768831 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5757,6 +5757,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	resource_size_t phys_addr;
 	unsigned long prot = 0;
 	void __iomem *maddr;
+	struct page *page;
 	pte_t *ptep, pte;
 	spinlock_t *ptl;
 	int offset = offset_in_page(addr);
@@ -5769,6 +5770,19 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
 		return -EINVAL;
 	pte = ptep_get(ptep);
+
+	/*
+	 * Reject anything that looks like ordinary RAM, including anonymous
+	 * folios in CoW mappings or allocated kernel memory. Note that we
+	 * cannot distinguish memblock allocations from non-RAM reliably, so
+	 * we cannot easily reject them here.
+	 */
+	page = pfn_to_online_page(pte_pfn(pte));
+	if (page && !PageReserved(page)) {
+		pte_unmap_unlock(ptep, ptl);
+		return -EINVAL;
+	}
+
 	pte_unmap_unlock(ptep, ptl);
 
 	prot = pgprot_val(pte_pgprot(pte));
-- 
2.53.0



