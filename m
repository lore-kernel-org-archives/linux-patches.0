Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831360;
	b=UoNUaSEmfdmmaZGexjOnNTWXYXzjHoJsPmKDavPYThCbhV4JLE+OxghWFhhlNxCCelxU
	 Bomx+Paxz4+EbqVhnQE+i4d2nAWsVxh0l2NIyHjvzVgo3IphlGLeGdB7uu3AbZW0ZiE26
	 M0MfElg4gActd87uxKUQlZpYdVwdy38tgT3Z7tQbdkUTK5c/6KKAGb3QxpsLAvNMjYRN1
	 Zf2Y9yxisYQe4DYWTF8VFLEmyJoZCzYf+ppL8B+KyYi4i/kLz5SP6gYdOvQFgd27U6qyE
	 ng3JJe3MmtuY+IsO0QDfOg6ml5k05Z5+M0a20vMi24/PGSVBgGfeMaMr+mBdT2mMqnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2WzTIXhtKhh97SnTlJSD5xky8G0ne1fQbcn6RUDrZSw=;
	b=Z8iPVK73S20FwX3Pwx6pbHo6fg3eMyujt+AwCEqGqjbVoe8A/WBX/NjeU5EdlIUfI+a/
	 WJj7HIXRn1uYPcJkPc7gZtjtJzYKLniuOFKfZWMebaPA7F6tMkF/m/9xoU6jnC/h7qQy8
	 /Sl/AOhZa2XgQr8Gt/Mxt7/0gGH8AtInqF+MottswWarQVe3X1wiocAIJtv9UpCQ4Devn
	 qZmv3SBZCBukmzlbZTcsc5QxnKx4LbaZpgc05Vhb0KJJRuQ3blZ2ocXyPu1sOv9ARvTwQ
	 nRRJnHGDaU+oNn43rMeGRigaWRdPRWUDiTTX2UBQXgZjeab2OVPyQxU93qSYGt+DZpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpJI0lwF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD87606A336;
	Wed,  4 Nov 2026 22:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpJI0lwF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB82A1F000C1;
	Wed,  4 Nov 2026 22:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831360;
	bh=2WzTIXhtKhh97SnTlJSD5xky8G0ne1fQbcn6RUDrZSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpJI0lwFsqxJSCRC11rakzN3BPsME/0ATII0S+Uid23ePKE4PjlK5YLQAnt1pwiQm
	 d9+Yz+ysgRpeeVA0QlQ4zKQ0kl36BJmi6gJSy/t4n1nH/3y081ZBiEIzYX1XwpkcWs
	 1QWIVXFw9WDL14OwfFKgQzmh9qrUcO7FBgQjgrhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Riley <d.riley@proxmox.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0657/1005] KVM: x86/mmu: pass PFERR_GUEST_PAGE/FINAL_MASK to kvm_translate_gpa
Date: Wed,  4 Nov 2026 16:06:30 -0500
Message-ID: <20261104211102.101313215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 56325ba9ef367..284adaf508688 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2056,7 +2056,8 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
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
index 1fa251ca4dccf..d365bba579d28 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4349,7 +4349,8 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 {
 	if (exception)
 		exception->error_code = 0;
-	return kvm_translate_gpa(vcpu, mmu, vaddr, access, exception);
+	return kvm_translate_gpa(vcpu, mmu, vaddr, access | PFERR_GUEST_FINAL_MASK,
+				 exception);
 }
 
 static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 07b0ddd15b9de..9f8c4293bbe78 100644
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
index 7b997c4e6329f..d19a9e7e41f37 100644
--- a/arch/x86/kvm/regs.c
+++ b/arch/x86/kvm/regs.c
@@ -122,7 +122,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
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



