Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034861;
	b=IOLNUR0jmgT+ccH/VBVvMHAea6PqvygQU3HCn7+iSzlKmgpsgua0REvFR81vlyyxospC
	 3ugv7Sxakb+IJ8MlO0cYiF5JFunyhXp82lhjjm6fjAYzJ5Cnr4xjhRwTZyrUq3zfKncpQ
	 aw/HwNy7z34FJ2+ozekSqXJUUINP2l4Ua3xfiMVb5J6F51KdJHDaGk/fpY8XI2zN4ZN0i
	 eLWYpsGYhpphz8IWvvyETlbArpI9t106lO31BDZL1Dx+7jS1gh/a0u4sEAu9q5fluBb6m
	 f8V1HLMGOecQCru1g71qwQRhnxIvCVz2Xt25sK2rqiRLLgc3oCDhBT7U0IKi4qzvr6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=flRt5UeP8SjU4TuYpw1RghRbqBG58txrYTFfwZxAkVI=;
	b=jo4YYboCpAbCIlNDsqoiwztyNo7Hbm0LvtriAqx5vYjpe7FmYdYzdJ2nxGOabLSYXL3G
	 rp6eztIVQAln4xNaEtkJfPMmIJDm0H1VdYUy95FMFX28lK9qX3wvniC//Qva+W1Z2Nsfq
	 8whz54BYOYT/09+MyZFjsYVQGsTUr65WM1d67W16/dFOfep6VID4zmkM5aMRz6MQc5Qkl
	 ToPZtYMXsU5AvheRdAYxLSrgsbD5QaECCM301qgqVIzVBlk7Zp2p2rPv/zEhn2dOyYQwe
	 ErjdmmOWE894Diy/jEfWGMR9qBZ/eOUSijGONxdtFj/pc+TJe3o4iwXSAkIabrBByOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cktgb5Ul;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E65606A31C;
	Wed, 18 Nov 2026 20:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cktgb5Ul
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4591F000C4;
	Wed, 18 Nov 2026 20:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034860;
	bh=flRt5UeP8SjU4TuYpw1RghRbqBG58txrYTFfwZxAkVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cktgb5UlB5nFHkFb5GwpD1mJhFWK8HsqKVbibF6rnLY/6kOcKmvPinOAG3ZPPp0bx
	 TUdGj0V9m1vmXlHsegUU9s+6ohgsReKvUp+O7BHfYBnr7TNhvy5WHDDoU2U4hX9LsD
	 WIGC41LORMCpcQsmgAwcA2s10q/R61kNxeiuCAjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0519/3318] KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified
Date: Wed, 18 Nov 2026 15:19:01 +0100
Message-ID: <20261118150332.733420676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 2abb25273c82061dd4670690c81c319c03740bf6 ]

Force a refresh of the vmcs02 MSR bitmap during nested VM-Enter if the
runtime eVMCS controls (pin, primary, secondary, etc.) are being updated.
If L1 isn't intercepting TPR writes, runs L2 with TPR virtualization, and
then runs the same L2 with TPR virtualization disabled, KVM will fail to
refresh msr_bitmap02 and leave TPR in passthrough mode even though TPR
virtualization is disabled.  I.e. failure to refresh the bitmap lets L2 (or
L1 by proxy) read and write L0's TPR.

Fixes: 502d2bf5f2fd ("KVM: nVMX: Implement Enlightened MSR Bitmap feature")
Cc: stable@vger.kernel.org
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 34868396ccbfe..c32a05ad274d2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1622,6 +1622,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
 {
 #ifdef CONFIG_KVM_HYPERV
+	const u64 runtime_controls = HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1 |
+				     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2 |
+				     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC;
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
@@ -1630,6 +1633,9 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 	vmcs12->tpr_threshold = evmcs->tpr_threshold;
 	vmcs12->guest_rip = evmcs->guest_rip;
 
+	if ((hv_clean_fields & runtime_controls) != runtime_controls)
+		vmx->nested.force_msr_bitmap_recalc = true;
+
 	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL))) {
 		hv_vcpu->nested.pa_page_gpa = evmcs->partition_assist_page;
-- 
2.53.0



