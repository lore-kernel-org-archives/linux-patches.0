Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044645;
	b=xNKQ0tt+umqqEEWerZZpnfoAxnMVVSPDlwYc6ZF8m8ToN34MX/nkqgAb4h1X3kJux+Aj
	 CurD/qdPo3Q9EIuku0NMYrBPMtq/pjQGp2Sgfitt1cnQLbLOm2mo7ioCqxdGIZyRrgSHA
	 tmgMrx6JnDCeZF8zzOX0fPV7YIusFYncfupW05AYDTlmrQdWQUDHVOkP3oI1mA5bjtPA5
	 3tBD6V3Ib5W0rO8xVH6uRcxHBOuHdnheZRkbsJEBN8QuAim+9s4/UlhnpVrXbOp56DIPr
	 vfrnNGRzj4errajBFsnNo7RnzFqUiVcc87bU7Y78oNU0J4sTmH6ih+ENY4bEP7z/JCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SXeRhcMVm/OlFcHqbATp56B0AI2zA2/aYqObiGJq8lg=;
	b=kCz5UDgiMVkeF5XV9L9IEDjiUbaWnxt+vSw+19P+FO+pHgp8IXmSylpATEYIWHAEsLC6
	 I3CYoI1XvaUS+R70YhE0ZdjwCKV7nl+ugox41EjKwjtJQd5hJcUc7NKwTyU6Vod/o41r/
	 1oZOOqvaYm1Jwn6jWk4U/RRaghRta7JHSyeencQ3+O4EKK93tI6MdJ02zAK24R+auuX+u
	 qJ1V2sYNYnc6e/0qLHtu84Lg11XNE8nCHOZwMX2hZq7fxloZQrKegg4Kg6DaTeIMtU2q7
	 eS/hg6ystR2hrNWPJhJuOvwhcIyOYWG/9zLSi+AGqtTVkcQ70GJ53vH8/nWOn6sn5uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mu4IyUe1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32545606A325;
	Wed, 18 Nov 2026 23:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mu4IyUe1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DBA1F000C5;
	Wed, 18 Nov 2026 23:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044645;
	bh=SXeRhcMVm/OlFcHqbATp56B0AI2zA2/aYqObiGJq8lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mu4IyUe1xMe0bHSH8vQETrooLNFgwGUsDNMXaupOLhX3ltp1Dfdw7InZK8RunvzhR
	 xg5NL+kRgZfqrOUVepo4wcfvz2bCgB3obPFGXoEMeCqXHi6BgeQGdFcRQZpqJRBXSy
	 MfrcxIfBdUJ7oW/vHqiaii3LHKDEvcLtDMHZtLVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 0624/2857] KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0
Date: Wed, 18 Nov 2026 15:27:38 +0100
Message-ID: <20261118150223.960246048@linuxfoundation.org>
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
@@ -4990,6 +4990,9 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu,
 		return role;
 	}
 
+	if (KVM_BUG_ON(____is_efer_lma(regs) && !____is_cr4_pae(regs), vcpu->kvm))
+		*(u64 *)&regs->efer &= ~EFER_LMA;
+
 	role.base.efer_nx = ____is_efer_nx(regs);
 	role.base.cr0_wp = ____is_cr0_wp(regs);
 	role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);


