Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831810;
	b=4pfItg9f6X1m8Hy5hqUUyEK5CZ0HduKTnMfckdTdzT26xM2q+pneeJFr+6BA/K6NS0XJ
	 F1n0YzHu7j3D0srdK8bKp/6uC7fw+I3eC7zpGhyxqMH/bGWYLnHx9vOhi3/pZuOToDsAK
	 dOVOzOXG+acR+Yj88yF0XEa5We0287j+H8+ia0CS6qDEynBpX0PFH+UH77fWb3kUi/t5L
	 zm4iZUG7GRRSnX6EDC7jC9hLg9TQVTmp7dt/apnK2agQ50ck0D34vbwz+hNbQ/Kgu/cch
	 N2kqKdd0B1ogATUgFRI2Mn74K19GEOMDN1LZVGMeJIaNADjcC+swmwVS5q2Kalf/VWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iJ+B+lRT15iaj5dOaUM14RuspvgUFx4l/miAKyRASUw=;
	b=pTmyOe9kykZ907sAm81KIP44JbbOZBcFRJzxfbYdnCbbXBY4ZXnW5Q/NMTk4h8jm+Usf
	 Byk14K4K5yX3q1ThfZbFV+ZGWaWqJeQ3vGFLxrXb7I2h8SIrD+ud/vahFu2mNt80BSAwD
	 aH1u1QCyAGq59v7oRYXOQQnlpWEZY9oLjH59HG58P+R87o6oi6qm4Ut1d+wCT5e8oMFPJ
	 TmgU253OP8hX9ntIQ0HCPzLQZexi/+L+9Oq+M3y7fbsOWaPORWxfcHyh446IOSjvdXYiq
	 ptsRmmtQzTGz2enycoLtHxLFYJoOg0zhfFsMhZ6D7HVGG/2QBomgxvMzdv/xSyVCNrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqUyQ1no;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31666606A860;
	Wed,  4 Nov 2026 22:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqUyQ1no
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83801F00919;
	Wed,  4 Nov 2026 22:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831810;
	bh=iJ+B+lRT15iaj5dOaUM14RuspvgUFx4l/miAKyRASUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqUyQ1noAh5YUG+usWe6AIbnKqTI84znd610CS76Y1hnEY/W1UjYyhJKS8xnjzeb5
	 slL0qNbW2rCqFWztaKrcSyih0cTdYVVgRoH0bEspRBBEwptpZ/FqNmPDOx9PCFKGrh
	 s1/quG73jPhWkdHqCcBTG+Uq18cReSwh3YW1tK6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0925/1005] KVM: SVM: Trigger new ASID allocation in both VMCBs on pCPU switch
Date: Wed,  4 Nov 2026 16:10:58 -0500
Message-ID: <20261104211109.051255670@linuxfoundation.org>
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
@@ -1346,6 +1346,7 @@ int svm_allocate_nested(struct vcpu_svm
 	if (!svm->nested.msrpm)
 		goto err_free_vmcb02;
 
+	svm->nested.vmcb02.cpu = -1;
 	svm->nested.initialized = true;
 	return 0;
 
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3613,14 +3613,25 @@ static int pre_svm_run(struct kvm_vcpu *
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


