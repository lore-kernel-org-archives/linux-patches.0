Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064178;
	b=vfQrUnsCUX6UbKbyrWDOY4pVeKCr6dl33m3Ktfn0aGAWXDMgP66+rKyVwZUUFd/OoHZo
	 ZF8LXFQ9tuCoQardDvBW9pCuYmtaZxHRNIGSRplDiBSJ4Z93VW72kzLyKyCq7rQSsOLKs
	 S+P0fkOYJGNaLUHZzqOfLOGjM1Uo6pBZtnCYIebqcM/Byr+sgFPvppsMLTAhocsX7nmu3
	 qU5nmiwPkKGRlXIi3Kb483P3P2A6pHI/MpPO1Csjp4wIJfaePe3/IkMMvYZlV8z3/acDB
	 Zly3SFqTieJlvf7wKyQhvXyPHCTXScOm8Pthu/EMTjQh6XThNzllthq2tgIxGvCsqWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EyOcKsLrj2Q54kVT/zHE/iv9bki2QaJLzZ9bZGo0lA0=;
	b=uBicC7NRKidKvGrxnHn6C/dnfXkMnnpFkEA8JMw7lnKuQkvUyAEku0X+qI9kIxILJ99s
	 4EXtKQ/3Bs+MkYDevcqC0p+AVI2U0xTGJnaXz8z9BTeljb5LH3HaXsTjExVY0ZAB9NF+b
	 ixUuqyUVLcMihNCqSgOpCfvk7q8jdsVMK28XQuHpozcaQKoULIM5XbAaYdUzhkzmJlSgV
	 w2kRdj4pgN6A+AfrvpkMtQERm8oIiI82fl1Z7A8UMiBdVsyZ3fypcEiwolweLafPMojs1
	 BMiptXYCZBNBAQ+P4In2LLpdcqVNfRvnWrlTtTk7WTdavUPnzdSpGOnhvqjgE4ZK+nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bA8HaOtC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182B3606A335;
	Sat,  7 Nov 2026 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bA8HaOtC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEEB1F008A2;
	Sat,  7 Nov 2026 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064178;
	bh=EyOcKsLrj2Q54kVT/zHE/iv9bki2QaJLzZ9bZGo0lA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bA8HaOtCy0BMGhxvw6bWz8yEim0H1VZ4CpDexm3GbY1XipoEuNArHkjqJGNOi2c29
	 V0c2iG6EJ10rt9u6ewJVEydC3vIK7UiQmLQFKbPOYBp6D05xpX+/z+GH5EDsy9CUvM
	 7yqjxTkHS2GqXi+0TwuKMT5zNLps1R11+wtDFqYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0295/1257] KVM: arm64: ptdump: Fix shadow ptdump sleep-in-atomic-context problem
Date: Sat,  7 Nov 2026 08:43:11 -0500
Message-ID: <20261107134947.613447733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Wei-Lin Chang <weilin.chang@arm.com>

[ Upstream commit b1cc219eb21ab5f31fe4caa32be8057159e42db5 ]

Previously we exposed shadow page tables by creating a debugfs ptdump
file whenever a nested mmu instance gets bound to a new context, and
deleting the debugfs file whose context was getting unbound.

This turned out to be buggy, as the instance<->context binding process
is done with the mmu_lock held, and debugfs creation/deletion can sleep.

Change the approach and create a shadow ptdump file for each nested mmu
instead during kvm_vcpu_init_nested(), in a sleepable context. The files
will be named nested_mmu<index>, and reading it will return the nested
context's VTTBR, VTCR, and s2 enabled or not before dumping the shadow
page tables, given the nested mmu is valid.

Fixes: 19e15dc73f0f ("KVM: arm64: nv: Expose shadow page tables in debugfs")
Reported-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Closes: https://lore.kernel.org/kvmarm/aiuF0KSvvv-ZozI1@sm-arm-grace07/
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260924094951.727352-3-weilin.chang@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h |  6 ++----
 arch/arm64/kvm/nested.c          |  9 ++++-----
 arch/arm64/kvm/ptdump.c          | 32 +++++++++++++++-----------------
 3 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6eae7e7e2a684..ac2b0637692ad 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -392,12 +392,10 @@ static inline bool kvm_supports_cacheable_pfnmap(void)
 
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
-void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu);
-void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu);
+void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu, int idx);
 #else
 static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
-static inline void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu) {}
-static inline void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu) {}
+static inline void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu, int idx) {}
 #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index b191365d97cc2..41253fe45941c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -124,6 +124,9 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 			return ret;
 		}
 
+		for (i = 0; i < S2_MMU_PER_VCPU; i++)
+			kvm_nested_s2_ptdump_create_debugfs(&tmp[i], i + kvm->arch.nested_mmus_size);
+
 		guard(write_lock)(&kvm->mmu_lock);
 
 		for (i = 0; i < S2_MMU_PER_VCPU; i++)
@@ -837,10 +840,8 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
 
 	/* Make sure we don't forget to do the laundry */
-	if (kvm_s2_mmu_valid(s2_mmu)) {
-		kvm_nested_s2_ptdump_remove_debugfs(s2_mmu);
+	if (kvm_s2_mmu_valid(s2_mmu))
 		s2_mmu->pending_unmap = true;
-	}
 
 	/*
 	 * The virtual VMID (modulo CnP) will be used as a key when matching
@@ -854,8 +855,6 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
 	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM;
 
-	kvm_nested_s2_ptdump_create_debugfs(s2_mmu);
-
 out:
 	atomic_inc(&s2_mmu->refcnt);
 
diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index b5a0584260e8b..7829fe376385b 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -17,7 +17,7 @@
 
 #define MARKERS_LEN		2
 #define KVM_PGTABLE_MAX_LEVELS	(KVM_PGTABLE_LAST_LEVEL + 1)
-#define S2FNAMESZ		sizeof("0x0123456789abcdef-0x0123456789abcdef-s2-disabled")
+#define S2FNAMESZ		sizeof("nested_mmu0000")
 
 struct kvm_ptdump_guest_state {
 	struct kvm_s2_mmu	*mmu;
@@ -173,6 +173,15 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 		.seq		= m,
 	};
 
+	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
+		if (kvm_s2_mmu_valid(mmu))
+			seq_printf(m, "VTCR: 0x%016llx VTTBR: 0x%016llx s2: %s\n",
+				   mmu->tlb_vtcr, mmu->tlb_vttbr,
+				   mmu->nested_stage2_enabled ? "enabled" : "disabled");
+		else
+			return 0;
+	}
+
 	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
 	if (ret)
 		return ret;
@@ -299,26 +308,15 @@ static const struct file_operations kvm_pgtable_levels_fops = {
 	.release	= kvm_pgtable_debugfs_close,
 };
 
-void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu)
+void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu, int idx)
 {
-	struct dentry *dent;
 	char file_name[S2FNAMESZ];
 
-	snprintf(file_name, sizeof(file_name), "0x%016llx-0x%016llx-s2-%sabled",
-		 mmu->tlb_vttbr,
-		 mmu->tlb_vtcr,
-		 mmu->nested_stage2_enabled ? "en" : "dis");
-
-	dent = debugfs_create_file(file_name, 0400,
-				   mmu->arch->debugfs_nv_dentry, mmu,
-				   &kvm_ptdump_guest_fops);
+	snprintf(file_name, sizeof(file_name), "nested_mmu%d", idx);
 
-	mmu->shadow_pt_debugfs_dentry = dent;
-}
-
-void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu)
-{
-	debugfs_remove(mmu->shadow_pt_debugfs_dentry);
+	debugfs_create_file(file_name, 0400,
+			    mmu->arch->debugfs_nv_dentry, mmu,
+			    &kvm_ptdump_guest_fops);
 }
 
 void kvm_s2_ptdump_create_debugfs(struct kvm *kvm)
-- 
2.53.0



