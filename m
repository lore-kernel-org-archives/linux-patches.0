Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044261;
	b=ewfvtW6FzWIrmdGsiDpaVXfz2vbTRI6JmlDpVXqDFSE8DXseGxfs/b7rAZG7vU8JbBgm
	 H8qFX/e6zOvJbtEkTXgbhRu9Mv4fed8hQE4hQ6HmXoOdXDaFsMZoOO7D0hBePdMh4yGnI
	 l9fxBWLvXRzKBBmpySVZSyN68uyAxPySAoU59JiLaFa98BzlfS1T0bgxmqM3y7TgR81Af
	 39lVzSp89K2dYQZlr03HdWFZiIb8s9GwtkXya4SOAiKyu0VRE0pmEfy7iZlkjYeEcISV3
	 CCV12VryZs1plHKkIppnSqNX9mhq2AAg8CTSuQeiIPI1zG847mlEZTntai75v1mA4cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1wSsgqc3nsZerNnZYngAIburH9qGHoJHLp3etM2snA=;
	b=MrJYZyJJt4NmxDANENjEDH1b1pFfNSl4tgXLBRl3yVuKI54tJQ8sAtoBTtA9RlNcMVvx
	 eF4oD/LIKDlHAl4BbQ1asM5v6yqw4e+DkHvMM3L2F+zgtKBUvJsSs+FSleCuUYHHLwDRA
	 ya5OJBtLSHv7pV4q2/LN6x6SFAvcCbgT7l+oZNMC5VtzU9U3jvin58ji8T11hDVQ+uVZF
	 DCy9kJb0xekhv0OFdQkBt1Ihzz2U8L25XQXnu8DLjk2TodqjHWwNROSZywc6bVKQHgvg5
	 972vtvm7yBrVkcpS2UoT57haBkXMI4Vjf3RkE6Q20dJKIVhX023z8PSmFggzxNHD+tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2UWrXX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC249606A320;
	Wed, 18 Nov 2026 23:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2UWrXX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD901F000C5;
	Wed, 18 Nov 2026 23:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044260;
	bh=u1wSsgqc3nsZerNnZYngAIburH9qGHoJHLp3etM2snA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2UWrXX3F9MtTt5iHk3nwrZOB3K7BJMGRM8t5hVx2VFjtEq/Xf1PuGX4cIde0KDnk
	 8LOPK5JWMjvAMG3v/ocvsZg9thtTmixw3ArT6MBdMSSaAGM3Noa0OzvYqAwNrDkmc4
	 5Y/ultigsFD8dmbWTc9kJBVTXkpirq4lkpC90qY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0467/2857] KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified
Date: Wed, 18 Nov 2026 15:25:01 +0100
Message-ID: <20261118150218.251930254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the CONFIG_KVM_HYPERV #ifdef context and placed the runtime_controls declaration at the top of copy_enlightened_to_vmcs12(), since this tree lacks that option. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 38649d769b416..fdca4b97ab9a6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1569,6 +1569,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 
 static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
 {
+	const u64 runtime_controls = HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1 |
+				     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2 |
+				     HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC;
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
 	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
 
@@ -1576,6 +1579,9 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 	vmcs12->tpr_threshold = evmcs->tpr_threshold;
 	vmcs12->guest_rip = evmcs->guest_rip;
 
+	if ((hv_clean_fields & runtime_controls) != runtime_controls)
+		vmx->nested.force_msr_bitmap_recalc = true;
+
 	if (unlikely(!(hv_clean_fields &
 		       HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC))) {
 		vmcs12->guest_rsp = evmcs->guest_rsp;
-- 
2.53.0



