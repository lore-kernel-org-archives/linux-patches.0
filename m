Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585664;
	b=TxjYibOUB9CA2oSuQr5rTUXNng7XOOUEXyAWc0AeYxHo1TikBMVLzbqp+8Gri1/8Bi0u
	 b8jYUl3E3FqKKtyaeZMtM8glzGNxpXLmZMq26gFN5fY+sZN2VSmJHuLpqk+wh1NEpo/I6
	 pEpzncf8VfTzjY4RwyCjxL52r8wsRGOUL2YNy+IiEEe2Svqg6+aAwZo2cCYA+/VUZosgT
	 LQ84xCSFt6s1kY4h+INVX8OklMHOdUT90aXiFJdsxJQue32v8SsTQL90NTD6MLY5EYj+g
	 Iwvk39lcioyc9QXtlsBV2i1OS21RnCSE8gXPaBFX3FEaoVVZhGMUXzjJ21xcrKUgAqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lOM8xCswDmGaN1Osf2VExCNu9dYmLhXBpsV8YQKwKr8=;
	b=E1a8BGHPDhXrlPpEj54hoY9Ff3uK+QrZmpTJ0h1vDAAE/xTNb45HDRmbLe82tvQ3h6r4
	 lller8U8RKBd5ELTB2eww08i3YKcXJRAu2sFJgz+9Q6miE6RJox1XxIHDUmaOtwNT4stA
	 H0NKhwn77g0q+8qoGquG5QkU9CUqi8m1xxXku01/gqDrapGfO9pGyAk1un4NRSeq8RZrU
	 k5GOZecFgcTi3y7ewCQ2fPwo7lKQqq4R7Zw2pdtpbQVQpoAmIrGJ0c8+P+wKkvuCssdCZ
	 D2KnT1z7ugVzhPYBIpjavuD+FH6BzVgSmWglv/mw0DPTgaJk0hVocuTB54abVkfK5hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsp9+O8W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7179606B2E8;
	Fri, 13 Nov 2026 16:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsp9+O8W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303E31F000C5;
	Fri, 13 Nov 2026 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585664;
	bh=lOM8xCswDmGaN1Osf2VExCNu9dYmLhXBpsV8YQKwKr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsp9+O8W53Z26Q3NRL4v8G1rBtTU6AdtCnUz4BQSz8l9P6uC6gwEBhBjkTnar8vry
	 deTGN0Igh1p7iviQ2xuUU8TVz/btmzRO//EqoHoxNNqHQd4/fzPIE/qab5I1Pt+J1G
	 IvRIVbqHjiXxTnPMHf/0PcIaDVk08ghiiFyOlwQU=
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
Subject: [PATCH 7.3 236/507] mm/migrate: untag addresses when querying page nodes
Date: Fri, 13 Nov 2026 10:49:00 -0500
Message-ID: <20261113153802.498928104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 15b45832bcfa7..296f39a73d492 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2462,7 +2462,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
 		struct folio_walk fw;
 		struct folio *folio;
-- 
2.53.0



