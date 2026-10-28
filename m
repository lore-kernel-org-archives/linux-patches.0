Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214293;
	b=aUOw4FSo0uDnPffSDKizuvuwqbgNQp9587mQGtQ86vZQJFqbDIHbGIwTpnZ7Kf8Geg3Q
	 TMTGwy/s7O4z3V5d48KsLWx1PK/exTHMoZM1FRHm68WdGcLEjCbaG4moRSSuu+xKauzuO
	 hpslFKUTAQJBq3wwHE1rGpJ/OGOm2G6xCsDm5E90xOlNa+2MaA9kqQXs0QLHu5kFusGoj
	 3cqnOJ+24kNZgl/sdEke/tZw/x6pGwqbm8EgOPAsQb/g7fcJUqROJcUa0DlbKCG2GfA8B
	 6Qh97UbBLwXCWIMaWrgdHIvawdyaONnKluszpSouMU1hbsb7+/Z61+YwQaQFNl7C+Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=05azj9idyjjymGs/Z2up30U4FiFi3yTTm6QeUYViD10=;
	b=4sNEmzocMwyndXRgB8lwPboPXw8JGGSGh71vJjOR9ueKUiT5wTDdnLD400GYO4fpi2zZ
	 9p9F0o/5HQiSflFUaymOhI6Cm7NzisLLL1FlFmIXzfAv3xmTZurZ6mFbQLfLGV8JNpWbb
	 Q22CAMRrv+p8sPLXy+eSBKsOefWqR+sRX5di+kXSXAbLVl2EW/8HqEqpe515ZhiT3mBIc
	 +yYuVobb6HuyWFRaic8tMoQYySOhS4wgEzBSaU5dXSSH0rqX4LW/3t/CiCO//qNQ8CVT/
	 9E763Oqyqf/plNPaz7RvzIDwjVIq6Wv/5WI30xHXBFRLXj8gnF6DAjBPTLJzE4NaCIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1B+KzzKS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A580860A2603;
	Wed, 28 Oct 2026 19:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1B+KzzKS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24991F01825;
	Wed, 28 Oct 2026 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214292;
	bh=05azj9idyjjymGs/Z2up30U4FiFi3yTTm6QeUYViD10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1B+KzzKStVAhmXFUzyV3A1M7rkei8BtZq47NVfWP/C43rs3sdweejDCIf2s7pnXBa
	 gVCBpVA75m+1lde+TBF6cE9O4FcMqT6hnbh305EH9fR2FMiIm6FTkX+6jja6uAIcVn
	 tA3t0XwnPNihfrgDIviHc06l2nzQxCVQH3aRdzEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0805/1887] s390/mm: Fix in_atomic() handling in do_secure_storage_access()
Date: Wed, 28 Oct 2026 17:48:21 +0100
Message-ID: <20261028170517.747957396@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 11709abccf93b08adde95ef313c300b0d4bc28f1 ]

Kernel user spaces accesses to not exported pages in atomic context
incorrectly try to resolve the page fault.
With debug options enabled call traces like this can be seen:

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1523
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 419074, name: qemu-system-s39
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<00000383ea47cfa2>] copy_page_from_iter_atomic+0xa2/0x8a0
CPU: 12 UID: 0 PID: 419074 Comm: qemu-system-s39
Tainted: G        W           6.16.0-20250531.rc0.git0.69b3a602feac.63.fc42.s390x+debug #1 PREEMPT
Tainted: [W]=WARN
Hardware name: IBM 3931 A01 703 (LPAR)
Call Trace:
 [<00000383e990d282>] dump_stack_lvl+0xa2/0xe8
 [<00000383e99bf152>] __might_resched+0x292/0x2d0
 [<00000383eaa7c374>] down_read+0x34/0x2d0
 [<00000383e99432f8>] do_secure_storage_access+0x108/0x360
 [<00000383eaa724b0>] __do_pgm_check+0x130/0x220
 [<00000383eaa842e4>] pgm_check_handler+0x114/0x160
 [<00000383ea47d028>] copy_page_from_iter_atomic+0x128/0x8a0
([<00000383ea47d016>] copy_page_from_iter_atomic+0x116/0x8a0)
 [<00000383e9c45eae>] generic_perform_write+0x16e/0x310
 [<00000383e9eb87f4>] ext4_buffered_write_iter+0x84/0x160
 [<00000383e9da0de4>] vfs_write+0x1c4/0x460
 [<00000383e9da123c>] ksys_write+0x7c/0x100
 [<00000383eaa7284e>] __do_syscall+0x15e/0x280
 [<00000383eaa8417e>] system_call+0x6e/0x90
INFO: lockdep is turned off.

It is not allowed to take the mmap_lock while in atomic context. Therefore
handle such a secure storage access fault as if the accessed page is not
mapped: the uaccess function will return -EFAULT, and the caller has to
deal with this. Usually this means that the access is retried in process
context, which allows to resolve the page fault (or in this case export the
page).

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20250603134936.1314139-1-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 2ab388179833e..be6122b0e6d15 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -818,6 +818,8 @@ void do_secure_storage_access(struct pt_regs *regs)
 
 	switch (get_fault_type(regs)) {
 	case GMAP_FAULT:
+		if (faulthandler_disabled())
+			return do_fault_error(regs, VM_FAULT_BADMAP);
 		mm = current->mm;
 		gmap = (struct gmap *)S390_lowcore.gmap;
 		mmap_read_lock(mm);
@@ -829,6 +831,8 @@ void do_secure_storage_access(struct pt_regs *regs)
 		}
 		fallthrough;
 	case USER_FAULT:
+		if (faulthandler_disabled())
+			return do_fault_error(regs, VM_FAULT_BADMAP);
 		mm = current->mm;
 		mmap_read_lock(mm);
 		vma = find_vma(mm, addr);
-- 
2.53.0



