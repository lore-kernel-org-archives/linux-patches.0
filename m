Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028589;
	b=vQ2n0kuU3/yL6xMbzRnK+ax+z+iu1scm3tELV8j24YaDZAELdATCjaOpIGOLNWGaTplB
	 MDx7PXDs4UBMYE6iSGYf9SVBF56iGjmm+83slNYLHB//ZfCwNw+IXbHq1pW0uksRS+qiM
	 tz9RDJVDHwQ1CnkS3CqnjBcEsThEMB7tG6UbklpzPP9R0W+3qikNTN5ttxq6PTnGY1OCO
	 ORdq+MYEYOwWICKFMxj6hb6DIaq6ODgGMRhjBbO/IkKGFPNgG9MA1qOVIxqLvYeVVmM7E
	 V5tHugQOmDQU+Irdf6MYH1ORJaAivuOpwQaNYMtC9LE2EKbwbu9xc0nZTjyXSBSnMKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tuyXczH11ykxEC3kFoTRnaidGiN8envgGuzt55ZGRVo=;
	b=ZFrwxmotB85v7Q7aVcCDZNV6nKrWeWSlA9N6XKckWWiuUy7jYKY5It/sKrkTsic2Ogvm
	 zO+Ekl+XW9CDb4gBspiX4q0PhZ1w1CztkJewztChUgQt+ao3S5QuJWJAnoupS0ez9Zu/n
	 ViHXjlbVyrnrSYSo8G/bI3jOevsSRQdismiBHyJmdzOGvP+TVDI8gKns/oTJfTt8RO80+
	 OY7lKYIJJdTcToqsTBElvUIj7rO9IeiBFDt+a9pAR+uqamO8ipdSyDjN8pVc+FbasZImb
	 aow04qTYPAwaJ9gG49luypX9r+uIbo1gq4ddtAEJYiwUxZ2W4pHJFUP9Vouncd6ZKYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=siav3hHz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0B9606A31C;
	Wed, 18 Nov 2026 19:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=siav3hHz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37EF1F000C6;
	Wed, 18 Nov 2026 19:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028589;
	bh=tuyXczH11ykxEC3kFoTRnaidGiN8envgGuzt55ZGRVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=siav3hHznhwfm5eImOWO3NWMgiP0yzp5d43O5V04DvPkWrPHQWXxivSi7DdVBY5KR
	 Bx3E0vciyw/UvKq6F764MdK5PFbUv0WobCXbveQAUGnQmGv3LRKFiEr+MbFdl0Hnyv
	 gMKKQOd1/tRsL+mnOhLlQVmN52wUscezOQZYSU1E=
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
Subject: [PATCH 6.12 0022/1756] mm/userfaultfd: wake waiters when registration modes are removed
Date: Wed, 18 Nov 2026 15:35:49 +0100
Message-ID: <20261118150008.789470861@linuxfoundation.org>
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
[ sashal: replaced the local wake_userfault_range() wrapper with a direct wake_userfault() call, exposing the helper and its range structure across files ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c              |  9 ++-------
 include/linux/userfaultfd_k.h |  8 ++++++++
 mm/userfaultfd.c              | 12 ++++++++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 59f01cc7c5ace..e1b1a5b1a757a 100644
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
 
@@ -1185,8 +1180,8 @@ static void __wake_userfault(struct userfaultfd_ctx *ctx,
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
index 8ff68ce1860be..8b8be5fa2eb57 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -82,6 +82,14 @@ struct userfaultfd_ctx {
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
index 29d2366d88fa1..10685c46f0866 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1965,6 +1965,8 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
+		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+
 		cond_resched();
 
 		BUG_ON(!vma_can_userfault(vma, vm_flags, wp_async));
@@ -1999,6 +2001,16 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
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



