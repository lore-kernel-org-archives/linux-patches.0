Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043881;
	b=cxzmYLgUFbLo6KmEkyoEslpxpcCZyZ7e9x4UyYqI+rJRFmeTIbE3MPTStsmr4bIpD59L
	 SU2N7/MAf8XRbpFDC3wDvZgIfiY3y5kypakNW32jm0v1ESDKdrdOZfK90hLKDZnA4K+ez
	 GAs+xk9RtEoae1jwbWTxaPAKdKH28UQgTue2JaFimxWFhEz5jIokYuw3oFbQBMz+BcMDS
	 o0N9Afd4WSqNntoQKgH9ZTdl+i3rA9XVmB+4HnunNBNHpSNMqpZYBIEs6zSxoNigPW51o
	 7QkAa4vppEFyk1TxL2BEgEzGUG7PWIv+nciNgUCyGKiLun6+PyGaCvefXMkuxJQbcXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cUaNmGgjpnvQdD5gtJutwVrVK8J/zNQp4/KQDD3gklM=;
	b=JahgK2oVNOwC/FOqpdUF64F0l2+iGtfJvz9mjXzBux1LqbUiJhWdqWGx02txiFRyQOJD
	 AnxwX/UA9QAfTBdyandJ7SJJRSe0whSN8I5fBan8ion6yI0hKIIh9EBLZ8R37F8JZiB7B
	 C3jOaGK0fU15ygRTNnsFV+tXFsW5O63leClYSnlhM0Uxk3tqsP31fR8XC29x6KFjAlx3L
	 z3FRlX7kdl9t+nUAYv2NScIyFSjgO6ckPS9KVpwuk0OR1SZLf24hS83cqxDKfeEu+zWKW
	 bzXgJs15NMA4EsjgmeWczVor3gey2CBHkaXFn3ODu/QhX1V4VGs2QKtPC2gTX1VsnHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1h84fjFi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04E8606A32A;
	Wed, 18 Nov 2026 23:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1h84fjFi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2B11F000C4;
	Wed, 18 Nov 2026 23:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043881;
	bh=cUaNmGgjpnvQdD5gtJutwVrVK8J/zNQp4/KQDD3gklM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1h84fjFikc7yUykHLUY95PtBmlP9APxLRt2WZpOXyC89pJxFUm8XCQCuf605pXI9U
	 Z487W5vdrj6AcLdvpqgLnksEYr4S7dXrvq4ddHIMLnaZy/L4ZkuR+SRde5d25+jcjz
	 HTfiOHXpYsGKkaBvMNDZpBG4ZblhlxtVKanrWrWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0328/2857] KVM: nVM: Ensure INVVPID is emulated on the correct physical CPU
Date: Wed, 18 Nov 2026 15:22:42 +0100
Message-ID: <20261118150213.249939646@linuxfoundation.org>
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

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit 6d00e67326d831e6e610933a3800712f4ffe6ec1 ]

When emulating INVVPID, KVM executes INVVPID on the physical CPU using
vpid02 (instead of the L1 assigned VPID), after doing some validations
on the operands. However, it is possible that the physical CPU KVM
executes INVVPID on is different from the CPU L2 is running on.

For example, in the following scenario:
- L2 runs on CPU #1 and exits to L1 (vmx->nested.vmcs02.cpu=1)
- L1 migrates to CPU #2 and executes INVVPID
- KVM executes INVVPID on CPU #2
- L1 migrates back to CPU #1 and runs L2 (vmx->nested.vmcs02.cpu=1)

The TLB entries on CPU #1 are never invalidated, because INVVPID was
executed on CPU #2, and vmcs02 never ran on a different pCPU (i.e.
vmx_vcpu_load_vmcs() will *not* request KVM_REQ_TLB_FLUSH).

Ensure that INVVPID is being executed on the same pCPU that L2 last ran
on, and if not, fallback to clearing last_vpid=0 to trigger a full VPID
flush on the next nested VM-Enter (as KVM will detect L1 using a
different VPID for L2). If L2 ends up running on a different pCPU, KVM
will flush the TLB anyway through vmx_vcpu_load_vmcs().

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20260616214652.2157032-4-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 972191dfe66d3..15e8491a455f3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5820,6 +5820,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		u64 gla;
 	} operand;
 	int r, gpr_index;
+	int cpu;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
@@ -5867,11 +5868,19 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	 * and never explicitly flush vpid01.  INVVPID targets a VPID, not a
 	 * VMCS, and so whether or not the current vmcs12 has VPID enabled is
 	 * irrelevant (and there may not be a loaded vmcs12).
+	 *
+	 * If vmcs02 was last loaded on a different pCPU, then defer the flush
+	 * by invalidating the nested VPID tracking to ensure that KVM performs
+	 * the invalidation on the correct pCPU.
 	 */
-	if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR)
+	cpu = get_cpu();
+	if (cpu != vmx->nested.vmcs02.cpu)
+		vmx->nested.last_vpid = 0;
+	else if (type == VMX_VPID_EXTENT_INDIVIDUAL_ADDR)
 		vpid_sync_vcpu_addr(nested_get_vpid02(vcpu), operand.gla);
 	else
 		vpid_sync_context(nested_get_vpid02(vcpu));
+	put_cpu();
 
 	/*
 	 * Sync the shadow page tables if EPT is disabled, L1 is invalidating
-- 
2.53.0



