Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015035;
	b=C/UyB6m5hDyUV5E81+C8gj4RfnJjGjt8HDL5Q+k2IWaX+Jgw9IyuZb5Zts5XJnSlnXPm
	 CsZm+UnPp6JM0TlHRr7hIBYUPqkU+dODMTWV6IeCxDCPyqVEf3WdeYqxQb/Nh1RvYZLIw
	 a3frSeEvakg71dbxvD8iEMrUXNSg++4c1PKh1QwbdM6EOq+S3ZJAD1avDNyG1K5CM5aSX
	 fJnlgtUl5hkMEJLaYrYk98kfMR/i2gsZau5w++0vOy6DwaJIgBhYlsjw9phG5WUIRUKUv
	 l+mKKD1vQsz8fZMIQpSAyMMlM31PBbQeP+VKM6u6EcBToyVwm1y8oLcmVV4RFjmIklg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OtbHbm7ADFd2NoHsy67O2GQauYUr/N2QYrXDESsilYM=;
	b=Ljb1YHLA39Xeiy4nZThnN0O+utNDwVV4uepDPIzU747shEDUKwAf8tvtheXY7HWaKESa
	 rxBVVU7LSl3cRs7/8G0pcXzRt/XrcTYlUIn4DTyL7vJtbxA92AEV+tInDqTLu+giBVqrd
	 rGKonfV9tpmfsdk01bqzCUxL+UFTmFiP4IEIFoFQxc0HE0C1CPxdZIIf5lSOglGQxpT0B
	 UmiIiBJJyRrXN1GYOThHAbsQEZoT+SNgoEAIL64rHeFP6KmuSGr+kW0wqNL1xJkB8r1xV
	 iYMbFTWjazphrywuSLYD4RZweYOliyAUwDb2ShPlPWwOTq5vApsw7pRYhxLO0K8hoYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09Iz4rmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B6D606A325;
	Wed, 18 Nov 2026 15:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09Iz4rmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19971F000C4;
	Wed, 18 Nov 2026 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015035;
	bh=OtbHbm7ADFd2NoHsy67O2GQauYUr/N2QYrXDESsilYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09Iz4rmVvhZCpZ6D9fUtOMlaXDf1yonYHbbqxqxDub+Rg4UMrY4MLYGZPb50s08Ci
	 4dxfNPuJNeAn9voTvCPP06yZxO1S31ExjnB7PKXuHBNakMsCTgDk/UQ+Ey5Wf/4fle
	 sngxsY17oOsDLQTDVKEsp6rcM7d407nxDVuVN7bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0010/2651] mm/userfaultfd: wake waiters when registration modes are removed
Date: Wed, 18 Nov 2026 15:20:50 +0100
Message-ID: <20261118150248.370977041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 4eee9c389b072e161549d46dcb1ae10b0222717e ]

UFFDIO_REGISTER can replace MISSING or MINOR tracking without waking
faults that are already queued. For example, switching an anonymous
range from MISSING to WP leaves a missing-fault waiter asleep until
userspace explicitly wakes it.

When a registration change removes a UFFD mode, wake waiters in the
affected interval after updating the VMA. The VMA is write-locked at
this point, so no new faults can queue under the old modes and woken
threads cannot retry until mmap_write_unlock(). Waiters for retained
modes in the same interval may also wake and refault.

The hang reproduces for MISSING-to-WP and MINOR-to-MISSING transitions,
with both read and unread fault events.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-25-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Adjusted context to retain is_vm_hugetlb_page() instead of vma_is_hugetlb(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2286,6 +2286,9 @@ static struct vm_area_struct *userfaultf
 	return ret;
 }
 
+static void wake_userfault_range(struct userfaultfd_ctx *ctx,
+		unsigned long start, unsigned long end);
+
 /* Assumes mmap write lock taken, and mm_struct pinned. */
 static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 			       struct vm_area_struct *vma,
@@ -2303,6 +2306,8 @@ static int userfaultfd_register_range(st
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
+		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+
 		cond_resched();
 
 		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
@@ -2348,6 +2353,10 @@ static int userfaultfd_register_range(st
 		 */
 		userfaultfd_set_ctx(vma, ctx, vm_flags);
 
+		/* Retry faults for removed modes while the VMA is write-locked. */
+		if (any_mode_removed)
+			wake_userfault_range(ctx, start, vma_end);
+
 		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
 			hugetlb_unshare_all_pmds(vma);
 
@@ -3664,6 +3673,17 @@ static __always_inline void wake_userfau
 		__wake_userfault(ctx, range);
 }
 
+static void wake_userfault_range(struct userfaultfd_ctx *ctx,
+		unsigned long start, unsigned long end)
+{
+	struct userfaultfd_wake_range range = {
+		.start = start,
+		.len = end - start,
+	};
+
+	wake_userfault(ctx, &range);
+}
+
 static __always_inline int validate_unaligned_range(
 	struct mm_struct *mm, __u64 start, __u64 len)
 {


