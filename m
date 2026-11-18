Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022475;
	b=2MosVeTWPXlfFImaUENiCg/V4zSDjgNgFq5LeVe+sKqoOwSDo8HtN2om1Cy1EweAiz7e
	 aKy4XgTO+YSZjPBKeaaPWc05IxyRmo/du4AfBSfHZYZ+I30zL1euEMKcHgPbNpmlf5lZw
	 1UACDnbIUnmBuTyuEjDiHT1hP6jtshhU3Pc/Dkp198t8I+IQtRE17pmUT0Fx5/UALoK+9
	 3XvqpA03J14lpvjLlp3b4W6kw3+1QQmhV3WjiKp/xx7nwlEkdF6avVMiytyvx0m2va9wk
	 7PB/dp5KwDNgjsMCgrhnRSrgkcF0WqLcgoY30HNoYjY+PdvnQK14oq0+huX+duZSteg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G9w7Bg6qAfgdSHKKZlKSUIePJoBKhWz3E/alzO+pDc0=;
	b=iBWS1Ntfz0oakjRlucUcmOeCVEgYskq+FpiScX+1vwKKwS9UcDM861oSK9Ny1pqMgjVe
	 36vS4N/tJPQe1ug1f+haxNdoV0ffhlTzu32sImlhDIoW/XKhlYMFi4vh9hXWHn+7VJl3H
	 PZy05TBunXG7jA1fT5oumW315bE3BCMfMPsZGaccqdrZshUTdUSclOM7XxK8T0+bqh9sD
	 2zItgTG1t5qXcWz2p9pTiOSnYi3+pf4d/WmBHi4pJJvNUd2jakV4qMKRSQ67m/pmkfeUt
	 /t9oLxR9WS7mocPKtE2+/NPiNMce3NzIkkHDg8h84tnDcWYoOXiq13/xAh5Wo7xWFPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ekcZV9tV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D475606A335;
	Wed, 18 Nov 2026 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ekcZV9tV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C951B1F000C5;
	Wed, 18 Nov 2026 17:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022475;
	bh=G9w7Bg6qAfgdSHKKZlKSUIePJoBKhWz3E/alzO+pDc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekcZV9tVC3Jmv1ouqjPWQUSdM8fGhUfoqteb17UwLxg7bWXItZdmzoekA5/ijBwBY
	 i+ZKOvAW4W26rqHbLOlr6l7S8C95ixoOjSOXQGgwg6jfMf4KowKyBZRWml97xf4npg
	 k8G7f3gR6mix7UwDJ1pRc5RdfuS18ASrUZ7I431E=
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
Subject: [PATCH 6.18 0026/2151] mm/userfaultfd: wake waiters when registration modes are removed
Date: Wed, 18 Nov 2026 15:29:21 +0100
Message-ID: <20261118150122.605725845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
[ sashal: replaced the upstream wakeup wrapper with a direct cross-file wake_userfault() call using a shared range structure ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c              |  9 ++-------
 include/linux/userfaultfd_k.h |  8 ++++++++
 mm/userfaultfd.c              | 12 ++++++++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 2b4e83cc0cb9e..02ff11cf42bd8 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -71,11 +71,6 @@ struct userfaultfd_wait_queue {
 	bool waken;
 };
 
-struct userfaultfd_wake_range {
-	unsigned long start;
-	unsigned long len;
-};
-
 /* internal indication that UFFD_API ioctl was successfully executed */
 #define UFFD_FEATURE_INITIALIZED		(1u << 31)
 
@@ -1191,8 +1186,8 @@ static void __wake_userfault(struct userfaultfd_ctx *ctx,
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 }
 
-static __always_inline void wake_userfault(struct userfaultfd_ctx *ctx,
-					   struct userfaultfd_wake_range *range)
+void wake_userfault(struct userfaultfd_ctx *ctx,
+		    struct userfaultfd_wake_range *range)
 {
 	unsigned seq;
 	bool need_wakeup;
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 796a380664bd8..d65effb5cbff2 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -78,6 +78,14 @@ struct userfaultfd_ctx {
 	struct mm_struct *mm;
 };
 
+struct userfaultfd_wake_range {
+	unsigned long start;
+	unsigned long len;
+};
+
+void wake_userfault(struct userfaultfd_ctx *ctx,
+		    struct userfaultfd_wake_range *range);
+
 extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
 /* A combined operation mode + behavior flags. */
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e4a0cb3ad838a..d5467692e8c3b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2063,6 +2063,8 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
+		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+
 		cond_resched();
 
 		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
@@ -2097,6 +2099,16 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 */
 		userfaultfd_set_ctx(vma, ctx, vm_flags);
 
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



