Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053664;
	b=lnwbcALULokOCIy3JmCJhU6xSO85Qk4t2A8kKbg7CmUO3WCZlpkAQG5Lxo3lG5osQk5j
	 YKuoaE5Hv/29sfAt/joHlaOd885mHuknMgbkP4khk83gsCjpsGjx3ykiCW1VNLhwWA3om
	 W8r2R+Z0iAaqWpPVEjwwnuZWRuf31x+Uy64LthfybGe8FIyeh4Ii5BgbJ8oqWlvkwcFX5
	 btTX5wTDHeWEgVPi7NgRaEHh0fl0PDrM8b4QaEmeHVgSYJaLwTiK7tEsbcJsiFkku+zIP
	 cIiSp2lfMIkgOErEC8xihvoqg3SkuEp8Q1NNkXxgv/SC+RL5CQXKMn2KavaqHzT2rkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DOre3LGb9zspiXQV41kGtI8QClp2AyrstY2WhZW2Lyc=;
	b=PJgdioyCfZh+ht/VKotry6zPBgRa6ICc2RZmn4QDgxT4UdmUmrfdvz3p+ruJa7/tn0Qm
	 4GI7wSyiBG3PygHkwl2GZfYiggZ9RlI83U42IGpqiiUQbhvenZXgYrVTBQQEpqf+rHPhy
	 lkgGqkW8tbWUG5lDjmLrkp1TCDEwv6fbY+kkaj2gbgOzV/fH/JBbcI/2UH7lCltRhru3S
	 BHCauUuSTFsdo+PMn71F3YFnFgD7Ihr7LcgM7pJpFpRus3MrFvuCePEGo+CJsP3E0XZ8P
	 xjNK6G6bgXORi+4XME7KmOimHVY+jaw3XL1MuYlVR73m8cG0c6Y3Fd460JVzkZX15LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEoCHsGj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF813606A31C;
	Thu, 19 Nov 2026 02:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEoCHsGj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F091F000C4;
	Thu, 19 Nov 2026 02:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053664;
	bh=DOre3LGb9zspiXQV41kGtI8QClp2AyrstY2WhZW2Lyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEoCHsGjQVQy+Y754nh8he/azucONHQYHEzBCFYOZjj7Tn2zd9I6GerVgM5Hnmk2v
	 PNDObfaZeGqWCKoHl0cYx14IyuxudFXMdFHyvIHxx0ALOldXGwbj1SDwGlRL6YJDgI
	 wzBli5plz0ZpjR38QWV8/VqrVjCyqS/xNZtCPiek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0999/2214] KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0
Date: Wed, 18 Nov 2026 15:44:35 +0100
Message-ID: <20261118150052.352661388@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 34dacbe7ae93f2d3c26cd0bf3e08200b1fa2c180 ]

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
[ sashal: Moved the guard from the unavailable kvm_calc_cpu_role() to the paging-enabled branch of kvm_calc_mmu_role_common(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a768cbe23808c..887a9d4a1e8bb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4854,6 +4854,9 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 
 	role.base.access = ACC_ALL;
 	if (____is_cr0_pg(regs)) {
+		if (KVM_BUG_ON(____is_efer_lma(regs) && !____is_cr4_pae(regs), vcpu->kvm))
+			*(u64 *)&regs->efer &= ~EFER_LMA;
+
 		role.base.efer_nx = ____is_efer_nx(regs);
 		role.base.cr0_wp = ____is_cr0_wp(regs);
 	}
-- 
2.53.0



