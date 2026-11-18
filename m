Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028699;
	b=dWsWatSFUZ3AO0sGPwP4p6mz/eTFDMeReaVOk3oOSyJ6XIod18JKreF/Y9bKkeaOize7
	 KNMxwODm573D4hLf1PSXW5I4NcXdPD1Cm9JEgPMEsWPoqw6l+RZzGq8NuOGInkcdwEyP2
	 mfYkaUPXsH8b5ne0f/SA3RXzCK80NSBPhhSIMBuSKd0ERJEInibB4r8fXew4gFIYEiiUX
	 Zsz0NFs3VSOJpUy1aYbuZ/GhW0jenLiX7Ktbsn7FIA++B9xy19BRxGqIgxdjJJTkkvMBV
	 J3s8yeqrnvJiDQFbYnn98AMG6Lyn+96ry0FBt2uMyjLRR1iLAevCmIeZcLIN5Qu8GrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=szPk+J1lKdnBl4nbGVCCHRZn+o2O5M0B5sM+rJaUQYw=;
	b=OTXN7AODEYAefH+nCbIeu04hmj8BQnx29mzprnodIJnXMgU0Ez+oqeiTQkNL7dSPF+VI
	 6eAd+5xmj2KPXBDPXEMt+GYtSsOJy5tQw8aMNi0WDIyUcQsin5MafMPREQbPd1fNNigPD
	 JynHzd7Lr7efvHXd0YR9sp3NjRHMt9BZTGiZonlpSEyXNmPzHn73v1ax6nYvgXxneTGbq
	 6uMRlgsS/SxjYy/CB3mtwCvGCZt2j0sQQNKdYg9+AtEBonJTbJsUqx1qZRXbN15X6D+wq
	 IxhIGodpcjHuPMba+loIOHpmAmjSegH9OwNBZxLnkbrrwVdn039dOa6vgSOKuzlqVNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fh+QBnXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63917606A31C;
	Wed, 18 Nov 2026 19:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fh+QBnXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6D61F000C4;
	Wed, 18 Nov 2026 19:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028699;
	bh=szPk+J1lKdnBl4nbGVCCHRZn+o2O5M0B5sM+rJaUQYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fh+QBnXExh4ImNSZalJzZz5G6x/Fur1gYlM3Sx5PXfS/aC/DbcyujFxj2IVjDu+d1
	 CxI8k82ZJvu//fqx4uqRKZ4KFUEZemAQmbdj37kJMh5da54xVlgZjKtXI/R3IxtgjA
	 OnfZo8O5WUMcAoMB434MC7XSaf5gW+BirnISaC9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0088/1756] mm/vma: dont leak the charge for stack growth
Date: Wed, 18 Nov 2026 15:36:55 +0100
Message-ID: <20261118150011.760269973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit b1ee87802111156e27557e82acc31fa7dfc76e2a ]

acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
This can happen for read-only or MAP_NORESERVE mappings created with
MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
Committed_AS.

Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
Unaccounted growth skips the overcommit check while remaining subject
to the other stack-growth limits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-44-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced vma_test(vma, VMA_ACCOUNT_BIT) with the equivalent vma->vm_flags & VM_ACCOUNT check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index c930e03bd7997..e2c51c6ed83d2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1040,7 +1040,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if ((vma->vm_flags & VM_ACCOUNT) &&
+	    security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	return 0;
-- 
2.53.0



