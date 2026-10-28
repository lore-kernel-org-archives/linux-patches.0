Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214836;
	b=qTl/dN/pEYtjj11NdmOJOjyhrhlcUS/Au5FzxKYr1LU6hrlkC36nlHe3zdiVKwVgUCz2
	 b2Ekz7bEYnqgWsIbhPXwEFS3qz0dZQlUuMtBygX5dhSszx5A/xsVuulefjDzLAL4W64md
	 ga4n1foiYM/KppXcQKeF0JDXhetb0Tx0Vi+cc0K2qHDuvl4dWpKFzj3tg60zz+ALeZGn7
	 4TxiqEBEPAKgj4Z4sGwMe2vDALvhrH/hCm67LCOadUSP6Hcl7vg/LD0PszvNJo78jTe50
	 86izXuJLrdpzHQZUp9DUKFAgPyikP/eNlVhKA3yPUE1GYwU7Iw/wC4A42oaRyowRmBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iv+nz+Lhp1vbGl2GjqfYnHMmucoObXDPccgWuw4QTBY=;
	b=XdMBaxlYcphV1xxV2IfLsYJeGcVqwXXq7IGaOSNlNpYMQ84IjwVPsSwDW6SG2IHl5jTs
	 rh44JakyWZH67Fn/5Y6aAuKOnDf97d6A1ehlg9UUWY67xLySbWnHwCV7HC5tIw2EYfxJB
	 JiQrO+MZmWfSTmvrkRy91hHPxXeNnXlZ9WwSPfIlXbQwab9xXVM2kBQTxvNh2z+5UTwBe
	 pI67R8tRkIjnZQSVFSHfasey0kQWQ+S8Kmgq+ezZzpzahsCEcDi/AOkmoF2nEryZ0bUBt
	 JInWj/t4sOLqnuntzDpXUj6YcrRRyLN7LJx2faqhVa+pB1xSTACVx80Huv4zMvkre9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/siXvBD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E6A606A320;
	Wed, 28 Oct 2026 19:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/siXvBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FDC1F01825;
	Wed, 28 Oct 2026 19:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214835;
	bh=iv+nz+Lhp1vbGl2GjqfYnHMmucoObXDPccgWuw4QTBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/siXvBDieCO4J2flWsGTBA7Lt7PMEHcrYV2kk9B2cfmMHH40ckL7ICnvK+WoWCXS
	 TFpPLNHYVDI4NZkwOHL+MsWrSY9+++za6t/sNvVaLrtaKB90vM7Qa5BfYOtgpSDmNq
	 SlAWFx55r+t8W/NMgkICZWdBk1FlNMrcttUZYcWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ge Yang <yangge1116@126.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	David Hildenbrand <david@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0955/1887] KVM: SEV: Use long-term pin when registering encrypted memory regions
Date: Wed, 28 Oct 2026 17:50:51 +0100
Message-ID: <20261028170521.138769949@linuxfoundation.org>
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

From: Ge Yang <yangge1116@126.com>

[ Upstream commit 7e066cb9b71a22c3e5ef233de63ff14525baf6f0 ]

When registering an encrypted memory region for SEV-MEM/SEV-ES guests,
pin the pages with FOLL_TERM so that the pages are migrated out of
MIGRATE_CMA/ZONE_MOVABLE.  Failure to do so violates the CMA/MOVABLE
mechanisms and can result in fragmentation due to unmovable pages, e.g.
can make CMA allocations fail.

Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/1739241423-14326-1-git-send-email-yangge1116@126.com
[sean: massage changelog, make @flags an unsigned int]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: b6408b6cec5d ("KVM: SEV: Protect *all* of sev_mem_enc_register_region() with kvm->lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 53b37f3d770bc..302ebbb4878f5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -393,7 +393,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 				    unsigned long ulen, unsigned long *n,
-				    int write)
+				    unsigned int flags)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	unsigned long npages, size;
@@ -437,7 +437,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
 		return ERR_PTR(-ENOMEM);
 
 	/* Pin the user virtual address. */
-	npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 0, pages);
+	npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
 	if (npinned != npages) {
 		pr_err("SEV: Failure locking %lu pages.\n", npages);
 		ret = -ENOMEM;
@@ -525,7 +525,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	vaddr_end = vaddr + size;
 
 	/* Lock the user memory. */
-	inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
+	inpages = sev_pin_memory(kvm, vaddr, size, &npages, FOLL_WRITE);
 	if (IS_ERR(inpages))
 		return PTR_ERR(inpages);
 
@@ -958,7 +958,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		if (IS_ERR(src_p))
 			return PTR_ERR(src_p);
 
-		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, 1);
+		dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, PAGE_SIZE, &n, FOLL_WRITE);
 		if (IS_ERR(dst_p)) {
 			sev_unpin_memory(kvm, src_p, n);
 			return PTR_ERR(dst_p);
@@ -1025,7 +1025,7 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
 		return -EFAULT;
 
-	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, 1);
+	pages = sev_pin_memory(kvm, params.guest_uaddr, params.guest_len, &n, FOLL_WRITE);
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
@@ -1507,7 +1507,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
-				    PAGE_SIZE, &n, 1);
+				    PAGE_SIZE, &n, FOLL_WRITE);
 	if (IS_ERR(guest_page)) {
 		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
@@ -1971,7 +1971,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 		return -ENOMEM;
 
 	mutex_lock(&kvm->lock);
-	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
+	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
+				       FOLL_WRITE | FOLL_LONGTERM);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
 		mutex_unlock(&kvm->lock);
-- 
2.53.0



