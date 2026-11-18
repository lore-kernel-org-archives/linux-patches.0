Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035468;
	b=Wr6rfpjn7aCyB65LGxe2sVAFgKGAt0vMKXsRLQZLl9V5Q5HPUSUCQDIk9ph+Z0SjpsQj
	 mA4REBd54p5ZPpOh08ZKgwUiEvCUYHCyhfhpKgxKBwxL1FvrrHLsVlD88it9qKwj3gLoj
	 ehlW0PpL1A661k1TIccd/9geNWL4JknIGYOQszEySxs33J8tzGPWtekWTOfSJ89Uad8a3
	 E830dQtg7ux2endNtxc4taVMUcWw1OsLXrDQnjecpW/QjXcz7WCUm/NTYgeanv7kkGinz
	 sFzBM7j6A47pwdSNoKzXP7IzNF5pIwNRmUcx9WZJKqLwO97ZxmdDwGOuF1A9fxHbjgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l74XYMwJg2Z8aWfVkIMUOR1DlTidRLtnBuvhkHwP7CA=;
	b=1m08GrHpzqp/kn74bHu9FBSpQPK84h3wjXjz3YCSPjI/K0/K9hIRElJgOYHqqbpfPFRE
	 7gn4Wmv5aEkuVl1jTITGsJ2ZeKgXuhNpsBSE6UiQ/hAG2cHBhO9wA3lWy424z9zbf4Ci7
	 mIi7Oq3MNp6auqe5+LnkZMcTcFrXvGqnDym75ocNU67Bqlo5PUoISE6aXFoL3xYQKAxrr
	 Fsh5AIiFhD9x8uVNFn8vjhbrZc+EfHP3ABSpfIEbRYdXYCPdD5hNkBAsNGfQMAuU2hs9w
	 ymElWc/l4Q2JCOGz1cs6EQg9ByU2Rl6XVqL2RpXTXqUMGWX67ZqreMNBI2XFZ04O+Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTQkU5F4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B506606A31C;
	Wed, 18 Nov 2026 20:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTQkU5F4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CE51F000C4;
	Wed, 18 Nov 2026 20:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035468;
	bh=l74XYMwJg2Z8aWfVkIMUOR1DlTidRLtnBuvhkHwP7CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTQkU5F4APt2Eu2GnYTznNodXQQmqYIbYn/IucKFcbcah+s7bV1HC7W7Pnt11Osc0
	 tjpCDSmd0Xnw7KburhIeVjn6OsZmw8T465k8rz7ptz1IuQf3DM1bc5CRKG1+Dwz4Dq
	 J6XcRKC7q5bd4bvaqXfLyUU5VQ7iKv5Y8W/MtEDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 0715/3318] KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0
Date: Wed, 18 Nov 2026 15:22:17 +0100
Message-ID: <20261118150339.902622478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5137,6 +5137,9 @@ static union kvm_cpu_role kvm_calc_cpu_r
 		return role;
 	}
 
+	if (KVM_BUG_ON(____is_efer_lma(regs) && !____is_cr4_pae(regs), vcpu->kvm))
+		*(u64 *)&regs->efer &= ~EFER_LMA;
+
 	role.base.efer_nx = ____is_efer_nx(regs);
 	role.base.cr0_wp = ____is_cr0_wp(regs);
 	role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);


