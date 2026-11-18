Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043785;
	b=q0h8syFxWU1AEs6wMUOJb5Pqso4TJOnCj+Yt9ocI/vgWngmzWwrZEPJSoeAlTFHfqj/J
	 9fiUcx7u2AsSfN1cO1AovRTo6fvBbijJ6I3wh3dvO1nc/limLwoWLdZ8gdNY6SbQW5/Au
	 RA2OaXOyV6Il1FF6fyj1XWoc/HNV/CGVMGXO8rB4nVuLULXtQ511cEEKHVEFzaJGc5GTD
	 L449BV6WMDFsx5yJfGjCkluYIIUibQL5IMZEu229Gu4geabzBUzB7H4vKeXSlDCcZwvPI
	 m1zKXRFFeucGQ96qB4bb8DNYjPOudsfBRkPM9zcJKPDMp+1uCDod5ywIPvz5vGCnBwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v5U/XKDyTu9e88cFUSkLKmc9umYecpDEKr6MchgEPAI=;
	b=tiA9/DLZoASUlSE8UKPdIngmmJuf0sdPK+HtoqMBBow18vm1Lnnh/pHeAS0DR8b2P54V
	 EeeMow1u61n/bmHmaDS3ZnP2qdCjIXLi61312ZzQMmSrkUh/j27e9B38H06dzqAix/Mub
	 etY4DjQ3xjQP8lr4zsDCv5fUZyTIHD+W2nK8eZUXRCSMrwHVdtnqvFrpbvJSTG5CK10nH
	 bmlY/i93MQ+pjdEardw2InCcSl+1R7ebPyyiM4u/a+W6dQsE+Gz3edjHp0tst1HndeXB9
	 51gCVJYys2N1ijIs4YYZoG7+19TZBtf+/RTwhRLTH8HoxGoOL+SNvvMn+di3mIcLLWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dMo/5kVi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E5F606A320;
	Wed, 18 Nov 2026 23:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dMo/5kVi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72751F000C4;
	Wed, 18 Nov 2026 23:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043785;
	bh=v5U/XKDyTu9e88cFUSkLKmc9umYecpDEKr6MchgEPAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMo/5kViNfqz08g5JIw96IrFucqmD/SZE7FhAMDKNvoMDU2sdgHLeWllR6H1txWXJ
	 BBCCT0L4JWyzLF4b+DGL1xyqUYZzbyhrqlHVzjhnqD3522sSmT5rJTKGqPQdlkMzAg
	 K4d/qiLsvbuOOrFaGhM6s7iqTR46zpWR4wNyIZDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0335/2857] KVM: x86: Check EFER validity on KVM_SET_SREGS*
Date: Wed, 18 Nov 2026 15:22:49 +0100
Message-ID: <20261118150213.500689343@linuxfoundation.org>
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

[ Upstream commit 184bd464bdb66daa9173670904f24c29c7b7f7d4 ]

When handling userspace SREGS writes, check the validity of EFER (i.e.
allowed bits) before writing the new value of EFER through the
per-vendor set_efer callbacks. This prevents userspace from writing
bogus values (e.g. EFER.SVME=1 with nested=0).

Note: on KVM_SET_MSRS, KVM only checks EFER validity in terms of KVM
caps, not guest caps, so it is possible to set EFER bits that are
supported by KVM but not by the guest CPUID. Potentially allowing
userspace to set msrs before CPUID.

However, for KVM_SET_SREGS*, check the validity of the set bits against
both KVM and guest caps. This is consistent with other validity checks
(e.g. for CR4) that check validity against guest caps, which already
imposes the need to set CPUID before SREGS.

Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260713180153.2728382-2-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Applied the one-line EFER validity check to kvm_is_valid_sregs() in arch/x86/kvm/x86.c, because the regs.c file the patch targets doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0eab09da329f6..db710ae4848d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11643,7 +11643,8 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	}
 
 	return kvm_is_valid_cr4(vcpu, sregs->cr4) &&
-	       kvm_is_valid_cr0(vcpu, sregs->cr0);
+	       kvm_is_valid_cr0(vcpu, sregs->cr0) &&
+	       kvm_valid_efer(vcpu, sregs->efer);
 }
 
 static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
-- 
2.53.0



