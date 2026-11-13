Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591135;
	b=oYn+LFHhs33eaTwVxF21N8ICV+MU1Oa0Z3TVThZs822FjlQ42u93tOa4+19cQgi2/y82
	 HP04c3le+woMMouaCKAm12gxDEZpnEafesMnIz8nGfYhD+W7HN++0Jt3RGGhJ0fXqncos
	 1jzv6U6rgbyjyO1efDpY+hBMv0dsAMosxLacn1pAA6A1oPQY3GzEjh6RcWjWVVrbxVnrY
	 YVzGqOqPrglxctOBm8mq41zKyqOG7TqXkalH8vYv0C4qQJg4PtuuLOd5lgmTiplpqy4F1
	 gttDzcSwQHDiAxg9cUKxGDhZ7C/SKCCHxJ7O4Oxfd06+r8M00zh0cMwDjCd6qiXaP6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aiqKE9BF3ph39VvdVw3bnxpCF3eb3tU0uxkp3+3uBN0=;
	b=1pvcPhDbgQape5p7AUSU29G/vHanFPjCgb4LVGYxwA1s0Koxk/j/2o75lBPmzyWA7Y+p
	 4IoT4YqOLz7z2C2N2RJbiXGxfwYF8xhmcR9N2w0pI/r+bSIYgsGivfudvrI/EPcLPjlf5
	 PDoYD3De+76hHQ4HmEL6OeK60vhDtTxX8unGTJrSgHrbLhMEc58YJMAT01bjmT+ibbyuP
	 POntVcl3EhsB1xu3ydBUc1tbQ9iwn/gcXpMe86FbfpAsEqx0TtAWTzwaYXoThtv7i9sAJ
	 ISkqdOl6Xy7AFOfTJnLD/Qv+ymQqTUVljMtcrA24ccmoFuZkGgeiKTrQXY5ekCLrd4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtix5PYU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87117606A88C;
	Fri, 13 Nov 2026 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtix5PYU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219BC1F000C7;
	Fri, 13 Nov 2026 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591135;
	bh=aiqKE9BF3ph39VvdVw3bnxpCF3eb3tU0uxkp3+3uBN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtix5PYUW+qXvF7Fl4hV7hX2uhWdV7ZbVo7B9FrkNqrPbW5VjS3IXAl17KHJBSNxg
	 RG72KpwMmp73+mCKd2ksBCr8yOYfs1VQqFcJZxm5u1pfVrAQJ2bvLjOxYbcdC6L3kG
	 WKJfgKbRoi7pK2verM4W+4LYAPOOJyMf3q5oqT3A=
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
Subject: [PATCH 6.12 281/670] mm/migrate: untag addresses when querying page nodes
Date: Fri, 13 Nov 2026 10:47:25 -0500
Message-ID: <20261113153821.404218461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e07a098671cea..5711d721425fa 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2411,7 +2411,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
 		struct folio_walk fw;
 		struct folio *folio;
-- 
2.53.0



