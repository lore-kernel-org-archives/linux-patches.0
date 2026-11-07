Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061554;
	b=RMN9sdniDNb7FROSJVN1ZrPxMX6BmlI9Gtg7rz5qIQORUdq65E32Xdej+KRY0E2gkCtT
	 hHOWaoIZIGCw35Rqxonn/i1RgnSAhfSzBvaCMaQlJnxCHsGIBQL/B5Q4QCda0Ap51LD8r
	 Ls9sMcFkx6lMcHRleRKRllBAADP9ph5MqBy9OP7+rgqnio9A9zhpMnY7oNICRvLY1/aAs
	 JqC70Tc8xdz6uzAUezdcKtyb9kjeT5fprDTAgKTeVdh351SUpgLEwwW8kDGREg4b2Kn03
	 tOjUQdGo5/KTxUFeoqZ63rJxH1NWUIAHjV9VT8szXIWvH5KBx651vGCLwJlwI2VQ2Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8LHDuwWVYhpvpet+nAiEXOjoBOwb3i/9EMdJcpxu9kA=;
	b=U9UPmuESBb1O7prGTet6JN6eFaTLDJFQ61knLrzOCAGSQuJb/hyuGAtjzLjQpUa+sK3/
	 mE2kOuXdg0ZNMnWPm795kNICN5RA4C8sTsJnYHqwsHamr8LUQTbpc3+wqpFV+o+nXGxDN
	 5HgWty6VJWAXY7Ke8E90YVZ9gMtGNGXnthjVY/Sxhvc4VwaId4wTaBZcn85VNlmG5Eg+Q
	 fwh/jBvrgHHFJswsorV2pknvilj1aiwrYkMD7EEp8pk/iL1HwEzC9EaW6CNv8fLxWW4sB
	 FtPb11RXzKiwUHsBjhl9rbN1VYDxKtuZtRg9zLFDXMK/Lkq2eZF6p+J1Vbj2Xq3355Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2OLczNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D6E606A326;
	Sat,  7 Nov 2026 14:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2OLczNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F7E1F0089F;
	Sat,  7 Nov 2026 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061554;
	bh=8LHDuwWVYhpvpet+nAiEXOjoBOwb3i/9EMdJcpxu9kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2OLczNH5X2zMjnoETMFI1MMta+mXFUWIHm+1bKxIe5rmbeGLlhqFMtz4hbk6TBEf
	 gwNioZEE9rci4PJiAHKCdm6Jb2ibAjLcu6b4KAzCQ0gVOe1j88Z9OtHGU+sxjyXab8
	 cpk3VKbgLzgDGOjVlyzb8u3fWN5HYT1sjklQ2WhU=
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
Subject: [PATCH 6.12 0637/1536] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
Date: Sat,  7 Nov 2026 08:44:13 -0500
Message-ID: <20261107135015.425536315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -2862,15 +2862,18 @@ static long do_pagemap_scan(struct mm_st
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
@@ -2925,6 +2928,8 @@ static long do_pagemap_scan(struct mm_st
 		ret = -EFAULT;
 
 	kfree(p.vec_buf);
+out_mmput:
+	mmput(mm);
 	return ret;
 }
 


