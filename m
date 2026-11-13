Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585908;
	b=QSwIXoiUx7HWL4ETd5Q3NSQ65KECmHFONGYOa21x0a68XEit5Uzu+d4Ch3pz5l0doYZc
	 eMZ2DsGoZGoTo/B5MMmN0jm4ED97rimqGG2t2xQvLyzxrU7t1nTJno/0DgXbdAwy0F7Iq
	 sJ9Qj07VUFSLVD8tU0QBux8+biklhPOGfgBCq6sNCoG2ac1e2dMgPThEbKqs1oQ3V1Wsj
	 Fi0dNclTwiGejBRIEXMlUFFWXmAMuOpJqmQD6ixJvKPvkm9wRTW+2gWTW7FuCTMbxmM08
	 r6CjKJl7oEnFUU9w5BO/ZkIb1CdFKUi9xw9p7CGqug0CjbVFy6d1P3ru9O3cjyzTulA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mo6F9Qq6kulubEamTxD2VEGjXuXCYIDZeNkgmoKeq+g=;
	b=vJYNMiQWL10i3Z2tWpPzj3SdqV+t4p8oaXXQl7cb/IJZFbEjg3mbstvI9Y8nmcK33civ
	 9No7Gka8lTM0OdexnZt+5CcFjL/VjjdF+DkkVu0S0zTH1SQHPaQ/LqjlNR84DvYFzUNm6
	 6MAAD3HF/7TFJ0ulsvB6u9jaWTlbFsBxPmRChWaJjKTQdWWpaQ+UYXxVNlMS2V0deKpVo
	 qpuX51ALgPfVQxqRJ2deExNsJqK9HfLq28IJzRsxy4GH/s2sIf7n+E2SKBpbf2PxxLvht
	 Zxr8aJ1eP7YGiA0/nJ4MRm52BFXuKcKQuwdjbNAgVI1jSpyFgYTq8UPu314Iliive6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WW8+JbEB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7616076210;
	Fri, 13 Nov 2026 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WW8+JbEB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF7A1F000C6;
	Fri, 13 Nov 2026 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585908;
	bh=Mo6F9Qq6kulubEamTxD2VEGjXuXCYIDZeNkgmoKeq+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WW8+JbEBmQlSTIKCpZCPSUeyavLBylVbolswASLpCJqNbBD84S3STXgKk1Z5ZLrsD
	 eRf7uVCJFZYxAEDjyVUj5d+ZcnodE48R63TVu2W6iHAknQBwc9clRqwnv3Ifx8+jKT
	 sQT/1w8U2iX0Icoh/6vP0gV5ZCLEJV+1m5sCCg/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 473/507] KVM: arm64: Use kvm_s2_fault_vma_info in pkvm_mem_abort()
Date: Fri, 13 Nov 2026 10:52:57 -0500
Message-ID: <20261113153812.934062684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 0cdcc1039200b3c4fbc2ae3f9b5c1be1bc9155e8 ]

To paraphrase Marc in commit 08f97454b7fa ("KVM: arm64: Fix protected
mode handling of pages larger than 4kB"), pkvm_pgtable_stage2_map()
assumes the address passed as a parameter is aligned to the size of the
intended mapping, while HPFAR_EL2 gives the IPA minus the bottom 12
bits, regardless of the system page size configuration.

To fix this alignment, bring support for kvm_s2_fault_vma_info in
pkvm_mem_abort() and use its members where possible. They do contain the
page-alignment we need to fix the fault on system with pages larger than
4K.

Also, add a check at the start of pkvm_pgtable_stage2_map(), it does not
support !PAGE_ALIGNED arguments.

Fixes: ea03466e806f ("KVM: arm64: Handle aborts from protected VMs")
Cc: stable@vger.kernel.org
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260928095454.3255918-5-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmu.c  | 27 ++++++++++++++++++---------
 arch/arm64/kvm/pkvm.c |  3 +++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ebc17d3e0c00..cae133805c76b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1383,9 +1383,11 @@ static bool fault_supports_stage2_huge_mapping(const struct kvm_s2_fault_desc *s
 	if (map_size == PAGE_SIZE)
 		return true;
 
-	/* pKVM only supports PMD_SIZE huge-mappings */
-	if (is_protected_kvm_enabled() && map_size != PMD_SIZE)
-		return false;
+	/* pKVM only supports PMD_SIZE huge-mappings for non-protected VMs */
+	if (is_protected_kvm_enabled()) {
+		if (vcpu_is_protected(s2fd->vcpu) || map_size != PMD_SIZE)
+			return false;
+	}
 
 	size = memslot->npages * PAGE_SIZE;
 
@@ -1609,6 +1611,9 @@ struct kvm_s2_fault_vma_info {
 	bool		map_non_cacheable;
 };
 
+static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
+				     struct kvm_s2_fault_vma_info *s2vi);
+
 static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
 			       const struct kvm_s2_fault_vma_info *s2vi);
 
@@ -1698,12 +1703,12 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
+	struct kvm_s2_fault_vma_info s2vi = {};
 	struct kvm_vcpu *vcpu = s2fd->vcpu;
 	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
 	struct mm_struct *mm = current->mm;
 	struct kvm *kvm = vcpu->kvm;
 	void *hyp_memcache;
-	struct page *page;
 	int ret;
 
 	hyp_memcache = get_mmu_memcache(vcpu);
@@ -1711,12 +1716,16 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if (ret)
 		return -ENOMEM;
 
+	ret = kvm_s2_fault_get_vma_info(s2fd, &s2vi);
+	if (ret)
+		return ret;
+
 	ret = account_locked_vm(mm, 1, true);
 	if (ret)
 		return ret;
 
 	mmap_read_lock(mm);
-	ret = pin_user_pages(s2fd->hva, 1, flags, &page);
+	ret = pin_user_pages(s2fd->hva, 1, flags, &s2vi.page);
 	mmap_read_unlock(mm);
 
 	if (ret == -EHWPOISON) {
@@ -1726,7 +1735,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	} else if (ret != 1) {
 		ret = -EFAULT;
 		goto dec_account;
-	} else if (!folio_test_swapbacked(page_folio(page))) {
+	} else if (!folio_test_swapbacked(page_folio(s2vi.page))) {
 		/*
 		 * We really can't deal with page-cache pages returned by GUP
 		 * because (a) we may trigger writeback of a page for which we
@@ -1746,8 +1755,8 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}
 
 	write_lock(&kvm->mmu_lock);
-	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
-				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
+	ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(s2vi.gfn), PAGE_SIZE,
+				      page_to_phys(s2vi.page), KVM_PGTABLE_PROT_RWX,
 				      hyp_memcache, 0);
 	write_unlock(&kvm->mmu_lock);
 	if (ret) {
@@ -1758,7 +1767,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 
 	return 0;
 unpin:
-	unpin_user_pages(&page, 1);
+	unpin_user_page(s2vi.page);
 dec_account:
 	account_locked_vm(mm, 1, false);
 	return ret;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec123..c298a5b9b12a6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 end = addr + size;
 	int ret;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr | size)))
+		return -EINVAL;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
 
-- 
2.53.0



