Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585877;
	b=tNqrNOUOtxeKWAVZV8LUiodDl/YwWGsNTQZK5/aqoMPp2G3iU5CsiGWjgBJSqb+zYWLi
	 KjRoWwdrvJcjP+Q9EBPFhb5SnsP0UncJQV+ZERQTgDmWPGrKPOQzzLP3vjKu22sYS+6gC
	 jeXGuiz6H4h8vo8DfgKKuYKlV81ZcaC43ixOd2X8J8qCSKYj+72pLP3t+GwgSP6IfF3qB
	 hxjg2/P1uFnmwHkjNd8LARoVtL4amZ3f2ZUMJF+unpIHwldsQpht7AcRwRc8zYDzbAsng
	 VACvzSvUXD5Uh/LgDxOBpMYY967tVtdxss43i4b4uWhW4ZyZFoJ8/XZnvx/SIez7zvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g9XPcVSonoUv4FLr/9iNVViRRY2ZUcp5z0vkUikL7fw=;
	b=cIO2COy85KD5xPtY/tWXTFK0blcyav76ziag2VN6zXGn9SFmCbFIfdiQEzvm4FkWB5Se
	 Kdw2tL+CecACpuIRS/lhOX+P43mdL3PSTVhN04NSWtGShaI65hQXx38PaN6cmyXkbEvu7
	 gk8NF7YGml9PbU/6nHDPokAB6aXe50St1YoBhkj66yH/pXcXEXz8vKRj0edXYyxrOSL9Q
	 0Zw46uLQTSTsb5jn3++xtlzM5OqKMfuRnKe1GHLOSGJJOzUAdA+vpejRCP30EZTMhQjy0
	 PcBPRscsE3ZUsakudA+48K0jI9h9qyJN0NriG+qmpcmWQmIBe4+ot6QPaTIfg39JTmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xHyjpEDx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A535606EA86;
	Fri, 13 Nov 2026 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xHyjpEDx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159AA1F000C6;
	Fri, 13 Nov 2026 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585877;
	bh=g9XPcVSonoUv4FLr/9iNVViRRY2ZUcp5z0vkUikL7fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xHyjpEDx5/DMh70wAOQ7QVnkX/ZA0LVwpAm/C78Q/Nexel9/KUWIqWvOjDtPx7IKI
	 Em5+nrcbFbYK5HWOoqiMLYt3Uaz3OcxsG/u2dyobh4laK3YrivOE+0VHdxrZYcvvel
	 9urskXLYnhaeAwThI9IEGeAgxO+iPwzZWKnBUcdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 446/507] KVM: arm64: Pass kvm_s2_fault_desc to fault_supports_stage2_huge_mapping()
Date: Fri, 13 Nov 2026 10:52:30 -0500
Message-ID: <20261113153811.854578904@linuxfoundation.org>
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

[ Upstream commit 10c5cc50f056a6425305557063ad70c3eb0e686b ]

Pass the fault descriptor to fault_supports_stage2_huge_mapping() instead
of passing memslot and hva separately so it can access other s2fd
members such as vcpu. This implies to pass that same s2fd argument to
transparent_hugepage_adjust().

No functional change intended.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260928095454.3255918-3-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Stable-dep-of: 80b0b86dc5e4 ("KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmu.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bf6d6526639fa..291696dda0741 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1362,12 +1362,21 @@ static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
-static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
-					       unsigned long hva,
+struct kvm_s2_fault_desc {
+	struct kvm_vcpu		*vcpu;
+	phys_addr_t		fault_ipa;
+	struct kvm_s2_trans	*nested;
+	struct kvm_memory_slot	*memslot;
+	unsigned long		hva;
+};
+
+static bool fault_supports_stage2_huge_mapping(const struct kvm_s2_fault_desc *s2fd,
 					       unsigned long map_size)
 {
-	gpa_t gpa_start;
+	struct kvm_memory_slot *memslot = s2fd->memslot;
+	unsigned long hva = s2fd->hva;
 	hva_t uaddr_start, uaddr_end;
+	gpa_t gpa_start;
 	size_t size;
 
 	/* The memslot and the VMA are guaranteed to be aligned to PAGE_SIZE */
@@ -1436,9 +1445,9 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  * Returns the size of the mapping.
  */
 static long
-transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			    unsigned long hva, kvm_pfn_t *pfnp, gfn_t *gfnp)
+transparent_hugepage_adjust(const struct kvm_s2_fault_desc *s2fd, kvm_pfn_t *pfnp, gfn_t *gfnp)
 {
+	struct kvm *kvm = s2fd->vcpu->kvm;
 	kvm_pfn_t pfn = *pfnp;
 	gfn_t gfn = *gfnp;
 
@@ -1447,8 +1456,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-		int sz = get_user_mapping_size(kvm, hva);
+	if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE)) {
+		int sz = get_user_mapping_size(kvm, s2fd->hva);
 
 		if (sz < 0)
 			return sz;
@@ -1585,14 +1594,6 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
 	return prot;
 }
 
-struct kvm_s2_fault_desc {
-	struct kvm_vcpu		*vcpu;
-	phys_addr_t		fault_ipa;
-	struct kvm_s2_trans	*nested;
-	struct kvm_memory_slot	*memslot;
-	unsigned long		hva;
-};
-
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool write_fault, exec_fault;
@@ -1779,7 +1780,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PUD_SIZE))
+		if (fault_supports_stage2_huge_mapping(s2fd, PUD_SIZE))
 			break;
 		fallthrough;
 #endif
@@ -1787,7 +1788,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 		vma_shift = PMD_SHIFT;
 		fallthrough;
 	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(s2fd->memslot, s2fd->hva, PMD_SIZE))
+		if (fault_supports_stage2_huge_mapping(s2fd, PMD_SIZE))
 			break;
 		fallthrough;
 	case CONT_PTE_SHIFT:
@@ -2027,9 +2028,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		if (perm_fault_granule > PAGE_SIZE) {
 			mapping_size = perm_fault_granule;
 		} else {
-			mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
-								   s2fd->hva, &pfn,
-								   &gfn);
+			mapping_size = transparent_hugepage_adjust(s2fd, &pfn, &gfn);
 			if (mapping_size < 0) {
 				ret = mapping_size;
 				goto out_unlock;
-- 
2.53.0



