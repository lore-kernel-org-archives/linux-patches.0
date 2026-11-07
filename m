Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065390;
	b=1wSPnHOK8AeiB3dIvjZSIOsM0PNTnBURtN9Yw5mA4sR6ss8kX1EFNAP/p664IjnLDqFH
	 8eH+ctwvfG2Zf53sg597gB4PJADE8P+b42QcMJanhBqOO09oZRG4ZIfBCoLs7vPR/fpZP
	 /yqqtz5f+WSLBm0Zn+bgIsGgLtHLW9XTywc1CZYm1xDGtO4GLpXtQh5KWg3biw9pGx81H
	 TIYDUgQq+12j8MH4W6iUrGVL9aV57QiX3dakj4yQcA8yOXfz7sjnZtMGlWBAFVhrZSqVk
	 LIVopIvcMMAMugIM5yAI5ZBTd1Qz13ahWs1G6qquNr76orX1P3crPW5HsC2Et2QJaiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KaLWd26RiDb0r2o+JEbnm9gScclooonQhh4B5tRqYJE=;
	b=eNT70+B3qW3Uk+vkHdORXow+lpDYcemoi8JG8wcjc4NxtHu66LL9fsiVsB0U2IloBrPa
	 Um29dJLL1kzQlWUGYwRJkv5Jllj8gSPogPtPXz1X8IcUV25cGyFi+FIBOrGEFXK3tOZSg
	 Jcuba85D3GDFLyiXBhiMWSf+nTXSC7eC0NISwjinX18pxxxNKhw5Ust22XSzjcVw13ev1
	 i/JjjEp/KdPzP8IvKOxpEJ7NxDU9jETDWYlAQUqwvhAu/fPEMGq9P2HgijcMc3UVkhe1S
	 Lb6N2OtTrAN1xDumm330NWBZOf0na2+kQoEAO5j9woZsZnQr0HLw8AykqNzAVSa8e9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ylcj328;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B163606A32C;
	Sat,  7 Nov 2026 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ylcj328
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5EE1F0089F;
	Sat,  7 Nov 2026 15:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065390;
	bh=KaLWd26RiDb0r2o+JEbnm9gScclooonQhh4B5tRqYJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ylcj32825M0osBL9M4SLJfBk6gbeJ7LJHf38WiVz7cNMomp2Uuu38JcuHZcyFF1+
	 Z9gAXvhTtCrovUWgjPlcId6NhhzgkA48PkyQ0x3/nGWPJ7zxrxK0+8hA0iJy//PwE+
	 ruGlv2FjeGeYAuAXiAskd4FlHwTHa1h1Tjb9m4Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1113/1257] KVM: arm64: Sanitise ID_AA64MMFR3_EL1.S1P[IO]E
Date: Sat,  7 Nov 2026 08:56:49 -0500
Message-ID: <20261107135009.985988283@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 68c11eed4f8097ef1b71c30679e96eb654df29e0 ]

KVM uses the VM's ID registers as the source of truth for what the
guest has, but userspace can expose S1PIE or S1POE without the features
they imply. As per the architecture, both imply TCR2 and ATS1A, and
S1POE also implies HPDS. With TCR2 hidden, the world switch skips
PIR_EL1, PIRE0_EL1 and POR_EL1 while KVM doesn't trap them, so the guest
accesses registers that are neither trapped nor switched. Under VHE,
that leaks values between guests. On nVHE and hVHE, pKVM included, the
host kernel resumes with the guest's PIR_EL1 and PIRE0_EL1.

On first run, clear S1PIE and S1POE from the VM's ID registers when the
features they imply are missing, before anything derives state from
them. The guest and userspace then see neither feature, and the guest's
accesses to their registers UNDEF.

Fixes: 70ed7238297fb ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Fixes: d4a89e5aee23e ("KVM: arm64: Expose S1PIE to guests")
Reported-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20260930-arm64-gcs-v21-2-3556644cd927@kernel.org
Link: https://lore.kernel.org/r/8633u229lq.wl-maz@kernel.org
Cc: stable@vger.kernel.org
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Link: https://patch.msgid.link/20261020064306.1542865-1-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/config.c           | 78 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  2 +
 3 files changed, 81 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9c068f27f9b8a..d7caf8c4a11e7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1658,6 +1658,7 @@ static inline bool kvm_arch_has_irq_bypass(void)
 	return true;
 }
 
+void kvm_idregs_enforce_dependencies(struct kvm *kvm);
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
 struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg);
 void check_feature_map(void);
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1053676551aff..cfdb6c7133204 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -59,6 +59,7 @@ struct reg_feat_map_desc {
 	const struct reg_bits_to_feat_map feat_map;
 	const struct reg_bits_to_feat_map *bit_feat_map;
 	const unsigned int		  bit_feat_map_sz;
+	const unsigned int		  idreg_idx;
 };
 
 #define __NEEDS_FEAT_3(m, f, w, id, fld, lim)		\
@@ -130,6 +131,21 @@ struct reg_feat_map_desc {
 		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
 	}
 
+/*
+ * Declare the dependency between the features advertised in an id
+ * register, and the set of other features they depend on. This
+ * generates a struct reg_feat_map_desc.
+ */
+#define DECLARE_IDREG_FEAT_MAP(n, r, m, f)				\
+	struct reg_feat_map_desc n = {					\
+		.name			= #r,				\
+		.feat_map		= NEEDS_FEAT(~(r##_RES0 |	\
+						       r##_RES1), f),	\
+		.bit_feat_map		= m,				\
+		.bit_feat_map_sz	= ARRAY_SIZE(m),		\
+		.idreg_idx		= IDREG_IDX(SYS_##r),		\
+	}
+
 #define FEAT_SPE		ID_AA64DFR0_EL1, PMSVer, IMP
 #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
 #define FEAT_TRC_SR		ID_AA64DFR0_EL1, TraceVer, IMP
@@ -205,6 +221,7 @@ struct reg_feat_map_desc {
 #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
 #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
 #define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
+#define FEAT_HPDS		ID_AA64MMFR1_EL1, HPDS, IMP
 #define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
 #define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
 #define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
@@ -280,6 +297,25 @@ static bool feat_anerr(struct kvm *kvm)
 		kvm_has_feat(kvm, ID_AA64MMFR3_EL1, SNERR, FEAT_ANERR));
 }
 
+/*
+ * S1PIE and S1POE imply TCR2 and ATS1A, and S1POE also implies HPDS, but
+ * userspace can set them independently.
+ */
+static bool feat_s1pie(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, FEAT_S1PIE) &&
+		kvm_has_feat(kvm, FEAT_TCR2) &&
+		kvm_has_feat(kvm, FEAT_ATS1A));
+}
+
+static bool feat_s1poe(struct kvm *kvm)
+{
+	return (kvm_has_feat(kvm, FEAT_S1POE) &&
+		kvm_has_feat(kvm, FEAT_TCR2) &&
+		kvm_has_feat(kvm, FEAT_ATS1A) &&
+		kvm_has_feat(kvm, FEAT_HPDS));
+}
+
 static bool feat_sme_smps(struct kvm *kvm)
 {
 	/*
@@ -1299,6 +1335,14 @@ static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
 static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
 			      vtcr_el2_feat_map, FEAT_AA64EL2);
 
+static const struct reg_bits_to_feat_map id_aa64mmfr3_el1_feat_map[] = {
+	NEEDS_FEAT(ID_AA64MMFR3_EL1_S1PIE, feat_s1pie),
+	NEEDS_FEAT(ID_AA64MMFR3_EL1_S1POE, feat_s1poe),
+};
+
+static const DECLARE_IDREG_FEAT_MAP(id_aa64mmfr3_el1_desc, ID_AA64MMFR3_EL1,
+				    id_aa64mmfr3_el1_feat_map, FEAT_AA64EL1);
+
 static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] = {
 	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
 		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
@@ -1408,6 +1452,40 @@ void __init check_feature_map(void)
 	check_reg_desc(&ich_hfgitr_desc);
 }
 
+static const struct reg_feat_map_desc *idreg_feat_maps[] = {
+	&id_aa64mmfr3_el1_desc,
+};
+
+static bool idreg_apply_deps(struct kvm *kvm, const struct reg_feat_map_desc *r)
+{
+	struct resx resx = {};
+	u64 val;
+
+	for (int i = 0; i < r->bit_feat_map_sz; i++) {
+		if ((r->bit_feat_map[i].flags & CALL_FUNC) &&
+		    !r->bit_feat_map[i].match(kvm))
+			resx.res0 |= reg_feat_map_bits(&r->bit_feat_map[i]);
+	}
+
+	val = kvm->arch.id_regs[r->idreg_idx];
+	kvm->arch.id_regs[r->idreg_idx] &= ~resx.res0;
+	kvm->arch.id_regs[r->idreg_idx] |= resx.res1;
+
+	return val != kvm->arch.id_regs[r->idreg_idx];
+}
+
+void kvm_idregs_enforce_dependencies(struct kvm *kvm)
+{
+	bool again;
+
+	do {
+		again = false;
+
+		for (int i = 0; i < ARRAY_SIZE(idreg_feat_maps); i++)
+			again |= idreg_apply_deps(kvm, idreg_feat_maps[i]);
+	} while (again);
+}
+
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
 {
 	u64 regval = kvm->arch.id_regs[map->regidx];
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a2f4e769a4282..cac62ed43767c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5884,6 +5884,8 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 	if (kvm_vm_has_ran_once(kvm))
 		return 0;
 
+	kvm_idregs_enforce_dependencies(kvm);
+
 	/*
 	 * This hacks into the ID registers, so only perform it when the
 	 * first vcpu runs, or the kvm_set_vm_id_reg() helper will scream.
-- 
2.53.0



