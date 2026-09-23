Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A843B0AD8;
	Wed, 23 Sep 2026 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172980; cv=none; b=SdhRJf9UTKv453KmMn0zl78/d5RNUF5aB/P9Oy1xZC2nhvOrh1pl55C4RMaA0i+4M0NJ7ORyNBNN/ZMFmatgslBiY0gVtB7uFb6aTBWn4E/MoNNfI8tolYwXh5WncVJzY+vEb6Akr9JbcaG/yue7tj9XLvmVeZayI4KiKtAnFgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172980; c=relaxed/simple;
	bh=oQQj1mZK75o5UDnSFsbaeLX+5uAdj2bVMzbBR844ZrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqeHvv57C7JsS7SIKdMb7C3uHjGbC3FWswuv+V7HV0WN7fQRMi+DfCKipxvQ6+H8ynNXpHTu8hqCMPv1xewFSA6vGr037vOfpg9AfCCXNY1ZVdJK6Yg/1nn18OIbaAsqTHXcxVw/bOHLBuSWnSLuN3hhA7Ee47ufvu2roQx9f7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHsZfNrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHsZfNrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7928F1F000FF;
	Wed, 23 Sep 2026 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172979;
	bh=UGe/cPsFGck9/GUU3oz4esBX2F0XvvpKeW/ZC67ZHlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHsZfNrJ3aEvcZUl2E7GyhVFuOyl+NBzhtmWuJKuDePAUz0qFajreAMgj9gCXv1h6
	 QC4ysbceUjpoMP2qfLRqrY6SV/K2y7hcNeNxQebHfpo9eqSTDgsVwEuyOZGvm3zMIv
	 xLHoFtZ/NkCu6dPGqf9QkGCJgzWRJxhm0lpnr0OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Khrustalev <yury.khrustalev@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 111/438] arm64: mte: Fix PTRACE_{PEEK,POKE}MTETAGS error documentation
Date: Wed, 23 Sep 2026 16:02:12 +0200
Message-ID: <20260923140647.658269204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit fdb9ebc7fb7788b8371fbef6c17dc5c8291e1429 ]

PTRACE_{PEEK,POKE}MTETAGS return -EIO rather than -EOPNOTSUPP (as
documented) when no tags are copied from/to a mapping without PROT_MTE.
This has been the behaviour since the interface was introduced, though
the original intent was to distinguish between address not being
accessible and mapped as untagged.

Update the documentation to match the implementation (de-facto ABI).
Since -EOPNOTSUPP was never returned, change the error assignment to
-EIO as well to avoid confusion.

Fixes: df9d7a22dd21 ("arm64: mte: Add Memory Tagging Extension documentation")
Fixes: 18ddbaa02b7a ("arm64: mte: ptrace: Add PTRACE_{PEEK,POKE}MTETAGS support")
Reported-by: Yury Khrustalev <yury.khrustalev@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/arm64/memory-tagging-extension.rst | 5 ++---
 arch/arm64/kernel/mte.c                               | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/arch/arm64/memory-tagging-extension.rst b/Documentation/arch/arm64/memory-tagging-extension.rst
index e6fe428f0e2a4..1d32fc5df1838 100644
--- a/Documentation/arch/arm64/memory-tagging-extension.rst
+++ b/Documentation/arch/arm64/memory-tagging-extension.rst
@@ -208,11 +208,10 @@ will use the corresponding aligned address.
   tracer's space cannot be accessed or does not have valid tags.
 - ``-EPERM`` - the specified process cannot be traced.
 - ``-EIO`` - the tracee's address range cannot be accessed (e.g. invalid
-  address) and no tags copied. ``iov_len`` not updated.
+  address) or does not have valid tags (not mapped with the ``PROT_MTE``
+  flag) and no tags copied. ``iov_len`` not updated.
 - ``-EFAULT`` - fault on accessing the tracer's memory (``struct iovec``
   or ``iov_base`` buffer) and no tags copied. ``iov_len`` not updated.
-- ``-EOPNOTSUPP`` - the tracee's address does not have valid tags (never
-  mapped with the ``PROT_MTE`` flag). ``iov_len`` not updated.
 
 **Note**: There are no transient errors for the requests above, so user
 programs should not retry in case of a non-zero system call return.
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 1a9aad6ef22a0..31f5c6b0510e7 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -476,7 +476,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 		 * was never mapped with PROT_MTE.
 		 */
 		if (!(vma->vm_flags & VM_MTE)) {
-			err = -EOPNOTSUPP;
+			err = -EIO;
 			put_page(page);
 			break;
 		}
-- 
2.53.0



