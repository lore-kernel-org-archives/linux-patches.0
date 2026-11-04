Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831363;
	b=DT0W1JFbRcQJbQLAiZ/LFSlxT0ZBlFUzOEYTeYm7ytBRllggDwU1JglqVQSUoilgi1ym
	 uLwKqd8gGLYFu+9658SOJBfKVUk5T7LiImcFRaaJr9Yn3oQRJgabIqT8isowIv6B8GWHW
	 sNz7+YTiXElCx5YjsKLXNpsMMqBSmlxA756d+d6EHVx0otIp+zcsMoixxhqSyGIa2KehI
	 8/B27uQDNpLGm2ox6KInEta3V35JeVNOR1LFeWIgRxdczczShEaJsRSzd9a/WiTKgaY7k
	 A/sSDDn4ebMxogGWItyLBQeg+mZFLLFpCxzUdnvEZQ/czDnPijswtbVsKrAdsF+UBrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/dftNLjWqaJPmB4MUQ8FOL6ZTUPxYeJclud1hPap92c=;
	b=tfhpOTfTbTVs75rMYE+3ZGVIYVxQlaoU+cIhxp9ybyZbn8CJOejyOnWe5Gi7JSMfjcZ7
	 hY+B4ksnSpxel6DyiYOCo/s1Cr1r9Mg1gDbWxrcbhKi7m1QOYItrSUtwjMu7hQ4nQTELs
	 okDGheQlkM0Cmk+ZcKq3SuYpixy22qA+LkIIc0s3YzILBs0rAdXO1m2l+y7Bphj6IVfbF
	 MLsiLtHgxxrtsh29pqfPYsO1aPT95ilqwIIrrk3hyCufQs+r6oXN1WZtlyfgWkhFQDVlz
	 xKj4974LcqbLP7gh6r9nFopavW4PY5GQCXivkFIzZvCm4BXC4HH/NH5IsqI/x4l4kWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFRDbWBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D12C606A332;
	Wed,  4 Nov 2026 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFRDbWBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9351F00919;
	Wed,  4 Nov 2026 22:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831363;
	bh=/dftNLjWqaJPmB4MUQ8FOL6ZTUPxYeJclud1hPap92c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFRDbWBaZaDUb7lvt7GzH1KPkidIUTVgRpZe2AcVVECyqTO6KZAghSYReBZ+O7DYZ
	 GALkU3MpUyarR6DmwVmWL9NYy8cNd/IeRLe1+MYAPxDADmVzElsJr5iagKZ2ZP/S9D
	 oGYanBhKPkRWSXQpt++8Lic7OnhN3/n9PiI+o1B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Cheng <chengkev@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0659/1005] KVM: VMX: Synthesize nested EPT violation GVA_IS_VALID/GVA_TRANSLATED bits
Date: Wed,  4 Nov 2026 16:06:32 -0500
Message-ID: <20261104211102.150302339@linuxfoundation.org>
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

From: Kevin Cheng <chengkev@google.com>

[ Upstream commit 96b067b59ad9ccede585fcadab27543188353bff ]

When injecting an EPT Violation into L2 in response to a fault detected
while emulating an L2 GVA access, synthesize the GVA_IS_VALID and
GVA_TRANSLATED bits using information provided by the walker, instead of
pulling the bits from vmcs02.EXIT_QUALIFICATION.  The information in
vmcs02.EXIT_QUALIFICATION is valid/correct if and only if the fault being
injected into L1 is the direct result of an EPT Violation VM-Exit from L2.

E.g. if KVM is emulating an I/O instruction and the memory operand's
translation through L1's EPT fails, using vmcs02.EXIT_QUALIFICATION is
wrong as the semantics for EXIT_QUALIFICATION would be for an I/O exit,
not an EPT Violation exit.

Opportunistically clean up the formatting for creating the mask of bits
to pull from vmcs02.EXIT_QUALIFICATION.

Signed-off-by: Kevin Cheng <chengkev@google.com>
[sean: use plumbed in @access bits, massage changelog]
Link: https://patch.msgid.link/20260522232701.3671446-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[doebel: no advanced EPT vmexit info here, so the mask keeps only the two
GVA bits; set GVA_TRANSLATED via !(access & PFERR_GUEST_PAGE_MASK)]
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 17 ++++++++++++++++-
 arch/x86/kvm/vmx/nested.c      | 23 +++++++++++++++++++----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 798e5be42e72b..a298955834d0b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -495,7 +495,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	 * [2:0] - Derive from the access bits. The exit_qualification might be
 	 *         out of date if it is serving an EPT misconfiguration.
 	 * [5:3] - Calculated by the page walk of the guest EPT page tables
-	 * [7:8] - Derived from [7:8] of real exit_qualification
+	 * [7:8] - Derived from "fault stage" access bits
 	 *
 	 * The other bits are set to 0.
 	 */
@@ -509,6 +509,21 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		if (fetch_fault)
 			walker->fault.exit_qualification |= EPT_VIOLATION_ACC_INSTR;
 
+		/*
+		 * KVM doesn't emulate features that access GPAs directly, e.g.
+		 * Intel Processor Trace.  Assume the GVA is always valid; when
+		 * propagating faults from hardware, KVM will discard this info
+		 * and use the EXIT_QUALIFICATION bits from the VMCS.
+		 */
+		walker->fault.exit_qualification |= EPT_VIOLATION_GVA_IS_VALID;
+
+		/*
+		 * Accesses to guest paging structures are not the translation of
+		 * a guest linear address, i.e. GVA_TRANSLATED must be left clear.
+		 */
+		if (!(access & PFERR_GUEST_PAGE_MASK))
+			walker->fault.exit_qualification |= EPT_VIOLATION_GVA_TRANSLATED;
+
 		/*
 		 * Note, pte_access holds the raw RWX bits from the EPTE, not
 		 * ACC_*_MASK flags!
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 371c7ef6b44dc..ab1558f1f9f8d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -449,10 +449,25 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 			vm_exit_reason = EXIT_REASON_EPT_MISCONFIG;
 			exit_qualification = 0;
 		} else {
-			exit_qualification = fault->exit_qualification;
-			exit_qualification |= vmx_get_exit_qual(vcpu) &
-					      (EPT_VIOLATION_GVA_IS_VALID |
-					       EPT_VIOLATION_GVA_TRANSLATED);
+			const u64 mask = EPT_VIOLATION_GVA_IS_VALID |
+					 EPT_VIOLATION_GVA_TRANSLATED;
+
+			exit_qualification = fault->exit_qualification & ~mask;
+
+			/*
+			 * Use the EXIT_QUALIFICATION from the VMCS if and only
+			 * if the hardware VM-Exit from L2 was an EPT Violation.
+			 * If the fault is synthesized, then EXIT_QUALIFICATION
+			 * is stale and/or holds entirely different data.  And
+			 * conversely, KVM _must_ rely on EXIT_QUALIFICATION if
+			 * the fault came from hardware, because KVM only sees
+			 * and walks the faulting GPA.
+			 */
+			if (from_hardware)
+				exit_qualification |= vmx_get_exit_qual(vcpu) & mask;
+			else
+				exit_qualification |= fault->exit_qualification & mask;
+
 			vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
 		}
 
-- 
2.53.0



