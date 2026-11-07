Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061146;
	b=zR+4VLa5dfhmO3K+CSNDClwxbkYFFEjQLHzqjUYSr4PpR5LIuJ4bgrkwGmDh1fRMY03l
	 4aYoVOjWK6BAKajAJFfgR42rPYC1x1NAgJNitlolL8NlDXZxwA+SnqCsQ0QVpYr4KjHBD
	 plPrmAUpdqe5GlBarfFW+0/jV41SnhXh+QdAxycinEe+uluowx7UcA1CQHLsDBoR0eoH5
	 ic8hodVUUX0OssJPnSJ8ru4OURzbduDuKjeuotJKGTJpuVACUmyrqBUjFjJmwDHzxcaQB
	 eoSfkzpFRkQWB+Y/RNRTRgNuVADKwvNSQ9Vy1Adpjqkg31nmFk9m3VAAZzi78yNrqnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FH/KI0GzS88xBllP6tTnCJdUWXnVjl7GQJfuXL44JXE=;
	b=zoTiRUPMJjZ/YSNDEOTrJXNMg2mAmub9T4Ug6qy/6HvIsO2EZBi5Xc/74xymYYJUWLEA
	 b+3Yf7+z3ZjKlmAEOo35z5Nz2HQAAMPRy2NPaJRR3CFMMknC/KoSG0hxHJ2W4Lzbn8KNQ
	 bZKx2xU3bfMW8L7/qur2JTHlD5KaLoUE/6o8+Y9tRdmUZLzD1DlZMuE0tJxIDgzUQd6KI
	 XXQMgdo9rw/yn2iz/RnzTmKU+8A3p1ncDfxULAJubJS4z0vLwxc28qCEcbAeCdVx8M1yt
	 D88DGdJs/ELpciC8+tOoepflh4lmqUCEZhT1EKZZutPDK50tmB/dDjTD/Ao9twhGEAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2qbsktu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56420606A33E;
	Sat,  7 Nov 2026 14:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2qbsktu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F8E1F0089F;
	Sat,  7 Nov 2026 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061146;
	bh=FH/KI0GzS88xBllP6tTnCJdUWXnVjl7GQJfuXL44JXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qbsktu7i3xDTqrzW8NIRLaoMLa8SR6UNUnNDDEECnVSUL27LvV3Dpfzk64k4XNQw
	 JMk9Qugi9o5rM1+pIdOARYYp/0tvyHuKUPaWwGQFci4RRmigflwyKTBLqA8sfF5bNt
	 QsKfbgiwsZDxI3+gyvejmBslorGIAnriXKY1fWZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0452/1536] KVM: SEV: Extract loading of guest-provided VMSA to a separate helper
Date: Sat,  7 Nov 2026 08:41:08 -0500
Message-ID: <20261107135010.227285703@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 0060569e4f18a7dee2dd8728595e909f19a23c24 ]

Extract the loading/retrieval of a guest-provided VMSA to a separate helper
so that KVM can reuse the core logic when refreshing the VMSA after an MMU
invalidation from guest_memfd.

No functional change intended.

Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Michael Roth <michael.roth@amd.com>
Link: https://patch.msgid.link/20260709204948.1988414-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Kept the non-static function and its sev_snp_guest() check, and used direct mp_state assignments and kvm_release_pfn_clean(pfn) in place of kvm_set_mp_state() and the page-based release. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 58 +++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c086040ef11d1..e7f20e1b8d86f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3940,31 +3940,16 @@ static int snp_begin_psc(struct vcpu_svm *svm)
 	BUG();
 }
 
-/*
- * Invoked as part of svm_vcpu_reset() processing of an init event.
- */
-void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+static void sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_memory_slot *slot;
+	gfn_t gfn = gpa_to_gfn(gpa);
 	kvm_pfn_t pfn;
-	gfn_t gfn;
-
-	if (!sev_snp_guest(vcpu->kvm))
-		return;
-
-	guard(mutex)(&svm->sev_es.snp_vmsa_mutex);
 
-	if (!svm->sev_es.snp_ap_waiting_for_reset)
-		return;
+	lockdep_assert_held(&svm->sev_es.snp_vmsa_mutex);
 
-	svm->sev_es.snp_ap_waiting_for_reset = false;
-
-	/* Mark the vCPU as offline and not runnable */
-	vcpu->arch.pv.pv_unhalted = false;
-	vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
-
-	/* Clear use of the VMSA */
+	/* Clear use of the VMSA. */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 	svm->sev_es.snp_guest_vmsa_gpa = INVALID_PAGE;
 
@@ -3974,12 +3959,9 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	 */
 	vmcb_mark_all_dirty(svm->vmcb);
 
-	if (!VALID_PAGE(svm->sev_es.snp_pending_vmsa_gpa))
+	if (!VALID_PAGE(gpa))
 		return;
 
-	gfn = gpa_to_gfn(svm->sev_es.snp_pending_vmsa_gpa);
-	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
-
 	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (!slot)
 		return;
@@ -4003,7 +3985,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	svm->sev_es.snp_has_guest_vmsa = true;
 
 	/* Use the new VMSA */
-	svm->sev_es.snp_guest_vmsa_gpa = gfn_to_gpa(gfn);
+	svm->sev_es.snp_guest_vmsa_gpa = gpa;
 	svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 
 	/* Mark the vCPU as runnable */
@@ -4018,6 +4000,34 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 	kvm_release_pfn_clean(pfn);
 }
 
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	gpa_t gpa;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	guard(mutex)(&svm->sev_es.snp_vmsa_mutex);
+
+	if (!svm->sev_es.snp_ap_waiting_for_reset)
+		return;
+
+	svm->sev_es.snp_ap_waiting_for_reset = false;
+
+	/* Mark the vCPU as offline and not runnable */
+	vcpu->arch.pv.pv_unhalted = false;
+	vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+
+	gpa = svm->sev_es.snp_pending_vmsa_gpa;
+	svm->sev_es.snp_pending_vmsa_gpa = INVALID_PAGE;
+
+	sev_snp_reload_vmsa(vcpu, gpa);
+}
+
 static int sev_snp_ap_creation(struct vcpu_svm *svm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
-- 
2.53.0



