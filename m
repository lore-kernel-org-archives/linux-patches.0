Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037666;
	b=s3tLcl8/CygjFMbVAprpmcWc5aXN0FK130mEJID0W0ULEAiezPIQ9r2w2BLeNrsNVv3v
	 cX1Rv9IiJfWD4X4REhsNIcH9NCZw0vI28Upw6m9fyAWRCIcm07XxfAr295P1nGuYoL380
	 VcliNt0+1r5DWUwwvlclvmL4QcNH7TkvLWj5C6VAOiflBRzkajxp9dW6FGHOGSdQP8vPT
	 LI9ytPzwCYzMkvuCQUmubsGTJL5M1PKH4Pg4Bs6csm+dBfzlu43c5dvdzNUObsO16LK4r
	 qbQzSX0uVxf5DU8PqWw5d/aN14b4C1NZ3rl1+HJdjKwj6Ij8qvwSjTcwJPSxylSudDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ajCzYYqkNAIixsgUslquJyZoTynRQqCaRvB6Ru5eZnY=;
	b=DZkMriEimrsTp30FyisOqGQ+X/9u8tYn9AKKZb2z5OFhDnTlPyevBJrdZIMgc2MFMkrU
	 5k/N5NL8eBTvoyhQw+TpmdwBsnHtfyIkGxkjjju/TViIJITuQOKAZDm/jrKy+n2OK5FVn
	 KvR2O+JfUcYK7E1esr5Fr16L5sUDKPN+DjsNWNTPEJ54zRzCFwdIvipVx+59MUA/9qqGM
	 kixC9dQaDZzUBBQ0+V0SEQkcqzPv6VSAJ8G8nPrOYItqanCnOHcZH/wAMVMwyjOXqeGBG
	 vCERn1JZcraHiG3Pf9lXTuX6hCn83y7JEWyP2OPHO3y/52Qxd3S+bDawuUvZyCYM+kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkhfFkhk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE685606A330;
	Wed, 18 Nov 2026 21:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkhfFkhk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA631F000C4;
	Wed, 18 Nov 2026 21:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037666;
	bh=ajCzYYqkNAIixsgUslquJyZoTynRQqCaRvB6Ru5eZnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkhfFkhkc5U4NUD1MVVKtVE74fsCIe0qSTmSL6lsbrRj6VzI4APAeCjcAS5pq41v3
	 9OW/RatGqELNJX3d/d2uMwc3Zv/Q9RtoODg8VF2leZeLkKCTmyJ1yDhFn3SAHu22pP
	 +zQvrxSqV33Lr0Sh0oWrVYQJds6s8kNAlzoh9xJQ=
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
Subject: [PATCH 6.6 1478/3318] mm/migrate: untag addresses when querying page nodes
Date: Wed, 18 Nov 2026 15:35:00 +0100
Message-ID: <20261118150405.244549679@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 7d8746d7dc9cc4003661011424e5880ea7ae364b ]

When move_pages() is used with nodes == NULL, do_pages_stat_array() passes
each page address directly to vma_lookup().  A valid tagged address
therefore fails the VMA lookup and gets -EFAULT in its status entry,
instead of the node reported for the corresponding untagged address.

The tagged address ABI permits these pointers, and the migration path
already removes their tags.  Apply the target mm's untagging rules to the
query path as well, while holding its mmap read lock.

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
index 9ee07f7080cf8..0b8c4fe36c714 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2291,7 +2291,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
 		struct page *page;
 		int err = -EFAULT;
-- 
2.53.0



