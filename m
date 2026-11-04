Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831857;
	b=y/YE5BZW8i1vLRl8ShmsXXyDw1VO4/Zn06sQbqtfOPkiv3UdxfuHS9RM4kC7ey4b3b6g
	 YA5uosNW1UajhMGJYnc+pHo354yfFSSIZv1dHfArRqs6If2hxtUQ8jdwkvs/nQ0dFh93X
	 uIpX2Hqcuib/+EQrqtsnjA6LMdDzpY/3qDWMVkQNW6rExz5P2zLu47MPLngwse/OrhoQl
	 H8WioqAXz8+EnqcDJQR3lBhIALFVRDFYTbBH9pCfeMxFMF82MT9d297bZ3OWBvmKGeFwc
	 FGUgFvuGPcwkx3R7vvpn+tWMAHpCO5CF7J4JPe1Nm//9cAkfMHLtAFO1uZkneOc5PWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oDaShTwZP3Wf2FtO1+MiWuowyOVXZmzWIpBNDus5T4Y=;
	b=wZKqilr1yP64RbanV0gZ+mYwYIlGcqS72rsm7W0dfzYAveCkHytAYUt5bMg0lDwu5f3e
	 uFt6i6OpE9hmbc6e4SED9Wi2cKEcbhhqLJvDVNU5g/0i6KysEvnVwEhsJ3Dz/CIxI+8rO
	 LFCIP7iWixuIZBKxVnTd6DATyFrTFYxjY0NM0PNT42hC6MzHh0VkfV9iVIQgu0UcGe2i1
	 F9RDs1rqN6j/GEpDoumPPdMaRtUtA2YP+F+irsPRQ8bhGioA+VU2tnSzQ4aypP6m9xvyf
	 g5zacjO5DA7ywSmNKu0Y9lmRwu5GK+znP54ccj+an45CyJxqag4oEkwM+4M6dPWve3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=svE0gnhS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143A0606A328;
	Wed,  4 Nov 2026 22:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=svE0gnhS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C1D1F000C1;
	Wed,  4 Nov 2026 22:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831856;
	bh=oDaShTwZP3Wf2FtO1+MiWuowyOVXZmzWIpBNDus5T4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svE0gnhS0B3/O3ZSDNKhRLCIBhUmNgTk2t/tXB1q/BB+153wILnTdP1Rj27NdMwgx
	 hnD66tL5Jcw+WmyT32vijO5eHwojibke2qnmO9IQvnLL9udoOvotY1eDXDvMmoJV/j
	 vlTL5Z2dv0Lnj195XYw5g6Jo5cbjidlJzgf3IT1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 6.18 0940/1005] KVM: TDX: Check if there is valid exit infos based on vp_enter_ret
Date: Wed,  4 Nov 2026 16:11:13 -0500
Message-ID: <20261104211109.452458036@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit 0966c881ea13be5ec89820c185de4d55568e80ed upstream.

Check if there is valid exit info based on vp_enter_ret instead of relying
on the clobbered Exit Reason, in tdx_get_exit_info().

Current KVM uses "Exit Reason is not equal to the synthesized invalid
Exit Reason, -1u," as the condition to identify there is a real TD Exit
and valid exit infos.  However, there is one issue with this approach:
KVM updates the Exit Reason to the synthesized invalid Exit Reason for
real EPT MISCONFIG as well.  This is a false positive for real EPT
MISCONFIG, which has valid exit infos.

Though the issue can be addressed by changing the handling for real EPT
MISCONFIG to not update the Exit Reason to the synthesized one, relying
on the clobbered Exit Reason itself is brittle.  Instead, check
vp_enter_ret directly to identify if it is a valid Exit Reason.

Fixes: da407fe45908 ("KVM: TDX: Handle EPT violation/misconfig exit")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-3-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -885,21 +885,27 @@ static __always_inline u32 tdcall_to_vmx
 	return EXIT_REASON_TDCALL;
 }
 
-static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+static __always_inline bool tdx_is_exit_reason_valid(u64 vp_enter_ret)
 {
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	u32 exit_reason;
-
-	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
+	switch (vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
 	case TDX_SUCCESS:
 	case TDX_NON_RECOVERABLE_VCPU:
 	case TDX_NON_RECOVERABLE_TD:
 	case TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE:
 	case TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE:
-		break;
+		return true;
 	default:
-		return -1u;
+		return false;
 	}
+}
+
+static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u32 exit_reason;
+
+	if (!tdx_is_exit_reason_valid(tdx->vp_enter_ret))
+		return -1u;
 
 	exit_reason = tdx->vp_enter_ret;
 
@@ -2153,7 +2159,7 @@ void tdx_get_exit_info(struct kvm_vcpu *
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	*reason = tdx->vt.exit_reason.full;
-	if (*reason != -1u) {
+	if (tdx_is_exit_reason_valid(tdx->vp_enter_ret)) {
 		*info1 = vmx_get_exit_qual(vcpu);
 		*info2 = tdx->ext_exit_qualification;
 		*intr_info = vmx_get_intr_info(vcpu);


