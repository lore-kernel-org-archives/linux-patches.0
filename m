Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061509;
	b=fJjK3YQemeEDsf4I/00ejQt8BwhK8KsbRKxxpymAChoqMxMXIXfb0XmzCccy3DqaY9Dh
	 Y8mim6ZttmuIH9GYKvraCvZZLs+z2wwI2TaMSzZF8w4551XfoRiT3uNXwfPgiCfDBVQD8
	 HwsYkmDSzQTZWaWy4ygtbNl+HGOtFEoqvoDg3lyoF6scXkWvXZAWIVFWTrd/+0/nXRJ96
	 yUR+vpPLZQ/DK+yUPai7z5IfTAODwXva6pXliEd29c0ru1swTEjLNp9opI6k6T4cSjrnV
	 cnr5xxWd8tWmSt8AzcDPaTzk2UaGo8phMHWrbiFHOCoYaRHkBPywW8fGPZ6SASVfoVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E0ejE9EIjiHl84SR3X98dYdJ6u6XFwIlZE9rwj/XlqM=;
	b=bdpCmaeJsw/sBP65S3e5e83xvUECrbNCcDLMFyghIlCsmzohP+54Yn8EG+TYZFZTbUBW
	 biFZM5l7A0CMQHI2w1Ovx2EMH1bPRAC0mBTSOfFty6lHnKl4uamih5hx6cJp1IjNZNW3s
	 BT2vzzhJMcxYdSDwVqs21KcIoSRoqQNOqFr7Fc7OTOWCalrtQf5wkDcEAM+uwO4OXqDa4
	 1xc5YeYk1aFjrz3htTGvOJrKUXZWUkR2xnqLiMbeJS66UN4isx/ENLqG5AxyRlmXklctJ
	 xB3qn5RgNRZeFE85mbr179DpfiXGX8DBPKvKH5xCHIhhBm1sJSrYMKqgUbQdMTDmzQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjkJXASw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03CF606A339;
	Sat,  7 Nov 2026 14:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjkJXASw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1A41F0089F;
	Sat,  7 Nov 2026 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061508;
	bh=E0ejE9EIjiHl84SR3X98dYdJ6u6XFwIlZE9rwj/XlqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjkJXASwolRWPSTJoaewYC1YpfeRpweAe9wZOrs206B/mSjJsZG1tdECXEOB16jDG
	 UI8WCRzJ0ynSSAqO3sm3Sd3/EQRrmBLgFs1evQ8yTbaAtKDXogdiB3Kso+Ufm/ahCi
	 0SSrtWCctvxBQ/C8Ac0Q2AC8W9NCf6c/yeFGferI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Cheng <chengkev@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Bjoern Doebel <doebel@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0600/1536] KVM: VMX: Synthesize nested EPT violation GVA_IS_VALID/GVA_TRANSLATED bits
Date: Sat,  7 Nov 2026 08:43:36 -0500
Message-ID: <20261107135014.396667024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 829821fbc8437..0752d1b3d918b 100644
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
index 17ecc0e863d44..c2aae9db372d1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -447,10 +447,25 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
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



