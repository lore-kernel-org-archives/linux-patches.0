Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059644;
	b=NnXi5CCJTLN98Qv6uNwMR0OvzwRUaKi9OdSsp5YPlDMFtZjlwXNkHjvpSgWp2Yxiprm4
	 YpoJIAPBsmJ4CL7a/ToDtCNoBus+5qyVzjFK3sQGhhSAAN4PHtdz5B30hQ4wXmxYAlJV5
	 +gKU2p7hIFnbZj+1QouZHaNRWN4kZZQ23ArxAMc1NM+uQT7rckLU0oK+r9q37eW9LMESO
	 8PDQt5gBvlFN44Y6vhFwR6Y6FvDFyBzYq9aUOXzT5QxlA+aNKo3Jx1XVL7uzhqAUeUHgK
	 ZwrvMyAjIHgIxlgRWprc0F0jnt6/9XNNCVHO/MDcAFFi0JFpqFhS16ooUl0VE4EKMaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utFAmo5tgIN0TX9ynwm0CHhW1YmUyv6qjW5CPM7ibJ8=;
	b=EOWYU+YGIgQgmlu7W/2U1Xe1Vq4Z0pnwxbLVlPQYQT4cxJ19UziKwT3syC1EZFjcHNur
	 gaycLMZdUEs3yrZEPfW2ofb7dozWajDcwMH1kExrph0cSNRuyO2N2A6yrKdHqRS7NbrSG
	 BUQrI5g4XxdGQJA8CR46tZAXlKcsadUi2VSqbudvd/2R/hoVDlqUi5K2px03v/JJQFGDS
	 rBbwC4/YB9N69Yu0RJyPJbBtqKMaS0XsjVopODjUv/smbN6VotkUpBOmM44qGVYqI1xSN
	 BYN253rGQSAUUj/lIMYtXYS7QCohAgGfpj1eA0ta9Qyfem0N77Z9I3BBIyGUZgYNRwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b3u47ufi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B570560A6F75;
	Thu, 19 Nov 2026 03:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b3u47ufi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79E51F000C4;
	Thu, 19 Nov 2026 03:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059644;
	bh=utFAmo5tgIN0TX9ynwm0CHhW1YmUyv6qjW5CPM7ibJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3u47ufiRfHzbGZ2N+8S/haEWZam5M2uJck+tSNfjSxD2SqSSqsyfxYTfxSYn9maJ
	 2EhcN2/CFncOF+2bWikApX8yRF1lAJ7DkFu5QdMyECReJToSyh6NqdLu0CQEQ3hnKE
	 8d+1Z2JbVE9FVGgrPZkyvvoSQ3ZCQhOnf97vtu2w=
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
Subject: [PATCH 5.10 0888/1848] mm: disallow ioremaping ordinary RAM in generic_access_phys()
Date: Wed, 18 Nov 2026 15:48:46 +0100
Message-ID: <20261118145953.690852280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted follow_pfnmap_start()/end() handling to follow_phys(), deriving the PFN from phys_addr after the PTE lock is released ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 403fcef10bdac..ad8184041a75b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4985,11 +4985,22 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	resource_size_t phys_addr;
 	unsigned long prot = 0;
 	void __iomem *maddr;
+	struct page *page;
 	int offset = addr & (PAGE_SIZE-1);
 
 	if (follow_phys(vma, addr, write, &prot, &phys_addr))
 		return -EINVAL;
 
+	/*
+	 * Reject anything that looks like ordinary RAM, including anonymous
+	 * folios in CoW mappings or allocated kernel memory. Note that we
+	 * cannot distinguish memblock allocations from non-RAM reliably, so
+	 * we cannot easily reject them here.
+	 */
+	page = pfn_to_online_page(phys_addr >> PAGE_SHIFT);
+	if (page && !PageReserved(page))
+		return -EINVAL;
+
 	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
 	if (!maddr)
 		return -ENOMEM;
-- 
2.53.0



