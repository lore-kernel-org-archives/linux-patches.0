Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590340;
	b=QHGTiRDYALh/NKH3VEgcIhonpiukV/ewGfki/hCkD50h7r8MBFr0a60DoB4MwNazI8dq
	 KoOOlrHHZzXmIsPoYhjnPldYinerNWlHMDiqeN/fsQpI2p3Er/kYxDNfcHWk35DYqOtvf
	 8smUrHhoqbb2uEmfNUZSctWUm5dRAab18ovD+XGvRNsg92BPgYv5PFl+hjva4rtq+znBa
	 7/jGLF2OJn7bAi7KbY723MwKvFHMOrGn41HLXDfO6XFXkBRidXQmbBvs+LfF/5Sk2kZRZ
	 2kGvCHofHIea9CyWoMxNPsrk+MTpcqbJ5/UYKCq4sGVVomNVmOCvAhtWQ6KfIdZNwHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LIb6RI7E9irOLXYiyX4xWMGJE9Pwy3qSogTFZh0D46Q=;
	b=e0fqZSJQdKvXw3FAjgvVjsL1cAuWzhRiqskrndlTk1dKVXh+MuAB9nrnGFheCIZjZnEb
	 qcRp0H/BaLI9+FTy4BhRxdmryMRHEgyUZx26Guf+IvmqDOU+87xqO91kcHAcCBp6z5dxR
	 s3WCm38urjJ0Ak4+SsaMRr4B1A3simdDJi1zB4qzEWe8lE1D6KrjW6OmsTXkvf6tiCx4Q
	 szF5/4K/rTr9LeBrTCQrCyng6DfD8ZtkDsGjTuznCS+Lk5YyfxgzKSvm7eSsgTIId42Rv
	 4OTLBCsfKiE7JLE6Ecn+mH0drPBycVGyGe0IRAxuRysqwRonSu3Hp+RvDHonR47/ASQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEjU2Fnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D592D6083141;
	Fri, 13 Nov 2026 17:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEjU2Fnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068591F000C6;
	Fri, 13 Nov 2026 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590340;
	bh=LIb6RI7E9irOLXYiyX4xWMGJE9Pwy3qSogTFZh0D46Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEjU2FnlnbSHSV9PsRb1V5ZVL+QPGk9nqehEsNUmmSqiNUW6oMMoztjBo3JaIHQrC
	 mdNcROpcBbpDSrrvKQ+5KWSUlr7NQRK7L5iqXu6yVmt6UAmCNMc/KTleA9hR2nsVGO
	 0zCO+vMmmKCT9YMDhfvwyq28CtQrLRSULYNzThn8=
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
Subject: [PATCH 6.18 317/686] mm/migrate: untag addresses when querying page nodes
Date: Fri, 13 Nov 2026 10:47:30 -0500
Message-ID: <20261113153831.681439329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 08f1382318024..0d2b327368073 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2448,7 +2448,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
 		struct folio_walk fw;
 		struct folio *folio;
-- 
2.53.0



