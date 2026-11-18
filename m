Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047065;
	b=EEZD5+RHNKOmjycRaMLmANKBPGQtHivXn5yZELdHSTaYZjS82SsPfkj2dR3EB7663cCU
	 aBMOnC3tkibsQRiSIIneRU3fhvf83igSfhPNdd4t1nypkWxnvEw+LXZWUT/IRHZfNvm3w
	 ZDx2TfPsKifadomEq1mGkSfLlfxOp290ICJcSkjwLiAPde33xLvTlHWEPBgNDqZG+3QIg
	 MLn9iwb0p0h3LQTP67xFDJZNa4vhAFryq4LHAH9x1kJ3YaUmAPwb/K8L9UAh3wor5uGgR
	 XYZhoteyqeMZXiaeMyG6k6AUAC6IB/+KZEon9H1n9lNgwMSIzHAGbljOYLylfxicDAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K0VS3WLR5ly1dqBLPPp9oPWgfMEqyl+cSUh4/gzoOf0=;
	b=dMbDodcr4r7eHX1czc4lwviL5LteSAY3URiBblN1c+o69T77iyN6YGsxx8ZqiYS6uLaW
	 g4+S3q+V1uCnydgDQL089L8mI77pdmOcIlM6lmaydlJwPA7pv31kOAZhv+ILxW2yDMnoK
	 c8JqqzYBukAZpwPQZ2LlcEtH08/kRQtDPuswmgHSZBrog7JiLCKxrS/7GxmvREk4v/ye0
	 5NVzgjlbMu+Yo0Iw6+LtcGO3oSoGFae7blqO4SKyKVpdk7RP1opusOjIDm9nlLoopDTRH
	 87HSg8SAJRw3HSqayhmsecFqlRDFTLfz0Yaq0eAWJUtUryuXkcVzlJMnerlBe8VIO5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWrhcup0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511AB606A31C;
	Thu, 19 Nov 2026 00:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWrhcup0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D331F000C4;
	Thu, 19 Nov 2026 00:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047065;
	bh=K0VS3WLR5ly1dqBLPPp9oPWgfMEqyl+cSUh4/gzoOf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWrhcup0TkdcjtTNVD+Be2szpNiW9FbL1D+xHZq2MTIdJFvyZGUcIcF+bJOuFyMfB
	 AtaywJiCuaGDrQ4SnGDUUNUr80GJU5K3SOAmBrg9l4XD5IqpbiyUlszjvJTKpTS7aH
	 uQ8AMXIusee/QGCn6UbEhh4qNVYSpOOqV53kUoHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1503/2857] mm/mlock: use a long for the page count in mlock_fixup()
Date: Wed, 18 Nov 2026 15:42:17 +0100
Message-ID: <20261118150255.453026947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 3ae91e3079b1504ef162b2884454d5f1421f4eb9 ]

mlock_fixup() adjusts mm->locked_vm, an unsigned long, by the number of
pages whose VM_LOCKED state it changes, but computes that number in an
int:

	int nr_pages;
	...
	nr_pages = (end - start) >> PAGE_SHIFT;
	...
	mm->locked_vm += nr_pages;

When a single VMA range of 2^31 pages (8 TiB with 4 KiB pages) or more
is locked or unlocked, the count is truncated to 32 bits and then
sign-extended, so locked_vm is changed by the wrong amount, while
munmap(), mremap() and the other paths that maintain locked_vm use the
full unsigned long page count.

Such a range is reachable on 64-bit architectures with a 47-bit or
larger user address space (x86_64, arm64 with 48-bit VA, riscv64 Sv48)
by a task with CAP_IPC_LOCK or a raised RLIMIT_MEMLOCK, which do_mlock()
checks against the full untruncated length.  It costs nothing with
MAP_NORESERVE and MLOCK_ONFAULT/MCL_ONFAULT, since then no page is
populated.  On x86_64, after

	p = mmap(NULL, 8UL << 40, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
	mlock2(p, 8UL << 40, MLOCK_ONFAULT);

VmLck in /proc/self/status reads 18446744065119617024 kB instead of
8589934592 kB; munmap() of the region then subtracts the true size and
leaves VmLck at 18446744056529682432 kB instead of 0.  With 16 TiB,
locked_vm is not changed at all, VmLck stays 0 kB, and after the task
drops CAP_IPC_LOCK or lowers RLIMIT_MEMLOCK, mlock(), mmap(MAP_LOCKED)
and the other mlock_future_ok() and account_locked_vm() users enforce
RLIMIT_MEMLOCK against that count, so they let the task lock memory
beyond its limit (or, in the 8 TiB case, refuse every further lock).
The error persists for the life of the mm; unlocking the range in pieces
skews it further.  The wrong count is per-mm accounting only: it does
not change which pages are locked.

The int has been there since before git history (the variable was named
"pages" until it was renamed in 2.6.28); every other updater of
locked_vm uses an unsigned long or long count.  Make nr_pages a long,
which holds the page count of any user range and its negation, so the
existing sign handling is unchanged.

Found by formal verification of mm/mlock.c against the kernel binary.

Link: https://lore.kernel.org/20261014131358.780240-1-nickolai@csail.mit.edu
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Assisted-by: LLM
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
[ sashal: adjusted context for the older mlock_fixup() signature and local variable declarations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 0124022f0f379..8fa8e871ccbf8 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -406,7 +406,7 @@ static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgoff_t pgoff;
-	int nr_pages;
+	long nr_pages;
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
 
-- 
2.53.0



