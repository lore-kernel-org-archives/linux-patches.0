Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043879;
	b=hHz5HJo2Co7YjJ40Tgp7RnHNtmZHJA0rG1OZWMLeRiqpiGW+jE4m+quyMNHElMDSm0sM
	 3cVu2gfTHKceGjTpDPPGjfkf6aG+GvKKnlWtV0gm2U3x8YbeaURilKySmP19FX2SORjXu
	 WRRo1pt25k7EQ1ujZ3o5R0g8Czv1ORlIOB8b/tWzNS3Paf2KPpr85HedFtk2xK+urrp81
	 uPUgY69VGWCSxjvf2dpDinFeh474Zyah67NWuW54gQpSlfhF6SaivaFglfZOZS7RpL5xM
	 2IYxtrNReoPV+VQZgo4JJeOr55vsjQpyPscWyzTVLKwkLlBiF/GjPPWtg5AAS/ATiMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z4Bx3alB76ZY4YgylrRpk8OAazRaw2sB4VsU3QzAkTI=;
	b=i/ovA8bau/4AXhWkQbJWX7BAZbGYT/ORbHX/Z5M3L5etOgZqtRBO65dR4eWxBmcYR0ee
	 l8TB6nUyWCcdBigIzIPMb7l/Ndtrag9gBezFG3GWsuHsZkfawRytggH/0tHxnCY+Op6a4
	 +DH0zMirjVl6jLtgDcIKR1CjSoM4ye4DtQxrkkwTA4AkfiDuYlr3GdlOO3/umBglw3jQn
	 FCU9sljBpb2ASG7e3vHxO2YlYZW33RwWZkP/ezqF5L8glPv0K2gKrob1Y/+AVpG/tZ051
	 pjuYP0XOOPXDNA1KGwjCRms66S0V2d4uqq43PzSi7eGG0aNUq73jW7wFP660ioEEW0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K+51VfjZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32635606A31C;
	Wed, 18 Nov 2026 23:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K+51VfjZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3163C1F000C4;
	Wed, 18 Nov 2026 23:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043878;
	bh=Z4Bx3alB76ZY4YgylrRpk8OAazRaw2sB4VsU3QzAkTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+51VfjZ5EBuXQGWIE0YXbXyQ50yzQVvLsej0M9Yre8QnvE4FLsVkQ/9cTFCjD9N/
	 Qc25S0vkwafoPzVwEwp6PqNG2mcyduZDyM1jo2aCEQJkdjbwB9rNxPMkWQ6cpHc/6c
	 mxCmOOpyYi1jWwvA83yaeHoTfsu6LR3w0xO0wxHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0327/2857] KVM: nVMX: Decouple INVVPID operand checks from flushing of vpid02
Date: Wed, 18 Nov 2026 15:22:41 +0100
Message-ID: <20261118150213.214648927@linuxfoundation.org>
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

[ Upstream commit 32912404b4b1ee98400744941c78f019a63d6e8f ]

Separate the INVVPID operand checks from the actual flushing of vpid02 so
the flushing can be adjusted to do the right thing when vmcs02  was last
loaded on a different pCPU, without having to duplicate the logic across
multiple case-statements.

Opportunistically let the VM-Fail paths poke out past 80 chars.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20260616214652.2157032-3-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Used is_noncanonical_address() instead of is_noncanonical_invlpg_address() and dropped the LAM comment, since this tree lacks LAM support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ca610108c4b72..972191dfe66d3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5819,7 +5819,6 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		u64 vpid;
 		u64 gla;
 	} operand;
-	u16 vpid02;
 	int r, gpr_index;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
@@ -5854,8 +5853,14 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return kvm_handle_memory_failure(vcpu, r, &e);
 
 	if (operand.vpid >> 16)
-		return nested_vmx_fail(vcpu,
-			VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+		return nested_vmx_fail(vcpu, VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+
+	if (type != VMX_VPID_EXTENT_ALL_CONTEXT && !operand.vpid)
+		return nested_vmx_fail(vcpu, VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+
+	if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR &&
+	    is_noncanonical_address(operand.gla, vcpu))
+		return nested_vmx_fail(vcpu, VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
 	/*
 	 * Always flush the effective vpid02, i.e. never flush the current VPID
@@ -5863,29 +5868,10 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * VMCS, and so whether or not the current vmcs12 has VPID enabled is
 	 * irrelevant (and there may not be a loaded vmcs12).
 	 */
-	vpid02 = nested_get_vpid02(vcpu);
-	switch (type) {
-	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
-		if (!operand.vpid ||
-		    is_noncanonical_address(operand.gla, vcpu))
-			return nested_vmx_fail(vcpu,
-				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		vpid_sync_vcpu_addr(vpid02, operand.gla);
-		break;
-	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
-	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
-		if (!operand.vpid)
-			return nested_vmx_fail(vcpu,
-				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		vpid_sync_context(vpid02);
-		break;
-	case VMX_VPID_EXTENT_ALL_CONTEXT:
-		vpid_sync_context(vpid02);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return kvm_skip_emulated_instruction(vcpu);
-	}
+	if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR)
+		vpid_sync_vcpu_addr(nested_get_vpid02(vcpu), operand.gla);
+	else
+		vpid_sync_context(nested_get_vpid02(vcpu));
 
 	/*
 	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating
-- 
2.53.0



