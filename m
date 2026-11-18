Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044763;
	b=CZHcCmPRO1QbIuqrm7Y8Q12V25slrNZo8SEk7N6tA6SFhk2dOagRlLwzzaTxR+Q3kipS
	 SfKP0TlzKV2C1wL8i3Gp9+KdWY96yxgfIVSwlY04WYScwtmApfkfDqn/8aIcbwHrWtKlu
	 B60QAoeLqKvOzptzMc55NlxpdPrOzrgVhh7OO9lES9rBEAp2VyppHoNc4FuE0g+rsO4sQ
	 V58Gzy5/4zZwg1iS3jQZvTXyUpLR8oXsf7hahxYU/3wHy8NbK6WENj7UjRQA9Hibrd+UZ
	 HAsvqf1rgBjq0NZLeWTDeiceORiDaTepbn58BPS3HmF2et+/WLq9VU5b9ph1ysqdYgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QP2GDi/94/fGvflr9VlqFLe5BYh5qDE76OYA2s5lLP4=;
	b=3dkiKtQxDtYXTfqfDJwQcRGRQbITHcpnjTLXQ8yRIgzPm2bJb+o5nYs84Vm1jyn/+zDj
	 6sO/wCVMnTXKeHmb/d7ti2wsBpkI6jkhO6320P/kbiIBMegenDRoCjl8XlHf26tDNAAru
	 RhwIiwrwClHUdYPNOXLvxj/dcbc5eVgxA6C5qKx3jFnWLsOX+Ul6rCi9wHfvTiPJHE+2T
	 GfxAKt/tqwO7w42ESbjLBqNo0Jueo0Owk51ovwTllMUufoErYLJuqYVuUCCou+4UNLrbA
	 Iu4UAf3t4B4yP6qTffwuiyRn/llfQU2rHDU1ePJtP2c9TcDNkfMeq8FdYbiDl1oeqaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4QLEmre;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF1C60A2634;
	Wed, 18 Nov 2026 23:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4QLEmre
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D4E1F000CB;
	Wed, 18 Nov 2026 23:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044762;
	bh=QP2GDi/94/fGvflr9VlqFLe5BYh5qDE76OYA2s5lLP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4QLEmreneJi8juev3SPjnCKiapdMZyeunyVvnXICAanPbQeZHRaDkCZ9o6tylsSy
	 +BPlYTZNrdYDAOoWmR3sx/hdkfPdHhHMFfXKq1LyF98t9lzUyXzIrcrM0BS/TqpK1J
	 ipOGCKPmn6vZAWHbZkJ6XaF9cGQm+SI7Gh6dRXYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 0622/2857] KVM: SVM: Trigger new ASID allocation in both VMCBs on pCPU switch
Date: Wed, 18 Nov 2026 15:27:36 +0100
Message-ID: <20261118150223.883951126@linuxfoundation.org>
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
@@ -1125,6 +1125,7 @@ int svm_allocate_nested(struct vcpu_svm
 		goto err_free_vmcb02;
 	svm_vcpu_init_msrpm(&svm->vcpu, svm->nested.msrpm);
 
+	svm->nested.vmcb02.cpu = -1;
 	svm->nested.initialized = true;
 	return 0;
 
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3495,14 +3495,25 @@ static void pre_svm_run(struct kvm_vcpu
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


