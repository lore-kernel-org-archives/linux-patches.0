Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063628;
	b=U1HCYrmNF8dFlZEjC6I6iKrC39Ot/G8ybtwj/M9ZOYBtQsYi588kyMZuAtdKJrCiLIWg
	 kejKhh+YQCsBoWx+uc6h0fcAHS4T3GZPALwbtZosi9XFBReuoRvrA1z42pgMtdnhlQRs9
	 C5J7L4ecJ7kRwYWpChBknUWsjPiPPWPmWzJL79c2nZ9ahflCaIWC8XOe4IN/tVJjjwRpx
	 k/l0LieIAaZpIiNFp0NRLZchmm4mwybwnAgJKiGutW8Wtv1YAEIVCFgsnU16NhOrUDhy5
	 pWl0/+OmrPjCkgrh5CO5oL7BYflxiMtveBaWGfQ4L6FF/Cii+53ncZtF8u6q03VGMXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=urEFFS20i0U9xunhWuC3HCoszz+xGRxAXsxdSCBfH4I=;
	b=VYGKVI/6AUduJCEFHk1e6jrx/Q5Yk3HYd1cy/ULnrXkPCf/YxzpbEivGxjSJLP5tuqMq
	 A/suWy+oTLyjgHmWgNnDkxg5NL6nFPj1nlcXmz6e60JA7c45eVFBdtbs45JHGNf5rzHDi
	 X45tChgT87BE8SGUgR0E0Xuq5DwfEm5PZQwgmvSE8dkaq0J+DjHwOyihNZpCCBjPeN5xq
	 JQC0oG/tt+2/3DJAkt/k40BzxfXJEO06Dv1YS4z1DXAXDQPUsictFeGxULh1KmxEl7O47
	 muMh1292y3U5aVQflNb+9Tfy7uUmxH83W8F+oY3ugEqpCPpyC621qe5OCy2waQa13lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFAOvrES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438E4606A333;
	Sat,  7 Nov 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFAOvrES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDE61F0089F;
	Sat,  7 Nov 2026 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063628;
	bh=urEFFS20i0U9xunhWuC3HCoszz+xGRxAXsxdSCBfH4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFAOvrESmFLJsx0Za+gnWzN4s6Ke2yH+Op+N6G0ZTkHSooX+95YNqWkwDhuQRe6mt
	 AcO7awzG/psIKuOSS7pciHEq5/6j5bV5Xwm7aO/BfLPnT4vK7rVKkB5ixM1wq6OUGU
	 6TxrscnkvYU4x6qDLVQHimp9+7vzKYhJcZtGXrJ4=
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
Subject: [PATCH 6.18 746/869] mm/mlock: use a long for the page count in mlock_fixup()
Date: Sat,  7 Nov 2026 08:57:08 -0500
Message-ID: <20261107134918.076876967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 31045f17766a7..20061dd281502 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -468,7 +468,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long end, vm_flags_t newflags)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	int nr_pages;
+	long nr_pages;
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
 
-- 
2.53.0



