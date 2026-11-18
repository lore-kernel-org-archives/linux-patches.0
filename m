Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053718;
	b=mlPequOY2JLC3r2aRxbNgMAgvhKLuE8cOA+iySmgXH39uOh6hELFNLGxaCLCdkooOiCn
	 wukeGl0GJM7dIHg5rciJTFs3wmb1cDb6Dub9fPrT+7CWVNZMKxR6LMm3NXBQEHHS8xD1G
	 4SOzk0QatgkuFCvWw9YliUIfcf2xfFGEQumqphm4NcrWFVmKT9xp7bcZ10OX017Dg5kUt
	 ec7sDZwyLEReBAU+aPJa431u8xuMaBVatAD4Z9i6W704flZjcxoUyWednoa4Vq2r4jV4O
	 j8TRMauZ0S1E83wTCrthtN+E5Ory1Wu+denP33QtUV/1VBda6/DLEuH8tCG2j7uBI/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f12N3S7AdU+c6K60ED0IZ4LzkHhpchFOBeZdWH6l4yQ=;
	b=ZXlFAZZ5HzON7i22jSLvHrcewvEoMvwtlEyfcEmjJe2ah886xrT2zZ7+MlhuZD1eSt8N
	 8USXW4IZ9LwYt8uRutDd3p8xDz7rIlwtwFOu/TpXu3EdxyBKuDzC0fbm5kvrO3T7ZtnGZ
	 VoBcZJTSS5oFN0Mxb91+3Uikc5Q7zqzIDuPNYjTF0Zh3pujTU/AflMCJW8dxXyNoVfYIy
	 YGwhwB2ulcOzMszk7GG7x87DcUHSFLaWYcK0jgkVFUtUHu6tFk2GNfCCEcmr3uUFmg3Jr
	 tgIvq7/bZ7/hzgjZ8u5pW/RPxKAphbBVjWy3phbjzNKR549avZ4Y9xx8VbYO/GBq2dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8u6dbdZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117CA606A31C;
	Thu, 19 Nov 2026 02:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8u6dbdZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8231F000C4;
	Thu, 19 Nov 2026 02:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053717;
	bh=f12N3S7AdU+c6K60ED0IZ4LzkHhpchFOBeZdWH6l4yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8u6dbdZXtn/mzUQzS2XgBDKopl44HiIevuGLfL+oGJV+ymqZzY/OX//rD/wmFnu8
	 lrZ/2zedbHacoxxeaEepS91Q9xbNeSNzGkFC8vwCbwl6PhvPgCWYbZxwDEd1mYISvn
	 w3dp/Od5QC2/x5OiM4c2oFBOgMo+xZAQMvzKHL2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0981/2214] KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state
Date: Wed, 18 Nov 2026 15:44:17 +0100
Message-ID: <20261118150051.488635484@linuxfoundation.org>
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

[ Upstream commit 1c4c84a643b704e473cb171f7b61359ff29b12a4 ]

Force EFER.LMA=0 if EFER.LME=0 when preparing L2 state for VMRUN, i.e.
mimic real hardware's behavior of ignoring EFER.LMA if EFER.LME=0.  VMRUN
unfortunately allows the nonsensical combination, i.e. doesn't fail, but
KVM itself has an invariant EFER.LMA can be set et if and only if EFER.LME
is set.   Breaking that invariant can lead to a variety of issue,
particularly in MMU code that keys off EFER.LMA when determining whether to
emulate/virtualization 4/5-level paging versus PAE paging.

Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260902232028.2767071-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ sashal: Replaced the unavailable cached EFER field with a local READ_ONCE() snapshot of VMCB12 EFER. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f5b9bac913d7b..9a3045d843fc6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -461,6 +461,7 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
 	bool new_vmcb12 = false;
+	u64 efer = READ_ONCE(vmcb12->save.efer);
 
 	nested_vmcb02_compute_g_pat(svm);
 	vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
@@ -488,12 +489,16 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
+	/* SVM ignores EFER.LMA if EFER.LME=0 (instead of failing VMRUN). */
+	if (!(efer & EFER_LME))
+		efer &= ~EFER_LMA;
+
 	/*
 	 * Force-set EFER_SVME even though it is checked earlier on the
 	 * VMCB12, because the guest can flip the bit between the check
 	 * and now.  Clearing EFER_SVME would call svm_free_nested.
 	 */
-	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
+	svm_set_efer(&svm->vcpu, efer | EFER_SVME);
 
 	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
 	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
-- 
2.53.0



