Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061759;
	b=g3QbI2+mukIFWBpsfGP1zr69PyiIblkEdoBQwBN3xbZyFJ0GBAsDK2xSkR2pvznj4Q55
	 MJyGLjtzvxb70G9OLfSB5EFIFYCZZjalYp3g+XtJ/puFl0z8sx/I/BTo/euO5pnuDWEsO
	 /4KQm0ddRJZUMVe6HjHPFlJTP/k9V3KoCle6vOZ//haa+RW0oqCMbMO3KauCCbM9v4zLf
	 fW3njMFAascnyf6HWHmhRgYEUyU8gvnM3PLwMQ9ZY2urTF1Q2a6aCWsXJPgoML255nypa
	 4MpeEf9ngt3B3St19OEX3q4M6SFGO1lPg0FrgpKW/Z1Rc3dzjEZ6aNqGcz65HnX8VfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2iWWC57zf0pR/FKqwEQEMWnBe0dXbR1TG1V2QNtclUc=;
	b=rakV+GezqOnCu1RAbYIc/KPeuCYs8Ly0oktAOReNySuWQjjuwYEz2zaRLSruzcnwuhiF
	 jN9aCCBDhCMcD+Gzdyvq6MmPpyK7E4BEXq1O+KQua5KeQLhAbPQ+F/kqQlo5k0XXrzItE
	 ep2JzweAOCiI4zdtrxaj8nroNSXQvcDvj6IAmFPcIUkC2kfEKK0f8WD7D973a7V9P4Lyp
	 azqiFxbFtCKBrGwgLgzMGnflq1sw9cJf4i1hbkqFsLgZo9iZ6PyngW14uof33NRYqceXN
	 2XFXX7Ow6Q2Vp6I+9p3CbCGsQ/ZjFzryTBXqBLrEPEdT2b2sqxUi/kZZC7CqqRir2GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XiAbkfJ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD11606A32C;
	Sat,  7 Nov 2026 14:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XiAbkfJ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DFF1F008A2;
	Sat,  7 Nov 2026 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061759;
	bh=2iWWC57zf0pR/FKqwEQEMWnBe0dXbR1TG1V2QNtclUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XiAbkfJ5WaEhzlzzwSrbz1bMjnjjnIOmql5g6fJkilgQazzH2qbglrLpBdV152EAF
	 3EIFTDI6pq2KyVUoiELDCyiWf9QDiEg3aWScIYb/cfDLvadO+NnSAImdVjEULE364i
	 o8Lct/dg2h6VC8gHBffgeC1wEM5P2QPJdra9yuJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 0797/1536] KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0
Date: Sat,  7 Nov 2026 08:46:53 -0500
Message-ID: <20261107135019.932320225@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 34dacbe7ae93f2d3c26cd0bf3e08200b1fa2c180 upstream.

Bug the VM if KVM attempts to construct a CPU role with the should-be-
impossible combination of long mode being active without PAE paging being
enabled.  KVM's MMU construction assumes that EFER.LMA can be set if and
only CR4.PAE is set, and will create a completely invalid MMU if that
assumption fails.  FNAME(walk_addr_generic) already has sanity checks to
try and mitigate the fallout, but attempt to catch such bugs earlier, as
this is (at least) the second time KVM has had bugs that escaped into
FNAME(walk_addr_generic), and it's entirely possible the bad state could
cause problems elsewhere.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902232028.2767071-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5449,6 +5449,9 @@ static union kvm_cpu_role kvm_calc_cpu_r
 		return role;
 	}
 
+	if (KVM_BUG_ON(____is_efer_lma(regs) && !____is_cr4_pae(regs), vcpu->kvm))
+		*(u64 *)&regs->efer &= ~EFER_LMA;
+
 	role.base.efer_nx = ____is_efer_nx(regs);
 	role.base.cr0_wp = ____is_cr0_wp(regs);
 	role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);


