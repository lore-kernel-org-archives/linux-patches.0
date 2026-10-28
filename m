Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213161;
	b=EfwvBUSOZwvQg8Dj6zJeawBhgtoruvBfii036fLpJQX76Ket5u819TN2dkkgS+/5Ekrq
	 fLrtbsqFXWxUap3CFjacejB4sBr0r3l5HEeIqQYogVQy54J99aDyTe0o1w2DLZIbgKbzg
	 hKVngyoeC68dG4+wu9Lun/xfR3KisqEX50F2ejuL6UFWhNtZEgtzbDJN0L5RQvni+q7sH
	 LOewffqistmkXm2Jru1mKX4J8y41GFwEKZPW5ui+7xdU4rfj66NA2eFWlGaF3tN5kIA1F
	 R8J1lW5CT5gPZAe/4wrS3D+ywaMWsgIz51W/HWHryWlB0YTeUWrqSFYMgCBumGVhpww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ExEOqVCKjCvz9ybo/4NiojS4aGGFnXNPoOh7PZnOtPA=;
	b=Tal/qkFqHKBoq0hjLYfpXQCo/RHFpPs7cGMxlFRKXEMVKZeY3ejptvrjUSs4nzZlvNrk
	 d08IvW2KJUCoVN2cDtQqs8nkGx08pfg11dMjOsoOPLlnRRCozNOatQpm57gr3iOmbOsrI
	 cGP7HJNXymEzAHUIo8lC2PzTnv8ie1EDd4LWzxxOqrlrkVVIry+pJ7pko/iTMYsAiWA06
	 pnUu6lqIXfDBuRCOur5i7g0dXjs/DLuS4pwQJI4XvplIOf42JNF8O98JQriZX8FUvzSZt
	 n3L+H/SAtCfPNQFCtLVfPeWUK3xfsSJ4cxnr6de2Sv0fypbX/PWusz0fLZwZZ786YWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVS+sOfo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF70E606A31C;
	Wed, 28 Oct 2026 18:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVS+sOfo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0BA1F01825;
	Wed, 28 Oct 2026 18:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213160;
	bh=ExEOqVCKjCvz9ybo/4NiojS4aGGFnXNPoOh7PZnOtPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVS+sOfowQM4EWiMSIG3jIgfDlbHFOzJtYrMLLe/aYyPL7goGNHlbKoIpcMqnHgEJ
	 2ktRm1NiihdGkLQ1ErIdkT5Kn8vAB/4m0Vx4/n9/R93+akEs1xz6tZsHIyP9aWcGAn
	 uYVMysI504/DAjeUwRNXKXz/IaEvIaksHu35WCg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0408/1887] KVM: SVM: Use the active VMCBs MSR bitmap when checking if MSR is intercepted
Date: Wed, 28 Oct 2026 17:41:44 +0100
Message-ID: <20261028170508.518932895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ Upstream commit 9e06bbb9ade7cdf28d4a3b5b14e5812881c8df85 ]

Use the MSR permission bitmap of the active VMCB instead of assuming that
KVM is always using vmcb02's bitmap when L2 is active, as KVM uses msrpm02
if and only if L1 wants to intercept MSR accesses, i.e. if and only if KVM
needs to merge msprm01 with msrpm12.

Don't bother tracking the virtual address of the bitmap that's being used,
as __va() is cheap on x86, and caching the virtual address would introduce
yet another source of potentially stale information.

Fixes: b2ac58f90540 ("KVM/SVM: Allow direct access to MSR_IA32_SPEC_CTRL")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260826195833.844526-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[ sashal: adapted direct svm access to to_svm(vcpu) for the existing msr_write_intercepted() signature ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 88979fefaa284..488e954a4483a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -732,17 +732,7 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	u32 offset;
 	u32 *msrpm;
 
-	/*
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
-				      to_svm(vcpu)->msrpm;
+	msrpm = __va(__sme_clr(to_svm(vcpu)->vmcb->control.msrpm_base_pa));
 
 	offset    = svm_msrpm_offset(msr);
 	bit_write = 2 * (msr & 0x0f) + 1;
-- 
2.53.0



