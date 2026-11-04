Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831900;
	b=E25hF+/thj9tc8ZBGkcYX9aFoFUeG+Af68M/e+Kk4N3KayTTgaA33T/WebF96OdBHrli
	 3fB92tim2ycrTTwCAWEAmqDVm3pOI7wx97ya27tqB65NIB56lM4kE98/rEsuQL8lzkp6w
	 S51y5OgGRbHYkp1WZXLYocQT26KqWtvXLHZ6XS66fDnqU7rhojpGhxHfTzo3wtBRcCVdn
	 5ng4rctaQ46Drwpn+CL8+Z6VbQ8K46LgSoZug+pO0EyUGgpRPgr02yfaOFexQnx/zOMeW
	 Wh8wNxjoTJZcFSsOq0IJ2pzvjdb1gp0mGFvIKYz2G/ldxJs+DnU4F4aIFN0o7ssUGig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Hu0WhKRLNsSZqO9uiMlJFSbbpEcPjfmK+75l66UU+0=;
	b=bHkIvZ8J2TPd/EFR8igHY/4WiH3DZZ+2k9S2/iLkwwFDK8wo2sTXrj/FxFI1ZC4WGnAm
	 as7ThOgB1li3QmpsfzRFp8tzjhoJuldEHj2O9Hs9AlI1IQfi0IXVAFRTRiJrN8vT2CJCT
	 8/2DjqQaneF1VsBf722c6Ui9krBgtOdGdYOQgrdlqAzr7c4rVPbxAPNTaZoP0MvFD9irP
	 5vC8JsRRCOETf96+ZldIzHVkSENLF9qKudaH/RXPqAPbiciuTMfpQoA0GxwO7Pt7raMoc
	 eukJ4gp6F1PgAjer8fVfLZYy7BXFYWJ2w6/8bwnHg/HJrpTK1ELUUPEsY8N0pxCq/Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nk26N7+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E34606A85F;
	Wed,  4 Nov 2026 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nk26N7+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A716F1F000C1;
	Wed,  4 Nov 2026 22:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831899;
	bh=8Hu0WhKRLNsSZqO9uiMlJFSbbpEcPjfmK+75l66UU+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk26N7+CXVVNlv2pM/AspHvvMxtQUAll8ei2JyV7v/enWZ5t3lXOBliU3MCvXbHND
	 PwD+7Mcsp7PBMAEa89HN8ETfCToTF9z9lIH0YtMia1fVFv4wzVxjNxOp7Y1cndwPLK
	 NMMNPuBpGsdUsKFr12Sgdmm6Fpd7vfPQNDoRprEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 0943/1005] KVM: PPC: Book3S HV: Add preempt_disable() around virtual-mode HPTE bit-lock users
Date: Wed,  4 Nov 2026 16:11:16 -0500
Message-ID: <20261104211109.530013475@linuxfoundation.org>
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

From: Amit Machhiwal <amachhiw@linux.ibm.com>

commit abbbe5ff83e7c9ed3a4d61b73011f1df7bf87907 upstream.

kvmppc_hv_find_lock_hpte() requires virtual-mode callers to run with
preemption disabled, because it can return with HPTE_V_HVLOCK still held
until the caller later unlocks the HPTE.  Existing virtual-mode callers
in book3s_64_mmu_hv.c already follow that rule.

Two virtual-mode call paths do not:

1. kvmppc_handle_exit_hv() calls kvmppc_hpte_hv_fault() for hash-mode
   data-side and instruction-side faults after guest exit, with
   preemption already enabled.  kvmppc_hpte_hv_fault() calls
   kvmppc_hv_find_lock_hpte() directly.

2. kvmppc_pseries_do_hcall() executes virtual-mode handlers for HPT
   hcalls via kvmppc_pseries_do_hpt_hcall() with preemption enabled.
   The handlers for H_ENTER, H_REMOVE, H_READ, H_CLEAR_MOD, H_CLEAR_REF,
   H_PROTECT, and H_BULK_REMOVE spin on try_lock_hpte() or lock_rmap(),
   and H_ENTER also reaches kvmppc_do_h_enter(), which uses
   arch_spin_lock() on kvm->mmu_lock.  That raw lock choice is
   intentional because kvmppc_do_h_enter() is also used by real-mode
   callers, so the correct fix is to establish the proper preemption
   context at the virtual-mode caller boundary.

If a vCPU thread is preempted while holding HPTE_V_HVLOCK, any other
thread on the same CPU trying to acquire the same bit-lock can spin
indefinitely.  The same applies to lock_rmap() users and to the H_ENTER
path while holding the raw mmu_lock.

Fix this by adding preempt_disable()/preempt_enable() pairs around the
two kvmppc_hpte_hv_fault() call sites in kvmppc_handle_exit_hv(), and
around the kvmppc_pseries_do_hpt_hcall() invocation in
kvmppc_pseries_do_hcall().  Targeting only the HPT hcall helper avoids
wrapping non-HPT hcalls (such as H_RTAS, H_CONFER, H_REGISTER_VPA) that
perform page faults, blocking memory allocations, or context switches.

Fixes: 6165d5dd99db ("KVM: PPC: Book3S HV: add virtual mode handlers for HPT hcalls and page faults")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260928122837.8782-3-amachhiw@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1208,9 +1208,11 @@ int kvmppc_pseries_do_hcall(struct kvm_v
 	case H_CLEAR_REF:
 	case H_PROTECT:
 	case H_BULK_REMOVE:
+		preempt_disable();
 		idx = srcu_read_lock(&kvm->srcu);
 		ret = kvmppc_pseries_do_hpt_hcall(vcpu, req);
 		srcu_read_unlock(&kvm->srcu, idx);
+		preempt_enable();
 		if (ret == H_TOO_HARD)
 			return RESUME_HOST;
 		break;
@@ -1830,8 +1832,10 @@ static int kvmppc_handle_exit_hv(struct
 		else
 			vsid = vcpu->arch.fault_gpa;
 
+		preempt_disable();
 		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
 				vsid, vcpu->arch.fault_dsisr, true);
+		preempt_enable();
 		if (err == 0) {
 			r = RESUME_GUEST;
 		} else if (err == -1 || err == -2) {
@@ -1877,8 +1881,10 @@ static int kvmppc_handle_exit_hv(struct
 		else
 			vsid = vcpu->arch.fault_gpa;
 
+		preempt_disable();
 		err = kvmppc_hpte_hv_fault(vcpu, vcpu->arch.fault_dar,
 				vsid, vcpu->arch.fault_dsisr, false);
+		preempt_enable();
 		if (err == 0) {
 			r = RESUME_GUEST;
 		} else if (err == -1) {


