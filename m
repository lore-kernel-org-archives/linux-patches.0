Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038929;
	b=WqZIcE87ItA+OCE5wFq5bCw+jy5MACJgUgmx6bFJ28Yd/O+a8/6ZLVY69wWaExhfGKab
	 q9bHACkSfn0+n1Q5itgzZicXUdlbz5KA2RqKf7ZBFwpIPJAAWfHf9UkNaPIepyKq4nfac
	 11xLnvpnN2JcQtCQ9d/SmyhqOgR5b/ZbcAgu4CUcFI6zWcD38x3D+GwiO+tAwrQLBgASA
	 3JOC0QKqgwaTuasoKvXt2vKiKogoVr5pioVn83W1NA0/7tSPnYjohXnYZEOisQ85mwVNS
	 BX3SkPFlvJ+czMx3nT1YFHj6TWxsvV7/8BXKO/21gj0ey9HTK/VPp5ZD4V7drsW2usQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tUHpBbId6TZjRLZyHRF4VOHU2cPXM/w60yLpFeOjxsU=;
	b=beqhpjMD4269zB2HHWeA0RRcFyT//8xm/M9R5elmdzrRg4q/WnAsgJBWbCUYAvKO56tr
	 AjGthDrIkKfDtGddLvOnrw3UW1olCm3EkkOXRrPvM/nU84XPCUXevhuAxANoD8CEGfbeK
	 edGQ1U9vj0QCI5o+cb6qr82qjJFhKAyhOgYiB63XYsACbQjaW7erlkiwNBLt6UMx8lDrF
	 SrwuipD3SugFjNLVxpdRWDyI4qAaglCAVs65fydYjQquGa9EzNKn3K9zftgCuf7XVILQl
	 46MPktBIByzqZIVcd+5FG7bIAUVSS4zxzAQNZb4HJJ3YCKn7NcxZvr9jKYlHGAI0/+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TknzxxgF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807B7606A325;
	Wed, 18 Nov 2026 21:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TknzxxgF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9811F000C4;
	Wed, 18 Nov 2026 21:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038929;
	bh=tUHpBbId6TZjRLZyHRF4VOHU2cPXM/w60yLpFeOjxsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TknzxxgFTOe9doOnl8+6cWUTgkHUMudyVbd1CB0pU8FXv7ftRNfJYq+Xcum2RgkOV
	 m/40q/hCc98kk9RtvPu48mNsRrlvAx7GndQYj8jGXsC+bVmBFRRKi0JK1Pq+8F/+vy
	 q0xD6X2YVERALvwwroxFbZOskvy9797T+HinRAxQ=
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
Subject: [PATCH 6.6 1877/3318] mm/userfaultfd: wake waiters when registration modes are removed
Date: Wed, 18 Nov 2026 15:41:39 +0100
Message-ID: <20261118150418.289867738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted userfaultfd_register_range() changes to the existing userfaultfd_register() loop by inlining the wake_userfault_range() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 11b4ed7efa5f8..260d8e5d1724b 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1476,6 +1476,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
 	ret = 0;
 	for_each_vma_range(vmi, vma, end) {
+		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vm_flags));
@@ -1527,6 +1529,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		userfaultfd_set_vm_flags(vma, new_flags);
 		vma->vm_userfaultfd_ctx.ctx = ctx;
 
+		/* Retry faults for removed modes while the VMA is write-locked. */
+		if (any_mode_removed) {
+			struct userfaultfd_wake_range range = {
+				.start = start,
+				.len = vma_end - start,
+			};
+
+			wake_userfault(ctx, &range);
+		}
+
 		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
 			hugetlb_unshare_all_pmds(vma);
 
-- 
2.53.0



