Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831534;
	b=ilLvKu4ILWVCBzbrTxjGCT50Mv7UxwqoijzqruNwhlLvyKlz5mS+CXEr+6vdSJYqXgvM
	 kE2mUsd/px9HSjWdyRdyty0b19z7A4W0f8YE/OhTihkmdz3tPUsu+auKgeK1TyPyTNg1f
	 +li89n4Z8TWZY8inzq/X54o+f6ObpfmKwOxidIE4pF8KpslGUH8NDeMryVN4ZfRDZQB9D
	 +P1we/S+UHpYuK0PvMiVftpcKdEgDUXfYEmpuYFI7/kvmFa0UQ+xusy3VhiRqv5mmYP71
	 PP65lOqzthdMIM6PIZKnMDA6JYBxSMt7ls9kjSoSxoCamzbet7uNop7ZgTpYYw+7xMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMOs9EAY3mqEhBbphhDrDKMepW+3vak+E79BeZDl5LI=;
	b=x+QYmmt/MonIcnlEXPTOAgvm5iwpzirKzazoivFRs13NAQgM5hyy1oNzZIvxQck6r4oE
	 46o5SptXBjRNqf6pnPInybFTJx+xhku/7EsUOLkf5qtNJWz4zCnpAnDl0TcWRu1tNsCl5
	 h4F10EZy2Xhx3P0WEcvsaLGL6narW+EYLbBHzbVoxlsI5AyRKwZF3cDLOEdAgb4HgpNZQ
	 HoNyCpK1pJjCye8m6yZGpKYYhJKNMoydij9kafgNaWXZOAfCS8fmJIZBWWae0600UUBEZ
	 ehRRdxxPmGBlodzsgSb+DJ6m5lZEALe+TF6UFT7PJHT6XdHKI5GO9ZaXMYpD+I4nYGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQBqubiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1635D606A334;
	Wed,  4 Nov 2026 22:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQBqubiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA481F000C1;
	Wed,  4 Nov 2026 22:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831533;
	bh=EMOs9EAY3mqEhBbphhDrDKMepW+3vak+E79BeZDl5LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQBqubiOKYS2OIUlMlvCIxKWMTA2C2phScS0e9mkxM9MeV+zos19lCxlxiA37KfAi
	 w+zJ8EES++Ty0DEi0Dj3lN/TmB9o8A5mEleVfw1xQ8hz8vCpmWeWEA+r2tWUCy0zUO
	 GMr15cbFIbdYXhqI3BDksaSLGSTZm2cS0UenRoXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ngoc Quy <ngocquy0700@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 6.18 0713/1005] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
Date: Wed,  4 Nov 2026 16:07:26 -0500
Message-ID: <20261104211103.523143926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Ngoc Quy <ngocquy0700@gmail.com>

commit 4fb975471717c953f912776bb60301add1ffae11 upstream.

The PAGEMAP_SCAN ioctl takes mmap_read_lock() on an mm obtained from
/proc/<pid>/pagemap without holding a reference to mm_users.

proc_mem_open() deliberately grabs only mm_count, so a consumer that
touches the address space has to call mmget_not_zero() first.  Every other
consumer in this file does -- m_start(), do_procmap_query(),
show_smaps_rollup() and pagemap_read() -- but do_pagemap_scan() does not.

Without that reference the target can reach exit_mmap() concurrently, and
exit_mmap() calls unmap_vmas() while holding mmap_lock only for reading,
which does not exclude the scanner.  For ordinary VMAs this is harmless,
as free_pgtables() and remove_vma() run afterwards under mmap_write_lock.
A shared hugetlb VMA is different: __hugetlb_zap_end() frees the VMA's
hugetlb_vma_lock inside the read-locked phase.

walk_hugetlb_range() can therefore load vma->vm_private_data, have the
lock freed underneath it, and then down_read() a freed rw_semaphore.  The
load happens before the freeing side clears the pointer, so this is a
use-after-free and not a NULL dereference.  Any unprivileged user can
reach it with no huge pages configured, as hugetlb_reserve_pages()
allocates the lock before the VM_NORESERVE early return.

Pin mm_users across the scan, the way the other consumers do.  mmput()
from the exiting task can then no longer reach exit_mmap() while a walk is
in progress.

[akpm@linux-foundation.org: remove unneeded & undesirable test for !mm]
Link: https://lore.kernel.org/20261014095540.3261469-1-ngocquy0700@gmail.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Ngoc Quy <ngocquy0700@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3098,15 +3098,18 @@ static long do_pagemap_scan(struct mm_st
 	size_t n_ranges_out = 0;
 	int ret;
 
+	if (!mmget_not_zero(mm))
+		return -ESRCH;
+
 	ret = pagemap_scan_get_args(&p.arg, uarg);
 	if (ret)
-		return ret;
+		goto out_mmput;
 
 	p.masks_of_interest = p.arg.category_mask | p.arg.category_anyof_mask |
 			      p.arg.return_mask;
 	ret = pagemap_scan_init_bounce_buffer(&p);
 	if (ret)
-		return ret;
+		goto out_mmput;
 
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
@@ -3161,6 +3164,8 @@ static long do_pagemap_scan(struct mm_st
 		ret = -EFAULT;
 
 	kfree(p.vec_buf);
+out_mmput:
+	mmput(mm);
 	return ret;
 }
 


