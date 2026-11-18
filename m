Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034629;
	b=yBEPL2n97ot2CCT8QieaRIvdKQYhoaqk5iKbfWqRT/a3dsfAGMECubBYxVoqsPiMMFVN
	 FVkuNIRQLTPrOdCHy1SJXuqLv6YP1w55I0mxoaeh2/oxINUjPiXhLyTCzjd5jgWDp124U
	 njoszgXQ+0WtJolfg9mUA48C6AhuT9cBraOA56VytueaVdtE4crKZ/GZnz0FrRpS7Zs+H
	 nt2iL6dVMWPgx61cEWA9+ytReMiMmVt92qhQQVxvedrFkG8APboN6kq6VQ3poRRRQkfe4
	 5AxHAPpA9tgDhcESDMJ0wjHfZP/hMDXLRMEbll7TIG2b5eNHC7eED8xYTdaANqlpEkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0vCYjTQduT3LGiSsMlIR4JKwdzpX6g2JG79DeGdrWY=;
	b=L3S5PldRYKVjV4pCXH2yDzIKe+9s1zPzeiGN7nZsfjope1cWnF4Hgw2OHLK5esMVHE1J
	 z6FhwabC8FDhDmf5mHp5szXRuCr8PPEYQTYAFrlbl/3owtk5/5+D6h0Zy9tUDZG3CdJxA
	 sPeFIffdn18bdsVaze5akK2/TEf8l4cc9PEPO3T24dsaJH8O/MKnQJN9BfaoUr5yvyiw/
	 wN0rOfCOJkw0lG2M+q7Ej+VwsViJYXJ84xcpjcPoDJ/ta+Zy9nhTDiBIJOmZDcxQiK1fu
	 +kCzp0lUqiCi1ka2+R4ZtMnCfgccsPpaxwp9pqI8di1Vh0h6lLJXb9kfDYYWnde4H/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfoF7Skh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048360A2604;
	Wed, 18 Nov 2026 20:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfoF7Skh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEE11F000C4;
	Wed, 18 Nov 2026 20:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034628;
	bh=B0vCYjTQduT3LGiSsMlIR4JKwdzpX6g2JG79DeGdrWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfoF7SkhsRieFQNQYA8e3RmPWKbQf6V4PQgX8uBLTp8aeQ9aumXtTZIvMTychUpj/
	 Gu9ecuYhl2vjDX4sdi4t9mosissZQ6PmIcS/yJzU7HuV+IWnJGEmkCd0tsY/VzvZPq
	 vKOloUGI/XYdBt7QVikDdar/oC/a0XHR8YFzIGCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0378/3318] KVM: nVMX: Decouple INVVPID operand checks from flushing of vpid02
Date: Wed, 18 Nov 2026 15:16:40 +0100
Message-ID: <20261118150327.588781803@linuxfoundation.org>
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
[ sashal: Merged the per-case INVVPID flush switch into upstream's single flush call while keeping the existing per-pCPU deferral, and used is_noncanonical_address() since the LAM helper is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 57 +++++++++++----------------------------
 1 file changed, 16 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0087daad441dc..c90e479f802cb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5855,7 +5855,6 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		u64 vpid;
 		u64 gla;
 	} operand;
-	u16 vpid02;
 	int r, gpr_index;
 	int cpu;
 
@@ -5891,8 +5890,14 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
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
@@ -5904,44 +5909,14 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * by invalidating the nested VPID tracking to ensure that KVM performs
 	 * the invalidation on the correct pCPU.
 	 */
-	vpid02 = nested_get_vpid02(vcpu);
-	switch (type) {
-	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
-		if (!operand.vpid ||
-		    is_noncanonical_address(operand.gla, vcpu))
-			return nested_vmx_fail(vcpu,
-				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		cpu = get_cpu();
-		if (cpu != vmx->nested.vmcs02.cpu)
-			vmx->nested.last_vpid = 0;
-		else
-			vpid_sync_vcpu_addr(vpid02, operand.gla);
-		put_cpu();
-		break;
-	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
-	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
-		if (!operand.vpid)
-			return nested_vmx_fail(vcpu,
-				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
-		cpu = get_cpu();
-		if (cpu != vmx->nested.vmcs02.cpu)
-			vmx->nested.last_vpid = 0;
-		else
-			vpid_sync_context(vpid02);
-		put_cpu();
-		break;
-	case VMX_VPID_EXTENT_ALL_CONTEXT:
-		cpu = get_cpu();
-		if (cpu != vmx->nested.vmcs02.cpu)
-			vmx->nested.last_vpid = 0;
-		else
-			vpid_sync_context(vpid02);
-		put_cpu();
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return kvm_skip_emulated_instruction(vcpu);
-	}
+	cpu = get_cpu();
+	if (cpu != vmx->nested.vmcs02.cpu)
+		vmx->nested.last_vpid = 0;
+	else if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR)
+		vpid_sync_vcpu_addr(nested_get_vpid02(vcpu), operand.gla);
+	else
+		vpid_sync_context(nested_get_vpid02(vcpu));
+	put_cpu();
 
 	/*
 	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating
-- 
2.53.0



