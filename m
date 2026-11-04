Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831821;
	b=wG6Tm7k5H9J7Mrx8ZGnqfNIhJpC8vgVpdreQZvc8f2b7c/CFRlGmeDSqdOcA/rx0W92f
	 KsVt9UvTnNBIurL2IprXAoY2aptafTDZnCg2hfCYO0mMxesMVRkDnsKzcpLf3j/Fjob6Z
	 lXB7KCeGB5f1E0Sw82ytx1QtEcYyT+pCjvy475QjjyyXGWnaTnKQLWrPlfqFv0OitzQ3g
	 lgvRkm9mzI14QlEJOd0C6oIClqjmY8/1EXuqikVZpibBdNj3lB/wo2JQIa1/lO6mFUc4F
	 ru5YOVoPTXzWH3AXhfuTpeAHTiW2neEepDtgokdO+kmwD/qhnl4T7Uo7yJXojSV3c3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n78C2/X1Ee1NPGKD/8m63zKNICVjrKRxNRjQzn56lGc=;
	b=UnjfkXeVdz4zcb47MosL+WeKGpxKHBu3SCdYGF5P8pN4ZVIRM2vXKOwpRhfGQBeasp4P
	 JZJNVycnjhPEkSlenmE6DEFAXlVX60CP+BJj6KUU8gihVEIb9D/Jqy7YK6qaBpGmKxG/o
	 MoifrFgTPD8zJhvhrFESkABnnFpvzgPu98c+XmnodNQhVw1T0mdPKvbegl7Yd4Hwjtf5L
	 3wP7ntUVp0vU37ShYcT9hJ2mp3sOEDN/bEKuoeglgkjlDIsVrLiznMwVonvUj+nzPN5di
	 l/MI8FYPP3dKJwcCsctEcY/bDCjM9QaDgLUgy73Aa/zqXzx/ksfYK66/Lkxo8NEolaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LpZ+xW59;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAB7606A847;
	Wed,  4 Nov 2026 22:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LpZ+xW59
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8A91F000C1;
	Wed,  4 Nov 2026 22:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831821;
	bh=n78C2/X1Ee1NPGKD/8m63zKNICVjrKRxNRjQzn56lGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LpZ+xW59dKgztVCpaoDyBA2NxMBBNUKVJTVWfftMlLS9arIRi1jEs86UzD5MiD7XA
	 /HrXu3+NAFWZSSF7eACqxvTyHgSwqANHYZUplf9VSCqUdPXfwCfOBEdtGU092NhgY3
	 0pPyusFPA33/i4WKDw39gqdcWtqPJ9JyLVXRe4Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0932/1005] KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0
Date: Wed,  4 Nov 2026 16:11:05 -0500
Message-ID: <20261104211109.239679274@linuxfoundation.org>
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
@@ -5639,6 +5639,9 @@ static union kvm_cpu_role kvm_calc_cpu_r
 		return role;
 	}
 
+	if (KVM_BUG_ON(____is_efer_lma(regs) && !____is_cr4_pae(regs), vcpu->kvm))
+		*(u64 *)&regs->efer &= ~EFER_LMA;
+
 	role.base.efer_nx = ____is_efer_nx(regs);
 	role.base.cr0_wp = ____is_cr0_wp(regs);
 	role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);


