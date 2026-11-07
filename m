Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061506;
	b=T/Y3piOQ1UgESsvwRCZN3zRby2suMC2spL7pIbsbNEl5/LPn4wvkDC7sXRwFMNaqOZXu
	 yuq8r1Kl+ORzSPW53QOuvw44Zu2I2wcQYYVNtVsP07U5e4QEt3HtWgnPqlL/thD0nH3eg
	 h5IU7LGI2GWL93I2mDOSL+1T6dMAfyQOPcO4yoVFau6qk+qjUGUNB3pK+5W+mv5/dF8a6
	 zvs1EX676LqIfnfv6YolBLhGV+dVyhcYUVN7mOlb+F3NhjrlrbHgZUyKd2C0Rhs5BxMKi
	 Ee8e/QnFjVaNS74K2BzXDVurmax3YSp3nrXszgWdMwktWu0BsBTK4ed94hJcAL5n5cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AAOoSANg/HU1P0s6pK4bH2FFsSvTHRSYOqUul/EsUQ0=;
	b=ntL+r/LGRbOrP+nE6PBNvfqF2tH2CPpW5ppPYWNrTkzpCV8vCsv4Dk0w9vDUSQ/LZz8d
	 Ue3cwXTe1iuUf8M5bP4M7tpJMQUlW9AzKRsE2pZ+Hxd/wsqPXNhL3IlH1T9VCvaKC2KIh
	 RcHaH8uwfwvOpuIXFS56pVaNDOAD4F20BfBCG5FWNTjCY/2eyNP7MLOv/hPdvhiSv0jk2
	 bx4rHy8hED1uY198Keu9T2tw1uSgWQdCAS0x6WggPYOGWf57OIsrvYJWGe4LhJ91S4HMW
	 VYysBFrHFDgR3BP8NojsoIMJOfVDfEHjzgGiw3KDESGwfUTG+EDhjnp9tK3sZt7bX1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P5K2ZMZS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5FF606A326;
	Sat,  7 Nov 2026 14:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P5K2ZMZS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C131F0089F;
	Sat,  7 Nov 2026 14:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061506;
	bh=AAOoSANg/HU1P0s6pK4bH2FFsSvTHRSYOqUul/EsUQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5K2ZMZSxVB9V98H3HZj25p7gyDclkX12wRuq3oKHsOByiEyHNcUoUf20AoEW50qj
	 461TDBzzHwwhvGVu++SzQLfW8UOrOmDM2vSxqFUL/DH/C47mc0PSeYXJX76N3jMUmJ
	 +UiJbBsOlZBrUeiz/1d3mqMM3yy+A8791NK78Gsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Riley <d.riley@proxmox.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0598/1536] KVM: x86/mmu: pass PFERR_GUEST_PAGE/FINAL_MASK to kvm_translate_gpa
Date: Sat,  7 Nov 2026 08:43:34 -0500
Message-ID: <20261107135014.339596492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit bd1c40114b02cf63ba33da8e7df71ed0fc2a3019 ]

The XS/XU bit for EPT are only applied to final accesses, and use the
U bit from the page walk itself.  While strictly speaking not necessary
(any value of PFERR_USER_MASK would be the same for page table accesses,
because they're reads and writes only), it is clearer and less hackish
to only apply MBEC to PFERR_GUEST_FINAL_MASK.  Allow kvm-intel.ko to
distinguish the two cases.

Tested-by: David Riley <d.riley@proxmox.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[doebel: load_pdptrs() lives in arch/x86/kvm/regs.c in this tree; keep
this tree's mmu_is_nested() in the Hyper-V hunk]
Stable-dep-of: 96b067b59ad9 ("KVM: VMX: Synthesize nested EPT violation GVA_IS_VALID/GVA_TRANSLATED bits")
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/hyperv.c          | 3 ++-
 arch/x86/kvm/mmu/mmu.c         | 3 ++-
 arch/x86/kvm/mmu/paging_tmpl.h | 7 +++++--
 arch/x86/kvm/regs.c            | 3 ++-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 40660da6b7737..8987d8da4baac 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2055,7 +2055,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 * read with kvm_read_guest().
 	 */
 	if (!hc->fast && mmu_is_nested(vcpu)) {
-		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
+		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa,
+					PFERR_GUEST_FINAL_MASK, NULL);
 		if (unlikely(hc->ingpa == INVALID_GPA))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 	}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2ff392fa15518..a47ccba3dc7a9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4138,7 +4138,8 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 {
 	if (exception)
 		exception->error_code = 0;
-	return kvm_translate_gpa(vcpu, mmu, vaddr, access, exception);
+	return kvm_translate_gpa(vcpu, mmu, vaddr, access | PFERR_GUEST_FINAL_MASK,
+				 exception);
 }
 
 static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ce467bc3383c9..9e17ebcc4c318 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -377,7 +377,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
 		real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(table_gfn),
-					     nested_access, &walker->fault);
+					     nested_access | PFERR_GUEST_PAGE_MASK,
+					     &walker->fault);
 
 		/*
 		 * FIXME: This can happen if emulation (for of an INS/OUTS
@@ -445,7 +446,9 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		gfn += pse36_gfn_delta(pte);
 #endif
 
-	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
+	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn),
+				     access | PFERR_GUEST_FINAL_MASK,
+				     &walker->fault);
 	if (real_gpa == INVALID_GPA)
 		return 0;
 
diff --git a/arch/x86/kvm/regs.c b/arch/x86/kvm/regs.c
index 49afacc9b0990..ffc518cc93079 100644
--- a/arch/x86/kvm/regs.c
+++ b/arch/x86/kvm/regs.c
@@ -166,7 +166,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * to an L1 GPA.
 	 */
 	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(pdpt_gfn),
-				     PFERR_USER_MASK | PFERR_WRITE_MASK, NULL);
+				     PFERR_USER_MASK | PFERR_WRITE_MASK |
+				     PFERR_GUEST_PAGE_MASK, NULL);
 	if (real_gpa == INVALID_GPA)
 		return 0;
 
-- 
2.53.0



