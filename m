Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDC81D097D;
	Wed,  2 Oct 2024 14:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878967; cv=none; b=VeFFG7vSrP5AnVlnZjXdMGL2yLf+afkHSgq9fI3PN4raIBEe2qJLLaDkJAn6Cqlq8PmISqRK9VnkcRXo9e6DaJKYLC5z1auLT4VLEFlndJCOgxSgkoBC1pWXIlXHy2MeWTV+ZsaUXMJQIARZSok5nTy3eZkvvQH8VdFTnv6QyMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878967; c=relaxed/simple;
	bh=RUkQb291UoTPK1pxTfEs/myJwHZaYJfXY/mhyeCVcPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+xr3Ub5x8dQsTTLX3ILiHfqo9UHAFca0Lk/8O5V9nIe42p4NH5DuD9FgG2mo449G1nsYmruOk+Nii6a4qnC6SpHLdh9UfkhM6mo/p3X7pVU+3maoYSmOuR8v+DpMoseUr9TwJglAxCLCCcoHEwQDgIk2UdEx2B4748YyEvLky0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJLzCTqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJLzCTqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8B8C4CEC2;
	Wed,  2 Oct 2024 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878967;
	bh=RUkQb291UoTPK1pxTfEs/myJwHZaYJfXY/mhyeCVcPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJLzCTqjRCBYVGjqNCG0dd/o7mTNRgr62M6D1QTe7NhlxHhhLe/qLvXInxHTfncjV
	 rLOQr4rL6INoC60ncmBPQ0rU8IzFyqezI1qA/XN3utwRzrgXqKqSe7fXF3XbfzAP8o
	 NBX88TqDgpjUpfsPAELlsdUqJgcK+cp3GGJsT5c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 593/634] KVM: x86: Drop unused check_apicv_inhibit_reasons() callback definition
Date: Wed,  2 Oct 2024 15:01:33 +0200
Message-ID: <20241002125834.520752735@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

[ Upstream commit c7d4c5f01961cdc4f1d29525e2b0d71f62c5bc33 ]

The check_apicv_inhibit_reasons() callback implementation was dropped in
the commit b3f257a84696 ("KVM: x86: Track required APICv inhibits with
variable, not callback"), but the definition removal was missed in the
final version patch (it was removed in the v4). Therefore, it should be
dropped, and the vmx_check_apicv_inhibit_reasons() function declaration
should also be removed.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Link: https://lore.kernel.org/r/54abd1d0ccaba4d532f81df61259b9c0e021fbde.1714977229.git.houwenlong.hwl@antgroup.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 73b42dc69be8 ("KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/vmx/x86_ops.h      | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d0274b3be2c40..a571f89db6977 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1708,7 +1708,6 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
 	const unsigned long required_apicv_inhibits;
 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d404227c164d6..e46aba18600e7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -46,7 +46,6 @@ bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
 void vmx_migrate_timers(struct kvm_vcpu *vcpu);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
-bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
 void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void vmx_hwapic_isr_update(int max_isr);
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu);
-- 
2.43.0



