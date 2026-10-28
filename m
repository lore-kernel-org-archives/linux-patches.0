Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215649;
	b=bUfEJ386tkGp+QdJXk2O9zokNcolXXG9YnFAI01GG+pMpb9u9q4n38/j6p5OIO4DwdUc
	 EwKcbtwCsbf33F6OngHvhTI3QW6n5qMcJ978SNm0iofEyHORFaeeA+dZuWyVSB1e8BA7/
	 dayTYklCkHVLa63JVFY20qjUUpztgk1m0kZ2Cxzxln9VQ4SNCoYJqwVpgb5MvZafce1hM
	 Mb/aP26xcMDIi5ap2JFkL0Z0M5Gu3wkT2OTrYK0SLTbAtw6lr7yB5jE1XMeQIEWxWamHh
	 xyKrzD/QyBEeHpxvPZkraEbaYqoPdudC9wvD0yXOGnf+yl9ohu1z2wc5gs7Gf975QYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xFqVStGc5i/PGt5hF8xFMM2OIKTtCWVfDBJFjGproO4=;
	b=3YVRmvFdLKmKXf72GDPmzrctwVDBOiDJdK4D+rm4Ik026mcTEEQAF0hjgd5rl1t6fNwO
	 VAlTcOFDgpZe9t+rLk2TYchWGyBwurhKJ3Pyk1EwYelQPQyw52lg/ZMz03VJCq3n+Y2F0
	 msGHkUXgriHaE4QuVqN0V1ofV6HeIh0WbkFwQCXnlgMTj+afjJbjy+agDsGZij/LoAkbw
	 QjLlPeIdQpAaG3nMSlFRjzX/YqmblNyq34M3LhlyQGHgS4iJzEpNwPN9jy4ssxOTrdBxm
	 DCKQKV9kfdkVSrk3hWGi38UIKiV98rYHzloPumsizdZ9/ucwmqqOptIDvoYAsYfbKRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhfY07Nu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E437606A31A;
	Wed, 28 Oct 2026 19:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhfY07Nu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5016B1F01825;
	Wed, 28 Oct 2026 19:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215648;
	bh=xFqVStGc5i/PGt5hF8xFMM2OIKTtCWVfDBJFjGproO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhfY07NuUGGLXy3YrBDo5fdR9/B6FnzMM4sUbb9klkbX9JKF5SvpsT346MSd19q2q
	 ++POffsrheAsf7hvKeQkHBatpx50awNHglj74HAwY2iE4giOTB+FaNdRtektqt1Ydk
	 uemt6yCmo/vLSWDgYHgeQs8hSjwJGmECM7wLSRsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Carlier <devnexen@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1285/1887] mm/ptdump: always stabilise against page table freeing using init_mm
Date: Wed, 28 Oct 2026 17:56:21 +0100
Message-ID: <20261028170528.668913599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 27c32e5538344b13c1505a08861e04620c125d47 ]

Previous commits have established the invariant that kernel page table
freeing is performed while an mmap read lock on init_mm is held, which
fixes races between ptdump and kernel page table freeing over init_mm.

However, x86 and arm64 can perform a ptdump over an mm other than init_mm
via ptdump_walk_pgd() and since kernel memory ranges are shared across
non-kernel mm's, this means that the race still exists for these cases.

Fix this by acquiring a nested mmap write lock for init_mm in
ptdump_walk_pgd().

This is safe as we take this after mmap write locking the mm, and nothing
acquires the init_mm lock first before locking an arbitrary mm, so no
deadlock is possible.

Also update walk_page_range_debug() to assert that init_mm is write
locked, add a comment explaining why and remove some redundant code, and
eliminate the unnecessary and confusing invocation of
walk_kernel_page_table_range().

We can safely remove the non-NULL check for walk.mm, as the mmap lock
asserts would NULL pointer deref if it was (and of course no callers do
this).

The first point at which ptdump can race kernel page table freeing is
commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
table"), so we target this in the Fixes tag.

Link: https://lore.kernel.org/20260723-series-vmap-race-fix-v6-4-8cc77dcc0018@kernel.org
Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/pagewalk.c | 8 ++++++++
 mm/ptdump.c   | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 09df5b12aef73..9c3eae516130b 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -523,6 +523,14 @@ int walk_page_range_novma(struct mm_struct *mm, unsigned long start,
 	 * to account for page table freeing on vmap huge page mapping.
 	 */
 	mmap_assert_write_locked(walk.mm);
+	/*
+	 * x86, arm64 ptdump allow walks of efi mm's and x86 ptdump allows walks
+	 * of arbitrary mm's.
+	 *
+	 * However, they both must also hold the init_mm lock to account for
+	 * concurrent kernel page table freeing.
+	 */
+	mmap_assert_write_locked(&init_mm);
 
 	return walk_pgd_range(start, end, &walk);
 }
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 8e29b90d6bc39..4c6cbbaf833fa 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -154,11 +154,18 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 
 	get_online_mems();
 	mmap_write_lock(mm);
+	/* To stabilise kernel page tables we must hold the init_mm lock too. */
+	if (mm != &init_mm)
+		mmap_write_lock_nested(&init_mm, SINGLE_DEPTH_NESTING);
+
 	while (range->start != range->end) {
 		walk_page_range_novma(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
+
+	if (mm != &init_mm)
+		mmap_write_unlock(&init_mm);
 	mmap_write_unlock(mm);
 	put_online_mems();
 
-- 
2.53.0



