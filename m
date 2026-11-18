Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051955;
	b=JWQPhOuw1tKwZRVxM4aPHkAGGs+Jar+UaXqxx0WCWnrVZlf1QYM9Eb93LcISAWSlOwss
	 14wY1g8qV1q3yNEyUVlineuF1S2AhOHNM3D+AE5RI/oPIgzAajwsIwGFPaJio2CjR/NBZ
	 O43NiCBivvZ4UE3mgPmYejX5TtR0fUeuA4Ww622a0SLaBvwCB8OJ6kerxx9lXARHBD0Pk
	 3gM8blqKGJaJyowxX1Qd7s0a/Qb3G4Yu5uL8FtsHvFOo/TrnQ2QO0cceJOorzVL9SShOM
	 gBwr3GpqHAy077+D8znyQSQSbj8NQLQRsLzVJjdJAYruRcq6jj9If+GmoYa63nryTpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IPHglCYSxk1BGWQQ/i9iLgpXaxQ5rcY0TpJI/NhW9us=;
	b=dgj+9Ctv4FgLFY0lYWFUZvobryk7eozblY6fphmWn2/UnHx/LZUUZghPXEO66U5S6wxI
	 I41H/5G450xDCi1Y0G7uokwTVmvgagvev+fUtSu/t9kqLIJ0Vl5+jCAmEe9PjFARMPbX+
	 EegjxpF6Q8SThWH/1YYK39yrb1U/UzLczmcCBA9tDUU8O7Tn6mKJRgi4shwcaZlTg+dAb
	 /RAbUr+YRR8RM5T/tleJKi8RENDRsSY8FetFW+jAwH+HunXr9lEDXeAV5MsuQqrTyrMow
	 qyUTPvZFiqbQdX6nIq4SCH0ciE9Ibf3T0zSs42eJQE299oYkcIHYUj0dGQCF3BNRScA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cx5XHDYK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0385D606A331;
	Thu, 19 Nov 2026 01:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cx5XHDYK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1121F000C4;
	Thu, 19 Nov 2026 01:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051954;
	bh=IPHglCYSxk1BGWQQ/i9iLgpXaxQ5rcY0TpJI/NhW9us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cx5XHDYKheD5FemBflA+0s60ECO777nGmBcFelHYlNI5VAKVdCx2/lIuziUAFN3Lb
	 9X6H9JnyyvaEy7YE80a1KOIyz3kMoL2xLzm9FFCkUXAOVujRi96rsFOUZrBORLbxva
	 ZsDKUtH7wBctozMzXwbMp3NCAG8djhoJ0yHd2NVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 0365/2214] KVM: SVM: Trigger new ASID allocation in both VMCBs on pCPU switch
Date: Wed, 18 Nov 2026 15:34:01 +0100
Message-ID: <20261118150025.267011126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit bf260dc9e7b8bfcd06c1a8e739797b1cf0917c72 upstream.

When the pCPU where the VMCB was most recently used is switched, reset
the ASID generation in both VMCBs, triggering new ASID allocation for
the immediate VMRUN as well as the next VMRUN on the other VMCB.

The ASID is shared between vmcb01 and vmcb02, and gets flushed on every
nested transition. However, since pCPU tracking is done per VMCB, it is
possible for one VMCB to allocate a new ASID when migrated to a new
pCPU, and then the other VMCB reuses that ASID on the old pCPU. This can
result in the same ASID being used by multiple vCPUs on the old pCPU.

Example scenario:
- vCPU runs on pCPU A, vmcb01 is active, asid=1.
- vCPU migrates to pCPU B, vmcb01 pCPU changes, new asid=2.
- Another vCPU runs on pCPU A and allocates asid=2 as well.
- vCPU migrates back to pCPU A, and then switches to vmcb02 before it
  runs again with vmcb01.
- No pCPU switch is detected for vmcb02, so VMRUN is done with asid=2.
- Two vCPUs end up using asid=2 on the same pCPU.

Keep the VMCB dirtying to the active VMCB only. Clean bits are tracked
by a pCPU for each VMCB, so do not unnecessarily dirty a VMCB if its
pCPU does not change.

Additionally, initialize the tracked pCPU for vmcb02 to -1 on nested
enablement as hardening, so that a new ASID allocation is always
triggered when nested is disabled and re-enabled.

No performance regression was noticed when overcommitting L1 vCPUs in L0
(to force rescheduling), pinning L1 <-> L2 vCPUs, and running CPUID in a
tight loop bouncing between 2 vCPUs in L2.

An alternative (and perhaps more proper) fix would be tracking the ASID
per-VMCB instead (e.g. [1]). However, that's a more involved change, and
it would result in having different ASIDs for L1 and L2 without actually
properly maintaining them. It would probably work because all TLB
flushes target the current VMCB, and the other VMCB is always flushed on
nested transitions, but the code ends up in an arguably more fragile
state. Punt a proper clean fix to an incoming (and overdue) overhaul of
SVM's ASID usage [2].

[1] https://lore.kernel.org/lkml/20250205182402.2147495-2-yosry.ahmed@linux.dev
[2] https://lore.kernel.org/kvm/20260728003557.1136583-1-yosry@kernel.org

Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Link: https://patch.msgid.link/20260903223258.486034-1-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 arch/x86/kvm/svm/svm.c    |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -916,6 +916,7 @@ int svm_allocate_nested(struct vcpu_svm
 		goto err_free_vmcb02;
 	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
 
+	svm->nested.vmcb02.cpu = -1;
 	svm->nested.initialized = true;
 	return 0;
 
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3416,14 +3416,25 @@ static void pre_svm_run(struct kvm_vcpu
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
-	 * If the previous vmrun of the vmcb occurred on a different physical
-	 * cpu, then mark the vmcb dirty and assign a new asid.  Hardware's
-	 * vmcb clean bits are per logical CPU, as are KVM's asid assignments.
+	 * If the previous VMRUN of the VMCB occurred on a different physical
+	 * cpu, then mark the VMCB dirty as hardware's clean bits are per pCPU.
+	 *
+	 * Reset the ASID generation in both VMCBs. This will lead to assigning
+	 * a new ASID now, and then again when switching to the other VMCB.
+	 * However, this is needed as the ASID is shared between the VMCBs, and
+	 * otherwise it would be possible to use an ASID allocated on one pCPU
+	 * on another, for example:
+	 * - vCPU migrates from pCPU A to pCPU B, allocates a new ASID.
+	 * - vCPU migrates back to pCPU A, and then switches the VMCB.
+	 * - The new VMCB does not detect a pCPU change and runs on pCPU A with
+	 *   the new ASID allocated on pCPU B, which is potentially used by
+	 *   another vCPU/VM.
 	 */
 	if (unlikely(svm->current_vmcb->cpu != vcpu->cpu)) {
-		svm->current_vmcb->asid_generation = 0;
 		vmcb_mark_all_dirty(svm->vmcb);
 		svm->current_vmcb->cpu = vcpu->cpu;
+		svm->vmcb01.asid_generation = 0;
+		svm->nested.vmcb02.asid_generation = 0;
         }
 
 	if (sev_guest(vcpu->kvm))


