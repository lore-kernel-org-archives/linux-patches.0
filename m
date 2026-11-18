Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059678;
	b=xqZLNBa9vwDC7WLhMRYsUZPbwD/C3iXa9wo3p6Thjaxqo2hnRKkMZ5ztuj4OSB90Hxgs
	 JpYwxGuTINnn81PWGhUNVZ34Dsuw+mAf/FwIpPTqeYgW4dX3lBduc85Nm1JBrs4m0TSLL
	 xKxmcp1Yi9XDFQ2hg8EalQ4uhpkPshwLzEzjSKk8NdJmjs9dYCVi/UaZfBcSRBrPQIrgo
	 21Z3+iijnlZo7Ac/xNhiZR2KYSjDvPrAMPSzaPvj6M6gY4Kq/3STiCssFD9TloRhpWu89
	 xWqqYg7koR53fL9MpAkHZNlMweYaETcdLzGL8Rb4FLAtdzeS82e0ze1VJBKO4jCWY8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V0aK7I8nwKrYOuw2Mp3II6yA1Uyqxvrspm9RUeUCQbw=;
	b=bn7Pr8E0MJWF+L6gKCGYu+R3GY/fRpEn9ZFbj17tlucldowzC8S2v+DHf+9vBGYeXu+B
	 M0zDUOXQMOoylQDj3pKOSiWTlIYm9aOn8LF3PWiz9FFHB9Ma10SfwCdhRzQAj5ZXLyprR
	 OyXOQ88EHJEyHuzjNo7yzjSropIGGuTxgKZIVCtz5C1oPwJGmmLC7PbwtUgtfKqAy8Uay
	 twanClJAxKgBBMo8FSaAPVd0KaoUvNgun9CsM0qMefu6cvxhU5L8DelrLWUE/LSVZdi+Y
	 Mf7wY67ywS4//VFfrbYELKVd/4aSYQf3a+cbxnPk2IldDUNffRfSelOLFBQgQjFXb+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7LXg4qv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D6B606A32A;
	Thu, 19 Nov 2026 03:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7LXg4qv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6AF1F000C4;
	Thu, 19 Nov 2026 03:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059677;
	bh=V0aK7I8nwKrYOuw2Mp3II6yA1Uyqxvrspm9RUeUCQbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7LXg4qvXjgTzXztRTcuuy5EeKY+KHIHavAk42QhqeeCzitiVYDYtPHTAtWQNhj/R
	 krib5zDhPUH28VnIvYcPENL5RYQJ2v5mUgWexYTsRaGn7g8BqNNl//D25VTthlOvkV
	 1R3ORD6EUD9IxXoPfhl3q6g2PSrIFboM031qiw7s=
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
Subject: [PATCH 5.10 0925/1848] mm/mlock: use a long for the page count in mlock_fixup()
Date: Wed, 18 Nov 2026 15:49:23 +0100
Message-ID: <20261118145955.517296259@linuxfoundation.org>
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
[ sashal: adjusted context to match the existing mlock_fixup() signature and local variable declarations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 884b1216da6a6..91b736be6d95f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -526,7 +526,7 @@ static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgoff_t pgoff;
-	int nr_pages;
+	long nr_pages;
 	int ret = 0;
 	int lock = !!(newflags & VM_LOCKED);
 	vm_flags_t old_flags = vma->vm_flags;
-- 
2.53.0



