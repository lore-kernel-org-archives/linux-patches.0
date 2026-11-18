Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053864;
	b=Dsjs2SU+l1If/33w4W7T/5Da1Hffa6Zi+lJjS5da0MDKrSBpbtkF7LG0FEzthgaN4rmJ
	 Dy67O6BOuliNwHkTG4wFsN+UU61JVDgPl6GXHIrZvMYhY/h35pB4DFd0b5OP3U9dlV0I6
	 1Q2+z6A8TM4+Zg9Ptw+K/J3JczvhjgwNtYZ4FgFjKV7fGJwjiaAxHbrf/IlymyurNmBQO
	 SeA80F0UOioHUTNYgkzUJsp9dgADp0SDuTV66q7YoMDKH9Ca4NUiSSY3B/M/19bnfs69f
	 7A4rwHBWn+FG50C/syNL0Axbu3pPmP/29aZ4SC/pD401qLfhWE16Z00UbeWEwetqcLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZSpmTPK52f/s54O72ozawmeYXNZs5osY8XGH5sleCY=;
	b=QOmXsYE+zcslBR6d0W+p9r39Lbs2dE/1bESaja+XXtI+7ojLOsueaiOU6Wvd3VfrU+Ap
	 M9BslDkR3DRvKeUbWUdgGzzzztPjXzL+tSagKXcsCHv7s5Aw2tlc4kygJKipwX8mgFzp5
	 IYBdROICcGy5r3zbRMkJ0sI6xWUqjJfDPdmDR1Ih4DmlhVztSyxt08rzhVahSNFb8sou+
	 zakv/9DWJSLix9QrdgtLoBEbiav0Lp1ZHc+XgJjgItpUqc12C3Jgvo+UM4X5RHo/KT8CO
	 qwfckwcdJObDvoa+pimglQRej+VplL9jEjvyiYT6HVzlytK3yYthATJiOoq5yNW2xjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKg6nIDg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF66606A32C;
	Thu, 19 Nov 2026 02:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKg6nIDg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418861F000C6;
	Thu, 19 Nov 2026 02:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053863;
	bh=KZSpmTPK52f/s54O72ozawmeYXNZs5osY8XGH5sleCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKg6nIDgPC3YUhH2QUr4F45QICw7OhVewIkkKCNbRQouuD2Xtwu/s2HROWWUJLo1A
	 fr2srd+Dv6aUdTkS13Mo3fUaITR0/rnEmmKutLlnvxLW0Iz3Unxy7IahvflR1DIvZv
	 JycnVn5GKMn6A/XYO9f2WbeRPpjKoSEmNSE9f0xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	odys.yuan@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1029/2214] mm/migrate: untag addresses when querying page nodes
Date: Wed, 18 Nov 2026 15:45:05 +0100
Message-ID: <20261118150053.496539689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 7d8746d7dc9cc4003661011424e5880ea7ae364b ]

When move_pages() is used with nodes == NULL, do_pages_stat_array()
uses each page address as-is for its VMA lookup. A valid tagged address
therefore gets -EFAULT in its status entry instead of the NUMA node
reported for the corresponding untagged address.

Strip the tag before the VMA lookup while holding the mmap read lock.
Use untagged_addr(), the helper available in 5.15 and already used by
the migration path.

Link: https://lore.kernel.org/20261026195330.46757-1-dennylin0707@gmail.com
Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.org
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <odys.yuan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 728fbb0b90245..cea35108bf95a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1889,7 +1889,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr(*pages);
 		struct vm_area_struct *vma;
 		struct page *page;
 		int err = -EFAULT;
-- 
2.53.0



